//
//  RHRegisterHint.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/14.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface RHRegisterHint : UIViewController
{
    MBProgressHUD           *m_pMBProgressHUD;
}

#pragma mark - IBAction
- ( IBAction )pressCloseBtn:(id)sender;
- ( IBAction )pressEmailLoginBtn:(id)sender;
- ( IBAction )pressFBLoginBtn:(id)sender;

@end
