//
//  RHMenuVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/13.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHMenuVC.h"
#import "RHAppDelegate.h"
#import "Utilities.h"
#import "RHProfileObj.h"
#import "MBProgressHUD.h"
#import "AsyncImageView.h"
#import "MenuCell.h"
#import "RevealController.h"
#import "RHMainVC.h"
#import "RHPregnantMemoVC.h"
#import "RHNewsHomePageVC.h"
#import "RHKnowledgeHomePageVC.h"
#import "RHNewsListVC.h"
#import "RHWebViewVC.h"
#import "RHLineMainVC.h"
#import "RHGroupVC.h"
#import "RHPointCollection.h"


static NSString *g_pstrMenuTitleFa[7] = {@"LE_MENU_HOME",@"LE_MENU_CHAT",@"LE_MENU_PREG",
    @"LE_MENU_BOOK",@"LE_MENU_NEWS",@"LE_MENU_GROUP",
    @"LE_MENU_FB"};

static NSString *g_pstrMenuTitleMa[8] = {@"LE_MENU_HOME",@"LE_MENU_CHAT",@"LE_MENU_PREG",
    @"LE_MENU_BOOK",@"LE_MENU_NEWS",@"LE_MENU_GOLD",@"LE_MENU_GROUP",
    @"LE_MENU_FB"};

static NSString *g_pstrMenuTitleOther[6] = {@"LE_MENU_HOME",@"LE_MENU_CHAT",
    @"LE_MENU_BOOK",@"LE_MENU_NEWS",@"LE_MENU_GROUP",
    @"LE_MENU_FB"};



 static NSString *g_pstrMenuImageFa[7] = {@"sidemenu_home",@"sidemenu_同心熱線",@"sidemenu_懷孕記事",
 @"sidemenu_孕媽咪寶典",@"sidemenu_好康資訊",@"sidemenu_孕媽咪社群",
 @"sidemenu_facebook"};

static NSString *g_pstrMenuImageMa[8] = {@"sidemenu_home",@"sidemenu_同心熱線",@"sidemenu_懷孕記事",
    @"sidemenu_孕媽咪寶典",@"sidemenu_好康資訊",@"settings_icon01.png",@"sidemenu_孕媽咪社群",
    @"sidemenu_facebook"};

 
 static NSString *g_pstrMenuImageOther[6] = {@"sidemenu_home",@"sidemenu_同心熱線",
 @"sidemenu_孕媽咪寶典",@"sidemenu_好康資訊",@"sidemenu_孕媽咪社群",
 @"sidemenu_facebook"};
 
/*
static NSString *g_pstrMenuTitle[6] = {@"首頁",@"同心熱線",@"懷孕記事",
    @"孕媽咪寶典",@"好康資訊",
    @"麗嬰房 媽咪同學會粉絲團"};

static NSString *g_pstrMenuTitleOther[5] = {@"首頁",@"同心熱線",
    @"孕媽咪寶典",@"好康資訊",
    @"麗嬰房 媽咪同學會粉絲團"};

static NSString *g_pstrMenuImage[6] = {@"sidemenu_home",@"sidemenu_同心熱線",@"sidemenu_懷孕記事",
    @"sidemenu_孕媽咪寶典",@"sidemenu_好康資訊",
    @"sidemenu_facebook"};

static NSString *g_pstrMenuImageOther[5] = {@"sidemenu_home",@"sidemenu_同心熱線",
    @"sidemenu_孕媽咪寶典",@"sidemenu_好康資訊",
    @"sidemenu_facebook"};

 */
 
@interface RHMenuVC () < UITableViewDataSource, UITableViewDelegate >
{
    RHProfileObj *m_pObj;
}

@property ( nonatomic, retain ) RHProfileObj *m_pObj;

- ( void )updateUserData:( NSNotification * )pNotification;
- ( void )openPregnantView:( NSNotification * )pNotification;
- ( void )openLineView:( NSNotification * )pNotification;
- ( void )openTodoView:( NSNotification * )pNotification;
- ( void )openKnowledgeView:( NSNotification * )pNotification;
- ( void )openNewsView:( NSNotification * )pNotification;
- ( void )openFBView:( NSNotification * )pNotification;
@end

