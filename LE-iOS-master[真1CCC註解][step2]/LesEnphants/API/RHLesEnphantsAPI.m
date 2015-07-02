//
//  RHLesEnphantsAPI.m
//  LesEnphantsAPI
//
//  Created by Rusty Huang on 2014/7/21.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHLesEnphantsAPI.h"
#import "SBJson.h"
#import "LesEnphantsApiDefinition.h"
#import "Utilities.h"
#import "RHAppDelegate.h"



@interface RHLesEnphantsAPI ()


@end

@implementation RHLesEnphantsAPI

#pragma mark - Utility
+ ( void )printPostData:( ASIFormDataRequest * )pRequest
{
    DLog(@"API:%@\n%@", [pRequest url],[pRequest postArgs]);
}

+ ( NSInteger )getDeviceTypeID
{
    NSString *pstrDevice = [[UIDevice currentDevice] model];
    NSInteger nID = 0;
    
    if ( [pstrDevice rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        nID = 1;
    }
    
    if ( [pstrDevice rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        nID = 2;
    }
    
    if ( [pstrDevice rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        nID = 3;
    }
    
    
    return nID;
}

+ ( NSInteger )getLoginTypeID:( NSString * )pstrType
{
    NSInteger nID = -1;
    if ( [pstrType compare:@"Guest" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        nID = 0;
    }
    
    if ( [pstrType compare:@"FB" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        nID = 1;
    }
    
    if ( [pstrType compare:@"EMAIL" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        nID = 2;
    }
    
    return nID;
}

+( NSString * )getLanID
{
    NSString *pstrLangID = @"0";
    
    NSString *pstrLang = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ( [pstrLang compare:@"zh-Hans" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        pstrLangID = @"1";
    }
    
    
    return pstrLangID;
}


#pragma mark - Gateway
+ ( void )KeepAlive:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kKeepAliveAPI];
        
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];

        
        NSString *pstrSession = [RHAppDelegate getPHPSessionID];
        
        if ( pstrSession == nil  )
        {
            return;
        }
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];        //PHP Session ID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackKeepAliveStatus:)] )
            {
                [sourceDelegate callBackKeepAliveStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackKeepAliveStatus:)] )
            {
                [sourceDelegate callBackKeepAliveStatus:nil];
            }
            
        }];
        [request startAsynchronous];
    }
    else
    {
        //無網路
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )ResetPassword:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kResetPasswordAPI];
        
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        NSInteger nType = [self getLoginTypeID:[pParameter objectForKey:@"Type"]];
        
        [pRequest addPostValue:[NSString stringWithFormat:@"%ld", (long)nType] forKey:kMethod];    //method
        [pRequest addPostValue:[pParameter objectForKey:@"ID"] forKey:kAccount];            //Account
        
        if ( nType == 2 )
        {
            [pRequest addPostValue:[pParameter objectForKey:@"PW"] forKey:kPassword];       //Password, Email Only
        }
        
        [pRequest addPostValue:[NSString stringWithFormat:@"%ld", (long)[self getDeviceTypeID]] forKey:kDeviceType];   //deviceType
        
        [pRequest addPostValue:[[UIDevice currentDevice] model] forKey:kModel];             //modal
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackResetPasswordStatus:)] )
            {
                [sourceDelegate callBackResetPasswordStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackResetPasswordStatus:)] )
            {
                [sourceDelegate callBackResetPasswordStatus:nil];
            }
            
        }];
        [request startAsynchronous];
    }
    else
    {
        //無網路
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )Login:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kLoginAPI];
        
        //CCC:ASIFormDataRequest是專門處理HTTP的工具
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        NSInteger nType = [self getLoginTypeID:[pParameter objectForKey:@"Type"]];
        //CCC:如果用Facebook登入,nType為1
        [pRequest addPostValue:[NSString stringWithFormat:@"%ld", (long)nType] forKey:kMethod];    //method
        [pRequest addPostValue:[pParameter objectForKey:@"ID"] forKey:kAccount];            //Account
        
        if ( nType == 2 )
        {
            [pRequest addPostValue:[pParameter objectForKey:@"PW"] forKey:kPassword];       //Password, Email Only
        }
        
        [pRequest addPostValue:[NSString stringWithFormat:@"%ld", (long)[self getDeviceTypeID]] forKey:kDeviceType];   //deviceType
        
        [pRequest addPostValue:[[UIDevice currentDevice] model] forKey:kModel];             //modal
        /*
         CCC:
         [[UIDevice currentDevice] model]：The model of the device 如iPhone或iPod touch
         
         [[UIDevice currentDevice] uniqueIdentifier]：設備唯一編號 deviceID
        */
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackLoginStatus:)] )
            {
                [sourceDelegate callBackLoginStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackLoginStatus:)] )
            {
                [sourceDelegate callBackLoginStatus:nil];
            }
            
        }];
        [request startAsynchronous];
    }
    else
    {
        //無網路
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )setLoginType:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kLoginTypeAPI];

        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];

        [pRequest addPostValue:[pParameter objectForKey:kLoginType] forKey:kLoginType];    //LoginType
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];        //PHP Session ID
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetLoginTypeStatus:)] )
            {
                [sourceDelegate callBackSetLoginTypeStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetLoginTypeStatus:)] )
            {
                [sourceDelegate callBackSetLoginTypeStatus:nil];
            }
            
        }];
        [request startAsynchronous];
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )updateDeviceToken:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kUpdateDeviceTokenAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[pParameter objectForKey:kDeviceToken] forKey:kDeviceToken];    //LoginType
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];        //PHP Session ID
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackUpdateDeviceTokenStatus:)] )
            {
                [sourceDelegate callBackUpdateDeviceTokenStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackUpdateDeviceTokenStatus:)] )
            {
                [sourceDelegate callBackUpdateDeviceTokenStatus:nil];
            }
            
        }];
        [request startAsynchronous];
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}



