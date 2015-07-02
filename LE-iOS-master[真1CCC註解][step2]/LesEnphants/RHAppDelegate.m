//
//  RHAppDelegate.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/13.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHAppDelegate.h"
#import "RHMainVC.h"
#import "RHMenuVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "RHLesDbDefinition.h"
#import "RHUserGuideVC.h"
#import "RHProfileObj.h"
#import "RevealController.h"
#import "RHUserDetailSettingVC.h"
#import "ImageCache.h"
#import "RHSQLManager.h"
#import "MBProgressHUD.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "Utilities.h"
#import "RHAlertView.h"
#import "RHRegisterHint.h"
#import "SBJson.h"
#import "RHPointCollection.h"
//XMPP
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import <CFNetwork/CFNetwork.h>

static  MBProgressHUD       *g_pMBProgressHUD = nil;



@interface RHAppDelegate()
{
    NSArray     *m_pAssociationListArray;
}

@property ( nonatomic, retain ) NSArray     *m_pAssociationListArray;

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end
//CCC:上一行的@end，是@interface RHAppDelegate()的@end

@implementation RHAppDelegate
@synthesize m_pRHMainVC;
@synthesize m_pRHMenuVC;
@synthesize m_pRHUserGuideVC;
@synthesize m_pRHProfileObj;
@synthesize m_pRHUserDetailSettingVC;
@synthesize m_pImageCache;
@synthesize m_pstrDeviceToken;
@synthesize m_pEmotionArray;
@synthesize m_pRHRegisterHint;
@synthesize m_pAssociationListArray;
@synthesize m_pRHPointCollection;
//XMPP
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;

#pragma mark - Life Cycle




- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup the XMPP stream
    self.m_pEmotionArray = nil;
	[self setupStream];
    
    
    [self showAllPushContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSLog(@"kStoragePath = %@", kStoragePath);
    NSFileManager *pManager = [NSFileManager defaultManager];
    //CCC:只是簡單建立資料夾
    if ( ![pManager fileExistsAtPath:kStoragePath] )
    {
        [pManager createDirectoryAtPath:kStoragePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    //creat Record Folder
    if ( ![pManager fileExistsAtPath:kRecordFolderPath] )
    {
        [pManager createDirectoryAtPath:kRecordFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //create Echo Image Folder
    if ( ![pManager fileExistsAtPath:kEchoImgFolderPath] )
    {
        [pManager createDirectoryAtPath:kEchoImgFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    
    //create Shape Image Folder
    if ( ![pManager fileExistsAtPath:kShapeImgFolderPath] )
    {
        [pManager createDirectoryAtPath:kShapeImgFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    
    //Create DB
    [[RHSQLManager instance] createUserDataTable];
    [[RHSQLManager instance] createChatDatabase];
    
    self.m_pRHUserGuideVC = nil;
    self.m_pRHProfileObj = nil;
    self.m_pRHUserDetailSettingVC = nil;
    self.m_pstrDeviceToken = @"";
    
    ImageCache *pImgCache = [[ImageCache alloc] initWithMaxSize:(10*1024*1024)];
    self.m_pImageCache = pImgCache;
    [pImgCache release];
    
    
    RHMainVC *pRHMainVC = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        pRHMainVC = [[RHMainVC alloc] initWithNibName:@"RHMainVC" bundle:nil];
    }
    else
    {
        pRHMainVC = [[RHMainVC alloc] initWithNibName:@"RHMainVC~iPad" bundle:nil];
    }
    
    
    RHMenuVC *pRHMenuVC = [[RHMenuVC alloc] initWithNibName:@"RHMenuVC" bundle:nil];
    self.m_pRHMainVC = pRHMainVC;//CCC疑問:不知道會不會增加pRHMainVC的reference count?-->答案:如果 self.m_pRHMainVC是@property ( nonatomic, retain ) ，那是pRHMainVC的reference count增加!!
    self.m_pRHMenuVC = pRHMenuVC;
    pRHMenuVC.m_pRHMainVC = pRHMainVC;
    [pRHMainVC release];
    [pRHMenuVC release];
    
    
    [m_pRHMenuVC.view setFrame:[UIScreen mainScreen].bounds];
    //[m_pRHMainVC.view setFrame:[UIScreen mainScreen].bounds];
    
    
    UIViewController *navController = [[[UINavigationController alloc] initWithRootViewController:m_pRHMainVC] autorelease];
    
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navController rearViewController:m_pRHMenuVC];
	
	revealController.enableSwipeAndTapGestures = YES;
	
	self.viewController = revealController;

    
//    UIViewController *navController = [[[UINavigationController alloc] initWithRootViewController:m_pRHMainVC] autorelease];
//    JDSideMenu *sideMenu = [[JDSideMenu alloc] initWithContentController:navController
//                                                          menuController:m_pRHMenuVC];
//    [sideMenu setBackgroundImage:[UIImage imageNamed:@"menuwallpaper"]];
    [self.window setRootViewController:self.viewController];
    
    
    NSLog(@"Window = %@", NSStringFromCGRect(self.window.bounds));

    //註冊APNS
    // Register push notifications
    [self registerForRemoteNotification];
    
    
    if ( [RHAppDelegate getPHPSessionID] != nil )
    {
        [RHLesEnphantsAPI getEmotionDB:self];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store
	// enough application state information to restore your application to its current state in case
	// it is terminated later.
	//
	// If your application supports background execution,
	// called instead of applicationWillTerminate: when the user quits.
	
    
	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
	{
		[application setKeepAliveTimeout:600 handler:^{
			
			NSLog(@"KeepAliveHandler");
			
			// Do other keep alive stuff here.
		}];
	}
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    [self teardownStream];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    
//    if ( [Utilities isConnectedToInternet] )
//    {
//        [RHLesEnphantsAPI KeepAlive:nil Source:self];
//    }

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [RHAppDelegate MessageBox:notification.alertBody];
    
    //TODO: 這裡打開可以關閉通知中心的東西
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo NS_AVAILABLE_IOS(3_0)
{
   /*
    {
        "aps":
        {
            "alert": 
            {
                "body": "這是標題", "action-loc-key": "確定"
            },
            "badge": 1
        },
        "le" : { Push Content } 
    }
    
    */
    
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateActive)
    {
        //Do checking here.
        NSString *pstrTitle = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
        //NSString *pstrCnt = [userInfo objectForKey:@"le"];
        //    NSString *pstrBtn = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"action-loc-key"];
        
        
        
        UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:@"" message:pstrTitle delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [pAlert show];
        [pAlert release];
    }
    
    
   
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"Did get register token: %@", deviceToken);

    if ( deviceToken )
    {
        // Translate token to string
        NSString *pstrToken = [NSString stringWithFormat:@"%@",deviceToken];
        pstrToken = [pstrToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        pstrToken = [pstrToken stringByReplacingOccurrencesOfString:@">" withString:@""];
        pstrToken = [pstrToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.m_pstrDeviceToken = pstrToken;
        
        //如果註冊了，就順便傳上去
        NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:pstrToken, kDeviceToken, nil];
        [RHLesEnphantsAPI updateDeviceToken:pDic Source:nil];
        
    }

}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
    

}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
        
    }
}
#endif

- (void)registerForRemoteNotification {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:types];
    }
}


- ( void )dealloc
{
    [m_pEmotionArray release];
    [m_pstrDeviceToken release];
    [m_pRHMainVC release];
    [m_pRHMenuVC release];
    [m_pRHUserGuideVC release];
    [m_pRHProfileObj release];
    [m_pRHUserDetailSettingVC release];
    [m_pImageCache release];
    
    [self teardownStream];
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - XMPP Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![xmppStream isDisconnected])
    {
		return YES;
	}
    
    RHProfileObj *pProfile = [RHProfileObj getProfile];
    
	NSString *myJID = [NSString stringWithFormat:@"%@@%@",pProfile.m_pstrJID, kChatServer];
    NSLog(@"myJID = %@", myJID);
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";

    
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];

	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		NSLog(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - XMPP Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
	[xmppStream setHostName:kChatServer];
	[xmppStream setHostPort:5222];
	
    
	// You may need to alter these settings depending on the server you're connecting to
	customCertEvaluation = YES;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// https://github.com/robbiehanson/XMPPFramework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}


#pragma mark - Class Methods
+ ( RHAppDelegate * )sharedDelegate
{//CCC:返回UIApplication物件的_delegate，這也是singleton 模式
//CCC:本方法也就是取出全局唯一的RHAppDelegate物件
    return  ( RHAppDelegate * )[[UIApplication sharedApplication] delegate];
}

+ ( void )MessageBox:( NSString * )pstrMsg
{
    UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:@"好孕邦" message:pstrMsg delegate:nil cancelButtonTitle:@"關閉" otherButtonTitles:nil];
    [pAlert show];
    [pAlert release];
}

+ ( BOOL )isFirstLaunch
{//CCC:NSUserDefaults可以想成是ios裝置上的文件或資料庫(永久儲存裝置)，只不過這個文件存的是用戶設定
    BOOL bHasLaunch = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserHasLaunched] boolValue];
    
    return !bHasLaunch;
}

