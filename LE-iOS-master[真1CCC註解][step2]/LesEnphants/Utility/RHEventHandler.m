//
//  RHEventHandler.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/21.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHEventHandler.h"
#import "RHSQLManager.h"
#import "RHProfileObj.h"



@implementation RHEventHandler

+ ( NSString * )saveEchoImage:( NSData * )pJpegData
{
    //Get Timestamp
    NSDate *pNow = [NSDate date];
    NSTimeInterval kTime = [pNow timeIntervalSince1970];
    
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"yyyyMMdd"];
    NSString *pstrDate = [pFormatter stringFromDate:pNow];
    [pFormatter release];
    
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    
    NSString *pstrFilePath = [NSString stringWithFormat:@"%@/%.0f_ECHO.jpg", kEchoImgFolderPath, kTime];
    
    BOOL bWriteFile = [pJpegData writeToFile:pstrFilePath atomically:YES];
    
    if ( bWriteFile )
    {
        //寫檔成功，要加入DB
        
        /*
         超音波照片資料
         ECHO_Timestamp	      String, Primary Key
         ECHO_Date             String ( ex. 20140820)
         ECHO_LoginType        String ( ex. 1 -> Mom, 2 -> Dad, 3 -> Guest )
         */
        
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:[NSString stringWithFormat:@"%.0f", kTime] forKey:@"ECHO_Timestamp"];
        [pParameter setObject:pstrDate forKey:@"ECHO_Date"];
        [pParameter setObject:[NSString stringWithFormat:@"%d", pObj.m_nType] forKey:@"ECHO_LoginType"];
        
        BOOL bInsertSucc = [[RHSQLManager instance] insertEchoImgData:pParameter];
        
        if ( bInsertSucc )
        {
            NSLog(@"Insert SUCC");
        }
    }
    
    return pstrFilePath;
}

+ ( NSString * )saveLastEchoImg:( NSData * )pJpegData
{

    
    NSString *pstrFilePath = [NSString stringWithFormat:@"%@/lastEcho.jpg", kEchoImgFolderPath];
    
    BOOL bWriteFile = [pJpegData writeToFile:pstrFilePath atomically:YES];

    if ( !bWriteFile )
    {
        NSLog(@"save last echo image failed");
    }
    
    return pstrFilePath;
}

+ ( NSString * )getLastEchoImg
{
    return [NSString stringWithFormat:@"%@/lastEcho.jpg", kEchoImgFolderPath];
}
+ ( NSString * )saveLastShapeImg:( NSData * )pJpegData
{
    
    
    NSString *pstrFilePath = [NSString stringWithFormat:@"%@/lastShape.jpg", kEchoImgFolderPath];
    
    BOOL bWriteFile = [pJpegData writeToFile:pstrFilePath atomically:YES];
    
    if ( !bWriteFile )
    {
        NSLog(@"save last echo image failed");
    }
    
    return pstrFilePath;
}

+ ( NSString * )getLastShapeImg
{
    return [NSString stringWithFormat:@"%@/lastShape.jpg", kEchoImgFolderPath];
}

@end
