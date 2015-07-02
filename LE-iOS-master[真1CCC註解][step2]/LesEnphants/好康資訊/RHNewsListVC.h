//
//  RHNewsListVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/24.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@interface RHNewsListVC : UIViewController
{
    NSString    *m_pstrTitle;
    NSInteger   m_nType;
    
    MBProgressHUD           *m_pMBProgressHUD;
    
    NSArray          *m_pDataArray;
}

@property ( nonatomic, retain ) NSArray          *m_pDataArray;
@property ( nonatomic, retain ) MBProgressHUD           *m_pMBProgressHUD;
@property ( nonatomic, retain ) NSString    *m_pstrTitle;
@property  NSInteger   m_nType;

@property (retain, nonatomic) IBOutlet UIView *m_pNaviBar;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnMenu;

@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;

@property (retain, nonatomic) IBOutlet UITableView *m_pMainTableView;


#pragma mark - Customized Methods


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;

@end