+ ( void )setLaunched
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kUserHasLaunched];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ ( void )savePHPSessionID:( NSString * )pstrID
{
    [[NSUserDefaults standardUserDefaults] setObject:pstrID forKey:kPHPSessionID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ ( NSString * )getPHPSessionID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPHPSessionID];
}

+ ( void )saveUID:( NSString * )pstrID
{
    [[NSUserDefaults standardUserDefaults] setObject:pstrID forKey:kUID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ ( NSString * )getUID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUID];
}

+ ( void )savePWD:( NSString * )pstrID
{
    [[NSUserDefaults standardUserDefaults] setObject:pstrID forKey:kPWD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ ( NSString * )getPWD
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPWD];
}

+ ( void )saveHomeImg:( NSString * )pstrImgName;
{
    [[NSUserDefaults standardUserDefaults] setObject:pstrImgName forKey:kHomeBgImg];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ ( NSString * )getHomeImg
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kHomeBgImg];
}

+ ( void )saveFBID:( NSString * )pstrFBID
{
    //CCC:NSUserDefaults可用來檢查第一次執行
    //CCC:似乎是把FB 數字存到系統預設檔
    [[NSUserDefaults standardUserDefaults] setObject:pstrFBID forKey:kFBID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ ( NSString * )getFBID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kFBID];
}


+ ( void )saveEmail:( NSString * )pstrEmail;
{
    [[NSUserDefaults standardUserDefaults] setObject:pstrEmail forKey:kEmail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ ( void )saveHomeBgImageIdx:( NSString * )pstrIDX
{
    [[NSUserDefaults standardUserDefaults] setObject:pstrIDX forKey:kHomeBgImg];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ ( void )saveHeightAndWeight:( NSString * )pstrHeight Weight:( NSString * )pstrWeight
{
    [[NSUserDefaults standardUserDefaults] setObject:pstrHeight forKey:kHeight];
    [[NSUserDefaults standardUserDefaults] setObject:pstrWeight forKey:kWeight];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ ( NSString * )getHeight
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kHeight];
}

+ ( NSString * )getWeight
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kWeight];
}

+ ( NSString * )getEmail
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kEmail];
}

+ ( NSString * )getHomeBgImageIdx
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kHomeBgImg];
}

+ ( BOOL )isRegistered
{
    NSString *pstrFile = [NSString stringWithFormat:@"%@/UserProfile.plist", kStoragePath];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:pstrFile];
}

+ ( void )showLoadingHUD
{
    if ( g_pMBProgressHUD )
    {
        [g_pMBProgressHUD hide:NO];
    }
    
    UIWindow *pWND =  [[UIApplication sharedApplication] keyWindow];
    
    g_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:pWND
                                            animated:NO];
}

+ ( void )hideLoadingHUD
{
    if ( g_pMBProgressHUD )
    {
        [g_pMBProgressHUD hide:NO];
    }
}

+ ( void )backgroundLogin
{
    [RHAppDelegate showLoadingHUD];
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    
    NSString *pstrFBID = [RHAppDelegate getFBID];
    
    if ( pstrFBID )
    {
        [pParameter setObject:@"FB" forKey:@"Type"];
        [pParameter setObject:pstrFBID forKey:@"ID"];
    }
    else
    {
        //Email
        [pParameter setObject:@"EMAIL" forKey:@"Type"];
        [pParameter setObject:[RHAppDelegate getEmail] forKey:@"ID"];
        [pParameter setObject:[RHAppDelegate getPWD] forKey:@"PW"];
    }
    
    [RHLesEnphantsAPI Login:pParameter Source:[RHAppDelegate sharedDelegate]];

}


+ ( void )resetEnvironment:( BOOL )bNeedRegist
{
    [RHAppDelegate savePHPSessionID:nil];
    [RHAppDelegate saveEmail:nil];
    [RHAppDelegate savePWD:nil];
    [RHAppDelegate saveUID:nil];
    [RHAppDelegate saveHomeImg:@""];
    [RHAppDelegate saveHomeBgImageIdx:0];
    [RHAppDelegate saveFBID:nil];
    [RHProfileObj clearProfile];
    [RHAppDelegate clearHightLight];
    [RHAppDelegate saveHeightAndWeight:@"" Weight:@""];
    
    if ( bNeedRegist )
    {
        if ( [RHAppDelegate sharedDelegate].m_pRHMainVC )
        {
            [[RHAppDelegate sharedDelegate].m_pRHMainVC showRegisterView];
        }
    }
}

