//
//  RHAppListVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/17.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHAppListVC : UIViewController
{
    
}
@property (retain, nonatomic) IBOutlet UITableView *m_pMainTable;

- ( void )setupData:( NSArray * )pArray;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;

@end
