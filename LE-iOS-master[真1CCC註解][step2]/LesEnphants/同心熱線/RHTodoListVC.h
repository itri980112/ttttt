//
//  RHTodoListVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/10/1.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHTodoListVC : UIViewController
{
    NSMutableArray      *m_pDataArray;
}

@property ( nonatomic, retain ) NSMutableArray      *m_pDataArray;
@property ( nonatomic, retain ) IBOutlet    UITableView     *m_pMainTableView;
@property ( nonatomic, retain ) IBOutlet    UITextField     *m_pTFInputTodo;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
@end