@implementation RHMenuVC
@synthesize m_pMBProgressHUD;
@synthesize m_pRHPregnantMemoVC;
@synthesize m_pRHNewsHomePageVC;
@synthesize m_pRHKnowledgeHomePageVC;
@synthesize m_pObj;
@synthesize m_pRHMainVC;
@synthesize m_pRHGroupVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pRHPregnantMemoVC = nil;
        self.m_pRHNewsHomePageVC = nil;
        self.m_pRHKnowledgeHomePageVC = nil;
        self.m_pObj = nil;
        self.m_pRHMainVC = nil;
        self.m_pRHGroupVC = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGestureTouchedNickame:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.m_pLblNickname addGestureRecognizer:tapGestureRecognizer];
    self.m_pLblNickname.userInteractionEnabled = YES;

    
    [Utilities setRoundCornor:self.m_pIconImgView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserData:) name:kMenuViewReveal object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPregnantView:) name:kOpenPregnantPage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openLineView:) name:kOpenLinePage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openTodoView:) name:kOpenTodolist object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKnowledgeView:) name:kOpenKnowledgePage object:nil];
    
    NSLog(@"self.view = %@", NSStringFromCGRect(self.view.frame));

    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj.m_nType == 2 )
    {
        [self.m_pBtnSetting setImage:[UIImage imageNamed:@"sidemenu_profile_dad.png"] forState:UIControlStateNormal];
    }
    
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

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear in RHMenuVC");
    
    //update icon
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj )
    {
        
        NSString *pstrURL = pObj.m_pstrPhotoURL;
        
        if ( [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            AsyncImageView *pAsyncImg = [[[AsyncImageView alloc] initWithFrame:self.m_pIconImgView.bounds] autorelease];
            [self.m_pIconImgView addSubview:pAsyncImg];
            [pAsyncImg setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [pAsyncImg loadImageFromURL:[NSURL URLWithString:pObj.m_pstrPhotoURL]];
        }
        else
        {
            if ( pObj.m_nType == 1 )
            {
                [self.m_pIconImgView setImage:[UIImage imageNamed:@"default_mom"]];
            }
            else if ( pObj .m_nType == 2 )
            {
                [self.m_pIconImgView setImage:[UIImage imageNamed:@"default_dad"]];
            }
            else if ( pObj.m_nType == 0 )
            {
                [self.m_pIconImgView setImage:[UIImage imageNamed:@"default_mom"]];
            }
            else
            {
                [self.m_pIconImgView setImage:[UIImage imageNamed:@"default_others"]];
            }
        }
    }
}

- (void)dealloc
{
    [_m_pIconImgView release];
    [_m_pLblNickname release];
    [_m_pLblPregnantLabel release];
    [_m_pMenuTable release];
    [m_pRHPregnantMemoVC release];
    [m_pRHNewsHomePageVC release];
    [m_pRHKnowledgeHomePageVC release];
    [_m_pBtnSetting release];
    [super dealloc];
}

#pragma mark - Private Methods

- (void)onTapGestureTouchedNickame:(UITapGestureRecognizer *)gesture {
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    // 訪客進行註冊
    if ( pObj.m_nType == 0 )
    {
        RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    
        if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RHMainVC class]])
        {
            
            if ( m_pRHMainVC == nil )
            {
                RHMainVC *frontViewController = nil;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    frontViewController = [[RHMainVC alloc] initWithNibName:@"RHMainVC" bundle:nil];
                }
                else
                {
                    frontViewController = [[RHMainVC alloc] initWithNibName:@"RHMainVC~iPad" bundle:nil];
                }
                
                self.m_pRHMainVC = frontViewController;
                [frontViewController release];
            }
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:m_pRHMainVC];
            [revealController setFrontViewController:navigationController animated:NO];
        }
        // Seems the user attempts to 'switch' to exactly the same controller he came from!
        else
        {
            [revealController revealToggle:self];
        }
        
        [RHAppDelegate showRegistHint];
    }
}

