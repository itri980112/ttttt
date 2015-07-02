//
//  RHUserProfileSettingVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/17.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHUserProfileSettingVC.h"
#import "RHAppDelegate.h"
#import "MBProgressHUD.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "RHProfileObj.h"
#import "Utilities.h"
#import "RHActionSheet.h"
#import "GoldCoinAnimationVC.h"

@interface RHUserProfileSettingVC () < RHActionSheetDelegate, UITextFieldDelegate, RHLesEnphantsAPIDelegate, GoldCoinAnimationVCDelegate >
{
    BOOL    m_bIsPregnantBtnSelected;
}
- ( void )showBasicSettingView;
- ( void )closeBasicSettingView;
- ( void )setLoginTypeToServer;
- ( void )checkRecommandID:( NSString * )pstrID;
- ( void )registerToServer;
@end

@implementation RHUserProfileSettingVC
@synthesize m_pTimePicker;
@synthesize m_pMBProgressHUD;
@synthesize m_bIsPresent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pTimePicker = nil;
        self.m_pMBProgressHUD = nil;
        m_nLoginType = 0;
        m_bIsPregnantBtnSelected = NO;
        m_bIsPresent = NO;
    }
    return self;
}

- ( void )viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // add observer for the respective notifications (depending on the os version)

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self registerForKeyboardNotifications];
    
    [self.view addSubview:self.m_pBasicSettingView];
    [self.m_pMainScrollView addSubview:self.m_pMomView];
    [self.m_pMainScrollView addSubview:self.m_pDadView];

    //先檢查是不是有設定過身份
    
    if ( [[RHAppDelegate sharedDelegate].m_pRHProfileObj hasSetLoginType] )
    {
        NSInteger nType = [RHAppDelegate sharedDelegate].m_pRHProfileObj.m_nType;
        m_nLoginType = nType;
        
        switch ( nType )
        {
            case 1:
            {
                m_bIsGuestLogin = NO;
                //[RHAppDelegate MessageBox:@"您已設定孕媽咪身份"];
            }
                break;
            case 2:
            {
                m_bIsGuestLogin = NO;
                //[RHAppDelegate MessageBox:@"您已設定準爸爸身份"];
            }
                break;
            case 0:
            {
                m_bIsGuestLogin = YES;
                //[RHAppDelegate MessageBox:@"您已設定Guest身份"];
            }
                break;
            case 4:
            {
                m_bIsGuestLogin = NO;
            }
                break;
                
            default:
                break;
        }
        
        
        //直接進到下一頁
        [self showBasicSettingView];
    }
    else
    {
        //尚未設定身份
        
        if ( m_bIsGuestLogin )
        {
            //直接到next page，預設為孕媽咪
            [self pressMomBtn:nil];
        }
    }
    self.m_pBasicSettingView.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self unRegisterForKeyboardNotifications];
    
    [_m_pBasicSettingView release];
    [m_pTimePicker release];
    [m_pMBProgressHUD release];
    [_m_pMainScrollView release];
    [_m_pMomView release];
    [_m_pDadView release];
    [_m_pNaviTitle release];
    [_m_pTFMomNickName release];
    [_m_pBtnPregnant release];
    [_m_pBtnBirthday release];
    [_m_pTFMomPhone release];
    [_m_pTFMomSuggestID release];
    [_m_pMomPhoneView release];
    [_m_pMomSuggestIDView release];
    [_m_pDadSettingTitle release];
    [_m_pDadSettingImgView release];
    [_m_pTFDadNickName release];
    [_m_pTFDadPhone release];
    [_m_pTFDadSuggestID release];
    [super dealloc];
}

