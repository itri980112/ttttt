//
//  RHAssociationInfoVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHActionSheet.h"

@class RHCreateAssociationPurposeVC;

@interface RHAssociationInfoVC : UIViewController
{
    RHCreateAssociationPurposeVC    *m_pRHCreateAssociationPurposeVC;
    NSDictionary                    *m_pOldMetaDataDic;
    
}

@property (strong, nonatomic) NSDictionary                    *m_pOldMetaDataDic;
@property (strong, nonatomic) RHCreateAssociationPurposeVC      *m_pRHCreateAssociationPurposeVC;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblMemberCount;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblMemberCountTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblPostCount;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblPostCountTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblArea;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblAreaTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblStarTitle;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnStar;


@property (strong, nonatomic) IBOutlet UIView *m_pJoinView;
@property (strong, nonatomic) IBOutlet UIView *m_pReportView;
@property (strong, nonatomic) IBOutlet UIImageView *m_pJoinIcon;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblJoinText;



@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblPurposeTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblReportTItle;



#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressPromoteBtn:(id)sender;
- ( IBAction )pressFunBtn1:(id)sender;

- ( IBAction )pressFunBtn2:(id)sender;
- ( IBAction )pressReportBtn:(id)sender;




#pragma mark - Public


@end
