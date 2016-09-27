//
//  OCTEvent+AttributedString.h
//  Scarecrow
//
//  Created by duanhongjin on 8/4/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#import <OctoKit/OctoKit.h>

@interface OCTEvent (AttributedString)

- (NSMutableAttributedString *)ad_attributedString;

- (NSMutableAttributedString *)ad_commitCommentEventAttributedString;
- (NSMutableAttributedString *)ad_issueCommentEventAttributedString;
- (NSMutableAttributedString *)ad_pullRequestCommentEventAttributedString;
- (NSMutableAttributedString *)ad_forkEventAttributedString;
- (NSMutableAttributedString *)ad_issueEventAttributedString;
- (NSMutableAttributedString *)ad_memberEventAttributedString;
- (NSMutableAttributedString *)ad_publicEventAttributedString;
- (NSMutableAttributedString *)ad_pullRequestEventAttributedString;
- (NSMutableAttributedString *)ad_refEventAttributedString;
- (NSMutableAttributedString *)ad_watchEventAttributedString;

- (NSMutableAttributedString *)ad_commentedCommitAttributedString;
- (NSMutableAttributedString *)ad_issueAttributedString;
- (NSMutableAttributedString *)ad_pullRequestAttributedString;
- (NSMutableAttributedString *)ad_repositoryNameAttributedString;
- (NSMutableAttributedString *)ad_forkedRepositoryNameAttributedString;
- (NSMutableAttributedString *)ad_memberLoginAttributedString;
- (NSMutableAttributedString *)ad_pullInfoAttributedString;
- (NSMutableAttributedString *)ad_pushEventAttributedString;
- (NSMutableAttributedString *)ad_branchNameAttributedString;
- (NSMutableAttributedString *)ad_pushedCommitsAttributedString;
- (NSMutableAttributedString *)ad_pushedCommitAttributedStringWithSHA:(NSString *)SHA;
- (NSMutableAttributedString *)ad_refNameAttributedString;
- (NSMutableAttributedString *)ad_dateAttributedString;

- (NSMutableAttributedString *)ad_octiconAttributedString;
- (NSMutableAttributedString *)ad_actorLoginAttributedString;

@end
