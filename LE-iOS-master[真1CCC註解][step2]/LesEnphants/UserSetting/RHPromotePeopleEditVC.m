//
//  RHPromotePeopleEditVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/16.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHPromotePeopleEditVC.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "RHProfileObj.h"
#import "AsyncImageView.h"
#import "Utilities.h"


@interface RHPromotePeopleEditVC () < AsyncImageViewDelegate >
- ( void )setPromoteIdToServer;
- ( void )getFriendByMatchID;
@end

@implementation RHPromotePeopleEditVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_PROMOTEID_TITLE", nil)];
    [self.m_pTFID setPlaceholder:NSLocalizedString(@"LE_PROMOTEID_HINT", nil)];
    [self.m_pBtnConfirm setTitle:NSLocalizedString(@"LE_COMMON_CONFIRM", nil) forState:UIControlStateNormal];
    [self.m_pBtnCancel setTitle:NSLocalizedString(@"LE_COMMON_CANCEL", nil) forState:UIControlStateNormal];
    
    [self.m_pLblHint setHidden:YES];
    [self.m_pIconImgView setHidden:YES];
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    NSDictionary *pDic = pObj.m_pRecommand;
    
    if ( [[pDic objectForKey:@"matchId"] compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
    {
        
        NSLog(@"pDic = %@", [pDic description]);
        
        [self.m_pLblRecommandID setText:[pDic objectForKey:@"nickname"]];
        [self.m_pTFID setHidden:YES];
        
        AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pIconImgView.bounds];
        [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
        [self.m_pIconImgView addSubview:pAsync];
        [pAsync setDelegate:self];
        
        NSString *pstrURL = [pDic objectForKey:@"photoUrl"];
        if ( [pstrURL compare:@"'" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            [pAsync loadImageFromURL:[NSURL URLWithString:pstrURL]];
        }
        [pAsync release];
        
        [Utilities setRoundCornor:self.m_pIconImgView];
        
        [self.m_pIconImgView setHidden:NO];
    }
    
    //Hide at first
    [self.m_pBtnCancel setHidden:YES];
    [self.m_pBtnConfirm setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_pTFID release];
    [_m_pIconImgView release];
    [_m_pBtnConfirm release];
    [_m_pBtnCancel release];
    [_m_pLblRecommandID release];
    [_m_pLblHint release];
    [super dealloc];
}

#pragma mark - Private Methods
- ( void )setPromoteIdToServer
{
    [RHAppDelegate showLoadingHUD];
    
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:[self.m_pTFID text] forKey:kPostRecommandID];
    
    [RHLesEnphantsAPI setRecommandID:pParameter Source:self];
}

- ( void )getFriendByMatchID
{
    [RHAppDelegate showLoadingHUD];
    
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:[self.m_pTFID text] forKey:kPostMatchID];
    
    [RHLesEnphantsAPI getUserByMatchID:pParameter Source:self];
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- ( IBAction )pressCancelBtn:(id)sender
{
    [self.m_pTFID setText:@""];
    [self.m_pTFID becomeFirstResponder];
    [self.m_pIconImgView setHidden:YES];
    [self.m_pBtnConfirm setHidden:YES];
    [self.m_pBtnCancel setHidden:YES];
}
- ( IBAction )pressConfirmBtn:(id)sender
{
    //call API
    [self setPromoteIdToServer];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self.m_pLblHint setHidden:YES];
    [self.m_pIconImgView setHidden:YES];
    //call API to fine ID
    [self getFriendByMatchID];
    return YES;
}


#pragma mark - API Delegate
- ( void )callBackSetRecommandIdStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [RHAppDelegate MessageBox:@"設定成功"];
        [self.m_pBtnConfirm setHidden:YES];
        [self.m_pBtnCancel setHidden:YES];
        [RHLesEnphantsAPI getUserProfile:nil Source:self];
    }
    else if ( nError == 107 )
    {
        //match ID not found
        [self.m_pLblHint setHidden:NO];
        [self.m_pIconImgView setHidden:NO];
        [RHAppDelegate hideLoadingHUD];
    }
    else if ( nError == 113 )
    {
        [RHAppDelegate MessageBox:@"推薦人已經設定過了"];
        [RHAppDelegate hideLoadingHUD];
    }
    else
    {
        [RHAppDelegate MessageBox:[pStatusDic objectForKey:@"message"]];
        [RHAppDelegate hideLoadingHUD];
    }
}

- ( void )callBackGetUserProfileStatus:( NSDictionary * )pStatusDic
{
    NSLog(@"pStatusDic = %@", pStatusDic);
    
    if ( pStatusDic )
    {
        NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
        
        if ( nStatus == 0 )
        {
            [[RHAppDelegate sharedDelegate] keepLoginProfile:[pStatusDic objectForKey:@"profile"]];
            NSDictionary *pDic = [[pStatusDic objectForKey:@"profile"] objectForKey:@"recommand"];
            
            [self.m_pLblRecommandID setText:[pDic objectForKey:@"nickname"]];
            [self.m_pTFID setHidden:YES];
            
            AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pIconImgView.bounds];
            [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [self.m_pIconImgView addSubview:pAsync];
            [pAsync setDelegate:self];
            
            NSString *pstrURL = [pDic objectForKey:@"photoUrl"];
            if ( [pstrURL compare:@"'" options:NSCaseInsensitiveSearch] != NSOrderedSame )
            {
                [pAsync loadImageFromURL:[NSURL URLWithString:pstrURL]];
            }
            [pAsync release];
            
            [Utilities setRoundCornor:self.m_pIconImgView];
            [self.m_pIconImgView setHidden:NO];
            [self.m_pLblHint setHidden:YES];
            [self.m_pLblRecommandID setHidden:NO];
        }
        else
        {
            NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatus]];
            [RHAppDelegate MessageBox:pstrErrorMsg];
        }
    }
    else
    {
        NSLog(@"Can't get User profile");
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackGetUserByMatchID:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        
        NSString *pstrPhoto = [pStatusDic objectForKey:@"photoUrl"];
        
        if ( [pstrPhoto compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pIconImgView.bounds];
            [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [self.m_pIconImgView addSubview:pAsync];
            [pAsync setDelegate:self];
            [pAsync loadImageFromURL:[NSURL URLWithString:pstrPhoto]];
            [pAsync release];
            
            [Utilities setRoundCornor:self.m_pIconImgView];
        }
        else
        {
            [self.m_pIconImgView setImage:[UIImage imageNamed:@"firstlaunch_others@3x.png"]];
        }

        [self.m_pIconImgView setHidden:NO];
        [self.m_pBtnCancel setHidden:NO];
        [self.m_pBtnConfirm setHidden:NO];
        
        [RHAppDelegate hideLoadingHUD];

    }
    else if ( nError == 107 )
    {
        NSArray *pArray = [self.m_pIconImgView subviews];
        
        for ( id oneView in pArray )
        {
            if ( [oneView isKindOfClass:[AsyncImageView class]])
            {
                AsyncImageView *pView = ( AsyncImageView * )oneView;
                [pView removeFromSuperview];
            }
        }
        
        [self.m_pIconImgView setImage:[UIImage imageNamed:@"settings_info@3x.png"]];
        
        //match ID not found
        [self.m_pLblHint setHidden:NO];
        [self.m_pIconImgView setHidden:NO];
        [self.m_pBtnCancel setHidden:YES];
        [self.m_pBtnConfirm setHidden:YES];
        [RHAppDelegate hideLoadingHUD];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
        [RHAppDelegate hideLoadingHUD];
    }
}

@end
