//
//  OCTEvent+AttributedString.m
//  Scarecrow
//
//  Created by duanhongjin on 8/4/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import "OCTEvent+AttributedString.h"
#import <Octicons/NSString+Octicons.h>
#import "NSMutableAttributedString+Scarecrow.h"
#import "OCTRef+Scarecrow.h"
#import <FormatterKit/TTTTimeIntervalFormatter.h>

@implementation OCTEvent (AttributedString)

- (NSMutableAttributedString *)ad_attributedString {
    NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
    
    [attributedString appendAttributedString:[self ad_octiconAttributedString]];
    [attributedString appendAttributedString:[self ad_actorLoginAttributedString]];
    
    if ([self isMemberOfClass:[OCTCommitCommentEvent class]]) {
        [attributedString appendAttributedString:[self ad_commitCommentEventAttributedString]];
        [attributedString appendAttributedString:[@"\n" stringByAppendingString:[self valueForKeyPath:@"comment.body"]].ad_attributedString.ad_addNormalTitleAttribute.ad_addParagraphStyleAttribute];
    } else if ([self isMemberOfClass:[OCTIssueCommentEvent class]]) {
        [attributedString appendAttributedString:[self ad_issueCommentEventAttributedString]];
        [attributedString appendAttributedString:[@"\n" stringByAppendingString:[self valueForKeyPath:@"comment.body"]].ad_attributedString.ad_addNormalTitleAttribute.ad_addParagraphStyleAttribute];
    } else if ([self isMemberOfClass:[OCTPullRequestCommentEvent class]]) {
        [attributedString appendAttributedString:[self ad_pullRequestCommentEventAttributedString]];
        [attributedString appendAttributedString:[@"\n" stringByAppendingString:[self valueForKeyPath:@"comment.body"]].ad_attributedString.ad_addNormalTitleAttribute.ad_addParagraphStyleAttribute];
    } else if ([self isMemberOfClass:[OCTForkEvent class]]) {
        [attributedString appendAttributedString:[self ad_forkEventAttributedString]];
    } else if ([self isMemberOfClass:[OCTIssueEvent class]]) {
        [attributedString appendAttributedString:[self ad_issueEventAttributedString]];
    } else if ([self isMemberOfClass:[OCTMemberEvent class]]) {
        [attributedString appendAttributedString:[self ad_memberEventAttributedString]];
    } else if ([self isMemberOfClass:[OCTPublicEvent class]]) {
        [attributedString appendAttributedString:[self ad_publicEventAttributedString]];
    } else if ([self isMemberOfClass:[OCTPullRequestEvent class]]) {
        [attributedString appendAttributedString:[self ad_pullRequestEventAttributedString]];
    } else if ([self isMemberOfClass:[OCTPushEvent class]]) {
        [attributedString appendAttributedString:[self ad_pushEventAttributedString]];
    } else if ([self isMemberOfClass:[OCTRefEvent class]]) {
        [attributedString appendAttributedString:[self ad_refEventAttributedString]];
    } else if ([self isMemberOfClass:[OCTWatchEvent class]]) {
        [attributedString appendAttributedString:[self ad_watchEventAttributedString]];
    }
    
    [attributedString appendAttributedString:self.ad_dateAttributedString];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_commitCommentEventAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTCommitCommentEvent class]]);
    
    NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
    
    [attributedString appendAttributedString:@" commented on commit ".ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_commentedCommitAttributedString];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_issueCommentEventAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTIssueCommentEvent class]]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:@" commented on issue ".ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_issueAttributedString];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_pullRequestCommentEventAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTPullRequestCommentEvent class]]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:@" commented on pull request ".ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_pullRequestAttributedString];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_forkEventAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTForkEvent class]]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:@" forked ".ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_repositoryNameAttributedString];
    [attributedString appendAttributedString:@" to ".ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_forkedRepositoryNameAttributedString];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_issueEventAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTIssueEvent class]]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    OCTIssueEvent *concreteEvent = (OCTIssueEvent *)self;
    
    NSString *action = nil;
    if (concreteEvent.action == OCTIssueActionOpened) {
        action = @"opened";
    } else if (concreteEvent.action == OCTIssueActionClosed) {
        action = @"closed";
    } else if (concreteEvent.action == OCTIssueActionReopened) {
        action = @"reopened";
    }
    
    [attributedString appendAttributedString:[NSString stringWithFormat:@" %@ issue ", action].ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_issueAttributedString];
    [attributedString appendAttributedString:[@"\n" stringByAppendingString:concreteEvent.issue.title].ad_attributedString.ad_addNormalTitleAttribute.ad_addParagraphStyleAttribute];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_memberEventAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTMemberEvent class]]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:@" added ".ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_memberLoginAttributedString];
    [attributedString appendAttributedString:@" to ".ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_repositoryNameAttributedString];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_publicEventAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTPublicEvent class]]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:@" open sourced ".ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_repositoryNameAttributedString];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_pullRequestEventAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTPullRequestEvent class]]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    OCTPullRequestEvent *concreteEvent = (OCTPullRequestEvent *)self;
    
    NSString *action = nil;
    if (concreteEvent.action == OCTIssueActionOpened) {
        action = @"opened";
    } else if (concreteEvent.action == OCTIssueActionClosed) {
        action = @"closed";
    } else if (concreteEvent.action == OCTIssueActionReopened) {
        action = @"reopened";
    } else if (concreteEvent.action == OCTIssueActionSynchronized) {
        action = @"synchronized";
    }
    
    [attributedString appendAttributedString:[NSString stringWithFormat:@" %@ pull request ", action].ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_pullRequestAttributedString];
    [attributedString appendAttributedString:[@"\n" stringByAppendingString:concreteEvent.pullRequest.title].ad_attributedString.ad_addNormalTitleAttribute.ad_addParagraphStyleAttribute];
    [attributedString appendAttributedString:@"\n".ad_attributedString];
    [attributedString appendAttributedString:self.ad_pullInfoAttributedString];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_refEventAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTRefEvent class]]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    OCTRefEvent *concreteEvent = (OCTRefEvent *)self;
    
    NSString *action = nil;
    if (concreteEvent.eventType == OCTRefEventCreated) {
        action = @"created";
    } else if (concreteEvent.eventType == OCTRefEventDeleted) {
        action = @"deleted";
    }
    
    NSString *type = nil;
    if (concreteEvent.refType == OCTRefTypeBranch) {
        type = @"branch";
    } else if (concreteEvent.refType == OCTRefTypeTag) {
        type = @"tag";
    } else if (concreteEvent.refType == OCTRefTypeRepository) {
        type = @"repository";
    }
    
    NSString *at = (concreteEvent.refType == OCTRefTypeBranch || concreteEvent.refType == OCTRefTypeTag ? @" at " : @"");
    
    [attributedString appendAttributedString:[NSString stringWithFormat:@" %@ %@ ", action, type].ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_refNameAttributedString];
    [attributedString appendAttributedString:at.ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_repositoryNameAttributedString];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_watchEventAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTWatchEvent class]]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:@" starred ".ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_repositoryNameAttributedString];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_commentedCommitAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTCommitCommentEvent class]]);
    
    OCTCommitCommentEvent *concreteEvent = (OCTCommitCommentEvent *)self;
    
    NSString *target = [NSString stringWithFormat:@"%@@%@", concreteEvent.repositoryName, [self ad_shortSHA:concreteEvent.comment.commitSHA]];
    NSMutableAttributedString *attributedString = target.ad_attributedString;
    
    NSURL *HTMLURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?title=Commit", concreteEvent.comment.HTMLURL.absoluteString]];
    
    [attributedString ad_addNormalTitleAttribute];
    [attributedString ad_addTintedForegroundColorAttribute];
    [attributedString ad_addHTMLURLAttribute:HTMLURL];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_issueAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTIssueCommentEvent class]] || [self isMemberOfClass:[OCTIssueEvent class]]);
    
    OCTIssue *issue = [self valueForKey:@"issue"];
    
    NSString *issueID = [issue.URL.absoluteString componentsSeparatedByString:@"/"].lastObject;
    NSURL *HTMLURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?title=Issue-@%@", issue.HTMLURL.absoluteString, issueID]];
    
    NSMutableAttributedString *attributedString = [NSString stringWithFormat:@"%@#%@", self.repositoryName, issueID].ad_attributedString;
    
    [attributedString ad_addNormalTitleAttribute];
    [attributedString ad_addTintedForegroundColorAttribute];
    [attributedString ad_addHTMLURLAttribute:HTMLURL];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_pullRequestAttributedString {
    NSParameterAssert([self isKindOfClass:[OCTPullRequestCommentEvent class]] || [self isMemberOfClass:[OCTPullRequestEvent class]]);
    
    NSString *pullRequestID = nil;
    NSURL *HTMLURL = nil;
    if ([self isKindOfClass:[OCTPullRequestCommentEvent class]]) {
        OCTPullRequestCommentEvent *concreteEvent = (OCTPullRequestCommentEvent *)self;
        
        pullRequestID = [concreteEvent.comment.pullRequestAPIURL.absoluteString componentsSeparatedByString:@"/"].lastObject;
        
        HTMLURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?title=Pull-Request-@%@", concreteEvent.comment.HTMLURL.absoluteString, pullRequestID]];
    } else if ([self isMemberOfClass:[OCTPullRequestEvent class]]) {
        OCTPullRequestEvent *concreteEvent = (OCTPullRequestEvent *)self;
        
        pullRequestID = [concreteEvent.pullRequest.URL.absoluteString componentsSeparatedByString:@"/"].lastObject;
        
        HTMLURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?title=Pull-Request-@%@", concreteEvent.pullRequest.HTMLURL.absoluteString, pullRequestID]];
    }
    
    NSParameterAssert(pullRequestID.length > 0);
    NSParameterAssert(HTMLURL);
    
    NSMutableAttributedString *attributedString = [NSString stringWithFormat:@"%@#%@", self.repositoryName, pullRequestID].ad_attributedString;
    
    [attributedString ad_addNormalTitleAttribute];
    [attributedString ad_addTintedForegroundColorAttribute];
    [attributedString ad_addHTMLURLAttribute:HTMLURL];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_repositoryNameAttributedString {
    return [self ad_repositoryNameAttributedStringWithString:self.repositoryName];
}

- (NSMutableAttributedString *)ad_repositoryNameAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attributedString = string.ad_attributedString;
    
    attributedString = attributedString.ad_addNormalTitleAttribute;
    return [attributedString.ad_addTintedForegroundColorAttribute ad_addReposLinkAttributeWithName:attributedString.string referName:nil];
}

