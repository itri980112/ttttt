//
//  RHPointCollection.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHPointCollection.h"
#import "RHProfileObj.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "RHInfoVC.h"
#import "RHAlertView.h"
#import "CustomIOS7AlertView.h"
#import "MBProgressHUD.h"
#import "RHStoreListVC.h"
#import "ZUUIRevealController.h"
#import "GoldCoinAnimationVC.h"

@interface RHPointCollection ()
{
    NSString *m_pstrKeepBirthday;
}

@property ( nonatomic, retain ) NSString *m_pstrKeepBirthday;

- ( void )exchangePoint;
- ( void )delayProcess;
@end

@implementation RHPointCollection
@synthesize m_pMBProgressHUD;
@synthesize m_bIsPresent;
@synthesize m_pstrKeepBirthday;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_pMBProgressHUD = nil;
        self.m_pstrKeepBirthday= @"";
        m_bIsPresent = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_POINT_TITLE", nil)];
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    [self.m_pLblID setText:pObj.m_pstrMatchID];
    [self.m_pLblGold setText:[NSString stringWithFormat:@"%d", pObj.m_nPoint]];
    [self.m_pLblPoint setText:[NSString stringWithFormat:@"%d", pObj.m_nLePoint]];
    
    
    [self.m_pMainScrollView addSubview:self.m_pCntView];
    [self.m_pMainScrollView setContentSize:self.m_pCntView.frame.size];
    
    ZUUIRevealController *viewController = (ZUUIRevealController *)self.navigationController.parentViewController;
    if ([viewController respondsToSelector:@selector(revealToggle:)]) {
        [self.m_pBtnBack setImage:[UIImage imageNamed:@"header_sidemenu.png"] forState:UIControlStateNormal];
    }
    
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [m_pMBProgressHUD release];
    [_m_pImgView release];
    [_m_pLblID release];
    [_m_pLblPoint release];
    [_m_pLblGold release];
    [_m_pMainScrollView release];
    [_m_pCntView release];
    [super dealloc];
}

#pragma mark - Private
- ( void )exchangePoint
{
    NSString *pstrMSG = @"1000枚好孕邦金幣\n等同於\n100點麗嬰房紅利點數";
    RHAlertView *alert = [[RHAlertView alloc]initWithTitle:@""
                                                   message:pstrMSG
                                                  delegate:nil
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"兌換",nil];
    [alert showWithCallback:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if ( buttonIndex == 1 )
         {
             //判斷是否為第一次兌換
             BOOL bIsExChanged = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IsExchanged"] boolValue];
             
             if ( !bIsExChanged )
             {
                 [self performSelector:@selector(delayProcess) withObject:nil afterDelay:0.25f];
             }
             else
             {
                 //直接換
                 RHProfileObj *pObj = [RHProfileObj getProfile];
                 NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
                 [pParameter setObject:[NSString stringWithFormat:@"%d", pObj.m_nPoint] forKey:kPoint];
                 
                 self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 [RHLesEnphantsAPI exchangePoint:pParameter Source:self];
             }
             
         }
         else
         {
             
         }
         
     }];

}

