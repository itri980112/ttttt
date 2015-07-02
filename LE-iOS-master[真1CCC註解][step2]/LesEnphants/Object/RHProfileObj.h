//
//  RHProfileObj.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/18.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kExpectedDate                   @"expectedDate"
#define kFriendsArray                   @"FriendsArray"
#define kObjGestation                      @"Gestation"
#define kID                             @"ID"
#define kJID                            @"JID"
#define kJPassword                      @"JPassword"
#define kMatchID                        @"MatchID"
#define kObjMobile                         @"Mobile"
#define kNickName                       @"NickName"
#define kPhotoURL                       @"PhotoURL"
#define kPoint                          @"Point"
#define kLePoint                        @"LePoint"
#define kWeek                           @"week"
#define kLeMember                       @"leMember"
#define kProfileType                           @"ProfileType"
#define kProfileMood                           @"ProfileMood"
#define kProfileEmail                           @"ProfileEmail"
#define kProfileBirthday                        @"ProfileBirthday"
#define kProfileLecard                          @"ProfileLeCard"
#define kRecommandData                          @"RecommandData"
#define kProfileHeight                          @"height"
#define kProfileWeight                          @"weight"
@interface RHProfileObj : NSObject
{
    NSString        *m_pstrExpectedDate;
    NSString        *m_pstrBirthDate;
    NSArray         *m_pFriendsArray;
    NSString        *m_pstrGestation;
    NSString        *m_pstrID;
    NSString        *m_pstrJID;
    NSString        *m_pstrJPassword;
    NSString        *m_pstrMatchID;
    NSString        *m_pstrMobile;
    NSString        *m_pstrNickName;
    NSString        *m_pstrPhotoURL;
    NSString        *m_pstrEmail;
    NSString        *m_pstrLeCard;
    NSString        *m_pstrLeMember;
    
    NSDictionary    *m_pRecommand;
    
    NSInteger       m_nPoint;
    NSInteger       m_nType;
    NSInteger       m_nMood;
    NSInteger       m_nLePoint;
    NSInteger       m_nWeek;
    NSInteger       m_nHeight;
    NSInteger       m_nWeight;
}


@property ( nonatomic, retain ) NSString        *m_pstrExpectedDate;
@property ( nonatomic, retain ) NSString        *m_pstrBirthDate;
@property ( nonatomic, retain ) NSArray         *m_pFriendsArray;
@property ( nonatomic, retain ) NSString        *m_pstrGestation;
@property ( nonatomic, retain ) NSString        *m_pstrID;
@property ( nonatomic, retain ) NSString        *m_pstrJID;
@property ( nonatomic, retain ) NSString        *m_pstrJPassword;
@property ( nonatomic, retain ) NSString        *m_pstrMatchID;
@property ( nonatomic, retain ) NSString        *m_pstrMobile;
@property ( nonatomic, retain ) NSString        *m_pstrNickName;
@property ( nonatomic, retain ) NSString        *m_pstrPhotoURL;
@property ( nonatomic, retain ) NSString        *m_pstrEmail;
@property ( nonatomic, retain ) NSString        *m_pstrLeCard;
@property ( nonatomic, retain ) NSString        *m_pstrLeMember;
@property ( nonatomic, retain ) NSDictionary    *m_pRecommand;
@property  NSInteger        m_nPoint;
@property  NSInteger        m_nType;
@property  NSInteger        m_nMood;
@property  NSInteger        m_nLePoint;
@property  NSInteger        m_nWeek;
@property  NSInteger        m_nHeight;
@property  NSInteger        m_nWeight;

- ( id )initWithDic:( NSDictionary * )pDic;


#pragma mark - Customized Methods
-( BOOL )hasSetLoginType;
- ( void )saveProfile;
+ ( void )clearProfile;
+ ( RHProfileObj * )getProfile;
@end
