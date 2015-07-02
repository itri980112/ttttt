//
//  RHMyBirthdayEditVC
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/16.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHMyBirthdayEditVC.h"
#import "Utilities.h"
#import "AsyncImageView.h"
#import "RHProfileObj.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
@interface RHMyBirthdayEditVC () < UITextFieldDelegate >
{
    NSString *m_pstrBirthday;
}

@property ( nonatomic, retain )  NSString *m_pstrBirthday;
- ( void )modifyMatchIdToServer;
@end

@implementation RHMyBirthdayEditVC
@synthesize m_pstrBirthday;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_pstrBirthday = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_MYBIRTHDAY_TITLE", nil)];
    [self.m_pBtnConfirm setTitle:NSLocalizedString(@"LE_COMMON_CONFIRM", nil) forState:UIControlStateNormal];
    
    
    [Utilities setRoundCornor:self.m_pIconImgView];
    
    //Load User Profile
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    
    if ( pObj )
    {
        NSString *pstrURL = pObj.m_pstrPhotoURL;
        
        if ( [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            AsyncImageView *pAsyncImg = [[[AsyncImageView alloc] initWithFrame:self.m_pIconImgView.bounds] autorelease];
            [self.m_pIconImgView addSubview:pAsyncImg];
            [pAsyncImg setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [pAsyncImg loadImageFromURL:[NSURL URLWithString:pObj.m_pstrPhotoURL]];
        }
        
        //set Selected Date
        NSDate *pDate = [NSDate date];
        if ( pObj.m_pstrBirthDate )
        {
            NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
            [pFormatter setDateFormat:@"yyyy-MM-dd"];
            
            
            
            pDate = [pFormatter dateFromString:pObj.m_pstrBirthDate];
        }

        if ( pDate )
        {
            [self.m_pDatePicker setDate:pDate];
        }
        
        [self.m_pDatePicker setMaximumDate:[NSDate date]];
        

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_m_pIconImgView release];
    [_m_pDatePicker release];
    [m_pstrBirthday release];
    [super dealloc];
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressSendBtn:(id)sender
{
    [self modifyMatchIdToServer];
}

#pragma mark - Private 
- ( void )modifyMatchIdToServer
{
    [RHAppDelegate showLoadingHUD];
    
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSDate *pDate = [self.m_pDatePicker date];
    
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.m_pstrBirthday= [pFormatter stringFromDate:pDate];
    
    
    
    [pParameter setObject:m_pstrBirthday forKey:kBirthday];
    
    [RHLesEnphantsAPI setUserProfile:pParameter Source:self];
    
}



#pragma mark - API Delegate
- ( void )callBackSetUserProfileStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [RHAppDelegate MessageBox:@"設定成功"];
        
        //TODO: 重新取得使用者資料
        RHProfileObj *pObj = [RHProfileObj getProfile];
        pObj.m_pstrBirthDate = m_pstrBirthday;
        [pObj saveProfile];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

@end
