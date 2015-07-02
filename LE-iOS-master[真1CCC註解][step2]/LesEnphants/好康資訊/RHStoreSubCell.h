/**
 *	@file		RHStoreSubCell.h
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


@interface RHStoreSubCell : UITableViewCell
{

	UILabel				*m_pLblContent;
    UILabel				*m_pLblAddress;
    BOOL                m_bGovCard;
    BOOL                m_bBabyRoom;
    BOOL                m_bOutlet;
}

@property (nonatomic, retain) IBOutlet UILabel              *m_pLblContent;
@property (nonatomic, retain) IBOutlet UILabel              *m_pLblAddress;
@property (nonatomic, retain) IBOutlet UIImageView			*m_pGovCardImgView;
@property (nonatomic, retain) IBOutlet UIImageView			*m_pBabyRoomImgView;
@property (nonatomic, retain) IBOutlet UIImageView			*m_pOutletImgView;
@property  BOOL                m_bGovCard;
@property  BOOL                m_bBabyRoom;
@property  BOOL                m_bOutlet;


- ( void )updateUI;

@end
