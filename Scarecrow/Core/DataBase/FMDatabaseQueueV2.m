//
//  FMDatabaseQueueV2.m
//  Scarecrow
//
//  Created by duanhongjin on 16/8/25.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import "FMDatabaseQueueV2.h"
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@implementation FMDatabaseQueueV2

+ (instancetype)databaseQueueWithPath:(NSString*)aPath key:(NSString*)key {
    FMDatabaseQueueV2 *q = [[FMDatabaseQueueV2 alloc]initWithPath:aPath key:key];
    
    FMDBAutorelease(q);
    
    return q;
}

- (instancetype)initWithPath:(NSString*)aPath key:(NSString*)key {
    self = [super init];
    if (self) {
        _key = key;
        
        sqlite3_config(SQLITE_CONFIG_MULTITHREAD);
        self.path = FMDBReturnRetained(aPath);
        
        if (![self database]) {
            return nil;
        }
        
        _update = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@.write", self] UTF8String], DISPATCH_QUEUE_SERIAL);
        _query = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@.read", self] UTF8String], DISPATCH_QUEUE_SERIAL);
        
        
        CFStringRef specificValueUpdate = CFSTR("queueUpdate");
        dispatch_queue_set_specific(_update, &_specificUpdateKey, (void*)specificValueUpdate, (dispatch_function_t)CFRelease);
        
        CFStringRef specificValueQuery = CFSTR("queueQuery");
        dispatch_queue_set_specific(_query, &_specificQueryKey, (void*)specificValueQuery, (dispatch_function_t)CFRelease);
    }
    return self;
}

- (void)dealloc {
    FMDBRelease(_db);
    FMDBRelease(self.path);
    
    if (_update) {
        _update = nil;
    }
    
    if (_query) {
        _query = nil;
    }
}

- (void)close {
    FMDBRetain(self);
    dispatch_sync(_update, ^() {
        [_db close];
        FMDBRelease(_db);
        _db = nil;
    });
    
    FMDBRelease(self);
}

- (FMDatabase*)database {
    if (!_db) {
        _db = FMDBReturnRetained([FMDatabase databaseWithPath:_path]);
        
        if (![_db openWithFlags:SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE]) {
            NSLog(@"FMDatabaseQueue could not reopen database for path %@", _path);
            FMDBRelease(_db);
            _db  = nil;
            return nil;
        }
        if (_key) {
            [_db setKey:_key];
        }
        NSLog(@"%@",[_db stringForQuery:@"PRAGMA journal_mode = WAL"]);
        [_db setShouldCacheStatements:YES];
    }
    return _db;
}

- (NSInteger)dbVersion {
    __block NSInteger version = 0;
    [self queryInDatabase:^(FMDatabase * db){
        FMResultSet *rs = [_db executeQuery:@"PRAGMA user_version"];
        if ([rs next])
        {
            version = [rs intForColumnIndex:0];
        }
        [rs close];
    }];
    return version;

}

- (void)queryInDatabase:(void (^)(FMDatabase *db))block {
    FMDBRetain(self);
    
    if (dispatch_get_specific(&_specificQueryKey) || dispatch_get_specific(&_specificUpdateKey)) {
        FMDatabase *db = [self database];
        @autoreleasepool {
            block(db);
        }
    } else {
        dispatch_sync(_query, ^() {
            FMDatabase *db = [self database];
            @autoreleasepool {
                block(db);
            }
            if ([db hasOpenResultSets]) {
                NSLog(@"Warning: there is at least one open result set around after performing [FMDatabaseQueue inDatabase:]");
            }
        });
    }
    FMDBRelease(self);
}

- (void)updateDatabase:(void (^)(FMDatabase *db))block {
    FMDBRetain(self);
    
    if (dispatch_get_specific(&_specificUpdateKey)) {
        FMDatabase *db = [self database];
        @autoreleasepool {
            block(db);
        }
    } else {
        dispatch_sync(_update, ^() {
            FMDatabase *db = [self database];
            @autoreleasepool {
                block(db);
            }
            if ([db hasOpenResultSets]) {
                NSLog(@"Warning: there is at least one open result set around after performing [FMDatabaseQueue inDatabase:]");
            }
        });
    }
    
    FMDBRelease(self);
}

- (BOOL)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(FMDatabase *db, BOOL *rollback))block {
    __block BOOL shouldRollback = NO;
    FMDBRetain(self);
    if (dispatch_get_specific(&_specificUpdateKey)) {
        if (![[self database] inTransaction]) {
            if (useDeferred) {
                [[self database] beginDeferredTransaction];
            } else {
                [[self database] beginTransaction];
            }
            @autoreleasepool {
                block([self database], &shouldRollback);
            }
            if (shouldRollback) {
                [[self database] rollback];
            } else {
                [[self database] commit];
            }
        } else {
            block([self database], &shouldRollback);
        }
    } else {
        dispatch_sync(_update, ^() {
            
            if (useDeferred) {
                [[self database] beginDeferredTransaction];
            } else {
                [[self database] beginTransaction];
            }
            @autoreleasepool {
                block([self database], &shouldRollback);
            }
            if (shouldRollback) {
                [[self database] rollback];
            } else {
                [[self database] commit];
            }
        });
    }
    
    FMDBRelease(self);
    return shouldRollback;
}

- (BOOL)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block {
    return [self beginTransaction:YES withBlock:block];
}

- (BOOL)inDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block {
    return [self beginTransaction:YES withBlock:block];
}

#if SQLITE_VERSION_NUMBER >= 3007000

- (NSError*)inSavePoint:(void (^)(FMDatabase *db, BOOL *rollback))block {
    static unsigned long savePointIdx = 0;
    __block NSError *err = nil;
    FMDBRetain(self);
    
    void(^saveBlock)(void) = ^{
        NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];
        BOOL shouldRollback = NO;
        if ([[self database] startSavePointWithName:name error:&err]) {
            block([self database], &shouldRollback);
            if (shouldRollback) {
                [[self database] rollbackToSavePointWithName:name error:&err];
            } else {
                [[self database] releaseSavePointWithName:name error:&err];
            }
        }
    };
    
    if (dispatch_get_specific(&_specificUpdateKey)) {
        saveBlock();
    } else {
        dispatch_sync(_update, ^() {
            saveBlock();
        });
    }
    
    FMDBRelease(self);
    return err;
}

#endif

@end
