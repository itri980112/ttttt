//
//  RHAssociationPostListVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RHAssociationAddPostVC;
@class RHEditAssociationVC;
@class RHAssociationInfoVC;
@class RHAssociationPostDetailVC;
@interface RHAssociationPostListVC : UIViewController
{
    NSString                *m_pstrTitle;
    NSInteger               m_nIdx;
    NSDictionary            *m_pConfigDic;
    BOOL                    m_bIsManager;
    BOOL                    m_bIsMember;
    
    RHAssociationAddPostVC  *m_pRHAssociationAddPostVC;
    RHEditAssociationVC     *m_pRHEditAssociationVC;
    RHAssociationInfoVC     *m_pRHAssociationInfoVC;
    RHAssociationPostDetailVC   *m_pRHAssociationPostDetailVC;
}


@property (strong, nonatomic) IBOutlet UIButton *m_pBtnNew;
@property ( nonatomic, retain ) RHAssociationAddPostVC  *m_pRHAssociationAddPostVC;
@property ( nonatomic, retain ) RHEditAssociationVC     *m_pRHEditAssociationVC;
@property ( nonatomic, retain ) RHAssociationInfoVC     *m_pRHAssociationInfoVC;
@property ( nonatomic, retain ) RHAssociationPostDetailVC   *m_pRHAssociationPostDetailVC;
@property ( nonatomic, retain ) NSDictionary            *m_pConfigDic;
@property (retain, nonatomic) IBOutlet UILabel          *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UITableView      *m_pAssociationListTable;
@property ( nonatomic, retain ) NSString                *m_pstrTitle;
@property NSInteger               m_nIdx;
@property BOOL                    m_bIsManager;

@property (strong, nonatomic) IBOutlet UILabel *m_pLblClassName;
@property (strong, nonatomic) IBOutlet UIImageView *m_pClassImage;
@property (strong, nonatomic) IBOutlet UIImageView *m_pCoverImage;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnJoin;


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressNewPostBtn:(id)sender;
- ( IBAction )pressConfigBtn:(id)sender;
- ( IBAction )pressJoinBtn:(id)sender;
#pragma mark - Public
- ( void )setupData:( NSArray * )pDataArray;

@end
