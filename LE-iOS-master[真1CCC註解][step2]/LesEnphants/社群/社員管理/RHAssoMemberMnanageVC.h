//
//  RHAssociationListVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RHAssociationManageDetailVC;
@interface RHAssoMemberMnanageVC : UIViewController
{
    RHAssociationManageDetailVC     *m_pRHAssociationManageDetailVC;

}


@property (strong, nonatomic) RHAssociationManageDetailVC     *m_pRHAssociationManageDetailVC;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtn_1;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtn_2;
@property (strong, nonatomic) IBOutlet UITableView *m_pMainTableView;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;


#pragma mark - Public
- ( void )setupAssoID:( NSString * )pstrID;


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressBtn_1:(id)sender;
- ( IBAction )pressBtn_2:(id)sender;

@end
