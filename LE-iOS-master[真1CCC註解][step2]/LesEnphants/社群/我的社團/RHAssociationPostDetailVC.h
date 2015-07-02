//
//  RHAssociationPostDetailVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/12/15.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHAssociationPostDetailVC : UIViewController
{
    BOOL            m_bCanEdit;
    NSString        *m_pstrAssoID;
}

@property (strong, nonatomic) IBOutlet UIImageView *m_pIocnImageView;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblClass;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblNickName;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblDateTIme;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblMessageCount;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblReportCount;
@property (strong, nonatomic) IBOutlet UILabel *m_plblLikeCount;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnLike;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnComment;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnManage;
@property (strong, nonatomic) IBOutlet UITableView *m_pMainTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *m_pMainScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *m_pMainTF;
@property   BOOL            m_bCanEdit;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblMainCnt;
@property (strong, nonatomic) IBOutlet UITextView *m_pTxtMainCnt;
@property (strong, nonatomic) NSString        *m_pstrAssoID;
@property (strong, nonatomic) IBOutlet UITextField *m_pTFCntText;
@property (strong, nonatomic) IBOutlet UIView *m_pContainerView;
@property (strong, nonatomic) IBOutlet UIView *m_pMainInfoView;
@property (strong, nonatomic) IBOutlet UIView *m_pMainFuncView;
#pragma mark - Public
-( void )setupDataDic:( NSDictionary * )pDic;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressAddImageBtn:(id)sender;
- ( IBAction )pressPostBtn:(id)sender;
- ( IBAction )pressLikeBtn:(id)sender;
- ( IBAction )pressCommentBtn:(id)sender;
- ( IBAction )pressManageBtn:(id)sender;

@end
