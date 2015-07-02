//
//  RHKnowledgeHomePageVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/24.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHKnowledgeHomePageVC.h"
#import "RevealController.h"
#import "RHKnowledgeAdvancedSearhVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"
#import "RHKnowledgeListVC.h"
#import "RHKnowledgeCell.h"


@interface RHKnowledgeHomePageVC () < RHLesEnphantsAPIDelegate, RHKnowledgeAdvancedSearhVCDelegate >
{
    NSInteger       m_nSelIdx;
    NSString        *m_pstrNextPageTitle;
}

- ( void )showSearchMenuView;

@end

@implementation RHKnowledgeHomePageVC
@synthesize m_pDataArray;
@synthesize m_pRHKnowledgeAdvancedSearhVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pRHKnowledgeAdvancedSearhVC = nil;
        self.m_pDataArray = [NSMutableArray arrayWithCapacity:1];
        m_nSelIdx = 0;
        m_pstrNextPageTitle = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_KNOWLEDGE_TITLE", nil)];
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.m_pNaviBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    [navigationBarPanGestureRecognizer release];//CCC try
	NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    [self.m_pBtnMenu addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [RHAppDelegate showLoadingHUD];
    
    //Load api
    
    [RHLesEnphantsAPI getKnowledgeList:nil Source:self];
    
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
    [_m_pNaviBar release];
    [_m_pBtnMenu release];
    [m_pRHKnowledgeAdvancedSearhVC release];
    [m_pDataArray release];
    [_m_pMainTable release];
    [super dealloc];
}


#pragma mark - Private Methods


- ( void )showSearchMenuView
{
    RHKnowledgeAdvancedSearhVC   *pVC = [[RHKnowledgeAdvancedSearhVC alloc] initWithNibName:@"RHKnowledgeAdvancedSearhVC" bundle:nil];
    self.m_pRHKnowledgeAdvancedSearhVC = pVC;
    [m_pRHKnowledgeAdvancedSearhVC setDelegate:self];
    [pVC release];
    
    [self.navigationController pushViewController:m_pRHKnowledgeAdvancedSearhVC animated:YES];
}



#pragma mark - Customized Methods


#pragma mark - IBAction
- ( IBAction )pressAdvancedBtn:(id)sender
{
    [self showSearchMenuView];
}



#pragma mark - RHLesEnphantsAPIDelegate
- ( void )callBackGetKnowledgeListStatus:( NSDictionary * )pStatusDic
{
    //{"error":0,"data":[{"id":"2","subject":"\u5abd\u5abd\u6559\u5ba4"},{"id":"1","subject":"\u5b55\u5abd\u54aa\u7368\u4eab"},{"id":"4","subject":"\u653f\u5e9c\u6cd5\u898f\u8207\u8f14\u52a9"},{"id":"3","subject":"\u7279\u8ce3\u8cc7\u8a0a"}]}
    
    NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nStatus == 0 )
    {
        if ( m_pDataArray )
        {
            [m_pDataArray removeAllObjects];
            
            NSArray *pArray = [pStatusDic objectForKey:@"data"];
            
            for ( id obj in pArray )
            {
                [m_pDataArray addObject:obj];
                
            }
            
            [self.m_pMainTable reloadData];
            [RHAppDelegate hideLoadingHUD];
        }
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatus]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
}

- ( void )callBackGetKnowledgeContentStatus:( NSDictionary * )pStatusDic
{
    //進到下一頁
    
    NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nStatus == 0 )
    {
        NSArray *pData = [pStatusDic objectForKey:@"data"];
        
        RHKnowledgeListVC *pList = [[[RHKnowledgeListVC alloc] initWithNibName:@"RHKnowledgeListVC" bundle:nil] autorelease];
        
        NSDictionary *pDic = [m_pDataArray objectAtIndex:m_nSelIdx];
        [pList setM_pstrTitle:m_pstrNextPageTitle];
        [pList setM_pDataArray:pData];
        [self.navigationController pushViewController:pList animated:YES];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatus]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [RHAppDelegate showLoadingHUD];
    
    NSInteger  nSection = [indexPath section];
    
    NSDictionary *pGroupDic = [m_pDataArray objectAtIndex:nSection];
    m_pstrNextPageTitle = [pGroupDic objectForKey:@"subject"];
    NSArray *m_pSubArray = [pGroupDic objectForKey:@"subKC"];
    NSUInteger nRow = [indexPath row];
    
    NSDictionary *pDic = [m_pSubArray objectAtIndex:nRow];
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:@"0" forKey:kFilter];
    [pParameter setObject:[pDic objectForKey:@"id"] forKey:kKeyWord];
    
    [RHLesEnphantsAPI getKnowledgeContent:pParameter Source:self];
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *pDic = [m_pDataArray objectAtIndex:section];
    UIView *pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    [pView setBackgroundColor:UIColorFromRGB(0x56BBE2)];
    
    NSString *pstrColor = [pDic objectForKey:@"color"];
    
    pstrColor = [pstrColor stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    
    unsigned int hexValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:pstrColor];
    [scanner setScanLocation:0]; // depends on your exact string format you may have to use location 1
    [scanner scanHexInt:&hexValue];
    
    
    UILabel *pLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    [pLbl setFont:[UIFont systemFontOfSize:20]];
    [pLbl setText:[pDic objectForKey:@"subject"]];
    [pLbl setTextColor:UIColorFromRGB(hexValue)];
    [pLbl setBackgroundColor:[UIColor clearColor]];
    [pLbl setTextAlignment:NSTextAlignmentCenter];
    
    [pView addSubview:pLbl];
    [pLbl release];
    
    return [pView autorelease];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger nCount = [m_pDataArray count];
    NSLog(@"nCount = %d", nCount);
    return nCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = [[[m_pDataArray objectAtIndex:section] objectForKey:@"subKC"] count];
    NSLog(@"nCount = %d", nCount);
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RHKnowledgeCellIdentifier = @"RHKnowledgeCellIdentifier";
    
    RHKnowledgeCell *cell = [tableView dequeueReusableCellWithIdentifier:RHKnowledgeCellIdentifier];
    if (cell == nil)
    {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *pArray =  [[NSBundle mainBundle] loadNibNamed:@"RHKnowledgeCell" owner:self options:nil];
        
        for ( id oneView in pArray )
        {
            if ( [oneView isKindOfClass:[RHKnowledgeCell class]] )
            {
                cell = oneView;
            }
        }
    }
    
    
    NSInteger  nSection = [indexPath section];
    
    NSDictionary *pGroupDic = [m_pDataArray objectAtIndex:nSection];
    NSArray *m_pSubArray = [pGroupDic objectForKey:@"subKC"];
    NSUInteger nRow = [indexPath row];
    
    NSDictionary *pDic = [m_pSubArray objectAtIndex:nRow];

    [cell setupData:pDic];
    [cell updateUI];
    
    return cell;
    
}

#pragma mark - RHKnowledgeAdvancedSearhVCDelegate <NSObject>

- ( void )callBackSearchFilter:( NSString * )pstrJSON Filter:( NSInteger )nFilter
{
    [RHAppDelegate showLoadingHUD];
    
    //Load api
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:[NSString stringWithFormat:@"%ld",(long)nFilter] forKey:kFilter];
    [pParameter setObject:pstrJSON forKey:kKeyWord];
    m_pstrNextPageTitle = @"進階查詢";
    [RHLesEnphantsAPI getKnowledgeContent:pParameter Source:self];

}


@end
