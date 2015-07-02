//
//  RHLoginVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/14.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHRegisterHint.h"
#import "RHAppDelegate.h"
#import "CustomIOS7AlertView.h"
#import "Utilities.h"
#import "RHLesEnphantsAPI.h"
#import "RHUserProfileSettingVC.h"
#import "LesEnphantsApiDefinition.h"
#import "RHMainVC.h"
#import "MBProgressHUD.h"

@interface RHRegisterHint () < UITextFieldDelegate >

@end

@implementation RHRegisterHint

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
}

- ( void )viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
	/*
     CCC:在某個地方執行
     [NSNotificationCenter defaultCenter] postNotificationName:kFBLoginSucceed object:nil;
    送出名為kFBLoginSucceed 的通知
     
     而
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FBLoginSucceed:) name:kFBLoginSucceed object:nil];
     是說當self物件收到名為kFBLoginSucceed的通知時
     執行FBLoginSucceed的方法
     
    */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FBLoginSucceed:) name:kFBLoginSucceed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FBLoginFailed:) name:kFBLoginFailed object:nil];

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

- ( void )showRegisterDialog
{
    UIView *pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 180)];
    [pView setBackgroundColor:[UIColor clearColor]];
    
    
    UITextField *pTxtView = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 240, 40)];
    [pTxtView setBorderStyle:UITextBorderStyleRoundedRect];
    [pTxtView setPlaceholder:@"請輸入Email"];
    [pTxtView setKeyboardType:UIKeyboardTypeEmailAddress];
    [pTxtView setDelegate:self];
    [pView addSubview:pTxtView];
    
    UITextField *pTxtView1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 240, 40)];
    [pTxtView1 setBorderStyle:UITextBorderStyleRoundedRect];
    [pTxtView1 setPlaceholder:@"請輸入密碼"];
    [pTxtView1 setDelegate:self];
    [pTxtView1 setSecureTextEntry:YES];
    [pView addSubview:pTxtView1];
    
    UITextField *pTxtView2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 110, 240, 40)];
    [pTxtView2 setBorderStyle:UITextBorderStyleRoundedRect];
    [pTxtView2 setPlaceholder:@"確認密碼"];
    [pTxtView2 setDelegate:self];
    [pTxtView2 setSecureTextEntry:YES];
    [pView addSubview:pTxtView2];
    
    
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    //        alertView.tag = kVisitTag;
    // Add some custom content to the alert view
    [alertView setContainerView:pView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"送出", nil]];
    
    [alertView show];
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex)
     {
         
         NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex,[alertView tag]);
         
         if (buttonIndex == 0)
         {
             [alertView close];
         }
         else if (buttonIndex == 1)
         {
             //註冊
             NSString *pstrEmail = [[pTxtView text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
             NSString *pstrPW = [[pTxtView1 text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
             NSString *pstrPW2 = [[pTxtView2 text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
             
             
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
             
             if ( [pstrPW compare:pstrPW2] != NSOrderedSame )
             {
                 [RHAppDelegate MessageBox:@"密碼設定錯誤！"];
                 return;
             }
             
             NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
             
             [pParameter setObject:@"EMAIL" forKey:@"Type"];
             [pParameter setObject:pstrEmail forKey:@"ID"];
             [pParameter setObject:pstrPW forKey:@"PW"];
             
             [RHAppDelegate resetEnvironment:NO];
             
             [RHAppDelegate saveEmail:pstrEmail];
             [RHAppDelegate saveUID:pstrEmail];
             [RHAppDelegate savePWD:pstrPW];
             
             [RHAppDelegate showLoadingHUD];
             [RHLesEnphantsAPI Login:pParameter Source:self];
             
         }
         
     }];
}


#pragma mark - IBAction
- ( IBAction )pressCloseBtn:(id)sender
{
    [self.view removeFromSuperview];
}

- ( IBAction )pressEmailLoginBtn:(id)sender
{
    [self showRegisterDialog];
    
}

- ( IBAction )pressFBLoginBtn:(id)sender
{
    [RHAppDelegate showLoadingHUD];

    [RHAppDelegate resetEnvironment:NO];
    [[RHAppDelegate sharedDelegate] LoginFB];
    [self pressCloseBtn:nil];
}


#pragma mark - Notification
- ( void )FBLoginSucceed:( NSNotification * )pNotification
{
    NSString *pstrUID = ( NSString * )[pNotification object];
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [pParameter setObject:@"FB" forKey:@"Type"];
    
    [pParameter setObject:pstrUID forKey:@"ID"];
    
    [RHAppDelegate saveFBID:pstrUID];
    
    
    
    [RHLesEnphantsAPI Login:pParameter Source:self];
}

- ( void )FBLoginFailed:( NSNotification * )pNotification
{
    [RHAppDelegate MessageBox:@"FB 登入失敗"];
    [RHAppDelegate hideLoadingHUD];
}



#pragma mark - Private
- ( void )switchToUserProfileSetting:( BOOL )bGuest
{
    RHUserProfileSettingVC *pVC = [[RHUserProfileSettingVC alloc] initWithNibName:@"RHUserProfileSettingVC" bundle:nil];
    [pVC setM_bIsPresent:YES];
    if ( bGuest )
    {
        [pVC setGuestLogin];
    }
    
    [[RHAppDelegate sharedDelegate].m_pRHMainVC presentViewController:pVC animated:YES completion:nil];
    [self pressCloseBtn:nil];
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
        
        [[RHAppDelegate sharedDelegate] updateEmotionDB];
        
        NSInteger nType = [[[pStatusDic objectForKey:@"profile"] objectForKey:@"type"] integerValue];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if ( nType == 1 || nType == 0 )
            {
                [RHAppDelegate saveHomeImg:@"home_mom01~iPad"];
            }
            else if ( nType == 2 )
            {
                [RHAppDelegate saveHomeImg:@"home_dad01~iPad"];
            }
            else
            {
                [RHAppDelegate saveHomeImg:@"home_others01~iPad"];
            }
        }
        else {
            if ( nType == 1 || nType == 0  )
            {
                [RHAppDelegate saveHomeImg:@"home_mom01.png"];
            }
            else if ( nType == 2 )
            {
                [RHAppDelegate saveHomeImg:@"home_dad01.png"];
            }
            else
            {
                [RHAppDelegate saveHomeImg:@"home_others01.png"];
            }
        }
        
        [self switchToUserProfileSetting:NO];
        
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatusCode]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    
    [RHAppDelegate hideLoadingHUD];
}

@end
