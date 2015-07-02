//
//  RHWebViewVC.h
//  iPolice
//
//  Created by Rusty Huang on 2014/9/2.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@interface RHWebViewVC : UIViewController
{
    NSString    *m_pstrTitle;
    NSString    *m_pstrURL;
    
    
    MBProgressHUD       *m_pMBProgressHUD;
}

@property (retain, nonatomic) IBOutlet UIView *m_pNaviBar;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnMenu;

@property ( nonatomic, retain ) MBProgressHUD       *m_pMBProgressHUD;
@property ( nonatomic, retain ) NSString            *m_pstrTitle;
@property ( nonatomic, retain ) NSString            *m_pstrURL;
@property (retain, nonatomic) IBOutlet UIWebView    *m_pMainWebView;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:( id )sender;

@end
