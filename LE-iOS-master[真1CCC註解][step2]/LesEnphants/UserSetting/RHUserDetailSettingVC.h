//
//  RHUserDetailSettingVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/18.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    RH_CHOOSE_IMAGE_ICON = 0,
    RH_CHOOSE_IMAGE_BG
}EIMAGECHOICE;



@class MBProgressHUD;
@class RHPointCollection;

@interface RHUserDetailSettingVC : UIViewController
{
    EIMAGECHOICE        m_enmuImageChoice;
    MBProgressHUD       *m_pMBProgressHUD;
    RHPointCollection   *m_pRHPointCollection;
}

@property (retain, nonatomic) MBProgressHUD       *m_pMBProgressHUD;
@property (retain, nonatomic) RHPointCollection   *m_pRHPointCollection;

@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (retain, nonatomic) IBOutlet UIImageView *m_pIconImgView;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblID;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblPhone;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblNickname;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblBirthday;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblPregnantDate;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblRegister;

@property (retain, nonatomic) IBOutlet UIImageView *m_pIcon1;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnPoint;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnQuestion;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblPair;


@property (retain, nonatomic) IBOutlet UITableView *m_pMainTable;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblS1;
#pragma mark - Customized MEthods



#pragma mark - IBAction
- ( IBAction )pressBacnBtn:(id)sender;
- ( IBAction )pressChangeIconBtn:(id)sender;
- ( IBAction )pressChangeBackgroundBtn:(id)sender;
- ( IBAction )pressPromoteBtn:(id)sender;
- ( IBAction )pressPointBtn:(id)sender;
- ( IBAction )pressQeuestionBtn:(id)sender;
@end
