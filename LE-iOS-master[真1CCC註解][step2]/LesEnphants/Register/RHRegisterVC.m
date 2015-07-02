//
//  RHRegisterVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/14.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHRegisterVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import <AdSupport/AdSupport.h>
#import "MBProgressHUD.h"
#import "RHUserProfileSettingVC.h"
#import "Utilities.h"
#import "LesEnphantsApiDefinition.h"
#import "CustomIOS7AlertView.h"
#import "RHProfileObj.h"
#import "RHAlertView.h"
#import "CustomIOS7AlertView.h"
@interface RHRegisterVC () < RHLesEnphantsAPIDelegate, UITextFieldDelegate >
{
    BOOL        m_bIsGuest;
    BOOL        m_bLogin;
}

- ( void )switchToUserProfileSetting:( BOOL )bGuest;

@end

@implementation RHRegisterVC
@synthesize delegate;
@synthesize m_pMBProgressHUD;
@synthesize m_pRHUserProfileSettingVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pMBProgressHUD = nil;
        self.m_pRHUserProfileSettingVC = nil;
        m_bIsGuest = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pRegisterSelectionView setFrame:[UIScreen mainScreen].bounds];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGRect frame = CGRectMake(0, 0, 0, 0);
        CGFloat addSpace = 25;
        CGFloat fontSize = 36;
        [self.m_pMainLogin.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
        [self.m_pMainRegister.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
        [self.m_pMainIgnore.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
        
        frame = self.m_pLoginEmail.frame;
        frame.origin.x -= addSpace * 4;
        frame.origin.y -= addSpace;
        frame.size.width += addSpace * 8;
        frame.size.height += addSpace;
        [self.m_pLoginEmail setFrame:frame];
        
        frame = self.m_pLoginFacebook.frame;
        frame.origin.x -= addSpace * 4;
        frame.size.width += addSpace * 8;
        frame.size.height += addSpace;
        [self.m_pLoginFacebook setFrame:frame];

        [self.m_pLoginEmail.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
        [self.m_pLoginFacebook.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FBLoginSucceed:) name:kFBLoginSucceed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FBLoginFailed:) name:kFBLoginFailed object:nil];
    
    self.navigationController.navigationBarHidden = YES;
}

- ( void )viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFBLoginSucceed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFBLoginFailed object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [m_pRHUserProfileSettingVC release];
    [_m_pRegisterSelectionView release];
    [_m_pEmailEditView release];
    [_m_pTFEmail release];
    [_m_pTFPassword release];
    [_m_pBtnEmailReg release];
    [_m_pLblRegTitle release];
    [super dealloc];
}

