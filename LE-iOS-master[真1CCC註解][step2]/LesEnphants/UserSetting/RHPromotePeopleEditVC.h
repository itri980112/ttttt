//
//  RHPromotePeopleEditVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/16.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHPromotePeopleEditVC : UIViewController
{
    
}
@property (retain, nonatomic) IBOutlet UILabel *m_pLblHint;

@property (retain, nonatomic) IBOutlet UILabel *m_pLblRecommandID;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFID;
@property (retain, nonatomic) IBOutlet UIImageView *m_pIconImgView;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnConfirm;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnCancel;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressCancelBtn:(id)sender;
- ( IBAction )pressConfirmBtn:(id)sender;

@end