+ ( void )clearHightLight
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kHightlightData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ ( void )addToHightLight:( NSDictionary * )pDataDic
{
    NSMutableArray *pArray = [NSMutableArray arrayWithArray:[RHAppDelegate getHightData]];
    [pArray addObject:pDataDic];
    
    [[NSUserDefaults standardUserDefaults] setObject:pArray forKey:kHightlightData];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ ( void )showRegistHint
{
    RHRegisterHint *pVC = [[RHRegisterHint alloc] initWithNibName:@"RHRegisterHint" bundle:nil];
    [[RHAppDelegate sharedDelegate] setupRegisterHint:pVC];
    [pVC release];
    [[[UIApplication sharedApplication] keyWindow] addSubview:[[RHAppDelegate sharedDelegate] getRegisterHintVC].view];
}



+ ( void )removefromHightLight:( NSDictionary * )pDataDic
{
    NSMutableArray *pArray = [NSMutableArray arrayWithArray:[RHAppDelegate getHightData]];
    
    
    NSInteger nIdx = -1;
    for ( NSInteger i = 0; i < [pArray count]; ++i )
    {
        NSDictionary *pOldData = [pArray objectAtIndex:i];
        NSString *pstrOldJID = [pOldData objectForKey:@"jid"];
        NSString *pstrNewJID = [pDataDic objectForKey:@"jid"];
        
        if ( [pstrOldJID compare:pstrNewJID options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            nIdx = i;
            break;
        }
    }
    
    if (nIdx >= 0 )
    {
        [pArray removeObjectAtIndex:nIdx];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:pArray forKey:kHightlightData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ ( NSArray * )getHightData
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kHightlightData];
}

+ ( NSString * )getFatherAsk
{
    NSString *pstrPath = [NSString stringWithFormat:@"%@/ask.plist", [Utilities getDocumentPath]];
    NSString *pstrString = [NSString stringWithContentsOfFile:pstrPath encoding:NSUTF8StringEncoding error:nil];
    return pstrString;
}
+ ( void )setFatherAsk:( NSString * )pstrAsk
{
    NSString *pstrPath = [NSString stringWithFormat:@"%@/ask.plist", [Utilities getDocumentPath]];
    [pstrAsk writeToFile:pstrPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ ( NSString * )getErrorMsgWithCode:( NSString * )pstrErrorCode
{

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ErrorCode" ofType:@"json"];
    NSError *pError = nil;
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *pReturnDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&pError];
    
    if ( pReturnDic )
    {
        return [pReturnDic objectForKey:pstrErrorCode];
    }
    
    
    return @"";
}

#pragma mark - Customized Methods

- ( void )showUserGuide
{
    RHUserGuideVC *pVC = [[RHUserGuideVC alloc] initWithNibName:@"RHUserGuideVC" bundle:nil];
    self.m_pRHUserGuideVC = pVC;
    //[self.m_pRHUserGuideVC.view setFrame:[UIScreen mainScreen].bounds];
    [pVC release];//CCC try
    
    [self.m_pRHMainVC presentViewController:m_pRHUserGuideVC animated:YES completion:nil];
}

- ( void )keepLoginProfile:( NSDictionary * )pDic
{
    RHProfileObj *pProfile = [[RHProfileObj alloc] initWithDic:pDic];
    
    if ( pProfile )
    {
        self.m_pRHProfileObj = pProfile;
        [pProfile release];
        
        [m_pRHProfileObj saveProfile];
    }
}

- ( void )showUserDetailSettingPage
{
    RHUserDetailSettingVC *pVC = [[RHUserDetailSettingVC alloc] initWithNibName:@"RHUserDetailSettingVC" bundle:nil];
    self.m_pRHUserDetailSettingVC = pVC;
    [pVC release];
    
    UINavigationController *pNav = [[[UINavigationController alloc] initWithRootViewController:self.m_pRHUserDetailSettingVC] autorelease];
    
    
     [self.viewController presentViewController:pNav animated:YES completion:nil];
}

- ( void )showPointCollectionSettingPage
{
    RHPointCollection *pVC = [[RHPointCollection alloc] initWithNibName:@"RHPointCollection" bundle:nil];
    self.m_pRHPointCollection = pVC;
    [pVC release];
    m_pRHPointCollection.m_bIsPresent = YES;
    
    UINavigationController *pNav = [[UINavigationController alloc] initWithRootViewController:m_pRHPointCollection];
    
    [self.viewController presentViewController:pNav animated:YES completion:nil];
}

- ( NSDictionary * )getFriendDicFromJID:( NSString * )pstrJID
{

    NSDictionary *pFriendDic = nil;
    
    for ( NSInteger i = 0; i < [m_pRHProfileObj.m_pFriendsArray count]; ++i )
    {
        NSDictionary *pDic = [m_pRHProfileObj.m_pFriendsArray objectAtIndex:i];
        NSString *pstrFrinedJID = [pDic objectForKey:@"jid"];
        
        if ( [pstrFrinedJID compare:pstrJID] == NSOrderedSame )
        {
            pFriendDic = pDic;
            break;
        }
    }

    return pFriendDic;
}

- ( void )updateEmotionDB
{
    [RHLesEnphantsAPI getEmotionDB:self];
}

- ( void )setupRegisterHint:( RHRegisterHint * )pVC
{
    self.m_pRHRegisterHint = pVC;
    self.m_pRHRegisterHint.view.frame = self.window.frame;
}
- ( RHRegisterHint * )getRegisterHintVC
{
    return m_pRHRegisterHint;
}

- ( void )keepAssociationList:( NSArray * )pArray
{
    if ( pArray )
    {
        self.m_pAssociationListArray = pArray;
    }
}

- ( NSArray * )getAssociationArray
{
    return m_pAssociationListArray;
}

#pragma mark - Private
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        {
            //[self sendFacebookRequest];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[FBSession activeSession].accessTokenData.accessToken forKey:@"FBAccessTokenKey"];
            [defaults setObject:[FBSession activeSession].accessTokenData.expirationDate forKey:@"FBExpirationDateKey"];
            [defaults synchronize];
            
            [self fetchUserData];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            [FBSession.activeSession closeAndClearTokenInformation];
            
            //remove fb token
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ( [defaults objectForKey:@"FBAccessTokenKey"] )
            {
                [defaults removeObjectForKey:@"FBAccessTokenKey"];
            }
            if ( [defaults objectForKey:@"FBExpirationDateKey"] )
            {
                [defaults removeObjectForKey:@"FBExpirationDateKey"];
            }
            [defaults synchronize];
        }
            break;
        default:
            break;
    }
    
    
}

- (NSDictionary*)parseURLParams:(NSString *)query
{
    NSLog(@"parseURLParams = %@", query);
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

- ( void )showAllPushContent
{
    UIApplication* app = [UIApplication sharedApplication];//CCC:每個app都有一個唯一的UIApplication instance
    NSArray *pPushArray = [app scheduledLocalNotifications];
    NSLog(@"目前有%d個", [pPushArray count]);
    for ( NSInteger i = 0; i < [pPushArray count]; ++i )
    {
        UILocalNotification* alarm = [pPushArray objectAtIndex:i];
        NSDictionary *pDic = alarm.userInfo;
        NSLog(@"alarm[%d] = %@",i, [alarm description]);
        NSLog(@"userInfo[%d] = %@", i, [pDic objectForKey:@"UserData"]);
    }
}

#pragma mark - FB Related
- (void)openSession
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    FBAccessTokenData *pToken = [FBAccessTokenData createTokenFromString:[defaults objectForKey:@"FBAccessTokenKey"] permissions:nil expirationDate:[defaults objectForKey:@"FBExpirationDateKey"] loginType:FBSessionLoginTypeFacebookApplication refreshDate:nil];
    
    [[FBSession activeSession] openFromAccessTokenData:pToken completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
     {
         if ( error )
         {
             NSLog(@"open session failed");
         }
         else
         {
             [self sessionStateChanged:session state:state error:error];
         }
     }];
    
}

- ( void )LoginFB
{
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
     {
         NSLog(@"Error 1 = %@", [error description]);
         if (!error)
         {
             if (![FBSession activeSession].isOpen)
             {
                 NSArray *pPermission = [NSArray arrayWithObjects:@"user_about_me", nil];
                 
                 // Use deprecated method(openActiveSessionWithPermissions) to block the native dialog of the new feature on iOS6
                 [FBSession openActiveSessionWithReadPermissions:pPermission allowLoginUI:YES completionHandler:^(FBSession *session,
                                                                                                      FBSessionState status,
                                                                                                      NSError *error) {
                     if (error)
                     {
                         NSLog(@"Error = %@", [error description]);
                         [[NSNotificationCenter defaultCenter] postNotificationName:kFBLoginFailed object:[error localizedDescription]];
                         [FBSession.activeSession closeAndClearTokenInformation];
                     }
                     else
                     {
                         [self sessionStateChanged:session state:status error:error];
                     }
                 }];
                 
                 
             }
             else
             {
                 //[self sendFacebookRequest];
                 [self fetchUserData];
             }
         }
         else
         {
             NSArray *pPermission = [NSArray arrayWithObjects:@"user_about_me", nil];
             // Use deprecated method(openActiveSessionWithPermissions) to block the native dialog of the new feature on iOS6
             [FBSession openActiveSessionWithReadPermissions:pPermission allowLoginUI:YES completionHandler:^(FBSession *session,
                                                                                                  FBSessionState status,
                                                                                                  NSError *error) {
                 if (error)
                 {
                     NSLog(@"Error 2 = %@", [error description]);
                     [[NSNotificationCenter defaultCenter] postNotificationName:kFBLoginFailed object:[error localizedDescription]];
                     [FBSession.activeSession closeAndClearTokenInformation];
                 }
                 else
                 {
                     [self sessionStateChanged:session state:status error:error];
                 }
             }];
             
         }
     }];
    
}
- ( void )LogoutFB
{
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[FBSession activeSession] close];
    [FBSession setActiveSession:nil];
}


