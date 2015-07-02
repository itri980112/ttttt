//
//  RHKnowledgeHomePageVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/24.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RHKnowledgeAdvancedSearhVC;
@class RHKnowledgeListVC;

@interface RHKnowledgeHomePageVC : UIViewController
{
    RHKnowledgeAdvancedSearhVC      *m_pRHKnowledgeAdvancedSearhVC;
    NSMutableArray                  *m_pDataArray;
}

@property (retain, nonatomic) NSMutableArray                  *m_pDataArray;
@property (retain, nonatomic) RHKnowledgeAdvancedSearhVC      *m_pRHKnowledgeAdvancedSearhVC;
@property (retain, nonatomic) IBOutlet UIView *m_pNaviBar;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnMenu;
@property (retain, nonatomic) IBOutlet UITableView *m_pMainTable;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;

//Searhc Menu View

#pragma mark - Customized Methods


#pragma mark - IBAction
- ( IBAction )pressAdvancedBtn:(id)sender;

@end
