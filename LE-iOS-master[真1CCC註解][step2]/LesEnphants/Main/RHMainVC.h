//
//  RHMainVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/13.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RHLoginVC;
@class RHRegisterVC;
@class MBProgressHUD;
@interface RHMainVC : UIViewController
{
    RHLoginVC               *m_pRHLoginVC;
    RHRegisterVC            *m_pRHRegisterVC;
    MBProgressHUD           *m_pMBProgressHUD;
}


@property (retain, nonatomic) IBOutlet UIImageView *m_pBackgroundImage;
@property (retain, nonatomic) MBProgressHUD           *m_pMBProgressHUD;
@property ( nonatomic, retain ) RHLoginVC           *m_pRHLoginVC;
@property ( nonatomic, retain ) RHRegisterVC        *m_pRHRegisterVC;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnMenu;
@property (retain, nonatomic) IBOutlet UIView *m_pNaviBar;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;


@property (retain, nonatomic) IBOutlet UIImageView *m_pSelfIconView;
@property (retain, nonatomic) IBOutlet UIScrollView *m_pMainScrollView;
@property (retain, nonatomic) IBOutlet UIView *m_pMainPageView;
@property (retain, nonatomic) IBOutlet UIButton *m_pLblCountDown;
@property (retain, nonatomic) IBOutlet UIButton *m_pNextCheckDate;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnWeek;

@property (strong, nonatomic) IBOutlet UIView *m_pBottomView;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnTodo;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnEmotion;
@property (strong, nonatomic) IBOutlet UIButton *m_pbtnChooseFriend;
@property (strong, nonatomic) IBOutlet UIImageView *m_pRelativedIconView;

@property (strong, nonatomic) IBOutlet UIView *m_pGuestBottomView;

@property (strong, nonatomic) IBOutlet UILabel *m_pLblCountDownTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblPregNoteTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblNextTitle;

#pragma mark - Public
- ( void )showRegisterView;

#pragma mark - IBAction
- ( IBAction )pressLoginBtn:(id)sender;
- ( IBAction )pressRegisterBtn:(id)sender;
- ( IBAction )pressSwithToPregnantMemoBtn:(id)sender;
- ( IBAction )pressResetBtn:(id)sender;
- ( IBAction )pressForceToEmotionPage:(id)sender;
- ( IBAction )pressForceToTodoListPage:(id)sender;
- ( IBAction )pressForceToChatPage:(id)sender;
- ( IBAction )pressChooseFreindsPage:(id)sender;
- ( IBAction )pressCountDownBtn:(id)sender;
- ( IBAction )pressWeekBtn:(id)sender;
- ( IBAction )pressNextBtn:(id)sender;
- ( IBAction )pressMainIconBtn:(id)sender;



@end
