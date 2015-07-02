//
//  RHMyAssociationVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHMyAssociationVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAssociationListCell.h"
#import "RHCreateAssociationVC.h"
#import "RHAssociationPostListVC.h"
#import "RHProfileObj.h"
@interface RHMyAssociationVC ()
{
    NSMutableArray         *m_pCreatedArray;
    NSMutableArray         *m_pJoinedArray;
    
}

@property ( nonatomic, retain ) NSMutableArray          *m_pCreatedArray;
@property ( nonatomic, retain ) NSMutableArray          *m_pJoinedArray;


- ( void )updateUI;

@end

@implementation RHMyAssociationVC
@synthesize m_pCreatedArray;
@synthesize m_pJoinedArray;
@synthesize m_pRHCreateAssociationVC;
@synthesize m_pRHAssociationPostListVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pCreatedArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pJoinedArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pRHCreateAssociationVC = nil;
        self.m_pRHAssociationPostListVC = nil;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_GROUP_MYASSO_TITLE", nil)];
    [self.m_pLblMine setText:NSLocalizedString(@"LE_GROUP_MYASSO_MINE", nil)];
    [self.m_pLblJoin setText:NSLocalizedString(@"LE_GROUP_MYASSO_JOIN", nil)];
    
}



- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI getMyAssociation:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Methods
- ( void )updateUI
{
    CGRect kRectCreated = self.m_pCreatedView.frame;
    CGRect kRectJoined = self.m_pJoinedView.frame;
    
    kRectCreated.origin.y = 0;
    NSInteger nTableViewHeightCreate = [m_pCreatedArray count] * 50;
    nTableViewHeightCreate = MAX(nTableViewHeightCreate, 200);
    kRectCreated.size.height = 8 + 44 + nTableViewHeightCreate;
    
    
    [self.m_pCreatedView setFrame:kRectCreated];
    
    kRectJoined.origin.y = kRectCreated.origin.y + kRectCreated.size.height;
    NSInteger nTableViewHeightJoin = [m_pJoinedArray count] * 50;
    nTableViewHeightJoin = MAX(nTableViewHeightJoin, 200);
    kRectJoined.size.height = 8 + 44 + nTableViewHeightJoin;
    
    [self.m_pJoinedView setFrame:kRectJoined];
    
    NSInteger nTotalHeight = kRectCreated.size.height + kRectJoined.size.height;
    
    [self.m_pMainScrollView setContentSize:CGSizeMake(300, nTotalHeight)];

    [self.m_pJoinedTable reloadData];
    [self.m_pCreatedTable reloadData];
}




#pragma mark - Public
- ( void )setupData:( NSArray * )pCreatedArray Join:( NSArray * )pJoinedArray
{
    if ( pCreatedArray )
    {
        self.m_pCreatedArray = [NSMutableArray arrayWithArray:pCreatedArray];
    }
    else
    {
        self.m_pCreatedArray = [NSMutableArray arrayWithCapacity:1];
    }
    
    if ( pJoinedArray )
    {
        self.m_pJoinedArray = [NSMutableArray arrayWithArray:pJoinedArray];
    }
    else
    {
        self.m_pJoinedArray = [NSMutableArray arrayWithCapacity:1];
    }
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressAddBtn:(id)sender
{
    self.m_pRHCreateAssociationVC = [[RHCreateAssociationVC alloc] initWithNibName:@"RHCreateAssociationVC" bundle:nil];
    [self.navigationController pushViewController:m_pRHCreateAssociationVC animated:YES];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSUInteger nRow = [indexPath row];
    NSDictionary *pDic = nil;
    
    //BOOL bIsManager = NO;
    if ( [tableView tag] == 0 )
    {
        //社長身份
        pDic = [m_pCreatedArray objectAtIndex:nRow];
        //bIsManager = YES;
    }
    else
    {
        //社員身份
        pDic = [m_pJoinedArray objectAtIndex:nRow];
        //bIsManager = NO;
    }
    
    self.m_pRHAssociationPostListVC = [[RHAssociationPostListVC alloc] initWithNibName:@"RHAssociationPostListVC" bundle:nil];
    [m_pRHAssociationPostListVC setM_pConfigDic:pDic];
    //[m_pRHAssociationPostListVC setM_bIsManager:bIsManager];
    
    //判斷Creator
    NSDictionary *pCreatorDic = [pDic objectForKey:@"creator"];
    NSString *pstrmatchId = [pCreatorDic objectForKey:@"matchId"];
    BOOL bIsCreator = NO;
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( [pstrmatchId compare:pObj.m_pstrMatchID options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        bIsCreator = YES;
    }
    
    NSArray *pManagerArray = [pDic objectForKey:@"manager"];
    
    BOOL bIsManager = NO;
    for ( NSInteger i = 0 ; i < [pManagerArray count]; ++i )
    {
        NSDictionary *pDic = [pManagerArray objectAtIndex:i];
        NSString *pstrManagermatchId = [pDic objectForKey:@"matchId"];
        
        if ( [pstrManagermatchId compare:pObj.m_pstrMatchID options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            bIsManager = YES;
        }
    }
    
    
    
    [m_pRHAssociationPostListVC setM_bIsManager:(bIsManager|bIsCreator)];

    
    [self.navigationController pushViewController:m_pRHAssociationPostListVC animated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = 0;
    if ( [tableView tag] == 0 )
    {
        nCount = [m_pCreatedArray count];
    }
    else
    {
        nCount = [m_pJoinedArray count];
    }
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    // Configure the cell...
    
    NSUInteger nRow = [indexPath row];
    NSDictionary *pDic = nil;
    
    
    if ( [tableView tag] == 0 )
    {
        pDic = [m_pCreatedArray objectAtIndex:nRow];
    }
    else
    {
        pDic = [m_pJoinedArray objectAtIndex:nRow];
    }
    
    [cell.textLabel setText:[pDic objectForKey:@"name"]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    
    return cell;
}




#pragma mark - API
- ( void )callBackGetMyAssociationListStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [self setupData:[pStatusDic objectForKey:@"created"] Join:[pStatusDic objectForKey:@"joined"]];
        [self updateUI];

    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}




@end
