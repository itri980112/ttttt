//
//  RHUserGuideVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/17.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHUserGuideVC : UIViewController
{
    
}


@property (retain, nonatomic) IBOutlet UIScrollView *m_pMainScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *m_pPageControl;


#pragma mark - IBAction
- ( IBAction )pressCloseBtn:(id)sender;

@end
