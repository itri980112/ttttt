//
//  RHSQLManager.m
//  HotaiAppPortal
//
//  Created by Rusty Huang on 2014/5/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHSQLManager.h"
#import "Utilities.h"

@implementation RHSQLManager


#pragma mark - LifeCycle
- (void)dealloc
{
    [super dealloc];
}

+ (instancetype)instance
{
    static dispatch_once_t onceToken;
    static RHSQLManager *_instance;
    
    dispatch_once(&onceToken, ^{
        _instance = [[RHSQLManager alloc]initWithPath:kLocalDBPath];
    });
    
    return _instance;
}

- (id)initWithPath:(NSString *)inPath
{
    self = [super initWithPath:inPath];
    if(self)
    {
        if([self open])
        {
            DLog(@"database open success");
        }
        else
        {
            DLog(@"database open fail");
        }
    }
    return self;
}


- ( BOOL )createUserDataTable
{
    /*
     錄音檔資料
     REC_Timestamp	      String, Primary Key
     REC_Date             String ( ex. 20140820)
     REC_LoginType        String ( ex. 1 -> Mom, 2 -> Dad, 3 -> Guest )
     */
    
    NSString *sqlCommand = @"CREATE TABLE IF NOT EXISTS RecordData(REC_Timestamp TEXT PRIMARY KEY, REC_Date TEXT,REC_LoginType TEXT)";
    
    NSLog(@"createLoginTable = %@", sqlCommand);
    BOOL bResult = [self executeUpdate:sqlCommand];
    
    if ( bResult == NO )
    {
        NSLog(@"建立RecordData失敗");
    }
    
    
    /*
     超音波照片資料
     ECHO_Timestamp	      String, Primary Key
     ECHO_Date             String ( ex. 20140820)
     ECHO_LoginType        String ( ex. 1 -> Mom, 2 -> Dad, 3 -> Guest )
     */
    
    sqlCommand = @"CREATE TABLE IF NOT EXISTS EchoImgData(ECHO_Timestamp TEXT PRIMARY KEY, ECHO_Date TEXT,ECHO_LoginType TEXT)";
    
    NSLog(@"EchoImgData = %@", sqlCommand);
    bResult = [self executeUpdate:sqlCommand];
    
    if ( bResult == NO )
    {
        NSLog(@"建立EchoImgData失敗");
    }

    /*
     身型照片資料
     SHAPE_Timestamp	      String, Primary Key
     SHAPE_Date             String ( ex. 20140820)
     SHAPE_LoginType        String ( ex. 1 -> Mom, 2 -> Dad, 3 -> Guest )
     */
    sqlCommand = @"CREATE TABLE IF NOT EXISTS ShapeImgData(SHAPE_Timestamp TEXT PRIMARY KEY, SHAPE_Date TEXT,SHAPE_LoginType TEXT)";
    
    NSLog(@"ShapeImgData = %@", sqlCommand);
    bResult = [self executeUpdate:sqlCommand];
    
    if ( bResult == NO )
    {
        NSLog(@"建立RecordData失敗");
    }

    
    
    return bResult;
}


- ( BOOL )insertRecordData:( NSDictionary * )pData
{
    BOOL bResult = NO;
    
    NSString *sqlCommand = [NSString stringWithFormat:@"Insert Into RecordData Values('%@', '%@','%@')",[pData objectForKey:@"REC_Timestamp"], [pData objectForKey:@"REC_Date"],[pData objectForKey:@"REC_LoginType"]];
    
    NSLog(@"insertRecordData = %@", sqlCommand);
    bResult = [self executeUpdate:sqlCommand];

    
    
    return bResult;
}

- ( BOOL )insertEchoImgData:( NSDictionary * )pData
{
    
    /*
     超音波照片資料
     ECHO_Timestamp	      String, Primary Key
     ECHO_Date             String ( ex. 20140820)
     ECHO_LoginType        String ( ex. 1 -> Mom, 2 -> Dad, 3 -> Guest )
     */
    
    BOOL bResult = NO;
    
    NSString *sqlCommand = [NSString stringWithFormat:@"Insert Into EchoImgData Values('%@', '%@','%@')",[pData objectForKey:@"ECHO_Timestamp"], [pData objectForKey:@"ECHO_Date"],[pData objectForKey:@"ECHO_LoginType"]];
    
    NSLog(@"insertEchoImgData = %@", sqlCommand);
    bResult = [self executeUpdate:sqlCommand];
    
    
    
    return bResult;
}

