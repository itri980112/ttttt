/**
 *	@file		MenuCell.h
 *	@brief		Declaration Customize Table Cell
 *	@author     Rusty Huang
 *	@version	0.1
 *	@date		2012/03/15
 *	@warning	Copyright by Rusty Huang
 *
 *
 *	Update History:\n
 *	2012/03/15 Rusty Huang Version 1.0 is created
 *
 *
**/

#import <UIKit/UIKit.h>


@interface MenuCell : UITableViewCell
{
	UIImageView			*m_pIconImageView;
	UILabel				*m_pLblContent;		

}
@property (nonatomic, retain) IBOutlet UIImageView      *m_pIconImageView;
@property (nonatomic, retain) IBOutlet UILabel			*m_pLblContent;


@end
