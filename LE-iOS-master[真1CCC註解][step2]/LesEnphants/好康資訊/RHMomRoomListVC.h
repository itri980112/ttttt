//
//  RHMomRoomListVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/17.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"


@interface RHMomRoomListVC : UIViewController <SKSTableViewDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet SKSTableView *m_pMainTable;

- ( void )setupData:( NSArray * )pArray;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
@end
