//
//  RHAssociationListVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RHAssociationPostListVC;
@interface RHAssociationListVC : UIViewController
{
    NSString                    *m_pstrTitle;
    NSInteger                   m_nIdx;
    RHAssociationPostListVC     *m_pRHAssociationPostListVC;
}
@property (retain, nonatomic) RHAssociationPostListVC     *m_pRHAssociationPostListVC;
@property (retain, nonatomic) IBOutlet UILabel          *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UITableView      *m_pAssociationListTable;
@property ( nonatomic, retain ) NSString                *m_pstrTitle;
@property NSInteger               m_nIdx;


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;

#pragma mark - Public
- ( void )setupData:( NSArray * )pDataArray;

@end