- ( void )delayProcess
{
    //要輸入生日做驗證
    __block NSString *pstrInputText = @"";
    
    UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)] autorelease];
    [pView setBackgroundColor:[UIColor lightGrayColor]];
    
    
    UILabel *pLblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 80)] autorelease];
    [pLblTitle setTextAlignment:NSTextAlignmentCenter];
    [pLblTitle setTextColor:[UIColor blackColor]];
    [pLblTitle setNumberOfLines:0];
    [pLblTitle setText:@"請輸入手機號碼與生日\n(例：1980-01-01)"];
    
    
    UILabel *pLblTitle1 = [[[UILabel alloc] initWithFrame:CGRectMake(10, 80, 55, 40)] autorelease];
    [pLblTitle1 setTextAlignment:NSTextAlignmentLeft];
    [pLblTitle1 setTextColor:[UIColor blackColor]];
    [pLblTitle1 setText:@"手機："];
    [pView addSubview:pLblTitle1];
    
    UITextField *pTxtView1 = [[[UITextField alloc] initWithFrame:CGRectMake(70, 80, 180, 40)] autorelease];
    [pTxtView1 setBorderStyle:UITextBorderStyleRoundedRect];
    [pTxtView1 setPlaceholder:@""];
    [pView addSubview:pLblTitle];
    [pView addSubview:pTxtView1];
    
    UILabel *pLblTitle2 = [[[UILabel alloc] initWithFrame:CGRectMake(10, 140, 55, 40)] autorelease];
    [pLblTitle2 setTextAlignment:NSTextAlignmentLeft];
    [pLblTitle2 setTextColor:[UIColor blackColor]];
    [pLblTitle2 setText:@"生日："];
    [pView addSubview:pLblTitle2];
    
    
    UITextField *pTxtView2 = [[[UITextField alloc] initWithFrame:CGRectMake(70, 140, 180, 40)] autorelease];
    [pTxtView2 setBorderStyle:UITextBorderStyleRoundedRect];
    [pTxtView2 setPlaceholder:@"yyyy-mm-dd"];
    [pView addSubview:pLblTitle];
    [pView addSubview:pTxtView2];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    //        alertView.tag = kVisitTag;
    // Add some custom content to the alert view
    [alertView setContainerView:pView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:NSLocalizedString(@"LE_COMMON_CANCEL", nil),NSLocalizedString(@"LE_COMMON_CONFIRM", nil), nil]];
    
    [alertView show];
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex)
     {

         if (buttonIndex == 0)
         {
             
         }
         else if (buttonIndex == 1)
         {
             
             self.m_pstrKeepBirthday = [pTxtView2 text];
             
             //set mobile first
             NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];

             [pParameter setObject:[pTxtView1 text] forKey:kMobile];
             
             [RHLesEnphantsAPI setUserProfile:pParameter Source:self];
         }
         
     }];
}

#pragma mark - ShowAnimation
- (void)showAnimation:(NSInteger)point
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType != 1 ) return;

    // 得到金幣,顯示動畫
    if (point >= kShowAnimationMinimumPoint) {
        GoldCoinAnimationVC *vc = nil;
        if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC~ipad" bundle:nil];
        }
        else {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC" bundle:nil];
        }
        
        vc.m_getPoint = point;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:^{
            [vc startAnimation];
        }];
    }
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    if ( m_bIsPresent )
    {
        ZUUIRevealController *viewController = (ZUUIRevealController *)self.navigationController.parentViewController;
        if ([viewController respondsToSelector:@selector(revealToggle:)]) {
            [viewController revealToggle:nil];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- ( IBAction )pressStoreBtn:(id)sender
{
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI getNewsContent:nil Source:self CntType:4];
}
- ( IBAction )pressExchangeBtn:(id)sender
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj.m_nPoint < 50 )
    {
        [RHAppDelegate MessageBox:@"金幣不足，不可兌換"];
        return;
    }

    NSString *pstrInfo = @"好孕邦金幣10枚可兌換麗嬰房紅利點數，可至麗嬰房實體店櫃及iBabymall網路購物抵用消費，紅利點數1點可折換現金1元。\n金幣兌換資料一經送出後，無法取消兌換訂單並退還紅利點數。請妥善保管您的登入帳號及密碼。\n除本條款另有規定者外，任何經由輸入正確帳號密碼所發生的交易，均視為正常交易。除非證明原因可歸責於麗嬰房之事由，導致您前述密碼遭他人盜用而產生損失外，您不得向麗嬰房請求賠償因帳號、密碼遭盜用所產生的任何損失。\n麗嬰房保有修改及變更本使用條款之內容。";
    
    UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 300)] autorelease];
    [pView setBackgroundColor:[UIColor clearColor]];
    
    
    UILabel *pLblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 300)] autorelease];
    [pLblTitle setFont:[UIFont systemFontOfSize:15]];
    [pLblTitle setTextAlignment:NSTextAlignmentLeft];
    [pLblTitle setNumberOfLines:0];
    [pLblTitle setTextColor:[UIColor blackColor]];
    [pLblTitle setText:pstrInfo];
    [pLblTitle sizeToFit];
    
    [pView addSubview:pLblTitle];
    
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
             //[alertView close];
         }
         else if (buttonIndex == 1)
         {
             [self exchangePoint];
             
//             //檢查有沒有輸入電話
//             if ( [pObj.m_pstrMobile compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
//             {
//                 //跳出提示
//                 
//                 UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 160)] autorelease];
//                 [pView setBackgroundColor:[UIColor whiteColor]];
//                 
//                 
//                 UILabel *pLblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 40)] autorelease];
//                 [pLblTitle setTextAlignment:NSTextAlignmentCenter];
//                 [pLblTitle setTextColor:[UIColor blackColor]];
//                 [pLblTitle setText:@"輸入手機號碼"];
//                 
//                 UITextField *pTxtView = [[[UITextField alloc] initWithFrame:CGRectMake(10, 50, 240, 40)] autorelease];
//                 [pTxtView setBorderStyle:UITextBorderStyleRoundedRect];
//                 
//                 UILabel *pLblHint = [[[UILabel alloc] initWithFrame:CGRectMake(20, 100, 220, 40)] autorelease];
//                 [pLblHint setTextAlignment:NSTextAlignmentLeft];
//                 [pLblHint setFont:[UIFont systemFontOfSize:12]];
//                 [pLblHint setNumberOfLines:0];
//                 [pLblHint setTextColor:[UIColor blackColor]];
//                 [pLblHint setText:@"若您已經持有麗嬰房會員的身份，請輸入同一組手機號碼"];
//                 
//                 
//                 
//                 [pView addSubview:pLblTitle];
//                 [pView addSubview:pTxtView];
//                 [pView addSubview:pLblHint];
//                 
//                 CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
//                 
//                 [alertView setContainerView:pView];
//                 
//                 // Modify the parameters
//                 [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"送出", nil]];
//                 
//                 [alertView show];
//                 // You may use a Block, rather than a delegate.
//                 [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex)
//                  {
//                      if (buttonIndex == 0)
//                      {
//                          [alertView close];
//                      }
//                      else if (buttonIndex == 1)
//                      {
//                          //送回手機資料
//                          NSString *pstrPhone = [pTxtView text];
//                          
//                      }
//                      
//                  }];
//             }
//             else
//             {
//                 //已有電話
//                 [self exchangePoint];
//             }

         }
         
     }];
}

