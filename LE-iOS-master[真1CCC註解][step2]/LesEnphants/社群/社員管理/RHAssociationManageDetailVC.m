//
//  RHAssociationInfoVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHAssociationManageDetailVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAssociationListCell.h"
#import "RHCreateAssociationPurposeVC.h"
#import "RHAssociationDefinition.h"
#import "RHAssoMemberMnanageVC.h"
#import "RHProfileObj.h"
#import "AsyncImageView.h"
#import "RHAlertView.h"

@interface RHAssociationManageDetailVC ()
{

}


@end

@implementation RHAssociationManageDetailVC
@synthesize m_pMainDic;
@synthesize m_bIsGrant;
@synthesize m_pstrAssoID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pMainDic = nil;
        m_bIsGrant = NO;
        self.m_pstrAssoID = @"";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //設定多國語系
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_GROUP_MANAGEMEMBER_TITLE", nil)];
    [self.m_pLblType setText:NSLocalizedString(@"LE_GROUP_MANAGEMEMBER_TYPE", nil)];
    [self.m_pLblBabyWeek setText:NSLocalizedString(@"LE_GROUP_MANAGEMEMBER_BABYWEEK", nil)];
    [self.m_pLblCoManagerment setText:NSLocalizedString(@"LE_GROUP_MANAGEMEMBER_COMANAGEMENT", nil)];
    [self.m_pLblDeleteMember setText:NSLocalizedString(@"LE_GROUP_MANAGEMEMBER_DELETE", nil)];
    
    
    [self updateUI];

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
    if ( m_pMainDic )
    {
        [self.m_pLblName setText:[m_pMainDic objectForKey:@"nickname"]];
        NSInteger nWeek = [[m_pMainDic objectForKey:@"weeks"] integerValue];
        [self.m_pLblWeek setText:[NSString stringWithFormat:@"%d", nWeek]];
        
        NSInteger nType = [[m_pMainDic objectForKey:@"type"] integerValue];
        
        if ( nType <= 1 )
        {
            [self.m_pLblType setText:@"孕媽咪"];
        }
        else if( nType == 2 )
        {
            [self.m_pLblType setText:@"準爸爸"];
        }
        else if( nType == 3 )
        {
            [self.m_pLblType setText:@"親友"];
        }
        
        [self.m_pSwitch setOn:m_bIsGrant];
        
        
        NSString *pstrImageUrl = [m_pMainDic objectForKey:@"photoUrl"];
        
        if ( pstrImageUrl )
        {
            if ( [pstrImageUrl compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
            {
                AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pImageView.bounds];
                [pAsync setBackgroundColor:[UIColor clearColor]];
                [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
                
                [self.m_pImageView addSubview:pAsync];
                [pAsync loadImageFromURL:[NSURL URLWithString:pstrImageUrl]];
            }
        }
        
    }
}

#pragma mark - Public

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressSwitchBtn:(id)sender
{
    UISwitch *pSwitch = ( UISwitch * )sender;
    
    NSString *pstrManager = @"";
    
    if ( pSwitch.on )
    {
        pstrManager = @"1";
    }
    else
    {
        pstrManager = @"0";
    }
    
    [RHAppDelegate showLoadingHUD];
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:m_pstrAssoID forKey:kAssoID];
    [pParameter setObject:pstrManager forKey:kAssoIsManager];
    [pParameter setObject:[m_pMainDic objectForKey:@"matchId"] forKey:kAssoMatchId];

    
    [RHLesEnphantsAPI SetAssociationMeberPermission:pParameter Source:self];
}

- ( IBAction )pressDeleteBtn:(id)sender
{
    //Delete
    RHAlertView *alert = [[RHAlertView alloc]initWithTitle:@""
                                                   message:@"是否要將社員刪除"
                                                  delegate:nil
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"刪除",nil];
    [alert showWithCallback:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if ( buttonIndex == 1 )
         {
             
             NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
             [pParameter setObject:m_pstrAssoID forKey:kAssoID];
             [pParameter setObject:[m_pMainDic objectForKey:@"matchId"] forKey:kAssoMatchId];
             
             //[RHAppDelegate showLoadingHUD];
             [RHLesEnphantsAPI kickMemberFromAssociation:pParameter Source:self];

         }
         else
         {
             
         }
         
     }];
}


#pragma mark - API
- ( void )callBackSetAssociationPermissionStatus:( NSDictionary * )pStatusDic
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

- ( void )callBackKickMemberFromAssociationStatus:( NSDictionary * )pStatusDic
{
    [RHAppDelegate hideLoadingHUD];
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        
        //[self.navigationController popViewControllerAnimated:YES];
        [self performSelector:@selector(pressBackBtn:) withObject:nil afterDelay:0.50f];
    }
    else
    {
        
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    
}


@end