- ( NSString * )getLastEchoImgData
{
    NSString *pstrLashID = @"";
    
    NSString *sqlCommand = @"select * from EchoImgData Order by ECHO_Timestamp DESC Limit 1";
    
    NSLog(@"sqlCommand = %@", sqlCommand);
    
    FMResultSet *s = [self executeQuery:sqlCommand];
    
    while ( [s next] )
    {
        NSLog(@" s = %@", [[s resultDict] description]);
        
        pstrLashID = [s stringForColumn:@"ECHO_Timestamp"];

    }
    
    NSLog(@"pstrLashID = %@", pstrLashID);

    return pstrLashID;
}

#pragma mark - Chat
- ( BOOL )createChatDatabase
{
    /*
     聯天名單
     JID                    String, Primary Key
     Name                   Display Name
     Timestamp              String
     LastMsg                String
     */
    
    NSString *sqlCommand = @"CREATE TABLE IF NOT EXISTS ChatList(JID TEXT PRIMARY KEY, Name TEXT, Timestamp TEXT,LastMsg TEXT)";
    
    NSLog(@"createChatListTable = %@", sqlCommand);
    BOOL bResult = [self executeUpdate:sqlCommand];
    
    if ( bResult == NO )
    {
        NSLog(@"建立ChatList失敗");
    }

    
    
    /*
     聯天記錄
     JID
     Msg
     Timestamp       
     MsgType    //文字 -> 0, 貼圖 -> 1
     Send       //送出 -> 1, 收到 -> 0
     */
    
    sqlCommand = @"CREATE TABLE IF NOT EXISTS ChatLog(JID TEXT, Msg TEXT,Timestamp TEXT, MsgType TEXT, Send TEXT)";
    
    NSLog(@"create Chat Log = %@", sqlCommand);
    bResult = [self executeUpdate:sqlCommand];
    
    if ( bResult == NO )
    {
        NSLog(@"建立create Chat Log失敗");
    }
    
    return YES;

}

- ( BOOL )insetChatJID:( NSString * )pstrJID Timestamp:( NSString * )pstrTimeStamp LastMsg:( NSString * )pstrMsg DisplayName:( NSString * )pstrName
{
    BOOL bResult = YES;
    
    NSString *sqlCommand = [NSString stringWithFormat:@"INSERT INTO ChatList VALUES('%@','%@','%@', '%@')",
                            pstrJID, pstrName, pstrTimeStamp, pstrMsg];
    
    NSLog(@"insetChatJID = %@", sqlCommand);
    bResult = [self executeUpdate:sqlCommand];
    
    if ( bResult == NO )
    {
        //己存在，直接更新
        sqlCommand = [NSString stringWithFormat:@"UPDATE ChatList SET Timestamp='%@', LastMsg = '%@', Name = '%@' WHERE JID = '%@'",pstrTimeStamp, pstrMsg, pstrName, pstrJID];
        
        NSLog(@"updateChatList = %@", sqlCommand);
        bResult = [self executeUpdate:sqlCommand];
    }
    
    return bResult;
    
}

- ( BOOL )insetChatLog:( NSString * )pstrJID
                   Msg:( NSString * )pstrMsg
             Timestamp:( NSString * )pstrTimeStamp
               MsgType:( NSString * )pstrType
                  Send:( NSString * )pstrSend
{
    BOOL bResult = YES;
    
    NSString *sqlCommand = [NSString stringWithFormat:@"INSERT INTO ChatLog VALUES('%@','%@','%@','%@','%@')",
                            pstrJID, pstrMsg, pstrTimeStamp, pstrType, pstrSend];
    
    NSLog(@"insetChatJID = %@", sqlCommand);
    bResult = [self executeUpdate:sqlCommand];
    
    return bResult;
}

- ( NSArray * )getChatList
{
    NSMutableArray *pReturnArray = [NSMutableArray arrayWithCapacity:1];
    
    NSString *sqlCommand = @"SELECT * from ChatList";
    
    FMResultSet *rs = [self executeQuery:sqlCommand];
    
    while ( [rs next] )
    {
        NSDictionary *pDic = [rs resultDict];
        [pReturnArray addObject:pDic];
    }
    
    return pReturnArray;
}

- ( NSArray * )getChatLogWithJID:( NSString * )pstrJID
{
    NSMutableArray *pReturnArray = [NSMutableArray arrayWithCapacity:1];
    
    NSString *sqlCommand = [NSString stringWithFormat:@"SELECT * from ChatLog WHERE JID = '%@'", pstrJID];
    
    FMResultSet *rs = [self executeQuery:sqlCommand];
    
    while ( [rs next] )
    {
        NSDictionary *pDic = [rs resultDict];
        [pReturnArray addObject:pDic];
    }
    
    return pReturnArray;
}


@end
