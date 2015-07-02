/**
 *	@file		RHFriendCell.h
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

@interface RHFriendCell : UITableViewCell
{
	UILabel                 *m_pLblName;
    UIImageView				*m_IconImgView;
    NSDictionary            *m_pDataDic;
    
    
}
@property (nonatomic, retain) IBOutlet UILabel                  *m_pLblName;
@property (nonatomic, retain) IBOutlet UIImageView				*m_IconImgView;
@property (nonatomic, retain) NSDictionary                      *m_pDataDic;

- ( void )updateUI;

@end
