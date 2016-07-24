//
//  OCTEvent+Persistence.m
//  Scarecrow
//
//  Created by duanhongjin on 8/4/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "OCTEvent+Persistence.h"
#import "OCTUser+Persistence.h"

@implementation OCTEvent (Persistence)

+ (BOOL)ad_saveUserReceivedEvents:(NSArray *)eventArray {
    NSString *path = [self receivedEvnetPath];
    return [NSKeyedArchiver archiveRootObject:eventArray toFile:path];
}

+ (NSArray *)ad_fetchUserReceivedEvents {
    NSString *path = [self receivedEvnetPath];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

+ (NSString *)receivedEvnetPath {
    NSString *path = [self persistenceDirectory];
    return [path stringByAppendingPathComponent:@"ReceivedEvents"];
}

+ (NSString *)persistenceDirectory {
    NSString *mainDoumentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [mainDoumentDirectory stringByAppendingFormat:@"/%@/Persistence", [OCTUser ad_currentUser].login];
    
    BOOL isDirectory = NO;
    BOOL isExist = [[NSFileManager defaultManager]fileExistsAtPath:path isDirectory:&isDirectory];
    if (!isDirectory || !isExist) {
        BOOL success = [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!success) {
            return nil;
        }
    }
    
    return path;
}

@end
