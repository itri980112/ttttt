/**
 *	@file		RHAppListCell.h
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



@protocol RHAppListCellDelegate <NSObject>

@optional
- ( void )callBackSelectedTag:( NSInteger )nIdx;

@end

@interface RHAppListCell : UITableViewCell
{
	UILabel				*m_pLblContent;
    id<RHAppListCellDelegate>   delegate;
    NSDictionary        *m_pDataDic;
}
@property (nonatomic, retain) NSDictionary        *m_pDataDic;
@property ( nonatomic, assign ) id<RHAppListCellDelegate>   delegate;
@property (nonatomic, retain) IBOutlet UILabel			*m_pLblContent;
@property (retain, nonatomic) IBOutlet UIImageView *m_pIconView;

- ( void )setupDataDic:( NSDictionary * )pDataDic;
- ( IBAction )pressDownloadBtn:(id)sender;
- ( void )updateUI;

@end