#pragma mark - IBAction
- ( IBAction )pressRegisterBtn:(id)sender
{
    //show 軟體用戶協議
    NSString *pstrInfo = @"財團法人工業技術研究院軟體用戶協議\n\n本應用軟體及其內容為財團法人工業技術研究院自行開發或經權利人合法授權，相關智慧財產權歸屬權利人及(或)財團法人工業技術研究院所有。用戶使用本應用軟體及相關服務時應尊重權利人之智慧財產權，不得使用任何方式侵害權利人之智慧財產權。\n\n本應用軟體需使用支援 Android 與 iOS 的行動式裝置。使用本應用軟體時將配合『麗嬰房品牌社群服務系統』後端平台服務，使用中將依據中華民國個人資料保護法規定收集個人相關資料，以供財團法人工業技術研究院及麗嬰房股份有限公司研究及應用之用。\n\n若用戶不同意個人資料被收集及使用請勿下載或使用本應用軟體。被收集及使用之個人資料將依中華民國個人資料保護法及其他個人隱私保護之法律進行保管。用戶之個人資料如需查詢/閱覽/製給複製本/補充或更正/停止收集、處理或利用/刪除，請洽(03)5917833。\n\n本應用軟體及其內容係免費提供用戶使用，不提供任何保證(例如:品質/功能等) 。用戶使用本應用軟體及其內容應考量個人身心狀況，若因使用本應用軟體及其內容產生任何損害/傷害，用戶同意自負相關責任。";
    
    UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 300)] autorelease];
    [pView setBackgroundColor:[UIColor clearColor]];
    
    
    UITextView *pTV = [[[UITextView alloc] initWithFrame:CGRectMake(0, 0, 260, 300)] autorelease];
    [pTV setFont:[UIFont systemFontOfSize:15]];
    [pTV setTextAlignment:NSTextAlignmentLeft];
    [pTV setTextColor:[UIColor blackColor]];
    [pTV setText:pstrInfo];
    //[pTV sizeToFit];
    
    [pView addSubview:pTV];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    //        alertView.tag = kVisitTag;
    // Add some custom content to the alert view
    [alertView setContainerView:pView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"確定", nil]];
    
    [alertView show];
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex)
     {
         
         if (buttonIndex == 0)
         {
             [alertView close];
         }
         else if (buttonIndex == 1)
         {
             //show Next page
             m_bIsGuest = NO;
             m_bLogin = NO;
             [self.m_pBtnEmailReg setTitle:@"使用Email註冊" forState:UIControlStateNormal];
             [self.m_pLblRegTitle setText:@"註冊"];
             [self.view addSubview:self.m_pRegisterSelectionView];
             
             CGRect kRect = self.m_pRegisterSelectionView.bounds;
             kRect.origin.x = [UIScreen mainScreen].bounds.size.width;
             [self.m_pRegisterSelectionView setFrame:kRect];
             
             
             //Move Enter
             [UIView beginAnimations:@"Move" context:nil];
             [UIView setAnimationDuration:0.50f];
             kRect.origin.x = 0;
             [self.m_pRegisterSelectionView setFrame:kRect];
             
             
             [UIView commitAnimations];

         }
     }];
    
    
//    NSString *pstrCnt = @"本應用軟體及其內容為財團法人工業技術研究院自行開發或經權利人合法授權，相關智慧財產權歸屬權利人及(或)財團法人工業技術研究院所有。用戶使用本應用軟體及相關服務時應尊重權利人之智慧財產權，不得使用任何方式侵害權利人之智慧財產權。\n\n本應用軟體需使用支援 Android 與 iOS 的行動式裝置。使用本應用軟體時將配合『麗嬰房品牌社群服務系統』後端平台服務，使用中將依據中華民國個人資料保護法規定收集個人相關資料，以供財團法人工業技術研究院及麗嬰房股份有限公司研究及應用之用。\n\n若用戶不同意個人資料被收集及使用請勿下載或使用本應用軟體。被收集及使用之個人資料將依中華民國個人資料保護法及其他個人隱私保護之法律進行保管。用戶之個人資料如需查詢/閱覽/製給複製本/補充或更正/停止收集、處理或利用/刪除，請洽(03)5917833。\n\n本應用軟體及其內容係免費提供用戶使用，不提供任何保證(例如:品質/功能等) 。用戶使用本應用軟體及其內容應考量個人身心狀況，若因使用本應用軟體及其內容產生任何損害/傷害，用戶同意自負相關責任。";
//    
//    RHAlertView *alert = [[RHAlertView alloc]initWithTitle:@"財團法人工業技術研究院軟體用戶協議"
//                                                   message:pstrCnt
//                                                  delegate:nil
//                                         cancelButtonTitle:@"取消"
//                                         otherButtonTitles:@"確定",nil];
//    [alert showWithCallback:^(UIAlertView *alertView, NSInteger buttonIndex)
//     {
//         if ( buttonIndex == 1 )
//         {
//             //show Next page
//             m_bIsGuest = NO;
//             m_bLogin = NO;
//             [self.m_pBtnEmailReg setTitle:@"使用Email註冊" forState:UIControlStateNormal];
//             [self.m_pLblRegTitle setText:@"註冊"];
//             [self.view addSubview:self.m_pRegisterSelectionView];
//             
//             CGRect kRect = self.m_pRegisterSelectionView.bounds;
//             kRect.origin.x = 320;
//             [self.m_pRegisterSelectionView setFrame:kRect];
//             
//             
//             //Move Enter
//             [UIView beginAnimations:@"Move" context:nil];
//             [UIView setAnimationDuration:0.50f];
//             kRect.origin.x = 0;
//             [self.m_pRegisterSelectionView setFrame:kRect];
//             
//             
//             [UIView commitAnimations];
//         }
//         else
//         {
//             
//         }
//         
//     }];
}

