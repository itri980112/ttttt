//
//  RHNewsListVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/24.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHNewsListVC.h"
#import "RHLesEnphantsAPI.h"
#import "MBProgressHUD.h"
#import "RHAppDelegate.h"
#import "RHNewsContentVC.h"
#import "RHNewsFilter.h"
#import "AsyncImageView.h"

@interface RHNewsListVC () < RHLesEnphantsAPIDelegate >

@end

#pragma mark - Life Cycle

@implementation RHNewsListVC
@synthesize m_pstrTitle;
@synthesize m_nType;
@synthesize m_pMBProgressHUD;
@synthesize m_pDataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pstrTitle = @"";
        m_nType = -1;
        self.m_pMBProgressHUD = nil;
        self.m_pDataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    
//    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
//    [self.m_pNaviBar addGestureRecognizer:navigationBarPanGestureRecognizer];
//      [navigationBarPanGestureRecognizer release];//CCC try
//    
//    [self.m_pBtnMenu addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    
    [self.m_pLblTitle setText:m_pstrTitle];
//    
//    self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [RHLesEnphantsAPI getNewsList:nil Source:self];
    
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
    self.navigationController.navigationBarHidden = YES;
}

- ( void )dealloc
{
    [m_pstrTitle release];
    [_m_pLblTitle release];
    [m_pDataArray release];
    [_m_pMainTableView release];
    [super dealloc];
}

#pragma mark - Private Methods


#pragma mark - Customized Methods


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - RHLesEnphantsAPIDelegate
- ( void )callBackGetNewsListStatus:( NSDictionary * )pStatusDic
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
            
            [self.m_pMainTableView reloadData];
            [self.m_pMBProgressHUD hide:YES];
        }
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatus]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSInteger nRow = [indexPath row];
//    
//    NSDictionary *pDic = [m_pDataArray objectAtIndex:nRow];
//    
//    RHNewsFilter *pVC = [[[RHNewsFilter alloc] initWithNibName:@"RHNewsFilter" bundle:nil] autorelease];
//    
//    [pVC setM_pstrID:[pDic objectForKey:@"id"]];
//    [pVC setM_pstrTitle:[pDic objectForKey:@"subject"]];
//    
//    [self.navigationController pushViewController:pVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger nRow = [indexPath row];
    NSInteger nSection = [indexPath section];
    NSDictionary *pDic = [m_pDataArray objectAtIndex:nSection];
    NSArray *pSubArray = [pDic objectForKey:@"SubNews"];
    NSDictionary *pSubDic = [pSubArray objectAtIndex:nRow];
    
    RHNewsContentVC *pVC = [[[RHNewsContentVC alloc] initWithNibName:@"RHNewsContentVC" bundle:nil] autorelease];
    
    [pVC setM_pContentData:pSubDic];
    
    [self.navigationController pushViewController:pVC animated:YES];
 
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
    NSDictionary *pDic = [m_pDataArray objectAtIndex:section];
    NSArray *pSubArray = [pDic objectForKey:@"SubNews"];
    
    NSInteger nCount = [pSubArray count];
    NSLog(@"nCount = %d", nCount);
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil)
//    {
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
    
    
    
    NSUInteger nRow = [indexPath row];
    NSUInteger nSection = [indexPath section];
    
    
    NSDictionary *pDic = [m_pDataArray objectAtIndex:nSection];
    NSArray *pSubArray = [pDic objectForKey:@"SubNews"];
    NSDictionary *pSubDic = [pSubArray objectAtIndex:nRow];
    
    
    [cell.textLabel setText:[pSubDic objectForKey:@"subject"]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSString *pstrColor = [pSubDic objectForKey:@"color"];
    
    pstrColor = [pstrColor stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    
    unsigned int hexValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:pstrColor];
    [scanner setScanLocation:0]; // depends on your exact string format you may have to use location 1
    [scanner scanHexInt:&hexValue];
    
    [cell setBackgroundColor:UIColorFromRGB(hexValue)];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSString *pstrIconUrl = [pSubDic objectForKey:@"iconUrl"];
    if ( [pstrIconUrl compare:@""] != NSOrderedSame )
    {
        pstrIconUrl = [pstrIconUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        UIImageView *pImgView = cell.imageView;
//        //[pImgView setBackgroundColor:[UIColor redColor]];
//        [pImgView setImage:[UIImage imageNamed:@"Icon-120.png"]];
        AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [pAsync setBackgroundColor:[UIColor clearColor]];
        [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
        [cell addSubview: pAsync];
        [pAsync loadImageFromURL:[NSURL URLWithString:pstrIconUrl]];
        
    }
    
    
    
    return cell;
    
}


@end