- ( void )updateUserData:( NSNotification * )pNotification
{
    //Load Photo
    RHProfileObj *pObj = [RHProfileObj getProfile];
    self.m_pObj = pObj;
    
    [self.m_pLblNickname setText:pObj.m_pstrNickName];
    
    if ( [pObj.m_pstrExpectedDate compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame)
    {
        [self.m_pLblPregnantLabel setText:[NSString stringWithFormat:NSLocalizedString(@"LE_MENU_PREGDATE", nil), pObj.m_pstrExpectedDate]];
    }
    else
    {
        [self.m_pLblPregnantLabel setText:@""];
    }
    
    
    if ( pObj.m_nType == 0 )
    {
        //訪客
        [self.m_pLblNickname setText:@"註冊"];
    }
    else if ( pObj.m_nType == 4 )
    {
        //親友
        [self.m_pLblPregnantLabel setHidden:YES];
    }
    
    if ( pObj )
    {
        
        NSString *pstrURL = pObj.m_pstrPhotoURL;
        
        if ( [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            AsyncImageView *pAsyncImg = [[[AsyncImageView alloc] initWithFrame:self.m_pIconImgView.bounds] autorelease];
            [self.m_pIconImgView addSubview:pAsyncImg];
            [pAsyncImg setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [pAsyncImg loadImageFromURL:[NSURL URLWithString:pObj.m_pstrPhotoURL]];
        }
    }

    
    
    [self.m_pMenuTable reloadData];
}

- ( void )openPregnantView:( NSNotification * )pNotification
{
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    //CCC:沒有連續點選懷孕記事
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RHPregnantMemoVC class]])
    {
        RHPregnantMemoVC *frontViewController = nil;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            frontViewController = [[RHPregnantMemoVC alloc] initWithNibName:@"RHPregnantMemoVC~iPad" bundle:nil];
        }
        else {
            frontViewController = [[RHPregnantMemoVC alloc] initWithNibName:@"RHPregnantMemoVC" bundle:nil];
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        [revealController setFrontViewController:navigationController animated:NO];
        [frontViewController release];//CCC do
        [navigationController release];//CCC do
        if ( pNotification )
        {
            [revealController revealToggle:self];
        }
    }
    else
    {
        [revealController revealToggle:self];
    }
}

- ( void )openLineView:( NSNotification * )pNotification
{
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RHLineMainVC class]])
    {
        RHLineMainVC *frontViewController = [[RHLineMainVC alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        [revealController setFrontViewController:navigationController animated:NO];
        
        if ( pNotification )
        {
            [revealController revealToggle:self];
        }
    }
    else
    {
        [revealController revealToggle:self];
    }

}

- ( void )openTodoView:( NSNotification * )pNotification
{
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RHLineMainVC class]])
    {
        RHLineMainVC *frontViewController = [[RHLineMainVC alloc] init];
        frontViewController.m_bForeceToTodoList = YES;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        [revealController setFrontViewController:navigationController animated:NO];
        
        if ( pNotification )
        {
            [revealController revealToggle:self];
        }
    }
    else
    {
        [revealController revealToggle:self];
    }
}

- ( void )openKnowledgeView:( NSNotification * )pNotification
{
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RHKnowledgeHomePageVC class]])
    {
        RHKnowledgeHomePageVC *frontViewController = [[RHKnowledgeHomePageVC alloc] init];

        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        [revealController setFrontViewController:navigationController animated:NO];
        
        if ( pNotification )
        {
            [revealController revealToggle:self];
        }
    }
    else
    {
        [revealController revealToggle:self];
    }
}

- ( void )openNewsView:( NSNotification * )pNotification
{
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RHNewsHomePageVC class]])
    {
        RHNewsHomePageVC *frontViewController = [[RHNewsHomePageVC alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        [revealController setFrontViewController:navigationController animated:NO];
        [frontViewController release];//CCC do
        [revealController release];//CCC do
    }
    else
    {
        [revealController revealToggle:self];
    }
}

- ( void )openFBView:( NSNotification * )pNotification
{
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;

    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RHWebViewVC class]])
    {
        RHWebViewVC *frontViewController = [[RHWebViewVC alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        NSString *pstrURL = @"https://www.facebook.com/phland.fans?ref=ts&fref=ts";
        [frontViewController setM_pstrURL:pstrURL];
        [revealController setFrontViewController:navigationController animated:NO];
        [frontViewController release];//CCC do
        [revealController release];//CCC do
        
    }
    else
    {
        [revealController revealToggle:self];
    }
}

- ( void )openSocialView:( NSNotification * )pNotification
{
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RHGroupVC class]])
    {

        RHGroupVC *frontViewController = [[RHGroupVC alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        [revealController setFrontViewController:navigationController animated:NO];
    }
    else
    {
        [revealController revealToggle:self];
    }
}

- ( void )openPointView:( NSNotification * )pNotification
{
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RHPointCollection class]])
    {
        
        RHPointCollection *frontViewController = [[RHPointCollection alloc] init];
        frontViewController.m_bIsPresent = YES;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        [revealController setFrontViewController:navigationController animated:NO];
    }
    else
    {
        [revealController revealToggle:self];
    }
}

#pragma mark - Customized Method



#pragma mark - IBAction
- ( IBAction )pressSettingBtn:(id)sender
{
    [[RHAppDelegate sharedDelegate] showUserDetailSettingPage];
}


