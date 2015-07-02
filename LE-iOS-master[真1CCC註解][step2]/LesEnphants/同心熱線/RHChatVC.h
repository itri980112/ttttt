//
//  RHChatVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/10/23.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHChatVC : UIViewController
{
    NSDictionary    *m_pDataDic;
}


@property (strong, nonatomic) NSDictionary    *m_pDataDic;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblName;
@property (strong, nonatomic) IBOutlet UIImageView *m_pIconImageView;
@property (strong, nonatomic) IBOutlet UITableView *m_pMainTableView;
@property (strong, nonatomic) IBOutlet UITextField *m_pTFChat;
@property (strong, nonatomic) IBOutlet UIView *m_pInputBar;
@property (strong, nonatomic) IBOutlet UIView *m_pContainerView;
@property (strong, nonatomic) IBOutlet UIScrollView *m_pEmotionScrollView;
@property (strong, nonatomic) IBOutlet UIView *m_pEmotionBgView;
@property (strong, nonatomic) IBOutlet UIPageControl *m_pEmotionPageCtrl;


#pragma mark - Customized Methods
- ( void )setupDataDic:( NSDictionary *)pDic;



#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressAddStickerBtn:(id)sender;
- ( IBAction )pressSendBtn:(id)sender;

@end
