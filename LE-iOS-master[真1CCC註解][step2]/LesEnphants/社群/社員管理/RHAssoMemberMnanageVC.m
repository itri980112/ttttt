//
//  RHAssoMemberMnanageVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHAssoMemberMnanageVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAssoMemberMnanageCell.h"
#import "RHAssociationPostListVC.h"
#import "RHProfileObj.h"
#import "RHAssociationManageDetailVC.h"

@interface RHAssoMemberMnanageVC ()
{
    NSMutableArray          *m_pMemberArray;
    NSString                *m_pstrAssoID;
    NSMutableArray          *m_pManagerArray;
    NSMutableArray          *m_pPendingArray;
    
}

@property ( nonatomic, retain ) NSMutableArray          *m_pMemberArray;
@property ( nonatomic, retain ) NSMutableArray          *m_pManagerArray;
@property ( nonatomic, retain ) NSMutableArray          *m_pPendingArray;
@property ( nonatomic, retain ) NSString                *m_pstrAssoID;

@end

@implementation RHAssoMemberMnanageVC
@synthesize m_pMemberArray;
@synthesize m_pstrAssoID;
@synthesize m_pManagerArray;
@synthesize m_pPendingArray;
@synthesize m_pRHAssociationManageDetailVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pMemberArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pManagerArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pPendingArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pstrAssoID = nil;
        self.m_pRHAssociationManageDetailVC = nil;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_GROUP_MANAGEMEMBER_TITLE", nil)];
    [self.m_pBtn_1 setTitle:NSLocalizedString(@"LE_GROUP_MANAGEMEMBER_ALLMEMBER", nil)
                   forState:UIControlStateNormal];
    [self.m_pBtn_2 setTitle:NSLocalizedString(@"LE_GROUP_MANAGEMEMBER_NEWAPPLY", nil)
                   forState:UIControlStateNormal];
    
    [self pressBtn_1:nil];
    
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
    
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI getAssociationByID:m_pstrAssoID Source:self];
}


#pragma mark - Private Methods
- ( void )updateUI;
{
    if ( [self.m_pBtn_1 isSelected] )
    {
        [self.m_pBtn_1 setBackgroundColor:UIColorFromRGB(0XE57D7B)];
    }
    else
    {
        [self.m_pBtn_1 setBackgroundColor:[UIColor whiteColor]];
    }
    
    if ( [self.m_pBtn_2 isSelected] )
    {
        [self.m_pBtn_2 setBackgroundColor:UIColorFromRGB(0XE57D7B)];
    }
    else
    {
        [self.m_pBtn_2 setBackgroundColor:[UIColor whiteColor]];
    }
    
    [self.m_pMainTableView reloadData];
}

