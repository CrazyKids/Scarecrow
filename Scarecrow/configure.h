//
//  configure.h
//  Scarecrow
//
//  Created by duanhongjin on 16/7/11.
//  Copyright © 2016年 duanhongjin. All rights reserved.
//

#ifndef configure_h
#define configure_h

#define github_client_id        @"fc0e3d615331d9308918"
#define github_client_secret    @"a899d6ea4f301b7a27fb71ce314d85b8381ce5d7"

#ifdef DEBUG
    #define DataBase_Debug  1
#else
    #define DataBase_Debug  0
#endif


#define AD_DataBaseName            @"scarecrow.db"
#define AD_DataBaseEncryptionName  @"scarecrowx.db"
#define AD_DataBaseVersion         1


#endif /* configure_h */