+ ( void )setUserProfile:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kSetProfileAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        
        //選填
        NSString *pstrNickName = [pParameter objectForKey:kNickname];
        
        NSString *pstrExpectedDate = [pParameter objectForKey:kExpectedDate];
        
        NSString *pstrMobile = [pParameter objectForKey:kMobile];
        
        NSString *pstrEmail = [pParameter objectForKey:kEmail];
        
        NSString *pstrBirthday = [pParameter objectForKey:kBirthday];
        
        NSString *pstrHeight = [pParameter objectForKey:kHeight];
        
        NSString *pstrWeight = [pParameter objectForKey:kWeight];
        
        if ( pstrNickName )
        {
            [pRequest addPostValue:pstrNickName forKey:kNickname];
        }
        
        if ( pstrExpectedDate )
        {
            [pRequest addPostValue:pstrExpectedDate forKey:kExpectedDate];
        }
        
        if ( pstrMobile )
        {
            [pRequest addPostValue:pstrMobile forKey:kMobile];
        }
        
        if ( pstrEmail )
        {
            [pRequest addPostValue:pstrEmail forKey:kEmail];
        }
        
        if ( pstrBirthday )
        {
            [pRequest addPostValue:pstrBirthday forKey:kBirthday];
        }
        
        if ( pstrHeight )
        {
            [pRequest addPostValue:pstrHeight forKey:kHeight];
        }
        
        if ( pstrWeight )
        {
            [pRequest addPostValue:pstrWeight forKey:kWeight];
        }
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetUserProfileStatus:)] )
            {
                [sourceDelegate callBackSetUserProfileStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetUserProfileStatus:)] )
            {
                [sourceDelegate callBackSetUserProfileStatus:nil];
            }
            
        }];
        [request startAsynchronous];
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}


