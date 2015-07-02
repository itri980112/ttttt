//
//  RHShareViewerVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageView;
@interface RHShareViewerVC : UIViewController

@property ( nonatomic, retain ) IBOutlet UILabel     *m_pCntTitle;
@property ( nonatomic, retain ) IBOutlet UIImageView *m_pCntView;
@property ( nonatomic, retain ) IBOutlet UIView      *m_pBottomView;
@property ( nonatomic, retain ) IBOutlet UIButton    *m_pBtniOS;
@property ( nonatomic, retain ) IBOutlet UIButton    *m_pBtnAndroid;
#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressiOSBtn:(id)sender;
- ( IBAction )pressAndroidBtn:(id)sender;

@end
