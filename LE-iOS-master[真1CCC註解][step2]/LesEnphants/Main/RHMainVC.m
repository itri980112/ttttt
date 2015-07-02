//
//  RHMainVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/13.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHMainVC.h"
#import "RHLoginVC.h"
#import "RHAppDelegate.h"
#import "RHRegisterVC.h"
#import "RevealController.h"
#import "MBProgressHUD.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "RHPregnantMemoVC.h"
#import "AsyncImageView.h"
#import "Utilities.h"
#import "RHProfileObj.h"
#import "RHMoodVC.h"
#import "RHChooseFriendsVC.h"
#import "RHImageViewerVC.h"
#import "RHShareViewerVC.h"
#import "RHUserProfileSettingVC.h"
#import "RHBabyViewerVC.h"
#import "RHMomViewerVC.h"


@interface RHMainVC () < RHLesEnphantsAPIDelegate >
- ( void )retrieveUserProfle:( NSNotification * )pNotification;
- ( void )showHightLight;
- ( void )loadEvent;
@end

@implementation RHMainVC
@synthesize m_pRHLoginVC;
@synthesize m_pRHRegisterVC;
@synthesize m_pMBProgressHUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pRHLoginVC = nil;
        self.m_pRHRegisterVC = nil;
    }
    return self;
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    
    NSString *pstrHomeBgImg = [RHAppDelegate getHomeImg];
    
    if ( pObj )
    {
        if ( pstrHomeBgImg && ( [pstrHomeBgImg compare:@""] != NSOrderedSame ) )
        {
            [self.m_pBackgroundImage setImage:[UIImage imageNamed:pstrHomeBgImg]];
        }
        else
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                if ( pObj.m_nType == 1 || pObj.m_nType == 0 )
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_mom01~iPad"]];
                }
                else if ( pObj.m_nType == 2 )
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_dad01~iPad"]];
                }
                else
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_others01~iPad"]];
                }
            }
            else {
                if ( pObj.m_nType == 1 || pObj.m_nType == 0 )
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_mom01"]];
                }
                else if ( pObj.m_nType == 2 )
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_dad01"]];
                }
                else
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_other01"]];
                }
            }
            
        }
    }

    [self loadEvent];
}

- ( void )viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //依身份Update UI
    
    [self showHightLight];
    
    
    //底部Menu Bar
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj.m_nType == 4 )
    {
        [self.m_pBottomView setHidden:YES];
        [self.m_pBtnWeek setHidden:YES];
        [self.m_pBtnEmotion setHidden:YES];
        [self.m_pBtnTodo setHidden:YES];
        [self.m_pbtnChooseFriend setFrame:CGRectMake(143, 306, 30, 30)];
    }
    else if ( pObj.m_nType == 0 )
    {
        [self.m_pBottomView setHidden:YES];
        [self.m_pGuestBottomView setHidden:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_MAIN_TITLE", nil)];
    [self.m_pLblCountDownTitle setText:NSLocalizedString(@"LE_MAIN_COUNTDOWN", nil)];
    [self.m_pLblPregNoteTitle setText:NSLocalizedString(@"LE_MAIN_PREGNOTE", nil)];
    [self.m_pLblNextTitle setText:NSLocalizedString(@"LE_MAIN_NEXTTEST", nil)];

    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    [self.m_pNaviBar addGestureRecognizer:navigationBarPanGestureRecognizer];
	NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    [navigationBarPanGestureRecognizer release];//CCC try
    NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    [self.m_pBtnMenu addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    

    //Notificattions
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveUserProfle:) name:kFinishRegister object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBackgroundImg:) name:kChangeBackgroundImg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserIcon:) name:kChangeUserIcon object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserProfle:) name:kMainViewtUserProfile object:nil];
    
    //判斷是否已註冊
    if ( [RHAppDelegate isRegistered] )
    {
        RHProfileObj *pObj = [RHProfileObj getProfile];

        
        NSString *pstrHomeBgImg = [RHAppDelegate getHomeImg];
        
        if ( pstrHomeBgImg )
        {
            [self.m_pBackgroundImage setImage:[UIImage imageNamed:pstrHomeBgImg]];
        }
        else
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                if ( pObj.m_nType == 1 || pObj.m_nType == 0 )
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_mom01~iPad"]];
                }
                else if ( pObj.m_nType == 2 )
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_dad01~iPad"]];
                }
                else
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_others01~iPad"]];
                }
            }
            else {
                if ( pObj.m_nType == 1  || pObj.m_nType == 0)
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_mom01"]];
                }
                else if ( pObj.m_nType == 2 )
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_dad01"]];
                }
                else
                {
                    [self.m_pBackgroundImage setImage:[UIImage imageNamed:@"home_other01"]];
                }
            }
        }
        
        
        [self retrieveUserProfle:nil];
    }
    else
    {
        [self showRegisterView];
    }
    
    [self.m_pMainScrollView setContentSize:self.m_pMainPageView.frame.size];
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