//{
//    RHProfileObj *pObj = [RHProfileObj getProfile];
//    
//    if ( pObj.m_nPoint < 50 )
//    {
//        [RHAppDelegate MessageBox:@"金幣不足，不可兌換"];
//        return;
//    }
//
//    NSString *pstrInfo = @"好孕邦金幣10枚可兌換麗嬰房紅利點數，可至麗嬰房實體店櫃及iBabymall網路購物抵用消費，紅利點數1點可折換現金1元。\n金幣兌換資料一經送出後，無法取消兌換訂單並退還紅利點數。請妥善保管您的登入帳號及密碼。\n除本條款另有規定者外，任何經由輸入正確帳號密碼所發生的交易，均視為正常交易。除非證明原因可歸責於麗嬰房之事由，導致您前述密碼遭他人盜用而產生損失外，您不得向麗嬰房請求賠償因帳號、密碼遭盜用所產生的任何損失。\n麗嬰房保有修改及變更本使用條款之內容。";
//
//    //show 兌換聲明
//    RHAlertView *alert = [[RHAlertView alloc]initWithTitle:@"兌換聲明"
//                                                   message:pstrInfo
//                                                  delegate:nil
//                                         cancelButtonTitle:@"取消"
//                                         otherButtonTitles:@"確定",nil];
//    [alert showWithCallback:^(UIAlertView *alertView, NSInteger buttonIndex)
//     {
//         if ( buttonIndex == 1 )
//         {
//             //檢查有沒有輸入電話
//             if ( [pObj.m_pstrMobile compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
//             {
//                 //跳出提示
//                 
//                 UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 160)] autorelease];
//                 [pView setBackgroundColor:[UIColor whiteColor]];
//                 
//                 
//                 UILabel *pLblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 40)] autorelease];
//                 [pLblTitle setTextAlignment:NSTextAlignmentCenter];
//                 [pLblTitle setTextColor:[UIColor blackColor]];
//                 [pLblTitle setText:@"輸入手機號碼"];
//                 
//                 UITextField *pTxtView = [[[UITextField alloc] initWithFrame:CGRectMake(10, 50, 240, 40)] autorelease];
//                 [pTxtView setBorderStyle:UITextBorderStyleRoundedRect];
//                 
//                 UILabel *pLblHint = [[[UILabel alloc] initWithFrame:CGRectMake(20, 100, 220, 40)] autorelease];
//                 [pLblHint setTextAlignment:NSTextAlignmentLeft];
//                 [pLblHint setFont:[UIFont systemFontOfSize:12]];
//                 [pLblHint setNumberOfLines:0];
//                 [pLblHint setTextColor:[UIColor blackColor]];
//                 [pLblHint setText:@"若您已經持有麗嬰房會員的身份，請輸入同一組手機號碼"];
//
//                 
//                 
//                 [pView addSubview:pLblTitle];
//                 [pView addSubview:pTxtView];
//                 [pView addSubview:pLblHint];
//                 
//                 CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
//                 
//                 [alertView setContainerView:pView];
//                 
//                 // Modify the parameters
//                 [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"送出", nil]];
//                 
//                 [alertView show];
//                 // You may use a Block, rather than a delegate.
//                 [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex)
//                  {
//                      if (buttonIndex == 0)
//                      {
//                          [alertView close];
//                      }
//                      else if (buttonIndex == 1)
//                      {
//                          //送回手機資料
//                          NSString *pstrPhone = [pTxtView text];
//                          
//                      }
//                      
//                  }];
//             }
//             else
//             {
//                 //已有電話
//                 [self exchangePoint];
//             }
//         }
//         else
//         {
//             
//         }
//         
//     }];
//   
//}