#pragma mark - Private
- ( void )showBasicSettingView
{
    [self.m_pMomView setHidden:YES];
    [self.m_pDadView setHidden:YES];

//    CGRect kRect = self.m_pBasicSettingView.bounds;
//    kRect.origin.x = self.view.frame.size.width;
//    [self.m_pBasicSettingView setFrame:kRect];
    
    //Move Enter
    [UIView beginAnimations:@"Move" context:nil];
    [UIView setAnimationDuration:0.50f];
//    kRect.origin.x = 0;
//    [self.m_pBasicSettingView setFrame:kRect];
    self.m_pBasicSettingView.alpha = 1.0;

    [UIView commitAnimations];
    
    //判斷四個身份,show不同的View
    switch ( m_nLoginType )
    {
        case 1:
        {
            //孕媽咪
            //[self.m_pMainScrollView addSubview:self.m_pMomView];
            [self.m_pMomView setHidden:NO];
            [self.m_pMainScrollView setContentSize:self.m_pMomView.frame.size];
            [self.m_pMomPhoneView setHidden:NO];
            [self.m_pMomSuggestIDView setHidden:NO];
            [self.m_pNaviTitle setText:@"註冊"];
            
            [self.m_pTFMomNickName setText:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrNickName];
            [self.m_pTFMomPhone setText:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrMobile];
            [self.m_pBtnPregnant setTitle:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrExpectedDate forState:UIControlStateNormal];
            [self.m_pBtnBirthday setTitle:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrBirthDate forState:UIControlStateNormal];
            
        }
            break;
        case 2:
        {
            //準爸爸
            //[self.m_pMainScrollView addSubview:self.m_pDadView];
            [self.m_pDadView setHidden:NO];
            [self.m_pMainScrollView setContentSize:self.m_pDadView.frame.size];
            [self.m_pDadSettingTitle setText:@"準爸爸基本設定"];
            [self.m_pDadSettingImgView setImage:[UIImage imageNamed:@"firstlaunch_dad@3x.png"]];
            [self.m_pNaviTitle setText:@"註冊"];
            
            [self.m_pTFDadNickName setText:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrNickName];
            [self.m_pTFDadPhone setText:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrMobile];
        }
            break;
        case 0:
        {
            //Guest，預設為孕媽咪
            //[self.m_pMainScrollView addSubview:self.m_pMomView];
            [self.m_pMomView setHidden:NO];
            [self.m_pMainScrollView setContentSize:self.m_pMomView.frame.size];
            
            // 隱藏預產期欄位，並移動生日欄位位置
            [self.m_pMomPregnant setHidden:YES];
            [self.m_pMomBirthday setFrame:self.m_pMomPregnant.frame];
            
            [self.m_pMomPhoneView setHidden:YES];
            [self.m_pMomSuggestIDView setHidden:YES];
            [self.m_pNaviTitle setText:@"訪客"];
            
            [self.m_pTFMomNickName setText:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrNickName];
            [self.m_pTFMomPhone setText:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrMobile];
            [self.m_pBtnPregnant setTitle:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrExpectedDate forState:UIControlStateNormal];
            [self.m_pBtnBirthday setTitle:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrBirthDate forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            //親友團
            //[self.m_pMainScrollView addSubview:self.m_pDadView];
            [self.m_pDadView setHidden:NO];
            [self.m_pMainScrollView setContentSize:self.m_pDadView.frame.size];
            [self.m_pDadSettingTitle setText:@"守護親友團基本設定"];
            [self.m_pDadSettingImgView setImage:[UIImage imageNamed:@"firstlaunch_others@3x.png"]];
            [self.m_pNaviTitle setText:@"註冊"];
            [self.m_pTFDadNickName setText:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrNickName];
            [self.m_pTFDadPhone setText:[RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pstrMobile];
        }
            break;
            
        default:
            break;
    }
    
    
    //把之前的資料設定上去，測試用的
}

- ( void )closeBasicSettingView
{
    if ( self.m_pBasicSettingView )
    {
//        CGRect kRect = self.m_pBasicSettingView.bounds;
//        kRect.origin.x= 0;
//        [self.m_pBasicSettingView setFrame:kRect];
        
        //Move Exit
        [UIView beginAnimations:@"Move" context:nil];
        [UIView setAnimationDuration:0.50f];
//        kRect.origin.x = self.view.frame.size.width;
//        [self.m_pBasicSettingView setFrame:kRect];
        
        //[self.m_pBasicSettingView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.50f];
        self.m_pBasicSettingView.alpha = 0.0;
        
        [UIView commitAnimations];
    }
}

- ( void )setLoginTypeToServer
{
    self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *pstrLoginType = [NSString stringWithFormat:@"%d", m_nLoginType];
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [pParameter setObject:pstrLoginType forKey:@"loginType"];

    
    [RHLesEnphantsAPI setLoginType:pParameter Source:self];
    
}

- ( void )checkRecommandID:( NSString * )pstrID
{
    //get userbyID
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:pstrID forKey:kPostMatchID];
    
    [RHLesEnphantsAPI getUserByMatchID:pParameter Source:self];
    
}

- ( void )registerToServer
{
    //前面已經檢查過字串的內容了
    if ( m_nLoginType <= 1 )  //0, 1都是孕媽咪
    {
        //上傳至Server
        self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [pParameter setObject:[self.m_pTFMomNickName text] forKey:kNickname];
        if (self.m_pBtnPregnant.titleLabel.text) {
            [pParameter setObject:[self.m_pBtnPregnant.titleLabel text] forKey:kExpectedDate];
        }
        [pParameter setObject:[self.m_pBtnBirthday.titleLabel text] forKey:kBirthday];
        [pParameter setObject:[self.m_pTFMomPhone text] forKey:kMobile];
        
        
        [RHLesEnphantsAPI setUserProfile:pParameter Source:self];

    }
    else
    {
        
        self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [pParameter setObject:[self.m_pTFDadNickName text] forKey:kNickname];
        [pParameter setObject:[self.m_pTFDadPhone text] forKey:kMobile];
        
        [RHLesEnphantsAPI setUserProfile:pParameter Source:self];
    }
}

#pragma mark - ShowAnimation
- (void)showAnimation:(NSInteger)point
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType > 1 )
    {
        [self startAnimationFinish:YES];
        return;
    }

    // 得到金幣,顯示動畫
    if (point >= kShowAnimationMinimumPoint) {
        GoldCoinAnimationVC *vc = nil;
        if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC~ipad" bundle:nil];
        }
        else {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC" bundle:nil];
        }
        
        vc.delegate = self;
        vc.m_getPoint = point;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:^{
            [vc startAnimation];
        }];
    }
}

