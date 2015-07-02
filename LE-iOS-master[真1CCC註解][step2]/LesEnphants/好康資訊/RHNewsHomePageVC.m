//
//  RHNewsHomePageVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/24.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHNewsHomePageVC.h"
#import "RHNewsListVC.h"
#import "RevealController.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "RHCntWebView.h"
#import "RHAppListVC.h"
#import "RHStoreListVC.h"
#import "RHMomRoomListVC.h"
#import "RHGovInfoListVC.h"


@interface RHNewsHomePageVC ()
{
    NSInteger       m_nType;
}

- ( void )switchToContentWithType:( NSInteger )nType;

@end

@implementation RHNewsHomePageVC
@synthesize m_pRHNewsListVC;

#pragma mark - Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pRHNewsListVC = nil;
        m_nType = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_NEWS_TITLE", nil)];
    [self.m_pLbl1 setText:NSLocalizedString(@"LE_NEWS_B1", nil)];
    [self.m_pLbl2 setText:NSLocalizedString(@"LE_NEWS_B2", nil)];
    [self.m_pLbl3 setText:NSLocalizedString(@"LE_NEWS_B3", nil)];
    [self.m_pLbl4 setText:NSLocalizedString(@"LE_NEWS_B4", nil)];
    [self.m_pLbl5 setText:NSLocalizedString(@"LE_NEWS_B5", nil)];
    [self.m_pLbl6 setText:NSLocalizedString(@"LE_NEWS_B6", nil)];
    
    
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.m_pNaviBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    [navigationBarPanGestureRecognizer release];//CCC try
	NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    
    [self.m_pBtnMenu addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.m_pMainScrollView setContentSize:CGSizeMake(320, 504)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- ( void )dealloc
{
    [m_pRHNewsListVC release];
    [_m_pNaviBar release];
    [_m_pBtnMenu release];
    [_m_pMainScrollView release];
    [super dealloc];
}

#pragma mark - Private Methods
- ( void )switchToContentWithType:( NSInteger )nType
{
    [RHLesEnphantsAPI getNewsContent:nil Source:self CntType:nType];
}
#pragma mark - Customized Methods


#pragma mark - IBAction
- ( IBAction )pressBtn:(id)sender
{
    NSInteger nTag = [( UIButton * )sender tag];
    m_nType = nTag;
    
    
    [RHAppDelegate showLoadingHUD];
    [self switchToContentWithType:nTag];
}


#pragma mark - RHLesEnphantsAPIDelegate
- ( void )callBackGetNewsContentStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        switch ( m_nType )
        {
            case 0:
            {
                NSArray *pData = [pStatusDic objectForKey:@"data"];
                
                RHNewsListVC *pVC = [[RHNewsListVC alloc] initWithNibName:@"RHNewsListVC" bundle:nil];
                [pVC setM_pstrTitle:NSLocalizedString(@"LE_NEWS_B1", nil)];
                [pVC setM_pDataArray:pData];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
                
                break;
            }

            case 2:
            {
                NSArray *pData = [pStatusDic objectForKey:@"data"];
                
                RHNewsListVC *pVC = [[RHNewsListVC alloc] initWithNibName:@"RHNewsListVC" bundle:nil];
                [pVC setM_pstrTitle:NSLocalizedString(@"LE_NEWS_B2", nil)];
                [pVC setM_pDataArray:pData];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];

                break;
            }
            case 1:
            {
                /*
                 // case 1 & 3
                RHCntWebView *pVC = [[RHCntWebView alloc] initWithNibName:@"RHCntWebView" bundle:nil];
                NSString *pstrURL = [pStatusDic objectForKey:@"url"];
                [pVC setM_pstrURL:pstrURL];
                [pVC setM_pstrTitle:[pStatusDic objectForKey:@"subject"]];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
                 */
                
                NSArray *pData = [pStatusDic objectForKey:@"data"];
                
                RHMomRoomListVC *pVC = [[RHMomRoomListVC alloc] initWithNibName:@"RHMomRoomListVC" bundle:nil];
                [pVC setupData:pData];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
                break;
            case 3:
            {
                NSArray *pData = [pStatusDic objectForKey:@"data"];
                
                RHGovInfoListVC *pVC = [[RHGovInfoListVC alloc] initWithNibName:@"RHGovInfoListVC" bundle:nil];
                [pVC setupData:pData];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
                break;
            case 4:
            {
                NSArray *pData = [pStatusDic objectForKey:@"data"];

                RHStoreListVC *pVC = [[RHStoreListVC alloc] initWithNibName:@"RHStoreListVC" bundle:nil];
                [pVC setupData:pData];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
                break;
            case 5:
            {
                NSArray *pData = [pStatusDic objectForKey:@"data"];
                
                RHAppListVC *pVC = [[RHAppListVC alloc] initWithNibName:@"RHAppListVC" bundle:nil];
                [pVC setupData:pData];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
                break;
                
                
            default:
                break;
        }

    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    
    
    
    
    
    [RHAppDelegate hideLoadingHUD];
}



@end
