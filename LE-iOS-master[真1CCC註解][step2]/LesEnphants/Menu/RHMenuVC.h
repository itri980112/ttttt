//
//  RHMenuVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/13.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@class RHPregnantMemoVC;
@class RHNewsHomePageVC;
@class RHKnowledgeHomePageVC;
@class RHMainVC;
@class RHGroupVC;

@interface RHMenuVC : UIViewController
{
    MBProgressHUD           *m_pMBProgressHUD;
    RHPregnantMemoVC        *m_pRHPregnantMemoVC;
    RHNewsHomePageVC        *m_pRHNewsHomePageVC;
    RHKnowledgeHomePageVC   *m_pRHKnowledgeHomePageVC;
    
    RHMainVC                *m_pRHMainVC;
    RHGroupVC               *m_pRHGroupVC;
}

@property (retain, nonatomic) RHMainVC                *m_pRHMainVC;
@property (retain, nonatomic) MBProgressHUD           *m_pMBProgressHUD;
@property (retain, nonatomic) RHPregnantMemoVC        *m_pRHPregnantMemoVC;
@property (retain, nonatomic) RHNewsHomePageVC        *m_pRHNewsHomePageVC;
@property (retain, nonatomic) RHKnowledgeHomePageVC   *m_pRHKnowledgeHomePageVC;
@property (retain, nonatomic) RHGroupVC               *m_pRHGroupVC;

@property (retain, nonatomic) IBOutlet UIImageView *m_pIconImgView;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblNickname;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblPregnantLabel;
@property (retain, nonatomic) IBOutlet UITableView *m_pMenuTable;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnSetting;

#pragma mark - Customized Method



#pragma mark - IBAction
- ( IBAction )pressSettingBtn:(id)sender;

@end