- ( void )fetchUserData
{
    NSMutableDictionary *pUserInfoDic = [NSMutableDictionary dictionaryWithCapacity:1];
    // Fetch user data
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                       id<FBGraphUser> user,
                                       NSError *error)
     {
         if (!error)
         {
             // Put Facebook data
             NSDictionary *userInfo = (NSDictionary *)user;
             [[RHAppDelegate sharedDelegate] setM_pFBGraphUser:userInfo];
             
             NSLog(@"userInfo = %@", userInfo);

             [[NSNotificationCenter defaultCenter] postNotificationName:kFBLoginSucceed object:user.id];

             /*
             NSString *userInfo = @"";
             
             // Example: typed access (name)
             // - no special permissions required
             userInfo = [userInfo
                         stringByAppendingString:
                         [NSString stringWithFormat:@"Name: %@\n\n",
                          user.name]];
             [pUserInfoDic setValue:user.name forKey:@"Name"];
             // Example: typed access, (birthday)
             // - requires user_birthday permission
             userInfo = [userInfo
                         stringByAppendingString:
                         [NSString stringWithFormat:@"Birthday: %@\n\n",
                          user.birthday]];
             
             // Example: partially typed access, to location field,
             // name key (location)
             // - requires user_location permission
             userInfo = [userInfo
                         stringByAppendingString:
                         [NSString stringWithFormat:@"Location: %@\n\n",
                          user.location[@"name"]]];
             
             // Example: access via key (locale)
             // - no special permissions required
             userInfo = [userInfo
                         stringByAppendingString:
                         [NSString stringWithFormat:@"Locale: %@\n\n",
                          user[@"locale"]]];
             
             userInfo = [userInfo
                         stringByAppendingString:
                         [NSString stringWithFormat:@"Link: %@\n\n",
                          user[@"link"]]];
             
             
             // Example: access via key for array (languages)
             // - requires user_likes permission
             if (user[@"languages"])
             {
                 NSArray *languages = user[@"languages"];
                 NSMutableArray *languageNames = [[NSMutableArray alloc] init];
                 for (int i = 0; i < [languages count]; i++)
                 {
                     languageNames[i] = languages[i][@"name"];
                 }
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Languages: %@\n\n",
                              languageNames]];
             }
             

             // Display the user info
             NSLog(@"userInfo = %@", userInfo);
              */
         }
     }];

    return;
    
    
    FBAccessTokenData *pData = [[FBSession activeSession] accessTokenData];
    
    NSLog(@"[FBSession activeSession].accessToken = %@", pData.accessToken);
    
    
    NSString *query = @"SELECT uid, name, pic_square FROM user WHERE uid = me()";
    NSLog(@"Query = %@", query);
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         if (error)
         {
             NSLog(@"Error: %@", [error localizedDescription]);
             [[NSNotificationCenter defaultCenter] postNotificationName:kFBLoginFailed object:[error localizedDescription]];
         }
         else
         {
             NSLog(@"Result: %@", result);
             //self.m_pUserData = [[result objectForKey:@"data"] objectAtIndex:0];
             //long lID = [[[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"uid"] longValue];
             
             NSNumber *pNumber = [[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"uid"];
             
             NSString *pstrUID = [NSString stringWithFormat:@"%lld", [pNumber longLongValue]];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kFBLoginSucceed object:pstrUID];
             
         }
     }];

}