- (void)startAnimationFinish:(BOOL)completed
{
    self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //檢查推薦ID
    NSString *pstrRecommandID = [[self.m_pTFMomSuggestID text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ( [pstrRecommandID compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        //沒有填，就直接註冊
        [self registerToServer];
    }
    else
    {
        //如果有填，就要檢查
        [self checkRecommandID:pstrRecommandID];
    }

}

#pragma mark - Customized Methods
- ( void )setGuestLogin
{
    m_bIsGuestLogin = YES;
}

#pragma mark - IBAction
- ( IBAction )pressMomBtn:(id)sender
{
    m_bIsOther = NO;
    //[self showBasicSettingView];
    
    if ( m_bIsGuestLogin )
    {
        m_nLoginType = 0;
    }
    else
    {
        m_nLoginType = 1;
    }
    
    
    [self setLoginTypeToServer];
}

- ( IBAction )pressDadBtn:(id)sender
{
    m_bIsOther = NO;
    //[self showBasicSettingView];
    m_nLoginType = 2;
    [self setLoginTypeToServer];
}

- ( IBAction )pressOtherBtn:(id)sender
{
    m_bIsOther = YES;
    //[self showBasicSettingView];
    m_nLoginType = 4;
    [self setLoginTypeToServer];
}

//基本設定頁
- ( IBAction )pressPregnantBtn:(id)sender
{
    [self doneButton:nil];

    NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
    

    RHActionSheet *sheet = [[RHActionSheet alloc] initWithTitle: title
                                                       delegate: self
                                              cancelButtonTitle: @"確定"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet showInView: [[RHAppDelegate sharedDelegate] window]];
    [sheet release];
    

    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0,0, self.view.frame.size.width, 216)];
    self.m_pTimePicker = picker;
    [picker release];
    
    m_pTimePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    //m_pTimePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    m_pTimePicker.datePickerMode = UIDatePickerModeDate;
    m_bIsPregnantBtnSelected = YES;
    
    [sheet addSubview: self.m_pTimePicker];
}


- ( IBAction )pressBirthdayBtn:(id)sender
{
    [self doneButton:nil];
    
    NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
    
    
    RHActionSheet *sheet = [[RHActionSheet alloc] initWithTitle: title
                                                       delegate: self
                                              cancelButtonTitle: @"確定"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet showInView: [[RHAppDelegate sharedDelegate] window]];
    [sheet release];
    
    
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0,0, self.view.frame.size.width, 216)];
    self.m_pTimePicker = picker;
    [picker release];
    
    m_pTimePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    //m_pTimePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    m_pTimePicker.datePickerMode = UIDatePickerModeDate;
    m_bIsPregnantBtnSelected = NO;
    
    [sheet addSubview: self.m_pTimePicker];

}

