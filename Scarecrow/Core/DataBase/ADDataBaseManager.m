//
//  ADDataBaseManager.m
//  Scarecrow
//
//  Created by duanhongjin on 8/25/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "ADDataBaseManager.h"
#import "SSKeychain+Scarecrow.h"
#import <FMDB/FMDB.h>
#import "FMDatabaseQueueV2.h"

@interface ADDataBaseManager ()

@property (strong, nonatomic, readonly) NSString *dbKey;
@property (assign, nonatomic) NSInteger dbVersion;
@property (strong, nonatomic) FMDatabaseQueueV2 *dataBaseQueue;

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) ADDataBase *dataBase;

@end

@implementation ADDataBaseManager

- (instancetype)initWithRawLogin:(NSString *)rawLogin {
    self = [super init];
    if (self) {
        NSString *dataBasePath = [self dataPathWithRawLogin:rawLogin];
        NSString *fileName = AD_DataBaseName;
        NSString *dbKey = self.dbKey;
        if (dbKey.length && !DataBase_Debug) {
            fileName = AD_DataBaseEncryptionName;
        }
        
        self.dbVersion = AD_DataBaseVersion;
        self.path = [dataBasePath stringByAppendingPathComponent:fileName];
        
        self.dataBase = [[ADDataBase alloc]initWithDataBaseQueue:self.dataBaseQueue];
    }
    return self;
}

- (void)dealloc {
    [self onClose];
}

- (void)onClose {
    if (self.dataBaseQueue) {
        [self.dataBaseQueue close];
        self.dataBaseQueue = nil;
        self.path = nil;
    }
}

- (NSString *)dataPathWithRawLogin:(NSString *)rawLogin {
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *currentPath = [paths objectAtIndex:0];
    NSString *dataBasePath = [currentPath stringByAppendingPathComponent:rawLogin];
    
    NSLog(@"dataBasePath: %@", dataBasePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dataBasePath]) {
        [fileManager createDirectoryAtPath:dataBasePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return dataBasePath;
}

- (NSString *)dbKey {
    return [SSKeychain username];
}

- (FMDatabaseQueueV2 *)dataBaseQueue {
    @synchronized (self) {
        if (!_dataBaseQueue) {
            _dataBaseQueue = [FMDatabaseQueueV2 databaseQueueWithPath:self.path key:self.dbKey];
            NSInteger storedVersion = [_dataBaseQueue dbVersion];
            if (self.dbVersion != storedVersion) {
                [_dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                    @try {
                        if (storedVersion == 0) {
                            [[self class]onCreate:db];
                        } else {
                            [[self class]onUpgrade:db oldVersion:storedVersion newVersion:self.dbVersion];
                        }
                    } @catch (NSException *exception) {
                        *rollback = YES;
                        NSLog(@"Error: %d, %@", [db lastErrorCode], [db lastErrorMessage]);
                    }
                    
                    NSString *sql = [NSString stringWithFormat:@"PRAGMA user_version = %ld",self.dbVersion];
                    [db executeUpdate:sql];
                    if([db hadError]) {
                        *rollback = YES;
                        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                    }
                }];
            }
        }
        return _dataBaseQueue;
    }
}

+ (void)onCreate:(FMDatabase *)database {
    NSArray *sqlArray = [self getCreateTableSqlString];
    for (NSString *sql in sqlArray) {
        [database executeUpdate:sql];
        if ([database hadError]) {
            [NSException raise:@"ADDataBaseManager exception" format:@"on create:%@,exctpion:%@", sql, database.lastErrorMessage];
        }
    }

}

+ (void)onUpgrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion {
    [self onDropAllTables:database];
    [self onCreate:database];
}

+ (void)onDropAllTables:(FMDatabase *)database {
    NSArray *classNameArray = [self classNameArray];
    for (NSString *className in classNameArray) {
        Class class = NSClassFromString(className);
        NSArray* dropSqls = [class tableDropSQLSentences];
        for (NSString* sql in dropSqls) {
            [database executeUpdate:sql];
        }
    }
}

+ (NSArray *)getCreateTableSqlString {
    NSMutableArray *sqlArray = [NSMutableArray new];
    
    NSArray *classNameArray = [self classNameArray];
    for (NSString *className in classNameArray) {
        Class class = NSClassFromString(className);
        [sqlArray addObjectsFromArray:[class tableCreateSQLSentences]];
    }
    
    return sqlArray;
}

+ (NSArray *)classNameArray {
    NSArray *classNameArray = @[
                                @"ADDataBase",
                                ];
    return classNameArray;
}


@end
