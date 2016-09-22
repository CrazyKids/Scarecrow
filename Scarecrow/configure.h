//
//  configure.h
//  Scarecrow
//
//  Created by duanhongjin on 16/7/11.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#ifndef configure_h
#define configure_h

#define github_client_id        @"c1d4933e35c7dbead606"
#define github_client_secret    @"3bf6f1e10337bc3ef48b378103f037df6efca0d8"
#define github_callback_url     @"https://github.com/CrazyKids/Scarecrow"

#ifdef DEBUG
    #define DataBase_Debug  1
#else
    #define DataBase_Debug  0
#endif


#define AD_DataBaseName            @"scarecrow.db"
#define AD_DataBaseEncryptionName  @"scarecrowx.db"
#define AD_DataBaseVersion         1


#endif /* configure_h */
