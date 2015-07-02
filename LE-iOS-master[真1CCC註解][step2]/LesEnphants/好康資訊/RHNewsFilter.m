//
//  RHNewsFilter.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/24.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHNewsFilter.h"
#import "RHLesEnphantsAPI.h"
#import "MBProgressHUD.h"
#import "RHAppDelegate.h"
#import "RHNewsContentVC.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
@interface RHNewsFilter () < RHLesEnphantsAPIDelegate >

@end

#pragma mark - Life Cycle

@implementation RHNewsFilter
@synthesize m_pstrTitle;
@synthesize m_nType;
@synthesize m_pMBProgressHUD;
@synthesize m_pDataArray;
@synthesize m_pstrID;

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
        self.m_pstrID = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [self.m_pLblTitle setText:m_pstrTitle];
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:@"0" forKey:kFilter];
    [pParameter setObject:m_pstrID forKey:kKeyWord];
    
    
    [RHLesEnphantsAPI getNewsContent:pParameter Source:self];

    
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
- ( void )callBackGetNewsContentStatus:( NSDictionary * )pStatusDic
{
    //{"error":0,"data":[{"id":7,"subject":"\u6a19\u984c2-3","content":"<h1>\u5167\u5bb9<\/h1>\r\n<font color=\"blue\">\u85cd\u8272\u5b57....<\/font>","updatedon":1408078322},{"id":5,"subject":"\u6a19\u984c2-1","content":"<h1>\u5167\u5bb9<\/h1>\r\n<font color=\"blue\">\u85cd\u8272\u5b57....<\/font>","updatedon":1408078306},{"id":6,"subject":"\u6a19\u984c2-2","content":"<h1>\u5167\u5bb9<\/h1>\r\n<font color=\"blue\">\u85cd\u8272\u5b57....<\/font>","updatedon":1408078306}]}

    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger nRow = [indexPath row];
    
    NSDictionary *pDic = [m_pDataArray objectAtIndex:nRow];
    
    RHNewsContentVC *pVC = [[[RHNewsContentVC alloc] initWithNibName:@"RHNewsContentVC" bundle:nil] autorelease];
    
    [pVC setM_pContentData:pDic];
    
    [self.navigationController pushViewController:pVC animated:YES];
 
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = [m_pDataArray count];
    NSLog(@"nCount = %d", nCount);
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    
    NSUInteger nRow = [indexPath row];

    NSDictionary *pDic = [m_pDataArray objectAtIndex:nRow];
    
    [cell.textLabel setText:[pDic objectForKey:@"subject"]];
    
    return cell;
    
}


@end