- ( IBAction )pressNextBtn:(id)sender
{
    
    //檢查輸入
    if ( m_nLoginType <= 1 )  //0(訪客), 1都是孕媽咪
    {
        NSString *pstrNickname = [[self.m_pTFMomNickName text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ( [pstrNickname compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            [RHAppDelegate MessageBox:@"請輸入暱稱"];
            return;
        }
        
        if ( m_nLoginType == 1 ) //孕媽咪才需要鎖
        {
            NSString *pstrPragenatDateString = [[self.m_pBtnPregnant titleLabel] text];
            if ( [pstrPragenatDateString compare:@"請設定" options:NSCaseInsensitiveSearch] == NSOrderedSame )
            {
                [RHAppDelegate MessageBox:@"請設定預產期"];
                return;
            }

            NSString *pstrMomPhone = [[self.m_pTFMomPhone text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ( [pstrMomPhone compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
            {
                [RHAppDelegate MessageBox:@"請輸入手機"];
                return;
            }
        }
    
        [self.view endEditing:YES];

        // 孕媽咪顯示動畫後才進行註冊
        
        if ( m_nLoginType == 1 )
        {
            [self showAnimation:100];
        }
        else
        {
            self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //檢查推薦ID
            NSString *pstrRecommandID = [[self.m_pTFMomSuggestID text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if ( [pstrRecommandID compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
            {
                //沒有填，就直接註冊
                [self registerToServer];
            }
            else
            {
                //如果有填，就要檢查
                [self checkRecommandID:pstrRecommandID];
            }
            
        }
        
    }
    else
    {
        NSString *pstrNickname = [[self.m_pTFDadNickName text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ( [pstrNickname compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            [RHAppDelegate MessageBox:@"請輸入暱稱"];
            return;
        }

        NSString *pstrDadPhone = [[self.m_pTFDadPhone text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ( [pstrDadPhone compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            [RHAppDelegate MessageBox:@"請輸入手機"];
            return;
        }
        
        
        [self.view endEditing:YES];
        
        self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //檢查推薦ID
        NSString *pstrRecommandID = [[self.m_pTFDadSuggestID text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ( [pstrRecommandID compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            //沒有填，就直接註冊
            [self registerToServer];
        }
        else
        {
            //如果有填，就要檢查
            [self checkRecommandID:pstrRecommandID];
        }
    }
    
}

- ( IBAction )pressBackBtn:(id)sender
{
    [self doneButton:nil];
    [self closeBasicSettingView];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDate *pDate = m_pTimePicker.date;
    NSLog(@"pDate = %@", [pDate description]);
    
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *pstrDateString = [pFormatter stringFromDate:pDate];
    [pFormatter release];
    
    if ( m_bIsPregnantBtnSelected )
    {
        [self.m_pBtnPregnant setTitle:pstrDateString forState:UIControlStateNormal];
    }
    else
    {
        [self.m_pBtnBirthday setTitle:pstrDateString forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( textField == self.m_pTFMomPhone || textField == self.m_pTFDadPhone )
    {
        UIView *pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [pView setBackgroundColor:[UIColor grayColor]];
        
        UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pBtn setTitle:@"完成" forState:UIControlStateNormal];
        [pBtn setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [pBtn addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        [pView addSubview:pBtn];
        
        textField.inputAccessoryView = [pView autorelease];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - Add Bunnton in Keyboard


- (void)doneButton:(id)sender
{
    [self.m_pTFMomNickName resignFirstResponder];
    [self.m_pTFDadNickName resignFirstResponder];
    [self.m_pTFMomPhone resignFirstResponder];
    [self.m_pTFDadPhone resignFirstResponder];
    [self.m_pTFMomSuggestID resignFirstResponder];
    [self.m_pTFDadSuggestID resignFirstResponder];
}


#pragma mark - API Delegate
- ( void )callBackSetLoginTypeStatus:( NSDictionary * )pSatusDic
{
    NSInteger nError = [[pSatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSLog(@"no Error");
        //進到設定頁面
        [self showBasicSettingView];
    }
    else if ( nError == 102 )
    {
        [RHAppDelegate MessageBox:@"Login type already settled"];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [self.m_pMBProgressHUD hide:YES];
}


- ( void )callBackSetUserProfileStatus:( NSDictionary * )pSatusDic
{

    //succeed
    //儲存設定

    NSInteger nError = [[pSatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        //close view
        
        //通知完成註冊
        [[NSNotificationCenter defaultCenter] postNotificationName:kFinishRegister object:nil];
        
        if ( m_bIsPresent )
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }

    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
}

- ( void )callBackGetUserByMatchID:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        //有此ID
        NSString *pstrID = [pStatusDic objectForKey:@"matchId"];
        
        //設定
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:pstrID forKey:kPostRecommandID];
        
        [RHLesEnphantsAPI setRecommandID:pParameter Source:self];
    }
    else if ( nError == 107 )
    {
        [RHAppDelegate MessageBox:@"查無此推薦ID"];
        [self.m_pMBProgressHUD hide:YES];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
        [self.m_pMBProgressHUD hide:YES];
    }
}

- ( void )callBackSetRecommandIdStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        //註冊
        [self registerToServer];
    }
    else if ( nError == 113 )
    {
        //設定過了，就直接Skip
        [self registerToServer];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
        [self.m_pMBProgressHUD hide:YES];
    }
}


#pragma mark - Keyboard Related
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unRegisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.m_pMainScrollView.contentInset = contentInsets;
    self.m_pMainScrollView.scrollIndicatorInsets = contentInsets;
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.m_pMainScrollView.contentInset = contentInsets;
    self.m_pMainScrollView.scrollIndicatorInsets = contentInsets;
}



@end
