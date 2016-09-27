//
//  DEFINES.h
//  Scarecrow
//
//  Created by duanhongjin on 8/10/16.
//  Copyright © 2016 duanhongjin. All rights reserved.
//

#ifndef DEFINES_h
#define DEFINES_h

#define LAYOUT_DEFAULT_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LAYOUT_DEFAULT_HEIGHT ([UIScreen mainScreen].bounds.size.height - 44)

#define AD_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define AD_APP_BUILD   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

// Notification Name
#define AD_NOTIFICATION_STARRED_UPDATE  @"AD_NOTIFICATION_STARRED_UPDATE"

#define AD_1PX    (1.0f / [UIScreen screenScale])

#endif /* DEFINES_h */
