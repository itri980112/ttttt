/**
 *	@file		RHAssociationPostCntCell.h
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

@protocol RHAssociationPostCntCellDelegate <NSObject>

@optional
- ( void )callBackLike:( NSInteger )nIdx;
- ( void )callBackComment:( NSInteger )nIdx;
- ( void )callBackDelete:( NSInteger )nIdx;
- ( void )callBackReport:( NSInteger )nIdx;

@end


@interface RHAssociationPostCntCell : UITableViewCell
{
    NSDictionary    *m_pMainDic;
    BOOL            m_bCanEdit;
}

@property ( assign, nonatomic ) id<RHAssociationPostCntCellDelegate>    delegate;

@property BOOL            m_bCanEdit;
@property ( nonatomic, retain ) NSDictionary                        *m_pMainDic;
@property ( nonatomic, retain ) IBOutlet        UIImageView         *m_pIconImgView;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblClass;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblName;
@property (strong, nonatomic) IBOutlet UILabel *m_plblDatetime;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblComment;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblViolation;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblLite;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblCnt;
@property (strong, nonatomic) IBOutlet UITextView *m_pTxtCnt;

@property (strong, nonatomic) IBOutlet UIButton *m_pBtnLike;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnComment;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnDelete;


- ( void )updateUI;

#pragma mark - IBAction
- ( IBAction )pressLikeBtn:(id)sender;
- ( IBAction )pressCommentBtn:(id)sender;
- ( IBAction )pressDeleteBtn:(id)sender;


@end
