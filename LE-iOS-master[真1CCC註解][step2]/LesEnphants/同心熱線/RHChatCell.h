/**
 *	@file		RHChatCell.h
 *	@brief		Declaration Customize Table Cell
 *	@author     Rusty Huang
 *	@version	0.1
 *	@date		2014/09/04
 *	@warning	Copyright by Rusty Huang
 *
 *
 *	Update History:\n
 *	2014/09/04 Rusty Huang Version 1.0 is created
 *
 *
**/

#import <UIKit/UIKit.h>

@interface RHChatCell : UITableViewCell
{
    NSDictionary    *m_pMainDic;
    
}

@property ( nonatomic, retain ) NSDictionary                    *m_pMainDic;
@property ( nonatomic, retain ) IBOutlet        UIImageView        *m_pStatusImgView;
@property ( nonatomic, retain ) IBOutlet        UILabel         *m_pLblCnt;
@property ( nonatomic, retain ) IBOutlet        UILabel         *m_pLblTime;

- ( void )updateUI;

@end
