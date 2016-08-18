//
//  OCTEvent+Persistence.m
//  Scarecrow
//
//  Created by duanhongjin on 8/4/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "OCTEvent+Persistence.h"
#import "OCTUser+Persistence.h"
#import "OCTEvent+AttributedString.h"
#import "NSURL+Scarecrow.h"

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

@implementation OCTEvent (NSURL)

- (NSURL *)ad_link {
    NSMutableAttributedString *attributedString = nil;
    
    if ([self isMemberOfClass:[OCTCommitCommentEvent class]]) {
        attributedString = self.ad_commentedCommitAttributedString;
    } else if ([self isMemberOfClass:[OCTForkEvent class]]) {
        attributedString = self.ad_forkedRepositoryNameAttributedString;
    } else if ([self isMemberOfClass:[OCTIssueCommentEvent class]]) {
        attributedString = self.ad_issueAttributedString;
    } else if ([self isMemberOfClass:[OCTIssueEvent class]]) {
        attributedString = self.ad_issueAttributedString;
    } else if ([self isMemberOfClass:[OCTMemberEvent class]]) {
        attributedString = self.ad_memberLoginAttributedString;
    } else if ([self isMemberOfClass:[OCTPublicEvent class]]) {
        attributedString = self.ad_repositoryNameAttributedString;
    } else if ([self isMemberOfClass:[OCTPullRequestCommentEvent class]]) {
        attributedString = self.ad_pullRequestAttributedString;
    } else if ([self isMemberOfClass:[OCTPullRequestEvent class]]) {
        attributedString = self.ad_pullRequestAttributedString;
    } else if ([self isMemberOfClass:[OCTPushEvent class]]) {
        attributedString = self.ad_branchNameAttributedString;
    } else if ([self isMemberOfClass:[OCTRefEvent class]]) {
        if ([self.ad_refNameAttributedString attribute:kLinkAttributeKey atIndex:0 effectiveRange:NULL]) {
            attributedString = self.ad_refNameAttributedString;
        } else {
            attributedString = self.ad_repositoryNameAttributedString;
        }
    } else if ([self isMemberOfClass:[OCTWatchEvent class]]) {
        attributedString = self.ad_repositoryNameAttributedString;
    }
    
    return [attributedString attribute:kLinkAttributeKey atIndex:0 effectiveRange:NULL];
}

@end

