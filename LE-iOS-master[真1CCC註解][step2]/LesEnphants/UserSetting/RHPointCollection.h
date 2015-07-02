//
//  RHPointCollection.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@interface RHPointCollection : UIViewController
{
    MBProgressHUD   *m_pMBProgressHUD;
    BOOL            m_bIsPresent;
}

@property (retain, nonatomic) MBProgressHUD   *m_pMBProgressHUD;
@property (retain, nonatomic) IBOutlet UIImageView *m_pImgView;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnBack;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblID;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblPoint;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblGold;
@property (retain, nonatomic) IBOutlet UIScrollView *m_pMainScrollView;
@property (retain, nonatomic) IBOutlet UIView *m_pCntView;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property   BOOL            m_bIsPresent;
#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressStoreBtn:(id)sender;
- ( IBAction )pressExchangeBtn:(id)sender;
- ( IBAction )pressInfoBtn1:(id)sender;
- ( IBAction )pressInfoBtn2:(id)sender;
@end
