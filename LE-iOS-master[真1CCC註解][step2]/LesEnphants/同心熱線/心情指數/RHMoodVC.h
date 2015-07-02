//
//  RHMoodVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/26.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RHColorPickerView;

@interface RHMoodVC : UIViewController
{
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *m_pMainScrollView;

//Mother
@property (retain, nonatomic) IBOutlet UIView *m_pMotherView;
@property (retain, nonatomic) IBOutlet UIImageView *m_pBigEmotionImg;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotion1;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotion2;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotion3;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotion4;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotion5;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotion6;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotion7;
@property (retain, nonatomic) IBOutlet RHColorPickerView *m_pColorPicker;
@property (retain, nonatomic) IBOutlet UIView *m_pMomRealtedCollection;



//Father
@property (retain, nonatomic) IBOutlet UIView *m_pFatherView;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblMsg;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotionF1;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotionF2;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotionF3;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotionF4;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotionF5;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotionF6;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnEmotionF7;
@property (retain, nonatomic) IBOutlet UIImageView *m_pEmotionImgFromMom;



#pragma mark - IBAction 
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressLogBtn:(id)sender;


//Mother
- ( IBAction )pressChangeImgBtn:(id)sender;
- ( IBAction )pressRecordBtn:(id)sender;
- ( IBAction )pressEmotionBtn:(id)sender;

//Father
- ( IBAction )pressNotifyMotherBtn:(id)sender;
@end
