//
//  RHAssociationInfoVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHAssociationInfoVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAssociationListCell.h"
#import "RHCreateAssociationPurposeVC.h"
#import "RHAssociationDefinition.h"
#import "RHAssoMemberMnanageVC.h"
#import "RHProfileObj.h"


@interface RHAssociationInfoVC ()
{
    NSString    *m_pstrPurpose;
    NSInteger   m_nSelClassify;
    BOOL        m_bIsMember;
}

@property ( nonatomic, retain ) NSString    *m_pstrPurpose;

@end

@implementation RHAssociationInfoVC
@synthesize m_pRHCreateAssociationPurposeVC;
@synthesize m_pOldMetaDataDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pRHCreateAssociationPurposeVC = nil;
        self.m_pstrPurpose = @"";
        m_nSelClassify = 0;
        m_bIsMember = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.m_pLblTitle setText:NSLocalizedString(@"LE_GROUP_INFO_TITLE", nil)];
    [self.m_pLblStarTitle setText:NSLocalizedString(@"LE_GROUP_INFO_STARTSET", nil)];
    [self.m_pLblMemberCountTitle setText:NSLocalizedString(@"LE_GROUP_INFO_COUNT", nil)];
    [self.m_pLblPostCountTitle setText:NSLocalizedString(@"LE_GROUP_INFO_ARTICLECOUNT", nil)];
    [self.m_pLblAreaTitle setText:NSLocalizedString(@"LE_GROUP_INFO_AREA", nil)];
    [self.m_pLblPurposeTitle setText:NSLocalizedString(@"LE_GROUP_INFO_PURPOSE", nil)];
    [self.m_pLblReportTItle setText:NSLocalizedString(@"LE_GROUP_INFO_REPORT", nil)];
    
    
    if ( m_pOldMetaDataDic )
    {
        NSString *pstrStarChina = [NSString stringWithFormat:@"%@,%@",
                                   [m_pOldMetaDataDic objectForKey:@"signStar"], [m_pOldMetaDataDic objectForKey:@"signChina"]];
        [self.m_pBtnStar setTitle:pstrStarChina forState:UIControlStateNormal];
        [self.m_pBtnStar setUserInteractionEnabled:NO];
        
        self.m_pstrPurpose = [m_pOldMetaDataDic objectForKey:@"purpose"];
        m_nSelClassify = [[m_pOldMetaDataDic objectForKey:@"class"] integerValue];
        
        NSString *pstrMemberCount = [NSString stringWithFormat:@"%d 人", [[m_pOldMetaDataDic objectForKey:@"memberCount"] integerValue]];
        NSString *pstrPostCount = [NSString stringWithFormat:@"%d 則", [[m_pOldMetaDataDic objectForKey:@"postsCount"] integerValue]];
        
        [self.m_pLblMemberCount setText:pstrMemberCount];
        [self.m_pLblPostCount setText:pstrPostCount];
        [self.m_pLblArea setText:[NSString stringWithFormat:@"%@", [m_pOldMetaDataDic objectForKey:@"city"]]];
        
        //判斷自已是否為Member
        RHProfileObj *pObj = [RHProfileObj getProfile];
        
        NSArray *pMemberArray = [m_pOldMetaDataDic objectForKey:@"member"];
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
        
        if ( bIsMember )
        {
            //退團，刪團
            [self.m_pJoinView setHidden:NO];
            [self.m_pReportView setHidden:NO];

        }
        else
        {
            //Join
            [self.m_pJoinView setHidden:NO];
            [self.m_pReportView setHidden:YES];
            [self.m_pLblJoinText setText:@"加入社團"];
            [self.m_pJoinIcon setImage:[UIImage imageNamed:@"加入社團"]];
        }
        
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
}


#pragma mark - Private Methods
- ( void )updateUI
{

}

#pragma mark - Public

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- ( IBAction )pressPromoteBtn:(id)sender
{
    
}
- ( IBAction )pressFunBtn1:(id)sender
{
    self.m_pRHCreateAssociationPurposeVC = [[RHCreateAssociationPurposeVC alloc] initWithNibName:@"RHCreateAssociationPurposeVC" bundle:nil];
    //[m_pRHCreateAssociationPurposeVC setDelegate:self];
    [m_pRHCreateAssociationPurposeVC setM_pstrPurpose:self.m_pstrPurpose];
    [m_pRHCreateAssociationPurposeVC setM_nSelClass:m_nSelClassify-1];
    [m_pRHCreateAssociationPurposeVC setM_bReadOnly:YES];
    [self.navigationController pushViewController:m_pRHCreateAssociationPurposeVC animated:YES];
}

- ( IBAction )pressFunBtn2:(id)sender
{
    if (m_bIsMember )
    {
        //退團
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:[m_pOldMetaDataDic objectForKey:@"id"] forKey:kAssoID];
        [RHAppDelegate showLoadingHUD];
        [RHLesEnphantsAPI leaveAssociation:pParameter Source:self];

    }
    else
    {
        //入團
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:[m_pOldMetaDataDic objectForKey:@"id"] forKey:kAssoID];
        [RHAppDelegate showLoadingHUD];
        [RHLesEnphantsAPI joinAssociation:pParameter Source:self];
    }
}

- ( IBAction )pressReportBtn:(id)sender
{
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:[m_pOldMetaDataDic objectForKey:@"id"] forKey:kAssoID];
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI reportAssociation:pParameter Source:self];

}

#pragma mark - API
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


- ( void )callBackReportAssociationPostStatus:( NSDictionary * )pStatusDic
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
@end