- ( BOOL )isFBLogin
{
    BOOL bLogin = NO;
    
    bLogin = [FBSession activeSession].isOpen;
    
    return bLogin;
}

#pragma mark - Gateway
- ( void )callBackKeepAliveStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 2 )
    {
        NSLog(@"需要重新登入");
        [RHAppDelegate backgroundLogin];
    }
}

- ( void )callBackLoginStatus:( NSDictionary * )pStatusDic
{
    NSLog(@"callBackLoginStatus = %@", pStatusDic);
    
    NSInteger nStatusCode = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nStatusCode == 0 )
    {
        //成功
        NSLog(@"profile = %@", [pStatusDic objectForKey:@"profile"]);
        
        NSDictionary *pProfile = [pStatusDic objectForKey:@"profile"];
        
        //NSString *pstrMSG = [NSString stringWithFormat:@"UID:\n%@", [pProfile objectForKey:@"id"]];
        //keep Login Profile
        [[RHAppDelegate sharedDelegate] keepLoginProfile:pProfile];
        
        //儲存PHP Session ID
        NSString *pstrPSID = [pStatusDic objectForKey:@"psid"];
        [RHAppDelegate savePHPSessionID:pstrPSID];

        //如果有Token了就順便Update回去
        //如果註冊了，就順便傳上去
        NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:[RHAppDelegate sharedDelegate].m_pstrDeviceToken, kDeviceToken, nil];
        [RHLesEnphantsAPI updateDeviceToken:pDic Source:nil];
        
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatusCode]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }

    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackGetEmontionDBStatus:( NSDictionary * )pStatusDic
{
    NSLog(@"callBackGetEmontionDBStatus = %@", pStatusDic);
    
    NSInteger nStatusCode = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nStatusCode == 0 )
    {
        //成功
        self.m_pEmotionArray = [pStatusDic objectForKey:@"data"];
        
    }
    else
    {
         NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatusCode]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	NSString *expectedCertName = [xmppStream.myJID domain];
	if (expectedCertName)
	{
		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
	
	if (customCertEvaluation)
	{
		[settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
	}
}

/**
 * Allows a delegate to hook into the TLS handshake and manually validate the peer it's connecting to.
 *
 * This is only called if the stream is secured with settings that include:
 * - GCDAsyncSocketManuallyEvaluateTrust == YES
 * That is, if a delegate implements xmppStream:willSecureWithSettings:, and plugs in that key/value pair.
 *
 * Thus this delegate method is forwarding the TLS evaluation callback from the underlying GCDAsyncSocket.
 *
 * Typically the delegate will use SecTrustEvaluate (and related functions) to properly validate the peer.
 *
 * Note from Apple's documentation:
 *   Because [SecTrustEvaluate] might look on the network for certificates in the certificate chain,
 *   [it] might block while attempting network access. You should never call it from your main thread;
 *   call it only from within a function running on a dispatch queue or on a separate thread.
 *
 * This is why this method uses a completionHandler block rather than a normal return value.
 * The idea is that you should be performing SecTrustEvaluate on a background thread.
 * The completionHandler block is thread-safe, and may be invoked from a background queue/thread.
 * It is safe to invoke the completionHandler block even if the socket has been closed.
 *
 * Keep in mind that you can do all kinds of cool stuff here.
 * For example:
 *
 * If your development server is using a self-signed certificate,
 * then you could embed info about the self-signed cert within your app, and use this callback to ensure that
 * you're actually connecting to the expected dev server.
 *
 * Also, you could present certificates that don't pass SecTrustEvaluate to the client.
 * That is, if SecTrustEvaluate comes back with problems, you could invoke the completionHandler with NO,
 * and then ask the client if the cert can be trusted. This is similar to how most browsers act.
 *
 * Generally, only one delegate should implement this method.
 * However, if multiple delegates implement this method, then the first to invoke the completionHandler "wins".
 * And subsequent invocations of the completionHandler are ignored.
 **/
- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
	//NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	// The delegate method should likely have code similar to this,
	// but will presumably perform some extra security code stuff.
	// For example, allowing a specific self-signed certificate that is known to the app.
	
	dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(bgQueue, ^{
		
		SecTrustResultType result = kSecTrustResultDeny;
		OSStatus status = SecTrustEvaluate(trust, &result);
		
		if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
			completionHandler(YES);
		}
		else {
			completionHandler(NO);
		}
	});
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	//NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
    
    RHProfileObj *pProfile = [RHProfileObj getProfile];
    
	NSString *myJID = pProfile.m_pstrJID;
	NSString *myPassword = pProfile.m_pstrJPassword;

    
    
	if (![[self xmppStream] authenticateWithPassword:myPassword error:&error])
	{
		NSLog(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	//NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	//NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	//NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	//NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    
	// A simple example of inbound message handling.
    
	if ([message isChatMessageWithBody])
	{
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:xmppStream
		                                               managedObjectContext:[self managedObjectContext_roster]];
	

		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *displayName = [user displayName];
        
        NSString *UserJID =[[message from] user];
    
        
        
        NSLog(@"Msg = %@", body);
        NSLog(@"UserJID = %@", UserJID);
        NSLog(@"Type = %@", [message type]);
        
        NSDictionary *pDic = [self getFriendDicFromJID:UserJID];
        
        if ( pDic )
        {
            displayName = [pDic objectForKey:@"nickname"];
        }
        
        NSString *pstrTimeStamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
        
        [[RHSQLManager instance] insetChatJID:UserJID Timestamp:pstrTimeStamp LastMsg:body DisplayName:@""];
        [[RHSQLManager instance] insetChatLog:UserJID Msg:body Timestamp:pstrTimeStamp MsgType:[message type] Send:@"0"];
        
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
		{
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
//                                                                message:body
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil];
//			[alertView show];
            [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteMsg object:nil];
		}
		else
		{
			// We are not active, so use a local notification instead
			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
			localNotification.alertAction = @"Ok";
            
            NSString *pstrPayload = [NSString stringWithFormat:@"{\"Name\":\"%@\", \"Body\":\"%@\"}", displayName, body];
            
            NSString *pstrMsg = @"";
            
            NSDictionary *pDic = [body JSONValue];
            NSInteger nType = [[pDic objectForKey:@"type"] integerValue];
            
            if ( nType == 0 )
            {
                pstrMsg = [NSString stringWithFormat:@"%@說 %@", displayName, [pDic objectForKey:@"body"]];
            }
            else
            {
                pstrMsg = [NSString stringWithFormat:@"%@ 傳送了一張圖片給你", displayName];
            }
            
            
			localNotification.alertBody = pstrMsg;
            localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:pstrPayload,@"Payload", nil];
            
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
		}
	}
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	NSLog(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    
    NSString *presenceType = [presence type]; // online/offline
	NSString *myUsername = [[sender myJID] user];
	NSString *presenceFromUser = [[presence from] user];
	
    NSLog(@"presenceType = %@", presenceType);
    NSLog(@"myUsername = %@", myUsername);
    NSLog(@"presenceFromUser = %@", presenceFromUser);
    
    
	if (![presenceFromUser isEqualToString:myUsername])
    {
		
		if  ([presenceType isEqualToString:@"subscribe"])
        {
            NSString *pstrMSG = [NSString stringWithFormat:@"%@ 想要和您聯絡",presenceFromUser];
            RHAlertView *alert = [[RHAlertView alloc]initWithTitle:@""
                                                           message:pstrMSG
                                                          delegate:nil
                                                 cancelButtonTitle:@"暫時不要"
                                                 otherButtonTitles:@"同意",nil];
            [alert showWithCallback:^(UIAlertView *alertView, NSInteger buttonIndex)
             {
                 if ( buttonIndex == 1 )
                 {
                     NSString *pstr = [NSString stringWithFormat:@"%@@%@", presenceFromUser, kChatServer];
                     //[self.xmppRoster addUser:[XMPPJID jidWithString:pstr] withNickname:presenceFromUser];
                     [self.xmppRoster acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:pstr] andAddToRoster:YES];
                     
                 }
                 else
                 {
                     
                 }
                 
             }];

        }
		
	}

}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		NSLog(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
	
}

@end
//CCC:上一行的@end，是@implementation RHAppDelegate的@end
