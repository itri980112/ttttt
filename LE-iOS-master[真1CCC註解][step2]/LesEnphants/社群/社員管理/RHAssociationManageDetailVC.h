//
//  RHAssociationManageDetailVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHAssociationManageDetailVC : UIViewController
{
    NSDictionary        *m_pMainDic;
    BOOL                m_bIsGrant;
    NSString            *m_pstrAssoID;
}

@property   BOOL                m_bIsGrant;
@property (strong, nonatomic) NSDictionary        *m_pMainDic;
@property (strong, nonatomic) NSString            *m_pstrAssoID;
@property (strong, nonatomic) IBOutlet UIImageView *m_pImageView;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblName;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblType;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblWeek;
@property (strong, nonatomic) IBOutlet UISwitch *m_pSwitch;


@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblMemberType;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblBabyWeek;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblCoManagerment;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblDeleteMember;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressSwitchBtn:(id)sender;
- ( IBAction )pressDeleteBtn:(id)sender;

#pragma mark - Public


@end
