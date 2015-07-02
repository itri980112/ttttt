//
//  RHProfileObj.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/18.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHProfileObj.h"

@implementation RHProfileObj
@synthesize m_pstrExpectedDate;
@synthesize m_pFriendsArray;
@synthesize m_pstrGestation;
@synthesize m_pstrID;
@synthesize m_pstrJID;
@synthesize m_pstrJPassword;
@synthesize m_pstrMatchID;
@synthesize m_pstrMobile;
@synthesize m_pstrNickName;
@synthesize m_pstrPhotoURL;
@synthesize m_pstrEmail;
@synthesize m_pstrLeCard;
@synthesize m_pstrBirthDate;
@synthesize m_nPoint;
@synthesize m_nType;
@synthesize m_nMood;
@synthesize m_nLePoint;
@synthesize m_pstrLeMember;
@synthesize m_pRecommand;
@synthesize m_nWeek;
@synthesize m_nHeight;
@synthesize m_nWeight;

- ( id )initWithDic:( NSDictionary * )pDic
{
    self = [super init];
    
    if ( self )
    {
        self.m_pstrExpectedDate = [pDic objectForKey:@"expectedDate"];
        self.m_pstrBirthDate =    [pDic objectForKey:@"birthday"];
        self.m_pFriendsArray =    [pDic objectForKey:@"friends"];
        self.m_pstrGestation =    [pDic objectForKey:@"gestation"];
        self.m_pstrID =           [pDic objectForKey:@"id"];
        self.m_pstrJID = [pDic objectForKey:@"jid"];
        self.m_pstrJPassword = [pDic objectForKey:@"jpassword"];
        self.m_pstrMatchID = [pDic objectForKey:@"matchId"];
        self.m_pstrMobile = [pDic objectForKey:@"mobile"];
        self.m_pstrNickName = [pDic objectForKey:@"nickname"];
        self.m_pstrPhotoURL = [pDic objectForKey:@"photoUrl"];
        self.m_pstrEmail = [pDic objectForKey:@"email"];
        self.m_pstrLeCard = [pDic objectForKey:@"leCard"];
        self.m_pstrLeMember = [pDic objectForKey:@"leMember"];
        self.m_pRecommand = [pDic objectForKey:@"recommand"];
        m_nPoint = [[pDic objectForKey:@"point"] integerValue];
        m_nType = [[pDic objectForKey:@"type"] integerValue];
        m_nMood = [[pDic objectForKey:@"mood"] integerValue];
        m_nLePoint = [[pDic objectForKey:@"lePoint"] integerValue];
        m_nWeek = [[pDic objectForKey:@"week"] integerValue];
        m_nHeight = [[pDic objectForKey:@"height"] integerValue];
        m_nWeight = [[pDic objectForKey:@"weight"] integerValue];
       // NSLog(@"ABC  %ld", (long)[[pDic objectForKey:@"recommand"] retainCount]);
        //NSLog(@"%ld", (long)[pDic  retainCount]);

    }
    
    return self;
}



- ( void )dealloc
{
    
    [m_pstrExpectedDate release];
    [m_pFriendsArray release];
    [m_pstrGestation release];
    [m_pstrID release];
    [m_pstrJID release];
    [m_pstrJPassword release];
    [m_pstrMatchID release];
    [m_pstrMobile release];
    [m_pstrNickName release];
    [m_pstrPhotoURL release];
    [m_pstrBirthDate release];
    [m_pstrEmail release];
    [m_pstrLeCard release];
    [m_pstrLeMember release];
    [m_pRecommand release];
    [super dealloc];
}


#pragma mark - Customized Methods
-( BOOL )hasSetLoginType
{
    if ( m_nType == 0 )
    {
        return NO;
    }
    
    return YES;
}

+ ( void )clearProfile
{
    NSString *pstrFile = [NSString stringWithFormat:@"%@/UserProfile.plist", kStoragePath];
    
    [[NSFileManager defaultManager] removeItemAtPath:pstrFile error:nil];
}

- ( void )saveProfile
{
    //BOOL bSucc = NO;
    
    NSString *pstrFile = [NSString stringWithFormat:@"%@/UserProfile.plist", kStoragePath];
    
    DLog(@"Savie file : %@", pstrFile);
    
    //直接存
    
    NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:self , @"profle", nil];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:pDic forKey:kArchiveKey];
    [archiver finishEncoding];
    [archiver release];
    
    //bSucc = [data writeToFile:pstrFile atomically:YES];
	[data writeToFile:pstrFile atomically:YES];//CCC try
    [data release];

}

