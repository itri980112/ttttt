//
//  RHAssociationListVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHAssociationListVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAssociationListCell.h"
#import "RHAssociationPostListVC.h"
#import "RHProfileObj.h"


@interface RHAssociationListVC ()
{
    NSMutableArray         *m_pAssociationListArray;
    BOOL                    m_bOffLine;
    
}

@property ( nonatomic, retain ) NSMutableArray          *m_pAssociationListArray;


@end

@implementation RHAssociationListVC
@synthesize m_pAssociationListArray;
@synthesize m_pstrTitle;
@synthesize m_nIdx;
@synthesize m_pRHAssociationPostListVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pAssociationListArray = [NSMutableArray arrayWithCapacity:1];
        m_nIdx = 0;
        self.m_pstrTitle = @"";
        self.m_pRHAssociationPostListVC = nil;
        m_bOffLine = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:m_pstrTitle];
    
    
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
    
    if ( m_bOffLine == YES )
    {
        [self.m_pAssociationListTable reloadData];
        return;
    }
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:[NSString stringWithFormat:@"%d", m_nIdx] forKey:kAssoListClass];
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI getAssociationListByClass:pParameter Source:self];
}


#pragma mark - Private Methods

#pragma mark - Public
- ( void )setupData:( NSArray * )pDataArray
{
    if ( pDataArray )
    {
        m_bOffLine = YES;
        self.m_pAssociationListArray = [NSMutableArray arrayWithArray:pDataArray];
    }
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSUInteger nRow = [indexPath row];
    
    NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nRow];
    
    self.m_pRHAssociationPostListVC = [[RHAssociationPostListVC alloc] initWithNibName:@"RHAssociationPostListVC" bundle:nil];
    [m_pRHAssociationPostListVC setM_pConfigDic:pDic];
    
    
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
    return [m_pAssociationListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"RHAssociationListCell";
    
    RHAssociationListCell *cell = (RHAssociationListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"RHAssociationListCell" owner:self options:nil];
        for(id currentObject in nibObjects)
        {
            if([currentObject isKindOfClass:[RHAssociationListCell class]])
            {
                cell = currentObject;
                break;
            }
        }
    }
    
    // Configure the cell...
    
    NSUInteger nRow = [indexPath row];
    
    NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nRow];
    
    [cell setM_pMainDic:pDic];
    [cell setM_nID:m_nIdx];
    [cell updateUI];
    
    return cell;
}


#pragma mark - API
- ( void )callBackGetAssociationByClassStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSArray *pArray = [pStatusDic objectForKey:@"data"];
        //[self setupData:pArray];
        self.m_pAssociationListArray = [NSMutableArray arrayWithArray:pArray];
        [self.m_pAssociationListTable reloadData];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
    
}

@end
