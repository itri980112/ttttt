/**
 *	@file		RHAssociationListCell.h
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

@interface RHAssociationListCell : UITableViewCell
{
    NSDictionary    *m_pMainDic;
    NSInteger       m_nID;
}

@property ( nonatomic, retain ) NSDictionary                        *m_pMainDic;
@property ( nonatomic, retain ) IBOutlet        UIImageView         *m_pIconImgView;
@property ( nonatomic, retain ) IBOutlet        UILabel             *m_pLblCnt;
@property ( nonatomic, retain ) IBOutlet        UIImageView         *m_pStatusImgView;
@property ( nonatomic, retain ) IBOutlet        UILabel             *m_pLblStatus;
@property ( nonatomic, retain ) IBOutlet        UILabel             *m_pLblMember;
@property ( nonatomic, retain ) IBOutlet        UILabel             *m_pLblPosts;
@property ( nonatomic, retain ) IBOutlet        UILabel             *m_pLblLocation;

@property   NSInteger       m_nID;
- ( void )updateUI;

@end
