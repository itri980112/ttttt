//
//  RHBgSelectionVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/16.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHBgSelectionVC : UIViewController
{
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *m_pMainScrollView;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnConfirm;

#pragma mark - IBAction
- ( IBAction )pressConfirmBtn:(id)sender;
- ( IBAction )pressBackBtn:(id)sender;
@end
