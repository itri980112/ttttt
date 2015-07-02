//
//  RHAssociationListVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHAssociationPostListVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAssociationListCell.h"
#import "RHGroupVC.h"
#import "AsyncImageView.h"
#import "RHAssociationAddPostVC.h"
#import "RHAssociationDefinition.h"
#import "RHEditAssociationVC.h"
#import "RHAssociationPostCntCell.h"
#import "RHAssociationPostCntCell2.h"
#import "RHAssociationInfoVC.h"
#import "RHAssociationPostDetailVC.h"
#import "RHProfileObj.h"
#import "RHAlertView.h"

@interface RHAssociationPostListVC () < RHAssociationPostCntCellDelegate >
{
    NSMutableArray         *m_pAssociationListArray;
    
}

@property ( nonatomic, retain ) NSMutableArray          *m_pAssociationListArray;


@end

@implementation RHAssociationPostListVC
@synthesize m_pAssociationListArray;
@synthesize m_pstrTitle;
@synthesize m_nIdx;
@synthesize m_pConfigDic;
@synthesize m_bIsManager;
@synthesize m_pRHAssociationAddPostVC;
@synthesize m_pRHEditAssociationVC;
@synthesize m_pRHAssociationInfoVC;
@synthesize m_pRHAssociationPostDetailVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pAssociationListArray = [NSMutableArray arrayWithCapacity:1];
        m_nIdx = 0;
        self.m_pstrTitle = @"";
        self.m_pConfigDic = nil;
        m_bIsManager = NO;
        self.m_pRHAssociationAddPostVC = nil;
        self.m_pRHEditAssociationVC = nil;
        self.m_pRHAssociationInfoVC = nil;
        self.m_pRHAssociationPostDetailVC = nil;
        m_bIsMember = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.m_pBtnNew setTitle:NSLocalizedString(@"LE_GROUP_NEWARTICLE_ADDNEW", nil) forState:UIControlStateNormal];
    if ( m_pConfigDic )
    {
        //初始化
        [self.m_pLblTitle setText:[m_pConfigDic objectForKey:@"name"]];
        [self.m_pLblClassName setText:[m_pConfigDic objectForKey:@"name"]];
        NSInteger nClass = [[m_pConfigDic objectForKey:@"class"] integerValue];
        
        NSString *pstrIconImgPath = [m_pConfigDic objectForKey:@"classIconUrl"];
        pstrIconImgPath = [pstrIconImgPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        AsyncImageView *pAsyncIcon = [[AsyncImageView alloc] initWithFrame:self.m_pClassImage.bounds];
        [pAsyncIcon setBackgroundColor:[UIColor clearColor]];
        [pAsyncIcon setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
        
        if ( pstrIconImgPath && [pstrIconImgPath compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            [self.m_pClassImage addSubview:pAsyncIcon];
            [pAsyncIcon loadImageFromURL:[NSURL URLWithString:pstrIconImgPath]];
        }
        
        
        
        AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pCoverImage.bounds];
        [pAsync setAutoresizingMask:self.m_pCoverImage.autoresizingMask];
        [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
        NSString *pstrURL = [m_pConfigDic objectForKey:@"imageUrl"];
        
        if ( pstrURL && [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            [self.m_pCoverImage addSubview:pAsync];
            [pAsync loadImageFromURL:[NSURL URLWithString:pstrURL]];
        }
        
    }
    
    
    if ( m_bIsManager )
    {
        NSLog(@"社長");
        [self.m_pBtnJoin setHidden:YES];
    }
    
    
    //判斷自已是否為Member
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    NSArray *pMemberArray = [m_pConfigDic objectForKey:@"member"];
    BOOL bIsMember = NO;
    
    for ( NSInteger i = 0; i < [pMemberArray count]; ++i )
    {
        NSDictionary *pDic = [pMemberArray objectAtIndex:i];
        NSString *pstrMatchId = [pDic objectForKey:@"matchId"];
        
        if ( [pObj.m_pstrMatchID compare:pstrMatchId options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            bIsMember = YES;
            break;
        }
    }

    m_bIsMember = bIsMember;
    
    if ( m_bIsMember )
    {
        [self.m_pBtnJoin setImage:[UIImage imageNamed:@"退出社團"] forState:UIControlStateNormal];
    }
    else
    {
        //加入社團
        [self.m_pBtnJoin setImage:[UIImage imageNamed:@"加入社團"] forState:UIControlStateNormal];
    }
    
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
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:[m_pConfigDic objectForKey:@"id"] forKey:kAssoID];
    [RHLesEnphantsAPI getAssociationPost:pParameter Source:self];
}


#pragma mark - Private Methods

#pragma mark - Public
- ( void )setupData:( NSArray * )pDataArray
{
    if ( pDataArray )
    {
        self.m_pAssociationListArray = [NSMutableArray arrayWithArray:pDataArray];
    }
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressNewPostBtn:(id)sender
{
    if ( m_bIsMember == NO && m_bIsManager == NO )
    {
        [RHAppDelegate MessageBox:@"請先申請加入社團"];
        return;
    }
    
    self.m_pRHAssociationAddPostVC = [[RHAssociationAddPostVC alloc] initWithNibName:@"RHAssociationAddPostVC" bundle:nil];
    
    [m_pRHAssociationAddPostVC setupAssoID:[m_pConfigDic objectForKey:@"id"]];

    [self.navigationController pushViewController:m_pRHAssociationAddPostVC animated:YES];
}
- ( IBAction )pressConfigBtn:(id)sender
{
    if ( m_bIsManager )
    {
        //維護我的社團
        self.m_pRHEditAssociationVC = [[RHEditAssociationVC alloc] initWithNibName:@"RHEditAssociationVC" bundle:nil];
        [m_pRHEditAssociationVC setM_pOldMetaDataDic:m_pConfigDic];
        
        [self.navigationController pushViewController:m_pRHEditAssociationVC animated:YES];
    }
    else
    {
        //社團資訊
        self.m_pRHAssociationInfoVC = [[RHAssociationInfoVC alloc] initWithNibName:@"RHAssociationInfoVC" bundle:nil];
        [m_pRHAssociationInfoVC setM_pOldMetaDataDic:m_pConfigDic];
        [self.navigationController pushViewController:m_pRHAssociationInfoVC animated:YES];
    }
}

- ( IBAction )pressJoinBtn:(id)sender
{
    if (m_bIsMember )
    {
        //退團
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:[m_pConfigDic objectForKey:@"id"] forKey:kAssoID];
        [RHAppDelegate showLoadingHUD];
        [RHLesEnphantsAPI leaveAssociation:pParameter Source:self];
        
    }
    else
    {
        //入團
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:[m_pConfigDic objectForKey:@"id"] forKey:kAssoID];
        [RHAppDelegate showLoadingHUD];
        [RHLesEnphantsAPI joinAssociation:pParameter Source:self];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSUInteger nRow = [indexPath row];
//    
//    NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nRow];

    
    NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nRow];
    
    NSString *loadNibNamed = @"RHAssociationPostDetailVC";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        loadNibNamed = @"RHAssociationPostDetailVC~Pad";
    }
    self.m_pRHAssociationPostDetailVC = [[RHAssociationPostDetailVC alloc] initWithNibName:loadNibNamed bundle:nil];
    
    [m_pRHAssociationPostDetailVC setupDataDic:pDic];
    [m_pRHAssociationPostDetailVC setM_pstrAssoID:[m_pConfigDic objectForKey:@"id"]];
    [m_pRHAssociationPostDetailVC setM_bCanEdit:m_bIsManager];
    [self.navigationController pushViewController:m_pRHAssociationPostDetailVC animated:YES];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nHeight = 0;
    
    NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:[indexPath row]];
    
    if ( pDic )
    {
        NSString *pstrImageUrl = [pDic objectForKey:@"imageUrl"];
        
        if ( pstrImageUrl && [pstrImageUrl compare:@""] != NSOrderedSame )
        {
            nHeight = 380;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                nHeight = 570;
            }
        }
        else
        {
            nHeight = 180;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                nHeight = 270;
            }
        }

    }
    
    
    
    return nHeight;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_pAssociationListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:[indexPath row]];
    
    if ( pDic )
    {
        NSString *pstrImageUrl = [pDic objectForKey:@"imageUrl"];
        
        if ( pstrImageUrl && [pstrImageUrl compare:@""] != NSOrderedSame )
        {
            NSString *CellIdentifier = @"RHAssociationPostCntCellIdentifier2";
            
            RHAssociationPostCntCell2 *cell = (RHAssociationPostCntCell2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSString *loadNibNamed = @"RHAssociationPostCntCell2";
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    loadNibNamed = @"RHAssociationPostCntCell2~Pad";
                }
                
                NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:loadNibNamed owner:self options:nil];
                for(id currentObject in nibObjects)
                {
                    if([currentObject isKindOfClass:[RHAssociationPostCntCell2 class]])
                    {
                        cell = currentObject;
                        break;
                    }
                }
            }
            
            NSUInteger nRow = [indexPath row];
            NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nRow];
            [cell setM_pMainDic:pDic];
            [cell setTag:nRow];
            [cell setDelegate:self];
            
            BOOL bIsCreator = NO;
            
            //NSLog(@"pDic = %@", pDic);
            NSString *pstrCreatorMatchID = [[pDic objectForKey:@"creator"] objectForKey:@"matchId"];
            RHProfileObj *pObj = [RHProfileObj getProfile];
            
            if ( [pstrCreatorMatchID compare:pObj.m_pstrMatchID] == NSOrderedSame )
            {
                bIsCreator = YES;
            }
            
            if ( m_bIsManager )
            {
                [cell setM_bCanEdit:YES];
            }
            else if ( bIsCreator )
            {
                [cell setM_bCanEdit:YES];
            }
            else
            {
                [cell setM_bCanEdit:NO];
            }
            
            
            [cell updateUI];
            
            return cell;

        }
        else
        {
            NSString *CellIdentifier = @"RHAssociationPostCntCellIdentifier";
            
            RHAssociationPostCntCell *cell = (RHAssociationPostCntCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSString *loadNibNamed = @"RHAssociationPostCntCell";
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    loadNibNamed = @"RHAssociationPostCntCell~Pad";
                }

                NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:loadNibNamed owner:self options:nil];
                for(id currentObject in nibObjects)
                {
                    if([currentObject isKindOfClass:[RHAssociationPostCntCell class]])
                    {
                        cell = currentObject;
                        break;
                    }
                }
            }
            
            NSUInteger nRow = [indexPath row];
            NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nRow];
            [cell setM_pMainDic:pDic];
            [cell setTag:nRow];
            [cell setDelegate:self];
            [cell setM_bCanEdit:m_bIsManager];
            [cell updateUI];
            
            return cell;

        }
        
    }
    
    
    return nil;
}


