//
//  RHPregnantMemoVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


typedef enum
{
    RH_PregnantPage_Beat = 0,
    RH_PregnantPage_Echo,
    RH_PregnantPage_Shape,
    RH_PregnantPage_Weight
}ERH_PREGNANTPAGE_TYPE;

@class CIDetector;

@interface RHPregnantMemoVC : UIViewController
{
    ERH_PREGNANTPAGE_TYPE       m_enumPregnantPageType;
}

@property (retain, nonatomic) IBOutlet UIButton *m_pBtnMenu;
@property (retain, nonatomic) IBOutlet UIView *m_pNaviBar;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab1;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab2;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab3;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab4;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTakePic;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEdit;;
@property (retain, nonatomic) IBOutlet UIView *m_pCntView;
@property (retain, nonatomic) IBOutlet UITableView *m_pCntTableView;
@property (retain, nonatomic) IBOutlet UITableView *m_pWeightTable;

//Weight View
@property (retain, nonatomic) IBOutlet UIView *m_pWeightView;
@property (retain, nonatomic) IBOutlet UIScrollView *m_pWeightScrollView;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFWeight;
@property (retain, nonatomic) IBOutlet UIView *m_pGraphView;

@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTab1;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTab2;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTab3;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTab4;

@property (strong, nonatomic) IBOutlet UILabel *m_pLbl1;
@property (strong, nonatomic) IBOutlet UILabel *m_pLbl2;
@property (strong, nonatomic) IBOutlet UILabel *m_pLbl3;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtn4;
#pragma mark - IBAction
- ( IBAction )pressTab1:(id)sender;
- ( IBAction )pressTab2:(id)sender;
- ( IBAction )pressTab3:(id)sender;
- ( IBAction )pressTab4:(id)sender;
- ( IBAction )pressCalendarBtn:(id)sender;
- ( IBAction )pressCameraBtn:( id )sender;
- ( IBAction )pressKnowledgeBtn:(id)sender;
- ( IBAction )pressEditBtn:(id)sender;
@end