- ( IBAction )pressInfoBtn1:(id)sender
{
    RHInfoVC    *pVC = [[RHInfoVC alloc] initWithNibName:@"RHInfoVC" bundle:nil];
    [pVC setM_bIsRule_1:NO];
    [self.navigationController pushViewController:[pVC autorelease] animated:YES];
}
- ( IBAction )pressInfoBtn2:(id)sender
{
    RHInfoVC    *pVC = [[RHInfoVC alloc] initWithNibName:@"RHInfoVC" bundle:nil];
    [pVC setM_bIsRule_1:YES];
    [self.navigationController pushViewController:[pVC autorelease] animated:YES];
}

#pragma mark - API CallBack
- ( void )callBackExchangePointStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"IsExchanged"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        NSInteger nGold = [[pStatusDic objectForKey:@"appPoint"] integerValue];
        NSInteger nPoint = [[pStatusDic objectForKey:@"lePoint"] integerValue];
        NSString *pstrLEmember = [pStatusDic objectForKey:@"LeMember"];
        
        [self.m_pLblGold setText:[NSString stringWithFormat:@"%d", nGold]];
        [self.m_pLblPoint setText:[NSString stringWithFormat:@"%d", nPoint]];
        
        
        NSInteger point = [[pStatusDic objectForKey:@"Point"] integerValue];
        [self showAnimation:point];
        
        
        //重拿一次 profile
        [RHLesEnphantsAPI getUserProfile:nil Source:self];
        
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
        
        if ( m_pMBProgressHUD )
        {
            [m_pMBProgressHUD hide:YES];
        }
    }
}

- ( void )callBackSetUserProfileStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        RHProfileObj *pObj = [RHProfileObj getProfile];
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:[NSString stringWithFormat:@"%d", pObj.m_nPoint] forKey:kPoint];
        [pParameter setObject:m_pstrKeepBirthday forKey:kBirthday];
        
        self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [RHLesEnphantsAPI exchangePoint:pParameter Source:self];
        
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
        
        if ( m_pMBProgressHUD )
        {
            [m_pMBProgressHUD hide:YES];
        }
    }

}

#pragma mark - RHLesEnphantsAPIDelegate
- ( void )callBackGetUserProfileStatus:( NSDictionary * )pStatusDic
{
    NSLog(@"pStatusDic = %@", pStatusDic);
    
    if ( pStatusDic )
    {
        NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
        
        if ( nStatus == 0 )
        {
            [[RHAppDelegate sharedDelegate] keepLoginProfile:[pStatusDic objectForKey:@"profile"]];
        }
        else
        {
            NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatus]];
            [RHAppDelegate MessageBox:pstrErrorMsg];
        }
    }
    else
    {
        NSLog(@"Can't get User profile");
    }
    
    if ( m_pMBProgressHUD )
    {
        [m_pMBProgressHUD hide:YES];
    }
}

- ( void )callBackGetNewsContentStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSArray *pData = [pStatusDic objectForKey:@"data"];
        
        RHStoreListVC *pVC = [[RHStoreListVC alloc] initWithNibName:@"RHStoreListVC" bundle:nil];
        [pVC setupData:pData];
        [self.navigationController pushViewController:[pVC autorelease] animated:YES];

    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }

    [RHAppDelegate hideLoadingHUD];
}
@end
