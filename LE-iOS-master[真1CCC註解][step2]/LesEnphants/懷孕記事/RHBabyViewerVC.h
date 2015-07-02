//
//  RHBabyViewerVC.h
//  LesEnphants
//
//  Created by Rich Fan on 2015/4/16.
//  Copyright (c) 2015年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHBabyViewerVC : UIViewController <UIPageViewControllerDataSource>

@property ( nonatomic, retain ) IBOutlet UILabel *m_strTitle;
@property ( nonatomic, retain ) IBOutlet UIView *m_pCntView;
@property ( strong, nonatomic) UIPageViewController *pageController;
@property ( readwrite ) NSInteger m_nWeek;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;

@end