- (NSMutableAttributedString *)ad_forkedRepositoryNameAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTForkEvent class]]);
    
    OCTForkEvent *concreteEvent = (OCTForkEvent *)self;
    
    return [self ad_repositoryNameAttributedStringWithString:concreteEvent.forkedRepositoryName];
}

- (NSMutableAttributedString *)ad_memberLoginAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTMemberEvent class]]);
    
    return [self ad_loginAttributedStringWithString:[self valueForKey:@"memberLogin"]];
}

- (NSMutableAttributedString *)ad_pullInfoAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTPullRequestEvent class]]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    OCTPullRequestEvent *concreteEvent = (OCTPullRequestEvent *)self;
    
    NSString *octicon = [NSString stringWithFormat:@" %@ ", [NSString octicon_iconStringForEnum:OCTIconGitCommit]];
    
    NSString *commits   = concreteEvent.pullRequest.commits > 1 ? @" commits with " : @" commit with ";
    NSString *additions = concreteEvent.pullRequest.additions > 1 ? @" additions and " : @" addition and ";
    NSString *deletions = concreteEvent.pullRequest.deletions > 1 ? @" deletions " : @" deletion ";
    
    [attributedString appendAttributedString:octicon.ad_attributedString.ad_addOcticonAttribute.ad_addParagraphStyleAttribute];
    [attributedString appendAttributedString:@(concreteEvent.pullRequest.commits).stringValue.ad_attributedString.ad_addNormalTitleAttribute.ad_addPullInfoForegroundColorAttribute];
    [attributedString appendAttributedString:commits.ad_attributedString.ad_addNormalPullInfoFontAttribute.ad_addPullInfoForegroundColorAttribute];
    [attributedString appendAttributedString:@(concreteEvent.pullRequest.additions).stringValue.ad_attributedString.ad_addNormalTitleAttribute.ad_addPullInfoForegroundColorAttribute];
    [attributedString appendAttributedString:additions.ad_attributedString.ad_addNormalPullInfoFontAttribute.ad_addPullInfoForegroundColorAttribute];
    [attributedString appendAttributedString:@(concreteEvent.pullRequest.deletions).stringValue.ad_attributedString.ad_addNormalTitleAttribute.ad_addPullInfoForegroundColorAttribute];
    [attributedString appendAttributedString:deletions.ad_attributedString.ad_addNormalPullInfoFontAttribute.ad_addPullInfoForegroundColorAttribute];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_pushEventAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTPushEvent class]]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:@" pushed to ".ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_branchNameAttributedString];
    [attributedString appendAttributedString:@" at ".ad_attributedString.ad_addNormalTitleAttribute];
    [attributedString appendAttributedString:self.ad_repositoryNameAttributedString];
    [attributedString appendAttributedString:self.ad_pushedCommitsAttributedString];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_branchNameAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTPushEvent class]]);
    
    NSString *branchName = [self valueForKey:@"branchName"];
    
    NSMutableAttributedString *attributedString = branchName.ad_attributedString;
    
    [attributedString ad_addNormalTitleAttribute];
    [attributedString ad_addTintedForegroundColorAttribute];
    [attributedString ad_addReposLinkAttributeWithName:self.repositoryName referName:[OCTRef ad_referenceNameWithBranch:branchName]];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_pushedCommitsAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTPushEvent class]]);
    
    OCTPushEvent *concreteEvent = (OCTPushEvent *)self;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *dictionary in concreteEvent.commits) {
        /* {
         "sha": "6e4dc62cffe9f2d1b1484819936ee264dde36592",
         "author": {
         "email": "coderyi@foxmail.com",
         "name": "coderyi"
         },
         "message": "增加iOS开发者coderyi的博客\n\n增加iOS开发者coderyi的博客",
         "distinct": true,
         "url": "https://api.github.com/repos/tangqiaoboy/iOSBlogCN/commits/6e4dc62cffe9f2d1b1484819936ee264dde36592"
         } */
        NSMutableAttributedString *commit = [[NSMutableAttributedString alloc] init];
        
        [commit appendAttributedString:@"\n".ad_attributedString];
        [commit appendAttributedString:[self ad_pushedCommitAttributedStringWithSHA:dictionary[@"sha"]]];
        [commit appendAttributedString:[@" - " stringByAppendingString:dictionary[@"message"]].ad_attributedString.ad_addNormalTitleAttribute];
        
        [attributedString appendAttributedString:commit];
    }
    
    return attributedString.ad_addParagraphStyleAttribute;
}