+ ( void )setuserPhoto:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kSetPhotoAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID

        //User Photo
        NSData *pPhotoData = [pParameter objectForKey:kPhoto];
        
        if ( pPhotoData )
        {
            //[pRequest setPostValue:pRecordData forKey:@"Files"];
            [pRequest addData:pPhotoData withFileName:@"image.png" andContentType:@"image/png" forKey:kPhoto];
        }
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetUserPhotoStatus:)] )
            {
                [sourceDelegate callBackSetUserPhotoStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetUserPhotoStatus:)] )
            {
                [sourceDelegate callBackSetUserPhotoStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getUserProfile:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetProfileAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetUserProfileStatus:)] )
            {
                [sourceDelegate callBackGetUserProfileStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetUserProfileStatus:)] )
            {
                [sourceDelegate callBackGetUserProfileStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )addPreganatRecord:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kAddPregnantRecordAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        NSString *pstrType = [pParameter objectForKey:kType];
        
        [pRequest addPostValue:pstrType forKey:kType];
        [pRequest addPostValue:[pParameter objectForKey:kTime] forKey:kTime];
        [pRequest addPostValue:[pParameter objectForKey:kMeta] forKey:kMeta];
        
        
        //User Photo
        NSData *pFileData = [pParameter objectForKey:kFile];
        
        if (  [pstrType compare:@"2" options:NSCaseInsensitiveSearch] == NSOrderedSame ) //胎心音，是錄影檔
        {
            [pRequest addData:pFileData withFileName:@"Video.mp4" andContentType:@"video/mp4" forKey:kFile];
        }
        else
        {
            [pRequest addData:pFileData withFileName:@"icon.jpeg" andContentType:@"image/jpeg" forKey:kFile];
        }
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAddPregnantRecordStatus:)] )
            {
                [sourceDelegate callBackAddPregnantRecordStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAddPregnantRecordStatus:)] )
            {
                [sourceDelegate callBackAddPregnantRecordStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )getPreganatRecord:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetPregnantRecordAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kType] forKey:kType];
        [pRequest addPostValue:[pParameter objectForKey:kFilter] forKey:kFilter];
        [pRequest addPostValue:[pParameter objectForKey:kKeyWord] forKey:kKeyWord];
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetPregnantRecordStatus:)] )
            {
                [sourceDelegate callBackGetPregnantRecordStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetPregnantRecordStatus:)] )
            {
                [sourceDelegate callBackGetPregnantRecordStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )deletePreganatRecord:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kdelPregnantRecordAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kRecordID] forKey:kRecordID];
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackDelPregnantRecordStatus:)] )
            {
                [sourceDelegate callBackDelPregnantRecordStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackDelPregnantRecordStatus:)] )
            {
                [sourceDelegate callBackDelPregnantRecordStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )addPregnantEvent:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kAddPregnantEventAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kIsPrenatalExamination] forKey:kIsPrenatalExamination];
        [pRequest addPostValue:[pParameter objectForKey:kDate] forKey:kDate];
        [pRequest addPostValue:[pParameter objectForKey:kStart] forKey:kStart];
        [pRequest addPostValue:[pParameter objectForKey:kEnd] forKey:kEnd];
        [pRequest addPostValue:[pParameter objectForKey:kNote] forKey:kNote];
        [pRequest addPostValue:[pParameter objectForKey:kEnablePush] forKey:kEnablePush];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAddPregnantEventStatus:)] )
            {
                [sourceDelegate callBackAddPregnantEventStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAddPregnantEventStatus:)] )
            {
                [sourceDelegate callBackAddPregnantEventStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getPregnantEvent:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetPregnantEventAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kType] forKey:kType];
        [pRequest addPostValue:[pParameter objectForKey:kFilter] forKey:kFilter];
        [pRequest addPostValue:[pParameter objectForKey:kKeyWord] forKey:kKeyWord];
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetPregnantEventStatus:)] )
            {
                [sourceDelegate callBackGetPregnantEventStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetPregnantEventStatus:)] )
            {
                [sourceDelegate callBackGetPregnantEventStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )addWeightRecord:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kAddPregnantWeightAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kDate] forKey:kDate];
        [pRequest addPostValue:[pParameter objectForKey:kWeight] forKey:kWeight];
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAddPregnantWeightStatus:)] )
            {
                [sourceDelegate callBackAddPregnantWeightStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAddPregnantWeightStatus:)] )
            {
                [sourceDelegate callBackAddPregnantWeightStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getWeightRecord:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetPregnantWeightAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetPregnantWeightStatus:)] )
            {
                [sourceDelegate callBackGetPregnantWeightStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetPregnantWeightStatus:)] )
            {
                [sourceDelegate callBackGetPregnantWeightStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getKnowledgeList:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetKnowledgeListAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[self getLanID] forKey:kLanguage];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetKnowledgeListStatus:)] )
            {
                [sourceDelegate callBackGetKnowledgeListStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetKnowledgeListStatus:)] )
            {
                [sourceDelegate callBackGetKnowledgeListStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )getKnowledgeContent:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetKnowledgeContentAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kFilter] forKey:kFilter];
        [pRequest addPostValue:[pParameter objectForKey:kKeyWord] forKey:kKeyWord];
        [pRequest addPostValue:[self getLanID] forKey:kLanguage];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetKnowledgeContentStatus:)] )
            {
                [sourceDelegate callBackGetKnowledgeContentStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetKnowledgeContentStatus:)] )
            {
                [sourceDelegate callBackGetKnowledgeContentStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getNewsList:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetNewsListAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetNewsListStatus:)] )
            {
                [sourceDelegate callBackGetNewsListStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetNewsListStatus:)] )
            {
                [sourceDelegate callBackGetNewsListStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getNewsContent:( NSDictionary * )pParameter Source:( id )sourceDelegate CntType:( NSInteger )nType
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = @"";;
        if (nType == 4 || nType == 1 || nType == 3)
        {
            pstrServer = [NSString stringWithFormat:@"%@/%@-%dv2.api",kServer, kGetNewsContentAPI, nType+1];
        }
        else
        {
            pstrServer = [NSString stringWithFormat:@"%@/%@-%d.api",kServer, kGetNewsContentAPI, nType+1];
        }
        
        
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[self getLanID] forKey:kLanguage];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetNewsContentStatus:)] )
            {
                [sourceDelegate callBackGetNewsContentStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetNewsContentStatus:)] )
            {
                [sourceDelegate callBackGetNewsContentStatus:nil];
            }
            
        }];
        [request startAsynchronous];

    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )setMatchID:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kSetMatchIdAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
         [pRequest addPostValue:[pParameter objectForKey:kPostMatchID] forKey:kPostMatchID];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetmatchIdStatus:)] )
            {
                [sourceDelegate callBackSetmatchIdStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetmatchIdStatus:)] )
            {
                [sourceDelegate callBackSetmatchIdStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )setRecommandID:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kSetRecommandIdAPI];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kPostRecommandID] forKey:kPostRecommandID];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetRecommandIdStatus:)] )
            {
                [sourceDelegate callBackSetRecommandIdStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetRecommandIdStatus:)] )
            {
                [sourceDelegate callBackSetRecommandIdStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getUserByMatchID:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetUserByMatchID];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kPostMatchID] forKey:kPostMatchID];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetUserByMatchID:)] )
            {
                [sourceDelegate callBackGetUserByMatchID:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetUserByMatchID:)] )
            {
                [sourceDelegate callBackGetUserByMatchID:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )AddUserToFreindByMatchID:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kAddUsertoFriendByMatchID];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kPostMatchID] forKey:kPostMatchID];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAddUserToFriendByMatchID:)] )
            {
                [sourceDelegate callBackAddUserToFriendByMatchID:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAddUserToFriendByMatchID:)] )
            {
                [sourceDelegate callBackAddUserToFriendByMatchID:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )DeleteUserToFreindByMatchID:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kDeleteUsertoFriendByMatchID];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kPostMatchID] forKey:kPostMatchID];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackDeleteUserToFriendByMatchID:)] )
            {
                [sourceDelegate callBackDeleteUserToFriendByMatchID:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackDeleteUserToFriendByMatchID:)] )
            {
                [sourceDelegate callBackDeleteUserToFriendByMatchID:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )AddNewTodo:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kAddNewTodo];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kToDo] forKey:kToDo];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAddNewTotoStatus:)] )
            {
                [sourceDelegate callBackAddNewTotoStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAddNewTotoStatus:)] )
            {
                [sourceDelegate callBackAddNewTotoStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}
+ ( void )DeleteTodo:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kDeleteTodo];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kToDoID] forKey:kToDoID];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackDeleteTotoStatus:)] )
            {
                [sourceDelegate callBackDeleteTotoStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackDeleteTotoStatus:)] )
            {
                [sourceDelegate callBackDeleteTotoStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )GetTodoList:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetTodoList];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kFilter] forKey:kFilter];
        [pRequest addPostValue:[pParameter objectForKey:kKeyWord] forKey:kKeyWord];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetTodoList:)] )
            {
                [sourceDelegate callBackGetTodoList:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetTodoList:)] )
            {
                [sourceDelegate callBackGetTodoList:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )ReadTodoWithID:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kReadTodo];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kToDoID] forKey:kToDoID];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackReadTodoStatus:)] )
            {
                [sourceDelegate callBackReadTodoStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackReadTodoStatus:)] )
            {
                [sourceDelegate callBackReadTodoStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )ReportTodoWithID:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kReportTodo];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kToDoID] forKey:kToDoID];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackReportTodoStatus:)] )
            {
                [sourceDelegate callBackReportTodoStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackReportTodoStatus:)] )
            {
                [sourceDelegate callBackReportTodoStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )ConfirmTodoWithID:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kConfirmTodo];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kToDoID] forKey:kToDoID];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackConfirmTodoStatus:)] )
            {
                [sourceDelegate callBackConfirmTodoStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackConfirmTodoStatus:)] )
            {
                [sourceDelegate callBackConfirmTodoStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )UploadFileForChat:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kUploadFileForChat];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        NSData *pFileData = [pParameter objectForKey:kFile];
        [pRequest addData:pFileData withFileName:@"File" andContentType:@"video/mp4" forKey:kFile];

        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackUploadFileForChatStatus:)] )
            {
                [sourceDelegate callBackUploadFileForChatStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackUploadFileForChatStatus:)] )
            {
                [sourceDelegate callBackUploadFileForChatStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )getQrCodeImage:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kQrCodeImage];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kString] forKey:kString];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackQrCodeImage:)] )
            {
                [sourceDelegate callBackQrCodeImage:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackQrCodeImage:)] )
            {
                [sourceDelegate callBackQrCodeImage:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getQrCodeImage2:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kQrCodeImage2];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kString] forKey:kString];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackQrCodeImage2:)] )
            {
                [sourceDelegate callBackQrCodeImage2:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackQrCodeImage2:)] )
            {
                [sourceDelegate callBackQrCodeImage2:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )setRegard:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kSetRegard];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kEnableMoodChange] forKey:kEnableMoodChange];
        [pRequest addPostValue:[pParameter objectForKey:kMon] forKey:kMon];
        [pRequest addPostValue:[pParameter objectForKey:kTues] forKey:kTues];
        [pRequest addPostValue:[pParameter objectForKey:kWed] forKey:kWed];
        [pRequest addPostValue:[pParameter objectForKey:kThur] forKey:kThur];
        [pRequest addPostValue:[pParameter objectForKey:kFri] forKey:kFri];
        [pRequest addPostValue:[pParameter objectForKey:kSat] forKey:kSat];
        [pRequest addPostValue:[pParameter objectForKey:kSun] forKey:kSun];
        [pRequest addPostValue:[pParameter objectForKey:kBody] forKey:kBody];
        [pRequest addPostValue:[pParameter objectForKey:kTime] forKey:kTime];
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetRegardStatus:)] )
            {
                [sourceDelegate callBackSetRegardStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetRegardStatus:)] )
            {
                [sourceDelegate callBackSetRegardStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )uploadMoodImage:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kUploadIamge];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kMood] forKey:kMood];
        
        NSData *pFileData = [pParameter objectForKey:kImage];
        [pRequest addData:pFileData withFileName:@"icon.jpeg" andContentType:@"image/jpeg" forKey:kImage];

        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackuploadMoodImage:)] )
            {
                [sourceDelegate callBackuploadMoodImage:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackuploadMoodImage:)] )
            {
                [sourceDelegate callBackuploadMoodImage:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )setMotherMood:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kSetMotherMood];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kMood] forKey:kMood];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetMotherMoodImage:)] )
            {
                [sourceDelegate callBackSetMotherMoodImage:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetMotherMoodImage:)] )
            {
                [sourceDelegate callBackSetMotherMoodImage:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getMotherMood:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetMotherMood];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetMotherMoodImage:)] )
            {
                [sourceDelegate callBackGetMotherMoodImage:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetMotherMoodImage:)] )
            {
                [sourceDelegate callBackGetMotherMoodImage:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getMoodStatistics:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetMotherStatistics];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kFilter] forKey:kFilter];
        [pRequest addPostValue:[pParameter objectForKey:kKeyWord] forKey:kKeyWord];
        
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetMotherMoodStatistics:)] )
            {
                [sourceDelegate callBackGetMotherMoodStatistics:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetMotherMoodStatistics:)] )
            {
                [sourceDelegate callBackGetMotherMoodStatistics:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )pushMotherMood:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kPushMotherMood];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kBody] forKey:kBody];
        
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackPushMotherMoodStatus:)] )
            {
                [sourceDelegate callBackPushMotherMoodStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackPushMotherMoodStatus:)] )
            {
                [sourceDelegate callBackPushMotherMoodStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )exchangePoint:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kExchangePoint];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kPoint] forKey:kPoint];
        
        NSString *pstrBirthday = [pParameter objectForKey:kBirthday];
        
        if ( pstrBirthday )
        {
           [pRequest addPostValue:pstrBirthday forKey:kBirthday];
        }
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackExchangePointStatus:)] )
            {
                [sourceDelegate callBackExchangePointStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackExchangePointStatus:)] )
            {
                [sourceDelegate callBackExchangePointStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )updateEvent:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kUpdateEvent];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kIsPrenatalExamination] forKey:kIsPrenatalExamination];
        [pRequest addPostValue:[pParameter objectForKey:kDate] forKey:kDate];
        [pRequest addPostValue:[pParameter objectForKey:kStart] forKey:kStart];
        [pRequest addPostValue:[pParameter objectForKey:kEnd] forKey:kEnd];
        [pRequest addPostValue:[pParameter objectForKey:kNote] forKey:kNote];
        [pRequest addPostValue:[pParameter objectForKey:kEnablePush] forKey:kEnablePush];
        [pRequest addPostValue:[pParameter objectForKey:kEnventID] forKey:kEnventID];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackUpdateEventStatus:)] )
            {
                [sourceDelegate callBackUpdateEventStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackUpdateEventStatus:)] )
            {
                [sourceDelegate callBackUpdateEventStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )updateNotes:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kUpdateNotes];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kNote] forKey:kNote];
        [pRequest addPostValue:[pParameter objectForKey:kEvnetID] forKey:kEvnetID];
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackUpdateNotesStatus:)] )
            {
                [sourceDelegate callBackUpdateNotesStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackUpdateNotesStatus:)] )
            {
                [sourceDelegate callBackUpdateNotesStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getEmotionDB:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetEmotionDB];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"getEmotionDB = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetEmontionDBStatus:)] )
            {
                [sourceDelegate callBackGetEmontionDBStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetEmontionDBStatus:)] )
            {
                [sourceDelegate callBackGetEmontionDBStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )shareRecordLog:( id )sourceDelegate;
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kShareRecord];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"shareRecordLog = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackShareRecordStatus:)] )
            {
                [sourceDelegate callBackShareRecordStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackShareRecordStatus:)] )
            {
                [sourceDelegate callBackShareRecordStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )shareAppLog:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kShareApp];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"shareAppLog = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackShareAppStatus:)] )
            {
                [sourceDelegate callBackShareAppStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackShareAppStatus:)] )
            {
                [sourceDelegate callBackShareAppStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}


#pragma mark - 社群
+ ( void )getAssociationList:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetAssociationList];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID

        [pRequest addPostValue:[self getLanID] forKey:kLanguage];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetAssociationListStatus:)] )
            {
                [sourceDelegate callBackGetAssociationListStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetAssociationListStatus:)] )
            {
                [sourceDelegate callBackGetAssociationListStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )newAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kNewAssociation];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        //User Photo
        NSData *pPhotoData = [pParameter objectForKey:kAssoImage];
        
        if ( pPhotoData )
        {
            //[pRequest setPostValue:pRecordData forKey:@"Files"];
            [pRequest addData:pPhotoData withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:kAssoImage];
        }
        
        [pRequest addPostValue:[pParameter objectForKey:kAssoSignStar] forKey:kAssoSignStar];
        [pRequest addPostValue:[pParameter objectForKey:kAssoSignChina] forKey:kAssoSignChina];
        [pRequest addPostValue:[pParameter objectForKey:kExpectedDate] forKey:kExpectedDate];
        [pRequest addPostValue:[pParameter objectForKey:kAssoCity] forKey:kAssoCity];
        [pRequest addPostValue:[pParameter objectForKey:kAssoClass] forKey:kAssoClass];
        [pRequest addPostValue:[pParameter objectForKey:kAssoPurpost] forKey:kAssoPurpost];
        [pRequest addPostValue:[pParameter objectForKey:kAssoIsPrivate] forKey:kAssoIsPrivate];
        [pRequest addPostValue:[pParameter objectForKey:kAssoName] forKey:kAssoName];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackNewAssociationByClassStatus:)] )
            {
                [sourceDelegate callBackNewAssociationByClassStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackNewAssociationByClassStatus:)] )
            {
                [sourceDelegate callBackNewAssociationByClassStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}
+ ( void )updateAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kUpdateAssociation];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        //User Photo
        NSData *pPhotoData = [pParameter objectForKey:kAssoImage];
        
        if ( pPhotoData )
        {
            //[pRequest setPostValue:pRecordData forKey:@"Files"];
            [pRequest addData:pPhotoData withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:kAssoImage];
        }
         [pRequest addPostValue:[pParameter objectForKey:kAssoASID] forKey:kAssoASID];
        [pRequest addPostValue:[pParameter objectForKey:kAssoSignStar] forKey:kAssoSignStar];
        [pRequest addPostValue:[pParameter objectForKey:kAssoSignChina] forKey:kAssoSignChina];
        [pRequest addPostValue:[pParameter objectForKey:kExpectedDate] forKey:kExpectedDate];
        [pRequest addPostValue:[pParameter objectForKey:kAssoCity] forKey:kAssoCity];
        [pRequest addPostValue:[pParameter objectForKey:kAssoClass] forKey:kAssoClass];
        [pRequest addPostValue:[pParameter objectForKey:kAssoPurpost] forKey:kAssoPurpost];
        [pRequest addPostValue:[pParameter objectForKey:kAssoIsPrivate] forKey:kAssoIsPrivate];
        [pRequest addPostValue:[pParameter objectForKey:kAssoName] forKey:kAssoName];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackUpdateAssociationByClassStatus:)] )
            {
                [sourceDelegate callBackUpdateAssociationByClassStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackUpdateAssociationByClassStatus:)] )
            {
                [sourceDelegate callBackUpdateAssociationByClassStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getMyAssociation:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetMyAssociation];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetMyAssociationListStatus:)] )
            {
                [sourceDelegate callBackGetMyAssociationListStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetMyAssociationListStatus:)] )
            {
                [sourceDelegate callBackGetMyAssociationListStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )getAssociationListByClass:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetAssociationListByClass];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoListClass] forKey:kAssoListClass]; //class
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetAssociationByClassStatus:)] )
            {
                [sourceDelegate callBackGetAssociationByClassStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetAssociationByClassStatus:)] )
            {
                [sourceDelegate callBackGetAssociationByClassStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )getAssociationTopList:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetAssociationTopList];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGerAssociationTopListStatus:)] )
            {
                [sourceDelegate callBackGerAssociationTopListStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGerAssociationTopListStatus:)] )
            {
                [sourceDelegate callBackGerAssociationTopListStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )getAssociationByID:(NSString * )pstrASID Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetAssociationByID];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:pstrASID forKey:kAssoASID]; //class
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetAssociationByIdStatus:)] )
            {
                [sourceDelegate callBackGetAssociationByIdStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetAssociationByIdStatus:)] )
            {
                [sourceDelegate callBackGetAssociationByIdStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )searchAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kSearchAssociation];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        NSString *pstrCity = [pParameter objectForKey:kAssoCity];
        if ( pstrCity )
        {
            [pRequest addPostValue:pstrCity forKey:kAssoCity]; //class
        }
        
        NSString *pstrSignStar = [pParameter objectForKey:kAssoSignStar];
        if ( pstrSignStar )
        {
            [pRequest addPostValue:pstrSignStar forKey:kAssoSignStar]; //class
        }
        
        NSString *pstrSignChina = [pParameter objectForKey:kAssoSignChina];
        if ( pstrSignChina )
        {
            [pRequest addPostValue:pstrSignChina forKey:kAssoSignChina]; //class
        }
        
        NSString *pstrKeyword = [pParameter objectForKey:kAssoKeyword];
        if ( pstrKeyword )
        {
            [pRequest addPostValue:pstrKeyword forKey:kAssoKeyword]; //class
        }
        
        
        
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSearchAssociationStatus:)] )
            {
                [sourceDelegate callBackSearchAssociationStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSearchAssociationStatus:)] )
            {
                [sourceDelegate callBackSearchAssociationStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )reportAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kReportAssociation];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackReportAssociationPostStatus:)] )
            {
                [sourceDelegate callBackReportAssociationPostStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackReportAssociationPostStatus:)] )
            {
                [sourceDelegate callBackReportAssociationPostStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}


+ ( void )joinAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kJoinAssociation];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackJoinAssociationPostStatus:)] )
            {
                [sourceDelegate callBackJoinAssociationPostStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackJoinAssociationPostStatus:)] )
            {
                [sourceDelegate callBackJoinAssociationPostStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}


+ ( void )leaveAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kLeaveAssociation];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackLeaveAssociationPostStatus:)] )
            {
                [sourceDelegate callBackLeaveAssociationPostStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackLeaveAssociationPostStatus:)] )
            {
                [sourceDelegate callBackLeaveAssociationPostStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )SetAssociationMeberPermission:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kSetAssociationMemberPermission];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        [pRequest addPostValue:[pParameter objectForKey:kAssoMatchId] forKey:kAssoMatchId];               //AssociationID
        [pRequest addPostValue:[pParameter objectForKey:kAssoIsManager] forKey:kAssoIsManager];
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetAssociationPermissionStatus:)] )
            {
                [sourceDelegate callBackSetAssociationPermissionStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackSetAssociationPermissionStatus:)] )
            {
                [sourceDelegate callBackSetAssociationPermissionStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}


+ ( void )acceptAssociationApply:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kAcceptAssociationApply];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        [pRequest addPostValue:[pParameter objectForKey:kAssoMatchId] forKey:kAssoMatchId];               //AssociationID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAcceptAssociationStatus:)] )
            {
                [sourceDelegate callBackAcceptAssociationStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackAcceptAssociationStatus:)] )
            {
                [sourceDelegate callBackAcceptAssociationStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )kickMemberFromAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kKickMemberFromAsso];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        [pRequest addPostValue:[pParameter objectForKey:kAssoMatchId] forKey:kAssoMatchId];               //AssociationID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackKickMemberFromAssociationStatus:)] )
            {
                [sourceDelegate callBackKickMemberFromAssociationStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackKickMemberFromAssociationStatus:)] )
            {
                [sourceDelegate callBackKickMemberFromAssociationStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )newAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kNewAssociationPost];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        
        //User Photo
        NSData *pPhotoData = [pParameter objectForKey:kAssoImage];
        
        if ( pPhotoData )
        {
            //[pRequest setPostValue:pRecordData forKey:@"Files"];
            [pRequest addData:pPhotoData withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:kAssoImage];
        }
        
        [pRequest addPostValue:[pParameter objectForKey:kAssoSubject] forKey:kAssoSubject];
        [pRequest addPostValue:[pParameter objectForKey:kAssoContent] forKey:kAssoContent];
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];
        
        
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackNewAssociationPostStatus:)] )
            {
                [sourceDelegate callBackNewAssociationPostStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackNewAssociationPostStatus:)] )
            {
                [sourceDelegate callBackNewAssociationPostStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
    
}


+ ( void )getAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetAssociationPost];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetAssociationPostStatus:)] )
            {
                [sourceDelegate callBackGetAssociationPostStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetAssociationPostStatus:)] )
            {
                [sourceDelegate callBackGetAssociationPostStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}



+ ( void )deleteAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kDeleteAssociationPost];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        [pRequest addPostValue:[pParameter objectForKey:kAssoPostID] forKey:kAssoPostID];               //AssociationID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackDeleteAssociationPostStatus:)] )
            {
                [sourceDelegate callBackDeleteAssociationPostStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackDeleteAssociationPostStatus:)] )
            {
                [sourceDelegate callBackDeleteAssociationPostStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )deleteAssociationComment:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kDeleteAssociationComment];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        [pRequest addPostValue:[pParameter objectForKey:kAssoPostID] forKey:kAssoPostID];               //AssociationID
        [pRequest addPostValue:[pParameter objectForKey:kAssoCommentID] forKey:kAssoCommentID];
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackDeleteAssociationCommentStatus:)] )
            {
                [sourceDelegate callBackDeleteAssociationCommentStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackDeleteAssociationCommentStatus:)] )
            {
                [sourceDelegate callBackDeleteAssociationCommentStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }
}

