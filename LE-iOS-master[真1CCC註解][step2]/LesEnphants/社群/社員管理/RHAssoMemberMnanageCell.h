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

typedef enum
{
    MEMBER_TYPE_PEDDING = 0,
    MEMBER_TYPE_MEMBER = 1,
    MEMBER_TYPE_MANAGER = 2
    
}ENUM_MEMEBER_TYPE;


@interface RHAssoMemberMnanageCell : UITableViewCell
{
    NSDictionary        *m_pMainDic;
    NSInteger           m_nID;
    ENUM_MEMEBER_TYPE   m_enumMemberType;
    BOOL                m_bHasGrant;
}

@property ( nonatomic, retain ) NSDictionary                        *m_pMainDic;
@property ( nonatomic, retain ) IBOutlet        UIImageView         *m_pIconImgView;
@property ( nonatomic, retain ) IBOutlet        UILabel             *m_pLblCnt;
@property ( nonatomic, retain ) IBOutlet        UIButton            *m_pFunBtn;


@property   NSInteger           m_nID;
@property   ENUM_MEMEBER_TYPE   m_enumMemberType;
@property   BOOL                m_bHasGrant;
- ( void )updateUI;

@end