- ( IBAction )pressLoginBtn:(id)sender
{
    //show Next page
    m_bIsGuest = NO;
    m_bLogin = YES;
    [self.m_pBtnEmailReg setTitle:@"使用Email登入" forState:UIControlStateNormal];
    [self.m_pLblRegTitle setText:@"登入"];
    [self.view addSubview:self.m_pRegisterSelectionView];
    
    CGRect kRect = self.m_pRegisterSelectionView.bounds;
    kRect.origin.x = [UIScreen mainScreen].bounds.size.width;
    [self.m_pRegisterSelectionView setFrame:kRect];
    
    
    //Move Enter
    [UIView beginAnimations:@"Move" context:nil];
    [UIView setAnimationDuration:0.50f];
    kRect.origin.x = 0;
    [self.m_pRegisterSelectionView setFrame:kRect];
    
    
    [UIView commitAnimations];
}

- ( IBAction )pressBackBtn:(id)sender
{
    CGRect kRect = self.m_pRegisterSelectionView.bounds;
    kRect.origin.x = 0;
    [self.m_pRegisterSelectionView setFrame:kRect];
    
    
    //Move Enter
    [UIView beginAnimations:@"Move" context:nil];
    [UIView setAnimationDuration:0.50f];
    kRect.origin.x = [UIScreen mainScreen].bounds.size.width;
    [self.m_pRegisterSelectionView setFrame:kRect];
    
    
    [UIView commitAnimations];

}

- ( IBAction )pressSkipBtn:(id)sender
{
    NSString *pstrMsg = @"即刻註冊可享3大服務\n1.親友即時通訊\n2.創建社團討論\n3.累積紅利點數";
    
    
    RHAlertView *alert = [[RHAlertView alloc]initWithTitle:@""
                                                   message:pstrMsg
                                                  delegate:nil
                                         cancelButtonTitle:@"返回"
                                         otherButtonTitles:@"確定",nil];
    [alert showWithCallback:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if ( buttonIndex == 1 )
         {
            
             //設定為Guest 登入
             m_bIsGuest = YES;
             
             
             self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             
             NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
             
             [pParameter setObject:@"GUEST" forKey:@"Type"];
             
             NSString *pstrUUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
             
             [pParameter setObject:pstrUUID forKey:@"ID"];
             
             
             [RHLesEnphantsAPI Login:pParameter Source:self];
         }
         else
         {
             
         }
         
     }];
}

- ( IBAction )pressFBRegisterBtn:(id)sender
{
    self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[RHAppDelegate sharedDelegate] LoginFB];
}

- ( IBAction )pressEmailRegisterBtn:(id)sender
{
    //按下Email註冊，要區分登入還是註冊
    
    if ( m_bLogin )
    {
        //登入
        [self showLoginDialog];
    }
    else
    {
        //註冊
        [self showRegisterDialog];
    }
    
    
//    [self.view addSubview:self.m_pEmailEditView];
//    
//    CGRect kRect = self.m_pEmailEditView.bounds;
//    kRect.origin.x = 320;
//    [self.m_pEmailEditView setFrame:kRect];
//    
//    
//    //Move Enter
//    [UIView beginAnimations:@"Move" context:nil];
//    [UIView setAnimationDuration:0.50f];
//    kRect.origin.x = 0;
//    [self.m_pEmailEditView setFrame:kRect];
//    
//    
//    [UIView commitAnimations];
    
}

