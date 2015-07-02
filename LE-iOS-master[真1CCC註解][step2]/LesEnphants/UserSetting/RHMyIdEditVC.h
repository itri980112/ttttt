//
//  RHMyIdEditVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/16.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHMyIdEditVC : UIViewController
{

}

@property (retain, nonatomic) IBOutlet UIImageView *m_pIconImgView;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFEdit;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;

@end
