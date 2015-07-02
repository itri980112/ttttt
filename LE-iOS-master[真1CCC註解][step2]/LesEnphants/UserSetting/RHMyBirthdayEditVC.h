//
//  RHMyBirthdayEditVC
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/16.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHMyBirthdayEditVC : UIViewController
{

}

@property (retain, nonatomic) IBOutlet UIImageView *m_pIconImgView;
@property (retain, nonatomic) IBOutlet UIDatePicker *m_pDatePicker;

@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnConfirm;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressSendBtn:(id)sender;


@end
