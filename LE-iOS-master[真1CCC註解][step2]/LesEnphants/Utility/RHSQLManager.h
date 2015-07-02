//
//  RHSQLManager.h
//  HotaiAppPortal
//
//  Created by Rusty Huang on 2014/5/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"


typedef enum
{
    RHSQLManager_STATUS_NONE = 0,
    RHSQLManager_STATUS_NOTFOUND,
    RHSQLManager_STATUS_DUPLICATE,
    RHSQLManager_STATUS_ERROR,
    RHSQLManager_STATUS_OK
}RHENUM_DB_STATUS_CODE;


#define kLocalDBPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/lesenphants.sqlite"]

@interface RHSQLManager : FMDatabase

#pragma mark - Class Methods
/**
@函式說明 : 返回一個 Singleton SQLite 管理器
@傳入參數 : NONE
@回傳參數 : Singleton SQLite 管理器
**/
+ (instancetype)instance;

#pragma mark - Customized Methods

- ( BOOL )createUserDataTable;

- ( BOOL )insertRecordData:( NSDictionary * )pData;
- ( BOOL )insertEchoImgData:( NSDictionary * )pData;
- ( NSString * )getLastEchoImgData;


#pragma mark - Chat
- ( BOOL )createChatDatabase;
- ( BOOL )insetChatJID:( NSString * )pstrJID
             Timestamp:( NSString * )pstrTimeStamp
               LastMsg:( NSString * )pstrMsg
           DisplayName:( NSString * )pstrName;


- ( BOOL )insetChatLog:( NSString * )pstrJID
                   Msg:( NSString * )pstrMsg
             Timestamp:( NSString * )pstrTimeStamp
               MsgType:( NSString * )pstrType
                  Send:( NSString * )pstrSend;

- ( NSArray * )getChatList;
- ( NSArray * )getChatLogWithJID:( NSString * )pstrJID;

@end
