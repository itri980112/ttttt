//
//  RHAppDelegate.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/13.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "XMPPFramework.h"

//Notification Settings
#define kFBLoginSucceed     @"FBLoginSucceed"
#define kFBLoginFailed      @"FBLoginFailed"
#define kMainViewtUserProfile     @"MainViewtUserProfile"
#define kMenuViewReveal     @"MenuReveal"
#define kFinishRegister     @"FinishRegister"
#define kChangeBackgroundImg        @"ChangeBackgroundImage"
#define kChangeUserIcon        @"ChangeUserIcon"
#define kReceiveRemoteMsg       @"ReceiveRemoteMsg"


//switchPage
#define kOpenPregnantPage           @"OpenPregnantPage"
#define kOpenLinePage               @"OpenLinePage"
#define kOpenTodolist               @"OpenTodoPage"
#define kOpenKnowledgePage          @"OpenKnowledgePage"


@class RHMenuVC;
@class RHMainVC;
@class RHUserGuideVC;
@class RHProfileObj;
@class RevealController;
@class RHUserDetailSettingVC;
@class ImageCache;
@class RHRegisterHint;
@class RHPointCollection;
@interface RHAppDelegate : UIResponder <UIApplicationDelegate, XMPPRosterDelegate>
{
    RHMainVC                *m_pRHMainVC;
    RHMenuVC                *m_pRHMenuVC;
    RHUserGuideVC           *m_pRHUserGuideVC;
    RHPointCollection       *m_pRHPointCollection;
    RHProfileObj            *m_pRHProfileObj;
    RHUserDetailSettingVC   *m_pRHUserDetailSettingVC;
    RHRegisterHint          *m_pRHRegisterHint;
    ImageCache              *m_pImageCache;
    
    NSString                *m_pstrDeviceToken;
    
    NSArray                 *m_pEmotionArray;
    
    //XMPP
    BOOL customCertEvaluation;
	
	BOOL isXmppConnected;
    
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

}
@property ( nonatomic, retain ) RHRegisterHint          *m_pRHRegisterHint;
@property ( nonatomic, retain ) NSString                *m_pstrDeviceToken;
@property ( nonatomic, retain ) ImageCache              *m_pImageCache;
@property ( nonatomic, retain ) RHProfileObj            *m_pRHProfileObj;
@property ( nonatomic, retain ) RHMainVC                *m_pRHMainVC;
@property ( nonatomic, retain ) RHMenuVC                *m_pRHMenuVC;
@property ( nonatomic, retain ) RHUserGuideVC           *m_pRHUserGuideVC;
@property ( nonatomic, retain ) RHUserDetailSettingVC   *m_pRHUserDetailSettingVC;
@property ( nonatomic, retain ) RHPointCollection       *m_pRHPointCollection;
@property ( nonatomic, retain ) NSArray                 *m_pEmotionArray;
@property ( nonatomic, retain ) NSDictionary            *m_pFBGraphUser;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RevealController *viewController;

//XMPP
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;


#pragma mark - XMPP
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (BOOL)connect;
- (void)disconnect;

#pragma mark - Class Methods
+ ( RHAppDelegate * )sharedDelegate;
+ ( void )MessageBox:( NSString * )pstrMsg;
+ ( BOOL )isFirstLaunch;
+ ( void )setLaunched;
+ ( void )savePHPSessionID:( NSString * )pstrID;
+ ( void )saveUID:( NSString * )pstrID;
+ ( void )savePWD:( NSString * )pstrID;
+ ( void )saveFBID:( NSString * )pstrFBID;
+ ( void )saveEmail:( NSString * )pstrEmail;
+ ( void )saveHomeImg:( NSString * )pstrImgName;
+ ( void )saveHomeBgImageIdx:( NSString * )pstrIDX;
+ ( void )saveHeightAndWeight:( NSString * )pstrHeight Weight:( NSString * )pstrWeight;

+ ( void )clearHightLight;
+ ( NSString * )getPHPSessionID;
+ ( NSString * )getUID;
+ ( NSString * )getPWD;
+ ( NSString * )getFBID;
+ ( NSString * )getEmail;
+ ( NSString * )getHomeBgImageIdx;
+ ( NSString * )getHeight;
+ ( NSString * )getWeight;
+ ( NSString * )getHomeImg;

+ ( NSString * )getFatherAsk;
+ ( void )setFatherAsk:( NSString * )pstrAsk;

+ ( void )addToHightLight:( NSDictionary * )pDataDic;
+ ( void )removefromHightLight:( NSDictionary * )pDataDic;
+ ( NSArray * )getHightData;

+ ( BOOL )isRegistered;
+ ( void )showLoadingHUD;
+ ( void )hideLoadingHUD;

+ ( void )backgroundLogin;


+ ( void )resetEnvironment:( BOOL )bNeedRegist;
+ ( void )showRegistHint;

+ ( NSString * )getErrorMsgWithCode:( NSString * )pstrErrorCode;
#pragma mark - Customized Methods

- ( void )setupRegisterHint:( RHRegisterHint * )pVC;
- ( RHRegisterHint * )getRegisterHintVC;
- ( void )showUserGuide;
- ( void )keepLoginProfile:( NSDictionary * )pDic;
- ( void )showUserDetailSettingPage;
- ( void )showPointCollectionSettingPage;
- ( NSDictionary * )getFriendDicFromJID:( NSString * )pstrJID;
- ( void )updateEmotionDB;
- ( void )keepAssociationList:( NSArray * )pArray;
- ( NSArray * )getAssociationArray;
#pragma mark - FB Related
- ( void )LoginFB;
- ( void )LogoutFB;
- ( void )fetchUserData;
- ( BOOL )isFBLogin;
@end