#pragma mark - API
- ( void )callBackGetAssociationPostStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [m_pAssociationListArray removeAllObjects];
        NSArray *pArray = [pStatusDic objectForKey:@"data"];
        //self.m_pAssociationListArray = [NSMutableArray arrayWithArray:pArray];
        
        for ( NSInteger i = 0 ; i < [pArray count]; ++i )
        {
            [m_pAssociationListArray insertObject:[pArray objectAtIndex:i] atIndex:0];
        }
        
        
        [self.m_pAssociationListTable reloadData];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackDeleteAssociationPostStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:[m_pConfigDic objectForKey:@"id"] forKey:kAssoID];
        [RHLesEnphantsAPI getAssociationPost:pParameter Source:self];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];

}

- ( void )callBackLikeAssociationPostStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:[m_pConfigDic objectForKey:@"id"] forKey:kAssoID];
        [RHLesEnphantsAPI getAssociationPost:pParameter Source:self];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackReportAssociationPostStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:[m_pConfigDic objectForKey:@"id"] forKey:kAssoID];
        [RHLesEnphantsAPI getAssociationPost:pParameter Source:self];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackJoinAssociationPostStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackLeaveAssociationPostStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}


#pragma mark - RHAssociationPostCntCellDelegate
- ( void )callBackLike:( NSInteger )nIdx
{
    NSLog(@"callBackLike : %d", nIdx);
    
    NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nIdx];
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:[m_pConfigDic objectForKey:@"id"] forKey:kAssoID];
    [pParameter setObject:[pDic objectForKey:@"id"] forKey:kAssoPostID];
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI likeAssociationPost:pParameter Source:self];

}