#pragma mark - UITableView
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = sizeof(g_pstrMenuTitleFa) / sizeof(g_pstrMenuTitleFa[0]);
    
    if ( m_pObj.m_nType == 1 )
    {
        nCount = sizeof(g_pstrMenuTitleMa) / sizeof(g_pstrMenuTitleMa[0]);
    }
    

    if (m_pObj.m_nType == 4 )
    {
        nCount = sizeof(g_pstrMenuTitleOther) / sizeof(g_pstrMenuTitleOther[0]);
    }
    
    
    NSLog(@"nCount = %d", nCount);
    
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MenuCellIdentifier = @"MenuCellIdentifier";
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuCellIdentifier];
    if (cell == nil)
    {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *pArray =  [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
        
        for ( id oneView in pArray )
        {
            if ( [oneView isKindOfClass:[MenuCell class]] )
            {
                cell = oneView;
            }
        }
    }
    
    // Configure the cell...
    
    NSUInteger nRow = [indexPath row];
    
    
    if (m_pObj.m_nType == 4 )
    {
        [cell.m_pLblContent setText:NSLocalizedString(g_pstrMenuTitleOther[nRow], nil)];
        [cell.m_pIconImageView setImage:[UIImage imageNamed:g_pstrMenuImageOther[nRow]]];
    }
    else if (m_pObj.m_nType == 1 )
    {
        [cell.m_pLblContent setText:NSLocalizedString(g_pstrMenuTitleMa[nRow], nil)];
        [cell.m_pIconImageView setImage:[UIImage imageNamed:g_pstrMenuImageMa[nRow]]];
    }
    else
    {
        [cell.m_pLblContent setText:NSLocalizedString(g_pstrMenuTitleFa[nRow], nil)];
        [cell.m_pIconImageView setImage:[UIImage imageNamed:g_pstrMenuImageFa[nRow]]];
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
	RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    NSInteger nRow = [indexPath row];

    switch ( nRow)
    {
        case 0:
        {
            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RHMainVC class]])
            {
                
                if ( m_pRHMainVC == nil )
                {
                    RHMainVC *frontViewController = nil;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        frontViewController = [[RHMainVC alloc] initWithNibName:@"RHMainVC" bundle:nil];
                    }
                    else
                    {
                        frontViewController = [[RHMainVC alloc] initWithNibName:@"RHMainVC~iPad" bundle:nil];
                    }

                    self.m_pRHMainVC = frontViewController;
                    [frontViewController release];
                }
                
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:m_pRHMainVC];
                [revealController setFrontViewController:navigationController animated:NO];
                [navigationController release];//CCC do
                
            }
            // Seems the user attempts to 'switch' to exactly the same controller he came from!
            else
            {
                [revealController revealToggle:self];
            }
            
        }
            break;
        case 1:
        {
            if ( m_pObj.m_nType == 0 )
            {
                [revealController revealToggle:self];
                [RHAppDelegate showRegistHint];
                return;
            }
            
            
            if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[RHLineMainVC class]])
            {
                RHLineMainVC *frontViewController = [[RHLineMainVC alloc] init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                [revealController setFrontViewController:navigationController animated:NO];

                
            }
            else
            {
                [revealController revealToggle:self];
            }
            
        }
            break;
        case 2:
        {
            
            if (m_pObj.m_nType == 4 )
            {
                [self openKnowledgeView:nil];
            }
            else
            {
                if ( m_pObj.m_nType == 0 )
                {
                    [revealController revealToggle:self];
                    [RHAppDelegate showRegistHint];
                    return;
                }
                
                [self openPregnantView:nil];
            }
            
            
        }
            break;
        case 3:
        {
            if (m_pObj.m_nType == 4 )
            {
                [self openNewsView:nil];
            }
            else
            {
                [self openKnowledgeView:nil];
            }
            
        }
            break;
        case 4:
        {
            if (m_pObj.m_nType == 4 )
            {
                [self openSocialView:nil];
                //[self openFBView:nil];
            }
            else
            {
                [self openNewsView:nil];
            }
            
        }
            break;
        case 5:
        {
            if (m_pObj.m_nType == 4 )
            {
                [self openFBView:nil];

            }
            else if (m_pObj.m_nType == 1 )
            {
                //Open 好孕邦金幣
                //[[RHAppDelegate sharedDelegate] showPointCollectionSettingPage];
                [self openPointView:nil];

            }
            else
            {
                
                //Open Social
                [self openSocialView:nil];

            }
        }
            break;
        case 6:
        {
            if (m_pObj.m_nType == 4 )
            {
                
            }
            else if (m_pObj.m_nType == 1 )
            {
                //Open Social
                [self openSocialView:nil];
            }
            else
            {
                [self openFBView:nil];
            }
        }
            break;
        case 7:
        {
            [self openFBView:nil];
        }
            break;
    }
}

@end