- ( void )dealloc
{
    [m_pRHRegisterVC release];
    [_m_pBtnMenu release];
    [_m_pNaviBar release];
    [_m_pLblTitle release];
    [_m_pSelfIconView release];
    [_m_pMainScrollView release];
    [_m_pMainPageView release];
    [_m_pBackgroundImage release];
    [_m_pLblCountDown release];
    [_m_pNextCheckDate release];
    [_m_pBtnWeek release];
    [super dealloc];
}


#pragma mark - Private Methods
- ( void )retrieveUserProfle:( NSNotification * )pNotification
{
    if (self.m_pMBProgressHUD == nil) {
        self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }

    [RHLesEnphantsAPI getUserProfile:nil Source:self];
}

- (void)updateUserProfle:( NSNotification * )pNotification
{
    // 如果是訪客就不要更新資料
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType == 0 )
    {
        return;
    }

    if (self.m_pMBProgressHUD == nil) {
        self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [RHLesEnphantsAPI getUserProfile:nil Source:self];
}

- ( void )updateBackgroundImg:( NSNotification * )pNotification
{
    NSString *pstr = [RHAppDelegate getHomeImg];
    [self.m_pBackgroundImage setImage:[UIImage imageNamed:pstr]];
}

- ( void )updateUserIcon:( NSNotification * )pNotification
{
    [self retrieveUserProfle:nil];
//    RHProfileObj *pObj = [RHProfileObj getProfile];
//    NSString *pstrURL = pObj.m_pstrPhotoURL;
//    
//    NSLog(@"pstrURL = %@", pstrURL);
//    
//    [self.m_pSelfIconView setBackgroundColor:[UIColor yellowColor]];
//    if ( [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
//    {
//        AsyncImageView *pAsyncView = ( AsyncImageView * )[self.m_pSelfIconView viewWithTag:1000];
//        if ( pAsyncView )
//        {
//            if ( pAsyncView.superview )
//            {
//                [pAsyncView removeFromSuperview];
//            }
//        }
//        
//        AsyncImageView *pImgAsynView = [[AsyncImageView alloc] initWithFrame:self.m_pSelfIconView.bounds];
//        [pImgAsynView setTag:1000];
//        [pImgAsynView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
//        [self.m_pSelfIconView addSubview:pImgAsynView];
//        [pImgAsynView loadImageFromURL:[NSURL URLWithString:pstrURL]];
//        
//        [Utilities setRoundCornor:pImgAsynView];
//    }

}

