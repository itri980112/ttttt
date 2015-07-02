//
//  RHInfoVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/10/10.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHInfoVC : UIViewController
{
    BOOL        m_bIsRule_1;
}
@property   BOOL        m_bIsRule_1;
@property (retain, nonatomic) IBOutlet UIScrollView *m_pMainScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *m_pRuleImgView2;
@property (retain, nonatomic) IBOutlet UIImageView *m_pRuleImgView1;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;

@end
