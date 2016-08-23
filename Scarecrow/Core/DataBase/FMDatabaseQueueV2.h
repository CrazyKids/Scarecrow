//
//  FMDatabaseQueueV2.h
//  Scarecrow
//
//  Created by duanhongjin on 16/8/25.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface FMDatabaseQueueV2 : NSObject {
    NSString            *_path;
    dispatch_queue_t    _queue;
    FMDatabase          *_db;
    NSString            *_key;
    
    dispatch_queue_t    _update;
    dispatch_queue_t    _query;
    
    int                 _specificUpdateKey;
    int                 _specificQueryKey;
}

@property (strong, atomic) NSString *path;

+ (instancetype)databaseQueueWithPath:(NSString*)aPath key:(NSString*)key;
- (instancetype)initWithPath:(NSString*)aPath key:(NSString*)key;
- (void)close;

- (FMDatabase*)database;
- (NSInteger)dbVersion;

- (void)queryInDatabase:(void (^)(FMDatabase *db))block;
- (void)updateDatabase:(void (^)(FMDatabase *db))block;

- (BOOL)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;
- (BOOL)inDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

#if SQLITE_VERSION_NUMBER >= 3007000
// NOTE: you can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock.
// If you need to nest, use FMDatabase's startSavePointWithName:error: instead.
- (NSError*)inSavePoint:(void (^)(FMDatabase *db, BOOL *rollback))block;
#endif

@end
