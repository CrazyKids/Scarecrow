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

// 由于github登录提示 Incorrect username or password, 故关闭2FA
#define DISABLE_2FA

#define AD_DataBaseName            @"scarecrow.db"
#define AD_DataBaseEncryptionName  @"scarecrowx.db"
#define AD_DataBaseVersion         1

#ifdef DEBUG
    #define DataBase_Debug  1
#else
    #define DataBase_Debug  0
#endif

#endif /* DEFINES_h */
