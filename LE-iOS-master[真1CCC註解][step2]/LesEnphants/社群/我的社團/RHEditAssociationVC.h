//
//  RHEditAssociationVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHActionSheet.h"

@class RHCreateAssociationPurposeVC;
@class RHAssoMemberMnanageVC;
@interface RHEditAssociationVC : UIViewController
{
    RHCreateAssociationPurposeVC    *m_pRHCreateAssociationPurposeVC;
    NSMutableDictionary             *m_pOldMetaDataDic;
    RHAssoMemberMnanageVC           *m_pRHAssoMemberMnanageVC;
    
}

@property (strong, nonatomic) NSMutableDictionary               *m_pOldMetaDataDic;
@property (strong, nonatomic) RHCreateAssociationPurposeVC      *m_pRHCreateAssociationPurposeVC;
@property (strong, nonatomic) RHAssoMemberMnanageVC           *m_pRHAssoMemberMnanageVC;
@property (strong, nonatomic) IBOutlet UILabel                  *m_pLblClassify;
@property (strong, nonatomic) IBOutlet UILabel                  *m_pLblRegion;
@property (strong, nonatomic) IBOutlet UITextField              *m_pTFName;
@property (strong, nonatomic) IBOutlet UISwitch                 *m_pPrivateSwitch;
@property (strong, nonatomic) IBOutlet UIButton                 *m_pBtnFinish;

@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblHint;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblStartTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblAreaTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblPurposeTItle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblUploadImageTItle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblPublicTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblManagementTitle;

@property (strong, nonatomic) IBOutlet UIImageView *m_pImgPublic;


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressDoneBtn:(id)sender;
- ( IBAction )pressFunBtn1:(id)sender;
- ( IBAction )pressFunBtn2:(id)sender;
- ( IBAction )pressFunBtn3:(id)sender;





#pragma mark - Public


@end