- ( IBAction )pressNextStepBtn:(id)sender
{
    //Email註冊的下一步按鈕
    
    
    //check Email
    NSString *pstrEmail = [[self.m_pTFEmail text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pstrPW = [[self.m_pTFPassword text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
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
    
    
    //call api
    self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [pParameter setObject:@"EMAIL" forKey:@"Type"];
    [pParameter setObject:pstrEmail forKey:@"ID"];
    [pParameter setObject:pstrPW forKey:@"PW"];
    
    
    [RHAppDelegate saveEmail:pstrEmail];
    [RHAppDelegate savePWD:pstrPW];
    
    [RHLesEnphantsAPI Login:pParameter Source:self];
    
}

#pragma mark - Methos
- ( void )switchToUserProfileSetting:( BOOL )bGuest
{
    RHUserProfileSettingVC *pVC = [[RHUserProfileSettingVC alloc] initWithNibName:@"RHUserProfileSettingVC" bundle:nil];
    self.m_pRHUserProfileSettingVC = pVC;
    [pVC release];
    
    if ( bGuest )
    {
        [m_pRHUserProfileSettingVC setGuestLogin];
    }
    
    [self.navigationController pushViewController:m_pRHUserProfileSettingVC animated:YES];
    
}

- ( void )showLoginDialog
{
    UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 130)] autorelease];
    [pView setBackgroundColor:[UIColor clearColor]];
    
    
    UITextField *pTxtView = [[[UITextField alloc] initWithFrame:CGRectMake(10, 10, 240, 40)] autorelease];
    [pTxtView setBorderStyle:UITextBorderStyleRoundedRect];
    [pTxtView setPlaceholder:@"請輸入Email"];
    [pTxtView setKeyboardType:UIKeyboardTypeEmailAddress];
    [pTxtView setDelegate:self];
    [pView addSubview:pTxtView];
    
    UITextField *pTxtView1 = [[[UITextField alloc] initWithFrame:CGRectMake(10, 60, 240, 40)] autorelease];
    [pTxtView1 setBorderStyle:UITextBorderStyleRoundedRect];
    [pTxtView1 setPlaceholder:@"請輸入密碼"];
    [pTxtView1 setDelegate:self];
    [pTxtView1 setSecureTextEntry:YES];
    [pView addSubview:pTxtView1];
    
    
    
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    //        alertView.tag = kVisitTag;
    // Add some custom content to the alert view
    [alertView setContainerView:pView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"忘記密碼",@"送出", nil]];
    
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
             //忘記密碼
             NSString *pstrEmail = [[pTxtView text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
             
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
             
             
             NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
             
             [pParameter setObject:pstrEmail forKey:@"email"];

             [RHAppDelegate showLoadingHUD];
             [RHLesEnphantsAPI ResetPassword:pParameter Source:self];

         }
         else if (buttonIndex == 2)
         {
             //註冊
             NSString *pstrEmail = [[pTxtView text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
             NSString *pstrPW = [[pTxtView1 text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
             
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
             
             
             [RHAppDelegate saveEmail:pstrEmail];
             [RHAppDelegate savePWD:pstrPW];
             
             [RHAppDelegate showLoadingHUD];
             [RHLesEnphantsAPI Login:pParameter Source:self];
             
         }
         
     }];

}

- ( void )showRegisterDialog
{
    UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 180)] autorelease];
    [pView setBackgroundColor:[UIColor clearColor]];
    
    
    UITextField *pTxtView = [[[UITextField alloc] initWithFrame:CGRectMake(10, 10, 240, 40)] autorelease];
    [pTxtView setBorderStyle:UITextBorderStyleRoundedRect];
    [pTxtView setPlaceholder:@"請輸入Email"];
    [pTxtView setKeyboardType:UIKeyboardTypeEmailAddress];
    [pTxtView setDelegate:self];
    [pView addSubview:pTxtView];
    
    UITextField *pTxtView1 = [[[UITextField alloc] initWithFrame:CGRectMake(10, 60, 240, 40)] autorelease];
    [pTxtView1 setBorderStyle:UITextBorderStyleRoundedRect];
    [pTxtView1 setPlaceholder:@"請輸入密碼"];
    [pTxtView1 setDelegate:self];
    [pTxtView1 setSecureTextEntry:YES];
    [pView addSubview:pTxtView1];
    
    UITextField *pTxtView2 = [[[UITextField alloc] initWithFrame:CGRectMake(10, 110, 240, 40)] autorelease];
    [pTxtView2 setBorderStyle:UITextBorderStyleRoundedRect];
    [pTxtView2 setPlaceholder:@"確認密碼"];
    [pTxtView2 setDelegate:self];
    [pTxtView1 setSecureTextEntry:YES];
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
             
             
             [RHAppDelegate saveEmail:pstrEmail];
             [RHAppDelegate savePWD:pstrPW];
             
             [RHAppDelegate showLoadingHUD];
             [RHLesEnphantsAPI Login:pParameter Source:self];

         }
         
     }];
}