- ( void )showHightLight
{
    NSInteger nMax = 5;
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj.m_nType == 4 )
    {
        //親友的layout不同
        nMax = 3;
        
        UIButton *pView1 = ( UIButton * )[self.m_pMainPageView viewWithTag:2000];
        UIButton *pView2 = ( UIButton * )[self.m_pMainPageView viewWithTag:2001];
        UIButton *pView3 = ( UIButton * )[self.m_pMainPageView viewWithTag:2002];
        
        [pView1 setFrame:CGRectMake(130, 60, 60, 60)];
        [pView2 setFrame:CGRectMake(15, 175, 60, 60)];
        [pView3 setFrame:CGRectMake(240, 175, 60, 60)];
    }
    else
    {
        
    }
    
    //hide all
    for ( NSInteger i = 0; i < 5; ++i )
    {
        UIButton *pView = ( UIButton * )[self.m_pMainPageView viewWithTag:(2000+i)];
        NSArray *pSubViews = [pView subviews];
        
        for ( id oneView in pSubViews )
        {
            if ( [oneView isKindOfClass:[AsyncImageView class]] )
            {
                AsyncImageView *pAsy = ( AsyncImageView * )oneView;
                [pAsy removeFromSuperview];
            }
        }
        
        
        [pView setHidden:YES];
    }
    
    
    NSArray *pArray = [RHAppDelegate getHightData];
    
    NSInteger nCount = MIN(nMax, [pArray count]);
    
    NSInteger nIdx = 2000;
    
    for ( NSInteger i = 0; i < nCount; ++i )
    {
        UIButton *pView = ( UIButton * )[self.m_pMainPageView viewWithTag:(nIdx+i)];
        NSDictionary *pDic = [pArray objectAtIndex:i];
        NSString *pstrURL = [pDic objectForKey:@"photoUrl"];
        
        if ( [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            AsyncImageView *pAsy = [[AsyncImageView alloc] initWithFrame:pView.bounds];
            [pAsy setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [pView addSubview:pAsy];
            [pAsy loadImageFromURL:[NSURL URLWithString:pstrURL]];
            [pAsy release];
            [Utilities setRoundCornor2:pAsy];
        }
        else
        {
            
        }
        
        [pView setHidden:NO];
    }
    
}

- ( void )loadEvent
{
    if ( [RHAppDelegate getPHPSessionID] )
    {
        //先取得年月
        NSTimeInterval kStartTimeInterval = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval kEndTImeInterval = kStartTimeInterval + ( 60 * 24 * 60 * 60);    //取得兩個月以後的
        NSString *pstrSearchKey = [NSString stringWithFormat:@"[%.0f,%.0f]", kStartTimeInterval, kEndTImeInterval];
        NSLog(@"pstrSearchKey = %@", pstrSearchKey);
        
        
        
        //Load Event
        
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:@"1" forKey:kFilter];
        [pParameter setObject:pstrSearchKey forKey:kKeyWord];
        
        [RHLesEnphantsAPI getPregnantEvent:pParameter Source:self];
    }
}

#pragma mark - Public
- ( void )showRegisterView
{
    //clear subviews
    NSArray *pSubViews = [self.m_pSelfIconView subviews];
    
    for ( id oneView in pSubViews )
    {
        if ( [oneView isKindOfClass:[AsyncImageView class]] )
        {
            AsyncImageView *pAsyncImgView = ( AsyncImageView * )oneView;
            [pAsyncImgView removeFromSuperview];
        }
    }
    
     UIButton *pBtn = (UIButton*)[self.m_pMainPageView viewWithTag:10000];
    
    pSubViews = [pBtn subviews];
    
    for ( id oneView in pSubViews )
    {
        if ( [oneView isKindOfClass:[AsyncImageView class]] )
        {
            AsyncImageView *pAsyncImgView = ( AsyncImageView * )oneView;
            [pAsyncImgView removeFromSuperview];
        }
    }

    
    //進入註冊頁面
    RHRegisterVC *pVC = [[RHRegisterVC alloc] initWithNibName:@"RHRegisterVC" bundle:nil];
    self.m_pRHRegisterVC = pVC;
    [pVC release];
    [self.navigationController pushViewController:m_pRHRegisterVC animated:YES];
    
    //檢查是否為初次使用
    if ( [RHAppDelegate isFirstLaunch] )
    {
        //接著馬上顯示User Guide
        [[RHAppDelegate sharedDelegate] showUserGuide];
    }

}

#pragma mark - IBAction
- ( IBAction )pressLoginBtn:(id)sender
{
    RHLoginVC *pVC = [[RHLoginVC alloc] initWithNibName:@"RHLoginVC" bundle:nil];
    self.m_pRHLoginVC = pVC;
    [pVC release];
    
    [self presentViewController:m_pRHLoginVC animated:YES completion:nil];
}

- ( IBAction )pressRegisterBtn:(id)sender
{
    
}

- ( IBAction )pressSwithToPregnantMemoBtn:(id)sender
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType == 0 )
    {
        [RHAppDelegate showRegistHint];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOpenPregnantPage object:nil userInfo:nil];
}

- ( IBAction )pressResetBtn:(id)sender
{
    [RHAppDelegate resetEnvironment:YES];
}

- ( IBAction )pressForceToEmotionPage:(id)sender;
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType == 0 )
    {
        [RHAppDelegate showRegistHint];
        return;
    }
    
    RHMoodVC *pVC = [[RHMoodVC alloc] initWithNibName:@"RHMoodVC" bundle:nil];
    [self.navigationController pushViewController:[pVC autorelease] animated:YES];
}

