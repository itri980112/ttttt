//
//  RHMoodStatisticVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/10/5.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHMoodStatisticVC : UIViewController
{
    
}
@property (retain, nonatomic) IBOutlet UIButton *m_pbtnPrev;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnNext;
@property (retain, nonatomic) IBOutlet UILabel *m_plblTitle;
@property (retain, nonatomic) IBOutlet UIView *m_pValue1;
@property (retain, nonatomic) IBOutlet UIView *m_pValue2;
@property (retain, nonatomic) IBOutlet UIView *m_pValue3;
@property (retain, nonatomic) IBOutlet UIView *m_pValue4;
@property (retain, nonatomic) IBOutlet UIView *m_pValue5;
@property (retain, nonatomic) IBOutlet UIView *m_pValue6;
@property (retain, nonatomic) IBOutlet UIView *m_pValue7;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblValue1;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblValue2;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblValue3;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblValue4;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblValue5;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblValue6;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblValue7;
@property (retain, nonatomic) IBOutlet UIView *m_pStatisticView;
@property (retain, nonatomic) IBOutlet UIScrollView *m_pMainScrollView;
@property (retain, nonatomic) IBOutlet UIView *m_pCntView;


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressPrevBtn:(id)sender;
- ( IBAction )pressNextBtn:(id)sender;
@end
