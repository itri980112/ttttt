//
//  RHKnowledgeListVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/1.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHKnowledgeListVC : UIViewController
{
    NSArray          *m_pDataArray;
    NSString         *m_pstrTitle;
}

@property (retain, nonatomic) NSString         *m_pstrTitle;
@property (retain, nonatomic) NSArray          *m_pDataArray;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (retain, nonatomic) IBOutlet UITableView *m_pMainTable;


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;

@end
