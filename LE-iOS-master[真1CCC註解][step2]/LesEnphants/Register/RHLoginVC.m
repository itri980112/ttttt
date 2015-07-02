//
//  RHLoginVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/14.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHLoginVC.h"
#import "RHLesEnphantsAPI.h"
#import <AdSupport/AdSupport.h>
#import "RHAppDelegate.h"
#import "Utilities.h"

@interface RHLoginVC () < RHLesEnphantsAPIDelegate >

@end

@implementation RHLoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FBLoginSucceed:) name:kFBLoginSucceed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FBLoginFailed:) name:kFBLoginFailed object:nil];
}

- ( void )viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFBLoginSucceed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFBLoginFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [_m_pTFEMail release];
    [_m_pTFPW release];
    [_m_pResultTV release];
    [super dealloc];
}


#pragma mark - Notification
- ( void )FBLoginSucceed:( NSNotification * )pNotification
{
    NSString *pstrUID = ( NSString * )[pNotification object];
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [pParameter setObject:@"FB" forKey:@"Type"];

    [pParameter setObject:pstrUID forKey:@"ID"];
    
    //Keep FB ID
    [RHAppDelegate saveFBID:pstrUID];
    
    
    [RHLesEnphantsAPI Login:pParameter Source:self];
}

- ( void )FBLoginFailed:( NSNotification * )pNotification
{
    
}


#pragma mark - IBAction
- ( IBAction )pressCloseBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- ( IBAction )pressEmailLoginBtn:(id)sender
{
    NSString *pstrEmail = [[self.m_pTFEMail text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pstrPW = [[self.m_pTFPW text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ( [pstrEmail compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        [RHAppDelegate MessageBox:@"請輸入Email"];
        return;
    }
    
    if ( ![Utilities NSStringIsValidEmail:pstrEmail] )
    {
        [RHAppDelegate MessageBox:@"Email格式有錯"];
        return;
    }
    
    
    if ( [pstrPW compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        [RHAppDelegate MessageBox:@"請輸入密碼"];
        return;
    }
    
    
    
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [pParameter setObject:@"EMAIL" forKey:@"Type"];
    [pParameter setObject:pstrEmail forKey:@"ID"];
    [pParameter setObject:pstrPW forKey:@"PW"];
    
    [RHLesEnphantsAPI Login:pParameter Source:self];
    
    
}
- ( IBAction )pressGuestLoginBtn:(id)sender
{
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [pParameter setObject:@"GUEST" forKey:@"Type"];
    
    NSString *pstrUUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [pParameter setObject:pstrUUID forKey:@"ID"];
    
    [RHLesEnphantsAPI Login:pParameter Source:self];
}
- ( IBAction )pressFBLoginBtn:(id)sender
{
    [[RHAppDelegate sharedDelegate] LoginFB];
}

#pragma mark - RHLesEnphantsAPIDelegate
- ( void )callBackLoginStatus:( NSDictionary * )pStatusDic
{
    NSLog(@"callBackLoginStatus = %@", pStatusDic);
    
    NSInteger nStatusCode = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nStatusCode == 0 )
    {
        //成功
        NSLog(@"profile = %@", [pStatusDic objectForKey:@"profile"]);
        
        NSDictionary *pProfile = [pStatusDic objectForKey:@"profile"];
        
        NSString *pstrMSG = [NSString stringWithFormat:@"UID:\n%@", [pProfile objectForKey:@"id"]];
        
        [self.m_pResultTV setText:pstrMSG];

    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatusCode]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
}

@end