+ ( void )reportAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kReportAssociationPost];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        [pRequest addPostValue:[pParameter objectForKey:kAssoPostID] forKey:kAssoPostID];               //AssociationID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackReportAssociationPostStatus:)] )
            {
                [sourceDelegate callBackReportAssociationPostStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackReportAssociationPostStatus:)] )
            {
                [sourceDelegate callBackReportAssociationPostStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )likeAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kLikeAssociationPost];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        [pRequest addPostValue:[pParameter objectForKey:kAssoPostID] forKey:kAssoPostID];               //AssociationID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackLikeAssociationPostStatus:)] )
            {
                [sourceDelegate callBackLikeAssociationPostStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackLikeAssociationPostStatus:)] )
            {
                [sourceDelegate callBackLikeAssociationPostStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}


+ ( void )commentAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kCommentAssociationPost];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];            //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];
        [pRequest addPostValue:[pParameter objectForKey:kAssoPostID] forKey:kAssoPostID];
        [pRequest addPostValue:[pParameter objectForKey:kAssoComment] forKey:kAssoComment];
        
        //User Photo
        NSData *pPhotoData = [pParameter objectForKey:kAssoImage];
        
        if ( pPhotoData )
        {
            //[pRequest setPostValue:pRecordData forKey:@"Files"];
            [pRequest addData:pPhotoData withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:kAssoImage];
        }
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackCommentPostStatus:)] )
            {
                [sourceDelegate callBackCommentPostStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackCommentPostStatus:)] )
            {
                [sourceDelegate callBackCommentPostStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )visitAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kVisitAssociation];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];               //AssociationID
        [pRequest addPostValue:[pParameter objectForKey:kAssoPostID] forKey:kAssoPostID];               //AssociationID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