#pragma mark - Public
- ( void )setupAssoID:( NSString * )pstrID
{
    self.m_pstrAssoID = pstrID;
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressBtn_1:(id)sender
{
    if ( [self.m_pBtn_1 isSelected] )
    {
        return;
    }
    
    [self.m_pBtn_1 setSelected:YES];
    [self.m_pBtn_2 setSelected:NO];
    
    [self updateUI];
    
}
- ( IBAction )pressBtn_2:(id)sender
{
    if ( [self.m_pBtn_2 isSelected] )
    {
        return;
    }
    
    [self.m_pBtn_1 setSelected:NO];
    [self.m_pBtn_2 setSelected:YES];
    
    [self updateUI];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSUInteger nRow = [indexPath row];
    NSDictionary *pDic = nil;
    
    if ( [self.m_pBtn_1 isSelected] )
    {
        //find Grant and go next vc
        
        
        self.m_pRHAssociationManageDetailVC = [[RHAssociationManageDetailVC alloc] initWithNibName:@"RHAssociationManageDetailVC" bundle:nil];
        
        
        NSUInteger nRow = [indexPath row];
        NSDictionary *pDic = nil;
        
        if ( nRow < [m_pManagerArray count] )
        {
            pDic = [m_pManagerArray objectAtIndex:nRow];
            [m_pRHAssociationManageDetailVC setM_bIsGrant:YES];
        }
        else
        {
            //member
            NSInteger nShift = [m_pManagerArray count];
            pDic = [m_pMemberArray objectAtIndex:(nRow-nShift)];
            [m_pRHAssociationManageDetailVC setM_bIsGrant:NO];
        }
        
        
        [m_pRHAssociationManageDetailVC setM_pMainDic:pDic];
        [m_pRHAssociationManageDetailVC setM_pstrAssoID:m_pstrAssoID];
        [self.navigationController pushViewController:m_pRHAssociationManageDetailVC animated:YES];
        
        
    }
    else
    {
        //accept
        pDic = [m_pPendingArray objectAtIndex:nRow];
        
        if ( pDic )
        {
            [RHAppDelegate showLoadingHUD];
            NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
            [pParameter setObject:m_pstrAssoID forKey:kAssoID];
            [pParameter setObject:[pDic objectForKey:@"matchId"] forKey:kAssoMatchId];
            [RHLesEnphantsAPI acceptAssociationApply:pParameter Source:self];
        }  
    }
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = 0;
    
    if ( [self.m_pBtn_1 isSelected] )
    {
        //show member + manager
        nCount = [m_pMemberArray count] + [m_pManagerArray count];
    }
    else
    {
        //show pedding
        nCount = [m_pPendingArray count];
    }
    
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"RHAssoMemberMnanageCell";
    
    RHAssoMemberMnanageCell *cell = (RHAssoMemberMnanageCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"RHAssoMemberMnanageCell" owner:self options:nil];
        for(id currentObject in nibObjects)
        {
            if([currentObject isKindOfClass:[RHAssoMemberMnanageCell class]])
            {
                cell = currentObject;
                break;
            }
        }
    }
    
    // Configure the cell...
    
    NSUInteger nRow = [indexPath row];
    NSDictionary *pDic = nil;
    
    if ( [self.m_pBtn_1 isSelected] )
    {
        //先show manager
        
        if ( nRow < [m_pManagerArray count] )
        {
            pDic = [m_pManagerArray objectAtIndex:nRow];
            [cell setM_enumMemberType:MEMBER_TYPE_MANAGER];
            [cell setM_bHasGrant:YES];
        }
        else
        {
            //member
            NSInteger nShift = [m_pManagerArray count];
            pDic = [m_pMemberArray objectAtIndex:(nRow-nShift)];
            [cell setM_enumMemberType:MEMBER_TYPE_MEMBER];
            [cell setM_bHasGrant:NO];
        }
    
        
    }
    else
    {
        //show pedding
        pDic = [m_pPendingArray objectAtIndex:nRow];
        [cell setM_enumMemberType:MEMBER_TYPE_PEDDING];
    }

    
    [cell setM_pMainDic:pDic];
    [cell setM_nID:nRow];
    [cell updateUI];
    
    return cell;
}


#pragma mark - API
- ( void )callBackGetAssociationByClassStatus:( NSDictionary * )pStatusDic
{
//    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
//    
//    if ( nError == 0 )
//    {
//        NSArray *pArray = [pStatusDic objectForKey:@"data"];
//        //[self setupData:pArray];
//        self.m_pAssociationListArray = [NSMutableArray arrayWithArray:pArray];
//        [self.m_pAssociationListTable reloadData];
//    }
//    else
//    {
//        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
//        [RHAppDelegate MessageBox:pstrErrorMsg];
//    }
//    
//    [RHAppDelegate hideLoadingHUD];
    
}

- ( void )callBackGetAssociationByIdStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSDictionary *pDataDic = [pStatusDic objectForKey:@"data"];
        
        if ( pDataDic )
        {
            NSArray *pMemberArray = [pDataDic objectForKey:@"member"];
            NSArray *pPendingArray = [pDataDic objectForKey:@"pending"];
            NSArray *pManagerArray = [pDataDic objectForKey:@"manager"];
            
            if ( pMemberArray )
            {
                self.m_pMemberArray = [NSMutableArray arrayWithArray:pMemberArray];
            }
            
            if ( pPendingArray )
            {
                self.m_pPendingArray = [NSMutableArray arrayWithArray:pPendingArray];
            }
            
            if ( pManagerArray )
            {
                [self.m_pManagerArray removeAllObjects];
                //Msnager要過濾自已
                RHProfileObj *pObj = [RHProfileObj getProfile];
                
                for ( NSInteger i = 0; i < [pManagerArray count]; ++i )
                {
                    NSDictionary *pDic = [pManagerArray objectAtIndex:i];
                    NSString *pstrManagerMatchID = [pDic objectForKey:@"matchId"];
                    if ( [pObj.m_pstrMatchID compare:pstrManagerMatchID options:NSCaseInsensitiveSearch] == NSOrderedSame )
                    {
                        continue;
                    }
                    [self.m_pManagerArray addObject:pDic];
                }
                
            }
            
            [self updateUI];
        }
        
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];

}

- ( void )callBackAcceptAssociationStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        //get data again
        [RHLesEnphantsAPI getAssociationByID:m_pstrAssoID Source:self];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];

}

@end
