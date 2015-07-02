//
//  RHAddEventVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/15.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHAddEventVC : UIViewController
{
    NSDate      *m_pSelDate;
}

@property ( nonatomic, retain ) NSDate      *m_pSelDate;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnDate;
@property (retain, nonatomic) IBOutlet UITableView *m_pMainTable;
@property (retain, nonatomic) IBOutlet UISwitch *m_pSwitch1;
@property (retain, nonatomic) IBOutlet UISwitch *m_pswitch2;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblS1;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblS2;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblS3;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblS4;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnConfirm;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:( id )sender;
- ( IBAction )pressCheckDateBtn:( id )sender;
- ( IBAction )pressTimeBtn:( id )sender;
- ( IBAction )pressNotificationBtn:( id )sender;
- ( IBAction )pressAddMemoBtn:( id )sender;
- ( IBAction )pressSubmitBtn:(id)sender;
@end