- (NSMutableAttributedString *)ad_pushedCommitAttributedStringWithSHA:(NSString *)SHA {
    NSParameterAssert([self isMemberOfClass:[OCTPushEvent class]]);
    
    NSMutableAttributedString *attributedString = [self ad_shortSHA:SHA].ad_attributedString;
    
    NSURL *HTMLURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/%@/commit/%@?title=Commit", self.repositoryName, SHA]];
    
    [attributedString ad_addNormalTitleFontAttribute];
    [attributedString ad_addTintedForegroundColorAttribute];
    [attributedString ad_addHTMLURLAttribute:HTMLURL];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_refNameAttributedString {
    NSParameterAssert([self isMemberOfClass:[OCTRefEvent class]]);
    
    OCTRefEvent *concreteEvent = (OCTRefEvent *)self;
    
    if (!concreteEvent.refName) {
        return @" ".ad_attributedString;
    }
    
    NSMutableAttributedString *attributedString = concreteEvent.refName.ad_attributedString;
    
    [attributedString ad_addNormalTitleFontAttribute];
    
    if (concreteEvent.eventType == OCTRefEventCreated) {
        [attributedString ad_addTintedForegroundColorAttribute];
        
        if (concreteEvent.refType == OCTRefTypeBranch) {
            [attributedString ad_addReposLinkAttributeWithName:self.repositoryName referName:[OCTRef ad_referenceNameWithBranch:concreteEvent.refName]];
        } else if (concreteEvent.refType == OCTRefTypeTag) {
            [attributedString ad_addReposLinkAttributeWithName:self.repositoryName referName:[OCTRef ad_referenceNameWithTag:concreteEvent.refName]];
        }
    } else if (concreteEvent.eventType == OCTRefEventDeleted) {
        [attributedString insertAttributedString:@" ".ad_attributedString atIndex:0];
        [attributedString appendAttributedString:@"\n".ad_attributedString];
        [attributedString ad_addTintedForegroundColorAttributeWithAlpha:0.5];
    }
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_dateAttributedString {
    TTTTimeIntervalFormatter *formatter = [TTTTimeIntervalFormatter new];
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSString *date = [formatter stringForTimeIntervalFromDate:[NSDate date] toDate:self.date];
    date = [NSString stringWithFormat:@"\n%@", date];
    
    NSMutableAttributedString *attributedString = date.ad_attributedString;
    
    [attributedString ad_addTimeFontAttribute];
    [attributedString ad_addTimeForegroundColorAttribute];
    [attributedString ad_addParagraphStyleAttribute];
    
    return attributedString;
}

- (NSMutableAttributedString *)ad_octiconAttributedString {
    OCTIcon icon = 0;
    if ([self isMemberOfClass:[OCTCommitCommentEvent class]]) {
        icon = OCTIconCommentDiscussion;
    } else if ([self isMemberOfClass:[OCTIssueCommentEvent class]]) {
        icon = OCTIconCommentDiscussion;
    } else if ([self isMemberOfClass:[OCTPullRequestCommentEvent class]]) {
        icon = OCTIconCommentDiscussion;
    } else if ([self isMemberOfClass:[OCTForkEvent class]]) {
        icon = OCTIconGitBranch;
    } else if ([self isMemberOfClass:[OCTIssueEvent class]]) {
        OCTIssueEvent *event = (OCTIssueEvent *)self;
        if (event.action == OCTIssueActionOpened) {
            icon = OCTIconIssueOpened;
        } else if (event.action == OCTIssueActionClosed) {
            icon = OCTIconIssueClosed;
        } else if (event.action == OCTIssueActionReopened) {
            icon = OCTIconIssueReopened;
        }
    } else if ([self isMemberOfClass:[OCTMemberEvent class]]) {
        icon = OCTIconOrganization;
    } else if ([self isMemberOfClass:[OCTPublicEvent class]]) {
        icon = OCTIconRepo;
    } else if ([self isMemberOfClass:[OCTPullRequestEvent class]]) {
        icon = OCTIconGitPullRequest;
    } else if ([self isMemberOfClass:[OCTPushEvent class]]) {
        icon = OCTIconGitCommit;
    } else if ([self isMemberOfClass:[OCTRefEvent class]]) {
        OCTRefEvent *event = (OCTRefEvent *)self;
        if (event.refType == OCTRefTypeBranch) {
            icon = OCTIconGitBranch;
        } else if (event.refType == OCTRefTypeTag) {
            icon = OCTIconTag;
        } else if (event.refType == OCTRefTypeRepository) {
            icon = OCTIconRepo;
        }
    } else if ([self isMemberOfClass:[OCTWatchEvent class]]) {
        icon = OCTIconStar;
    }
    
    return [[[[NSString octicon_iconStringForEnum:icon] stringByAppendingString:@"  "]ad_attributedString]ad_addOcticonAttribute];
}

- (NSMutableAttributedString *)ad_actorLoginAttributedString {
    return [self ad_loginAttributedStringWithString:self.actorLogin];
}

- (NSMutableAttributedString *)ad_loginAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attributedString = string.ad_attributedString;
    
    [attributedString ad_addNormalTitleFontAttribute];
    [attributedString ad_addTintedForegroundColorAttribute];
    [attributedString ad_addUserLinkAttribute];
    
    return attributedString;
}

- (NSString *)ad_shortSHA:(NSString *)sha {
    NSCParameterAssert(sha.length > 0);
    return [sha substringToIndex:7];
}

@end