+ ( RHProfileObj * )getProfile
{
    RHProfileObj *pProfile = nil;
    
    NSString *pstrFile = [NSString stringWithFormat:@"%@/UserProfile.plist", kStoragePath];
    
    DLog(@"get file : %@", pstrFile);
    
    //先檢查有沒有舊的資料
    
    BOOL bIsExist = [[NSFileManager defaultManager] fileExistsAtPath:pstrFile];
    
    if ( bIsExist )
    {
        //拿出資料
        NSData *pData = [NSData dataWithContentsOfFile:pstrFile];
        
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:pData];
        //NSDictionary *pDic = [[unarchiver decodeObjectForKey:kArchiveKey] retain];
        NSDictionary *pDic = [unarchiver decodeObjectForKey:kArchiveKey] ;//CCC try
        [unarchiver finishDecoding];
        [unarchiver release];
        
        pProfile = [pDic objectForKey:@"profle"];
    }
    else
    {
        DLog(@"資料不存在");
    }

    
    return pProfile;
    
}

#pragma mark - Coder
- ( void )encodeWithCoder:( NSCoder * )encoder
{
    [encoder encodeObject:m_pstrExpectedDate forKey:kExpectedDate];
    [encoder encodeObject:m_pFriendsArray forKey:kFriendsArray];
    [encoder encodeObject:m_pstrGestation forKey:kObjGestation];
    [encoder encodeObject:m_pstrID forKey:kID];
    [encoder encodeObject:m_pstrJID forKey:kJID];
    [encoder encodeObject:m_pstrJPassword forKey:kJPassword];
    [encoder encodeObject:m_pstrBirthDate forKey:kProfileBirthday];
    [encoder encodeObject:m_pstrEmail forKey:kProfileEmail];
    [encoder encodeObject:m_pstrLeCard forKey:kProfileLecard];
    [encoder encodeObject:m_pstrLeMember forKey:kLeMember];
    if ( [m_pstrMatchID isKindOfClass:[NSNull class]])
    {
        m_pstrMatchID = @"";
    }
    [encoder encodeObject:m_pRecommand forKey:kRecommandData];
    [encoder encodeObject:m_pstrMatchID forKey:kMatchID];
    [encoder encodeObject:m_pstrMobile forKey:kObjMobile];
    [encoder encodeObject:m_pstrNickName forKey:kNickName];
    [encoder encodeObject:m_pstrPhotoURL forKey:kPhotoURL];
    [encoder encodeInteger:m_nPoint forKey:kPoint];
    [encoder encodeInteger:m_nType forKey:kProfileType];
    [encoder encodeInteger:m_nMood forKey:kProfileMood];
    [encoder encodeInteger:m_nLePoint forKey:kLePoint];
    [encoder encodeInteger:m_nWeek forKey:kWeek];
    [encoder encodeInteger:m_nHeight forKey:kProfileHeight];
    [encoder encodeInteger:m_nWeight forKey:kProfileWeight];
}

- ( id )initWithCoder:( NSCoder * )decoder
{
    self = [super init];
    if ( self )
    {
        self.m_pstrExpectedDate = [decoder decodeObjectForKey:kExpectedDate];
        self.m_pFriendsArray = [decoder decodeObjectForKey:kFriendsArray];
        self.m_pstrGestation = [decoder decodeObjectForKey:kObjGestation];
        self.m_pstrID = [decoder decodeObjectForKey:kID];
        self.m_pstrJID = [decoder decodeObjectForKey:kJID];
        self.m_pstrJPassword = [decoder decodeObjectForKey:kJPassword];
        self.m_pstrBirthDate = [decoder decodeObjectForKey:kProfileBirthday];
        self.m_pstrEmail = [decoder decodeObjectForKey:kProfileEmail];
        self.m_pstrLeCard = [decoder decodeObjectForKey:kProfileLecard];
        self.m_pstrLeMember = [decoder decodeObjectForKey:kLeMember];
        
        self.m_pstrMatchID = [decoder decodeObjectForKey:kMatchID];
        self.m_pstrMobile = [decoder decodeObjectForKey:kObjMobile];
        self.m_pstrNickName = [decoder decodeObjectForKey:kNickName];
        self.m_pstrPhotoURL = [decoder decodeObjectForKey:kPhotoURL];
        self.m_pRecommand = [decoder decodeObjectForKey:kRecommandData];
        m_nPoint = [decoder decodeIntegerForKey:kPoint];
        m_nType = [decoder decodeIntegerForKey:kProfileType];
        m_nMood = [decoder decodeIntegerForKey:kProfileMood];
        m_nLePoint = [decoder decodeIntegerForKey:kLePoint];
        m_nWeek = [decoder decodeIntegerForKey:kWeek];
        m_nHeight = [decoder decodeIntegerForKey:kProfileHeight];
        m_nWeight = [decoder decodeIntegerForKey:kProfileWeight];
    }
    return self;
}

@end