//            NSDictionary *pDic = [responseString JSONValue];
//            
//            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackLikeAssociationPostStatus:)] )
//            {
//                [sourceDelegate callBackLikeAssociationPostStatus:pDic];
//            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
//            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackLikeAssociationPostStatus:)] )
//            {
//                [sourceDelegate callBackLikeAssociationPostStatus:nil];
//            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        //[RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

+ ( void )getAssociationComment:( NSDictionary * )pParameter Source:( id )sourceDelegate
{
    if ( [Utilities isConnectedToInternet] )
    {
        NSString *pstrServer = [NSString stringWithFormat:@"%@/%@",kServer, kGetAssociationCommentById];
        
        ASIFormDataRequest *pRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:pstrServer]];
        
        [pRequest addPostValue:[RHAppDelegate getPHPSessionID] forKey:kPHPSessionID];               //PHP Session ID
        [pRequest addPostValue:[pParameter objectForKey:kAssoID] forKey:kAssoID];                   //AssociationID
        [pRequest addPostValue:[pParameter objectForKey:kAssoPostID] forKey:kAssoPostID];           //AssociationID
        
        [RHLesEnphantsAPI printPostData:pRequest];
        
        __block ASIFormDataRequest *request = pRequest;
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSLog(@"responseString = %@", responseString);
            
            NSDictionary *pDic = [responseString JSONValue];
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetAssociationCommentStatus:)] )
            {
                [sourceDelegate callBackGetAssociationCommentStatus:pDic];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Failed : %@", [error description]);
            
            if ( sourceDelegate && [sourceDelegate respondsToSelector:@selector(callBackGetAssociationCommentStatus:)] )
            {
                [sourceDelegate callBackGetAssociationCommentStatus:nil];
            }
            
        }];
        [request startAsynchronous];
        
    }
    else
    {
        [RHAppDelegate MessageBox:kNotConnectToInternetMSG];
    }

}

@end
