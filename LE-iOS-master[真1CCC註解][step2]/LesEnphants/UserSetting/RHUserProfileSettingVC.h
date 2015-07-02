//
//  RHUserProfileSettingVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/17.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@interface RHUserProfileSettingVC : UIViewController
{
    BOOL        m_bIsPresent;
    BOOL        m_bIsOther;     //其他身份，不使用手機號碼
    
    BOOL        m_bIsGuestLogin;        //Guest Login，預設為孕媽咪
    
    UIDatePicker                *m_pTimePicker;
    NSInteger                   m_nLoginType;       //0(unknown), 1(mother), 2(father), 3(guest), 4(other)
    MBProgressHUD           *m_pMBProgressHUD;
}
@property (retain, nonatomic) IBOutlet UILabel *m_pNaviTitle;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnConfirm;
@property   BOOL        m_bIsPresent;
@property (retain, nonatomic) UIDatePicker                *m_pTimePicker;
@property (retain, nonatomic) MBProgressHUD           *m_pMBProgressHUD;
@property (retain, nonatomic) IBOutlet UIScrollView *m_pMainScrollView;
@property (retain, nonatomic) IBOutlet UIView *m_pBasicSettingView;




//Mother
@property (retain, nonatomic) IBOutlet UIView *m_pMomView;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFMomNickName;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnPregnant;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnBirthday;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFMomPhone;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFMomSuggestID;
@property (retain, nonatomic) IBOutlet UIView *m_pMomPregnant;
@property (retain, nonatomic) IBOutlet UIView *m_pMomBirthday;
@property (retain, nonatomic) IBOutlet UIView *m_pMomPhoneView;
@property (retain, nonatomic) IBOutlet UIView *m_pMomSuggestIDView;



//Dad
@property (retain, nonatomic) IBOutlet UIView *m_pDadView;
@property (retain, nonatomic) IBOutlet UILabel *m_pDadSettingTitle;
@property (retain, nonatomic) IBOutlet UIImageView *m_pDadSettingImgView;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFDadNickName;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFDadPhone;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFDadSuggestID;






//守護親友團

#pragma mark - Customized Methods
- ( void )setGuestLogin;


#pragma mark - IBAction
- ( IBAction )pressMomBtn:(id)sender;
- ( IBAction )pressDadBtn:(id)sender;
- ( IBAction )pressOtherBtn:(id)sender;


//基本設定頁
- ( IBAction )pressPregnantBtn:(id)sender;
- ( IBAction )pressBirthdayBtn:(id)sender;
- ( IBAction )pressNextBtn:(id)sender;
- ( IBAction )pressBackBtn:(id)sender;
@end