- ( IBAction )pressForceToTodoListPage:(id)sender
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType == 0 )
    {
        [RHAppDelegate showRegistHint];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOpenTodolist object:nil userInfo:nil];
}

- ( IBAction )pressForceToChatPage:(id)sender
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType == 0 )
    {
        [RHAppDelegate showRegistHint];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOpenLinePage object:nil userInfo:nil];
}

- ( IBAction )pressChooseFreindsPage:(id)sender
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj.m_nType == 0 )
    {
        [RHAppDelegate showRegistHint];
        return;
    }
    
    
    if ( pObj.m_nType == 1 || pObj.m_nType == 4 )
    {
        RHChooseFriendsVC *pVC = [[RHChooseFriendsVC alloc] initWithNibName:@"RHChooseFriendsVC" bundle:nil];
        [self.navigationController pushViewController:[pVC autorelease] animated:YES];

    }
}

- ( IBAction )pressCountDownBtn:(id)sender
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType == 1 || pObj.m_nType == 4 )
    {
        RHMomViewerVC *pVC = [[RHMomViewerVC alloc] initWithNibName:@"RHMomViewerVC" bundle:nil];
        RHProfileObj *pObj = [RHAppDelegate sharedDelegate].m_pRHProfileObj;
        pVC.m_nWeek = pObj.m_nWeek;
        [self.navigationController pushViewController:[pVC autorelease] animated:YES];
        
    }
}

- ( IBAction )pressWeekBtn:(id)sender
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType == 1 || pObj.m_nType == 4 )
    {
        //RHImageViewerVC *pVC = [[RHImageViewerVC alloc] initWithNibName:@"RHImageViewerVC" bundle:nil];
        RHBabyViewerVC *pVC = [[RHBabyViewerVC alloc] initWithNibName:@"RHBabyViewerVC" bundle:nil];
        RHProfileObj *pObj = [RHAppDelegate sharedDelegate].m_pRHProfileObj;
        
        //home_w01@2x
        //NSString *pstrWeekImgName = nil;
        //if (pObj.m_nWeek+1 <= 40) {
        //    pstrWeekImgName = [NSString stringWithFormat:@"Baby-W%02d.png", (int)pObj.m_nWeek+1];
        //}
        //else {
        //    pstrWeekImgName = [NSString stringWithFormat:@"Baby-W40.png"];
        //}
        
        pVC.m_nWeek = pObj.m_nWeek;
        //[pVC setM_pstrImageName:pstrWeekImgName];
        [self.navigationController pushViewController:[pVC autorelease] animated:YES];
        
    }
}

- ( IBAction )pressNextBtn:(id)sender
{
    
}

- ( IBAction )pressMainIconBtn:(id)sender
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj.m_nType == 1 )
    {
        //個人設定
        [[RHAppDelegate sharedDelegate] showUserDetailSettingPage];
    }
    else if ( pObj.m_nType == 2 )
    {
        //同心熱線
        //[[NSNotificationCenter defaultCenter] postNotificationName:kOpenLinePage object:nil userInfo:nil];
        [[RHAppDelegate sharedDelegate] showUserDetailSettingPage];
    }
}

- ( IBAction )pressShareBtn:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        RHShareViewerVC *pVC = [[RHShareViewerVC alloc] initWithNibName:@"RHShareViewerVC~iPad" bundle:nil];
        [self.navigationController pushViewController:[pVC autorelease] animated:YES];
    }
    else {
        RHShareViewerVC *pVC = [[RHShareViewerVC alloc] initWithNibName:@"RHShareViewerVC" bundle:nil];
        [self.navigationController pushViewController:[pVC autorelease] animated:YES];
    }
}