- ( void )callBackComment:( NSInteger )nIdx
{
    NSLog(@"callBackComment : %d", nIdx);
    
    if ( m_bIsMember == NO && m_bIsManager == NO )
    {
        [RHAppDelegate MessageBox:@"請先申請加入社團"];
        return;
    }
    
    
    NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nIdx];
    
    NSString *loadNibNamed = @"RHAssociationPostDetailVC";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        loadNibNamed = @"RHAssociationPostDetailVC~Pad";
    }
    
    self.m_pRHAssociationPostDetailVC = [[RHAssociationPostDetailVC alloc] initWithNibName:loadNibNamed bundle:nil];
    
    [m_pRHAssociationPostDetailVC setupDataDic:pDic];
    [m_pRHAssociationPostDetailVC setM_pstrAssoID:[m_pConfigDic objectForKey:@"id"]];
    [m_pRHAssociationPostDetailVC setM_bCanEdit:m_bIsManager];
    [self.navigationController pushViewController:m_pRHAssociationPostDetailVC animated:YES];
    
}

- ( void )callBackDelete:( NSInteger )nIdx
{

    RHAlertView *alert = [[RHAlertView alloc]initWithTitle:@""
                                                   message:@"刪除此文章？"
                                                  delegate:nil
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"刪除",nil];
    [alert showWithCallback:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if ( buttonIndex == 1 )
         {
             NSLog(@"callBackDelete : %d", nIdx);
             
             NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nIdx];
             
             NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
             [pParameter setObject:[m_pConfigDic objectForKey:@"id"] forKey:kAssoID];
             [pParameter setObject:[pDic objectForKey:@"id"] forKey:kAssoPostID];
             [RHAppDelegate showLoadingHUD];
             [RHLesEnphantsAPI deleteAssociationPost:pParameter Source:self];
             
         }
         else
         {
             
         }
         
     }];
 
    
}

- ( void )callBackReport:( NSInteger )nIdx
{
    NSLog(@"callBackReport : %d", nIdx);
    NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nIdx];
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:[m_pConfigDic objectForKey:@"id"] forKey:kAssoID];
    [pParameter setObject:[pDic objectForKey:@"id"] forKey:kAssoPostID];
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI reportAssociation:pParameter Source:self];
}

@end
