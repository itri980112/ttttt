//
//  RHRegisterVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/14.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RHRegisterVCDelegate <NSObject>

@optional
- ( void )callBackGuestLogin;
- ( void )callBackFBLogin;
- ( void )callBackEmailLogin;
@end

@class MBProgressHUD;
@class RHUserProfileSettingVC;
@interface RHRegisterVC : UIViewController
{
    id< RHRegisterVCDelegate > delegate;
    
    
    MBProgressHUD           *m_pMBProgressHUD;
    RHUserProfileSettingVC  *m_pRHUserProfileSettingVC;
}

@property (retain, nonatomic) MBProgressHUD           *m_pMBProgressHUD;
@property (retain, nonatomic) RHUserProfileSettingVC  *m_pRHUserProfileSettingVC;
@property (nonatomic, assign) id< RHRegisterVCDelegate > delegate;

@property (retain, nonatomic) IBOutlet UIButton *m_pMainLogin;
@property (retain, nonatomic) IBOutlet UIButton *m_pMainRegister;
@property (retain, nonatomic) IBOutlet UIButton *m_pMainIgnore;
@property (retain, nonatomic) IBOutlet UIButton *m_pLoginEmail;
@property (retain, nonatomic) IBOutlet UIButton *m_pLoginFacebook;
@property (retain, nonatomic) IBOutlet UIView *m_pRegisterSelectionView;
@property (retain, nonatomic) IBOutlet UIView *m_pEmailEditView;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFEmail;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFPassword;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmailReg;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblRegTitle;


#pragma mark - IBAction
- ( IBAction )pressRegisterBtn:(id)sender;
- ( IBAction )pressLoginBtn:(id)sender;
- ( IBAction )pressSkipBtn:(id)sender;
- ( IBAction )pressFBRegisterBtn:(id)sender;
- ( IBAction )pressEmailRegisterBtn:(id)sender;
- ( IBAction )pressNextStepBtn:(id)sender;
- ( IBAction )pressBackBtn:(id)sender;
@end