#pragma mark - Notification
- ( void )FBLoginSucceed:( NSNotification * )pNotification
{//CCC:pstrUID是一串數字組成的字串,像是@"115666098765274"
    NSString *pstrUID = ( NSString * )[pNotification object];
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [pParameter setObject:@"FB" forKey:@"Type"];
    
    [pParameter setObject:pstrUID forKey:@"ID"];
    
    [RHAppDelegate saveFBID:pstrUID];
    
    
    
    [RHLesEnphantsAPI Login:pParameter Source:self];
}

- ( void )FBLoginFailed:( NSNotification * )pNotification
{
    [RHAppDelegate MessageBox:@"FB登入失敗"];
    [m_pMBProgressHUD hide:YES];
}


#pragma mark - RHLesEnphantsAPIDelegate

- (void)callBackResetPasswordStatus:(NSDictionary *)pStatusDic
{
    NSLog(@"callBackResetPasswordStatus = %@", pStatusDic);
    
    NSInteger nStatusCode = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nStatusCode == 0 )
    {
        //成功
        [RHAppDelegate MessageBox:@"已發送Mail訊息"];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",(int)nStatusCode]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackLoginStatus:( NSDictionary * )pStatusDic
{
    NSLog(@"callBackLoginStatus = %@", pStatusDic);
    
    NSInteger nStatusCode = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nStatusCode == 0 )
    {
        //成功
        NSLog(@"profile = %@", [pStatusDic objectForKey:@"profile"]);
        
        NSMutableDictionary *pProfile = [pStatusDic objectForKey:@"profile"];
        
        
        // Get Facebook Data
        NSDictionary *pFBGraphUser = [[RHAppDelegate sharedDelegate] m_pFBGraphUser];
        if (pFBGraphUser) {
            
            // 如果沒有資料，就從FB取得
            NSString *pProfileNickname = [pProfile objectForKey:@"nickname"];
            NSString *pFBName = [pFBGraphUser objectForKey:@"name"];
            
            if ( (pProfileNickname == nil || pProfileNickname.length == 0) &&
                pFBName != nil) {
                [pProfile setObject:pFBName forKey:@"nickname"];
            }
        }
        
        
        //NSString *pstrMSG = [NSString stringWithFormat:@"UID:\n%@", [pProfile objectForKey:@"id"]];
        //keep Login Profile
        [[RHAppDelegate sharedDelegate] keepLoginProfile:pProfile];
        
        //儲存PHP Session ID
        NSString *pstrPSID = [pStatusDic objectForKey:@"psid"];
        [RHAppDelegate savePHPSessionID:pstrPSID];
        
        //Save UID
        [RHAppDelegate saveUID:[self.m_pTFEmail text]];
        //Save PWD
        [RHAppDelegate savePWD:[self.m_pTFPassword text]];
        
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
        
        if ( self.m_pEmailEditView.superview )
        {
            [self.m_pEmailEditView removeFromSuperview];
        }
        
        if ( [[RHAppDelegate sharedDelegate].m_pRHProfileObj hasSetLoginType] )
        {
            NSLog(@"有資料");
            [[NSNotificationCenter defaultCenter] postNotificationName:kFinishRegister object:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
//            [self switchToUserProfileSetting:NO];
        }
        else
        {
            NSLog(@"沒資料");
            [self switchToUserProfileSetting:m_bIsGuest];
        }
        
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatusCode]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    
    [RHAppDelegate hideLoadingHUD];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}



@end
