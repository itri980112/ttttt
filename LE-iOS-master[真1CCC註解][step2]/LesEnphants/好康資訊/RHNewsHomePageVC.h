//
//  RHNewsHomePageVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/24.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RHNewsListVC;
@interface RHNewsHomePageVC : UIViewController
{
    RHNewsListVC            *m_pRHNewsListVC;
}


@property ( nonatomic, retain ) RHNewsListVC            *m_pRHNewsListVC;
@property (retain, nonatomic) IBOutlet UIView *m_pNaviBar;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnMenu;
@property (retain, nonatomic) IBOutlet UIScrollView *m_pMainScrollView;


@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (retain, nonatomic) IBOutlet UILabel *m_pLbl1;
@property (retain, nonatomic) IBOutlet UILabel *m_pLbl2;
@property (retain, nonatomic) IBOutlet UILabel *m_pLbl3;
@property (retain, nonatomic) IBOutlet UILabel *m_pLbl4;
@property (retain, nonatomic) IBOutlet UILabel *m_pLbl5;
@property (retain, nonatomic) IBOutlet UILabel *m_pLbl6;
#pragma mark - Customized Methods


#pragma mark - IBAction
- ( IBAction )pressBtn:(id)sender;
@end