#pragma mark - RHLesEnphantsAPIDelegate
- ( void )callBackGetUserProfileStatus:( NSDictionary * )pStatusDic
{
    NSLog(@"pStatusDic = %@", pStatusDic);
    
    NSString *pstrURL = @"";
    
    if ( pStatusDic )
    {
        NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
        
        if ( nStatus == 0 )
        {
            [[RHAppDelegate sharedDelegate] keepLoginProfile:[pStatusDic objectForKey:@"profile"]];
            
            pstrURL = [[pStatusDic objectForKey:@"profile"] objectForKey:@"photoUrl"];
            
            //判斷天數
            NSString *pstr = [[pStatusDic objectForKey:@"profile"] objectForKey:@"expectedDate"];
            
            if ( [pstr compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
            {
                NSDate *pExpectedDate = [Utilities getDateFromDateTimeString2:pstr];
                NSDate *pToday = [NSDate date];
                
                NSTimeInterval kExpected = [pExpectedDate timeIntervalSince1970];
                NSTimeInterval kToday = [pToday timeIntervalSince1970];
                
                CGFloat fDiff = kExpected - kToday;
                
                NSInteger nDay = ceilf( fDiff / 86400);
                // Value < 0 :Show Zero
                if (nDay < 0) {
                    nDay = 0;
                }
                [self.m_pLblCountDown setTitle:[NSString stringWithFormat:@"%ld", (long)nDay] forState:UIControlStateNormal];
                
                
                NSInteger nWeek = [[[pStatusDic objectForKey:@"profile"] objectForKey:@"week"] integerValue];
                
                //home_w01@2x
                NSString *pstrWeekImgName = nil;
                if (nWeek+1 <= 40) {
                    pstrWeekImgName = [NSString stringWithFormat:@"home_w%02d", (int)nWeek+1];
                }
                else {
                    pstrWeekImgName = [NSString stringWithFormat:@"home_w40+.png"];
                }

            
                [self.m_pBtnWeek setImage:[UIImage imageNamed:pstrWeekImgName] forState:UIControlStateNormal];
            }
            
            RHProfileObj *pObj = [RHProfileObj getProfile];
            
            if ( pObj.m_nType == 1 )
            {
                [self.m_pRelativedIconView setHidden:YES];
                if ( ![pstrURL compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
                {
                    AsyncImageView *pAsyncView = ( AsyncImageView * )[self.m_pSelfIconView viewWithTag:1000];
                    if ( pAsyncView )
                    {
                        if ( pAsyncView.superview )
                        {
                            [pAsyncView removeFromSuperview];
                        }
                    }
                    
                    AsyncImageView *pImgAsynView = [[AsyncImageView alloc] initWithFrame:self.m_pSelfIconView.bounds];
                    [pImgAsynView setTag:1000];
                    [pImgAsynView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
                    [pImgAsynView setBackgroundColor:[UIColor clearColor]];
                    [self.m_pSelfIconView addSubview:pImgAsynView];
                    [pImgAsynView loadImageFromURL:[NSURL URLWithString:pstrURL]];
                    
                    //[Utilities setRoundCornor:pImgAsynView];
                }
                
                
                //放準爸爸的ICON
                UIButton *pBtn = (UIButton*)[self.m_pMainPageView viewWithTag:10000];
                
                NSArray *pFriends = [[pStatusDic objectForKey:@"profile"] objectForKey:@"friends"];
                
                for ( NSInteger i = 0; i < [pFriends count]; ++i )
                {
                    NSDictionary *pDic = [pFriends objectAtIndex:i];
                    
                    NSInteger nType = [[pDic objectForKey:@"type"] integerValue];
                    
                    if ( nType == 2 )
                    {
                        NSString *pstrURL = [pDic objectForKey:@"photoUrl"];
                        
                        if ( [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
                        {
                            AsyncImageView *pAsy = [[AsyncImageView alloc] initWithFrame:pBtn.bounds];
                            [pAsy setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
                            [pAsy setBackgroundColor:[UIColor clearColor]];
                            [pBtn addSubview:pAsy];
                            [pAsy setUserInteractionEnabled:NO];
                            [pAsy loadImageFromURL:[NSURL URLWithString:pstrURL]];
                            [pAsy release];
                            
                           // [Utilities setRoundCornor2:pAsy];
                        }
                        else
                        {
                            
                        }
                    }
                }

            }
            else if ( pObj.m_nType == 2 )
            {
                [self.m_pRelativedIconView setHidden:YES];
                if ( ![pstrURL compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
                {
                    //爸爸自已的放旁邊
                    UIButton *pBtn = (UIButton*)[self.m_pMainPageView viewWithTag:10000];
                    
                    AsyncImageView *pImgAsynView = [[AsyncImageView alloc] initWithFrame:pBtn.bounds];
                    [pImgAsynView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
                    [pBtn addSubview:pImgAsynView];
                    [pImgAsynView setUserInteractionEnabled:NO];
                    [pImgAsynView setBackgroundColor:[UIColor clearColor]];
                    [pImgAsynView loadImageFromURL:[NSURL URLWithString:pstrURL]];
                    
                    //[Utilities setRoundCornor2:pImgAsynView];
                }
                
                
                
                NSArray *pFriends = [[pStatusDic objectForKey:@"profile"] objectForKey:@"friends"];
                
                for ( NSInteger i = 0; i < [pFriends count]; ++i )
                {
                    NSDictionary *pDic = [pFriends objectAtIndex:i];
                    
                    NSInteger nType = [[pDic objectForKey:@"type"] integerValue];
                    
                    if ( nType == 1 )
                    {
                        NSString *pstrURL = [pDic objectForKey:@"photoUrl"];
                        
                        if ( [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
                        {
                            AsyncImageView *pAsyncView = ( AsyncImageView * )[self.m_pSelfIconView viewWithTag:1000];
                            if ( pAsyncView )
                            {
                                if ( pAsyncView.superview )
                                {
                                    [pAsyncView removeFromSuperview];
                                }
                            }
                            
                            
                            AsyncImageView *pAsy = [[AsyncImageView alloc] initWithFrame:self.m_pSelfIconView.bounds];
                            [pAsy setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
                            [self.m_pSelfIconView addSubview:pAsy];
                            [pAsy setUserInteractionEnabled:NO];
                            [pAsy setBackgroundColor:[UIColor clearColor]];
                            [pAsy loadImageFromURL:[NSURL URLWithString:pstrURL]];
                            [pAsy release];
                            
                            //[Utilities setRoundCornor:pAsy];
                        }
                        else
                        {
                            
                        }
                    }
                }
            }
            else if ( pObj.m_nType == 4 )
            {
                //親友
                if ( ![pstrURL compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
                {
                    //爸爸自已的放旁邊
                    
                    AsyncImageView *pImgAsynView = [[AsyncImageView alloc] initWithFrame:self.m_pRelativedIconView.bounds];
                    [pImgAsynView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
                    [self.m_pRelativedIconView addSubview:pImgAsynView];
                    [pImgAsynView setUserInteractionEnabled:NO];
                    [pImgAsynView setBackgroundColor:[UIColor clearColor]];
                    [pImgAsynView loadImageFromURL:[NSURL URLWithString:pstrURL]];
                    
                    //[Utilities setRoundCornor2:pImgAsynView];
                }
            }

            
            
            
            
            
        }
        else
        {
            //Error
            [RHAppDelegate backgroundLogin];
            
             RHProfileObj *pObj = [RHProfileObj getProfile];
            pstrURL = pObj.m_pstrPhotoURL;
        }
    
        //Menu要出現時，就通知更新資料
        [[NSNotificationCenter defaultCenter] postNotificationName:kMenuViewReveal object:nil];
    }
    else
    {
        NSLog(@"Can't get User profile");
        [self.m_pMBProgressHUD hide:NO];
    }
    
    
    //Login XMPP
    [[RHAppDelegate sharedDelegate] connect];
    
    [self loadEvent];
    //[self.m_pMBProgressHUD hide:NO];
}

- ( void )callBackGetPregnantEventStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSArray *pArray = [pStatusDic objectForKey:@"event"];
        
        if ( [pArray count] == 0 )
        {
            [self.m_pNextCheckDate setTitle:NSLocalizedString(@"LE_MAIN_NEXTCNT", nil) forState:UIControlStateNormal];
        }
        else
        {
            NSDictionary *pDic = [pArray objectAtIndex:0];//取得第一筆
            
            NSString *pstrDate = [pDic objectForKey:@"date"];
            NSArray *pStringArray = [pstrDate componentsSeparatedByString:@"-"];
            
            if ( [pStringArray count] == 3 )
            {
                NSString *pstrNewDate = [NSString stringWithFormat:@"%@/%@",
                                         [pStringArray objectAtIndex:1],
                                         [pStringArray objectAtIndex:2]];
                
                [self.m_pNextCheckDate setTitle:pstrNewDate forState:UIControlStateNormal];
            }
            
        }
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [self.m_pMBProgressHUD hide:NO];
}


@end
