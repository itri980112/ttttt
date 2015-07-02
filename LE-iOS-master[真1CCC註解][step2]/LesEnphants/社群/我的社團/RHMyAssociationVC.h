//
//  RHMyAssociationVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RHCreateAssociationVC;
@class RHAssociationPostListVC;

@interface RHMyAssociationVC : UIViewController
{

    RHCreateAssociationVC       *m_pRHCreateAssociationVC;
    RHAssociationPostListVC     *m_pRHAssociationPostListVC;
}

@property ( nonatomic, retain ) RHCreateAssociationVC       *m_pRHCreateAssociationVC;
@property ( nonatomic, retain ) RHAssociationPostListVC     *m_pRHAssociationPostListVC;
@property (strong, nonatomic) IBOutlet UITableView          *m_pCreatedTable;
@property (strong, nonatomic) IBOutlet UITableView          *m_pJoinedTable;
@property (strong, nonatomic) IBOutlet UIScrollView         *m_pMainScrollView;
@property (strong, nonatomic) IBOutlet UIView               *m_pCreatedView;
@property (strong, nonatomic) IBOutlet UIView               *m_pJoinedView;

@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblMine;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblJoin;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressAddBtn:(id)sender;

#pragma mark - Public
- ( void )setupData:( NSArray * )pCreatedArray Join:( NSArray * )pJoinedArray;

@end
