//
//  RHAddEventVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/15.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHAddEventVC.h"
#import "RHAppDelegate.h"
#import "CustomIOS7AlertView.h"
#import "LesEnphantsApiDefinition.h"
#import "RHLesEnphantsAPI.h"
#import "RHActionSheet.h"
#import "GoldCoinAnimationVC.h"
#import "RHProfileObj.h"

@interface RHAddEventVC () < UIActionSheetDelegate, RHActionSheetDelegate, UITableViewDataSource, UITableViewDelegate >
{
    UIDatePicker        *m_pTimePicker;
    NSDate              *m_pSelTime;
    BOOL                m_bIsPrenantal;
    BOOL                m_bIsNotification;
    NSMutableArray      *m_pEventArray;
    NSString            *m_pstrEventID;
}
@property ( nonatomic, retain ) NSString            *m_pstrEventID;
@property ( nonatomic, retain ) NSMutableArray             *m_pEventArray;
@property ( nonatomic, retain ) UIDatePicker        *m_pTimePicker;
@property ( nonatomic, retain ) NSDate              *m_pSelTime;
- ( NSString * )getTimeFromDate:( NSDate * )pDate;
- ( NSString * )getDateFromDate:( NSDate * )pDate;
- ( void )submitToServer;
- ( void )updateToServer;
- ( void )getTodayEventData;
@end

@implementation RHAddEventVC
@synthesize m_pSelDate;
@synthesize m_pTimePicker;
@synthesize m_pSelTime;
@synthesize m_pEventArray;
@synthesize m_pstrEventID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initializations
        self.m_pTimePicker = nil;
        self.m_pSelTime = [NSDate date];
        m_bIsPrenantal = NO;
        m_bIsNotification = NO;
        self.m_pEventArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pstrEventID = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.m_pLblS1 setText:NSLocalizedString(@"LE_PREG_S1", nil)];
    [self.m_pLblS2 setText:NSLocalizedString(@"LE_PREG_S2", nil)];
    [self.m_pLblS3 setText:NSLocalizedString(@"LE_PREG_S3", nil)];
    [self.m_pLblS4 setText:NSLocalizedString(@"LE_PREG_S4", nil)];
    
    [self.m_pBtnConfirm setTitle:NSLocalizedString(@"LE_COMMON_CONFIRM", nil) forState:UIControlStateNormal];
    
    
    [self.m_pLblTitle setText:[self getDateFromDate:m_pSelDate]];
    
    [self.m_pBtnDate setTitle:[self getTimeFromDate:m_pSelTime] forState:UIControlStateNormal];

    //get 當天的資料
    [self getTodayEventData];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_m_pLblTitle release];
    [m_pTimePicker release];
    [_m_pBtnDate release];
    [m_pEventArray release];
    [_m_pMainTable release];
    
    [_m_pSwitch1 release];
    [_m_pswitch2 release];
    [super dealloc];
}

#pragma mark - Private Methods
- ( void )getTodayEventData
{
    NSTimeInterval kStartTimeInterval = [m_pSelDate timeIntervalSince1970];
    NSTimeInterval kEndTImeInterval = kStartTimeInterval + ( 24 * 60 * 60);//取一天的Range
    NSString *pstrSearchKey = [NSString stringWithFormat:@"[%.0f,%.0f]", kStartTimeInterval, kEndTImeInterval];
    NSLog(@"pstrSearchKey = %@", pstrSearchKey);
    
    
    
    //Load Event
    [RHAppDelegate showLoadingHUD];
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:@"1" forKey:kFilter];
    [pParameter setObject:pstrSearchKey forKey:kKeyWord];
    
    [RHLesEnphantsAPI getPregnantEvent:pParameter Source:self];

}


- ( NSString * )getTimeFromDate:( NSDate * )pDate
{
    NSLog(@"pDate = %@", [pDate description]);
    
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"aa KK:mm"];
    
    NSString *pstrDateString = [pFormatter stringFromDate:pDate];
    [pFormatter release];
    
    return pstrDateString;
}

- ( NSString * )getSbumitTimeFromDate:( NSDate * )pDate
{
    NSLog(@"pDate = %@", [pDate description]);
    
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"HH:mm:ss"];
    
    NSString *pstrDateString = [pFormatter stringFromDate:pDate];
    [pFormatter release];
    
    return pstrDateString;
}

- ( NSString * )getDateFromDate:( NSDate * )pDate
{
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    
    [pFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *pstr = [pFormatter stringFromDate:pDate];
    
    [pFormatter release];
    
    return pstr;
}

- ( NSString * )getSubmitDateFromDate:( NSDate * )pDate
{
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    
    [pFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *pstr = [pFormatter stringFromDate:pDate];
    
    [pFormatter release];
    
    return pstr;
}

- ( void )updateToServer
{
    //更新
    NSString *pstrDate = [self getSubmitDateFromDate:m_pSelDate];
    NSString *pstrTime = [self getSbumitTimeFromDate:m_pSelTime];
    NSString *pstrIsPrenantal = [NSString stringWithFormat:@"%ld", (NSInteger)[self.m_pSwitch1 isOn]];//CCC try
    NSString *pstrIsNotification = [NSString stringWithFormat:@"%ld", (long)((NSInteger)[self.m_pswitch2 isOn])];//CCC try
    
    NSString *pstrSubject = @"[";
    
    for ( NSInteger i = 0;  i < [m_pEventArray count]; ++i )
    {
        pstrSubject = [pstrSubject stringByAppendingFormat:@"\"%@\"", [m_pEventArray objectAtIndex:i]];
        
        if ( i == ([m_pEventArray count] - 1 ) )
        {
            //最後一筆
            pstrSubject = [pstrSubject stringByAppendingString:@"]"];
        }
        else
        {
            pstrSubject = [pstrSubject stringByAppendingString:@","];
        }
    }
    
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:m_pstrEventID forKey:kEnventID];
    [pParameter setObject:pstrIsPrenantal forKey:kIsPrenatalExamination];
    [pParameter setObject:pstrDate forKey:kDate];
    [pParameter setObject:pstrTime forKey:kStart];
    [pParameter setObject:pstrTime forKey:kEnd];
    [pParameter setObject:pstrSubject forKey:kNote];
    [pParameter setObject:pstrIsNotification forKey:kEnablePush];
    
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI updateEvent:pParameter Source:self];
}

- ( void )submitToServer
{
    NSString *pstrDate = [self getSubmitDateFromDate:m_pSelDate];
    NSString *pstrTime = [self getSbumitTimeFromDate:m_pSelTime];
    NSString *pstrIsPrenantal = [NSString stringWithFormat:@"%ld", (long)((NSInteger)m_bIsPrenantal)];//CCC try
    NSString *pstrIsNotification = [NSString stringWithFormat:@"%ld", (long)((NSInteger)m_bIsNotification)];//CCC try
    
     NSString *pstrSubject = @"[";
    
    for ( NSInteger i = 0;  i < [m_pEventArray count]; ++i )
    {
        pstrSubject = [pstrSubject stringByAppendingFormat:@"\"%@\"", [m_pEventArray objectAtIndex:i]];
        
        if ( i == ([m_pEventArray count] - 1 ) )
        {
            //最後一筆
            pstrSubject = [pstrSubject stringByAppendingString:@"]"];
        }
        else
        {
            pstrSubject = [pstrSubject stringByAppendingString:@","];
        }
    }

    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:pstrIsPrenantal forKey:kIsPrenatalExamination];
    [pParameter setObject:pstrDate forKey:kDate];
    [pParameter setObject:pstrTime forKey:kStart];
    [pParameter setObject:pstrTime forKey:kEnd];
    [pParameter setObject:pstrSubject forKey:kNote];
    [pParameter setObject:pstrIsNotification forKey:kEnablePush];
    
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI addPregnantEvent:pParameter Source:self];
    
}

#pragma mark - ShowAnimation
- (void)showAnimation:(NSInteger)point
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType != 1 ) return;
    
    // 得到金幣,顯示動畫
    if (point >= kShowAnimationMinimumPoint) {
        GoldCoinAnimationVC *vc = nil;
        if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC~ipad" bundle:nil];
        }
        else {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC" bundle:nil];
        }
        
        vc.m_getPoint = point;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:^{
            [vc startAnimation];
        }];
    }
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:( id )sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressCheckDateBtn:( id )sender
{
    UISwitch *pSwitch = ( UISwitch * )sender;
    
    m_bIsPrenantal = [pSwitch isOn];
}

- ( IBAction )pressTimeBtn:( id )sender
{
    NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
    
    
    RHActionSheet *sheet = [[RHActionSheet alloc] initWithTitle: title
                                                       delegate: self
                                              cancelButtonTitle: @"確定"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet showInView: [[RHAppDelegate sharedDelegate] window]];
    [sheet release];
    
    if ( m_pTimePicker == nil )
    {
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0,0, 320, 216)];
        self.m_pTimePicker = picker;
        [picker release];
        
        
        NSLocale   *temp_locale=[[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];//CCC try
        m_pTimePicker.locale =temp_locale;//CCC try
        [temp_locale release];//CCC try
        //m_pTimePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];//CCC try
        //m_pTimePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        m_pTimePicker.datePickerMode = UIDatePickerModeTime;
    }
    
    [sheet addSubview: self.m_pTimePicker];
}

- ( IBAction )pressNotificationBtn:( id )sender
{
    UISwitch *pSwitch = ( UISwitch * )sender;
    
    m_bIsNotification = [pSwitch isOn];
}

- ( IBAction )pressAddMemoBtn:( id )sender
{
    __block NSString *pstrInputText = @"";
    
    CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
    CGFloat screenWidth = MIN(applicationFrame.size.width, applicationFrame.size.height);
    
    UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth*0.65, 100)] autorelease];
    [pView setBackgroundColor:[UIColor lightGrayColor]];
    
    
    UILabel *pLblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth*0.65, 40)] autorelease];
    [pLblTitle setTextAlignment:NSTextAlignmentCenter];
    [pLblTitle setTextColor:[UIColor blackColor]];
    [pLblTitle setText:@"新增備忘錄"];
    
    UITextField *pTxtView = [[[UITextField alloc] initWithFrame:CGRectMake(10, 50, screenWidth*0.65-20, 40)] autorelease];
    [pTxtView setBorderStyle:UITextBorderStyleRoundedRect];
    
    [pView addSubview:pLblTitle];
    [pView addSubview:pTxtView];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    //        alertView.tag = kVisitTag;
    // Add some custom content to the alert view
    [alertView setContainerView:pView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"確認", nil]];
    
    [alertView show];
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex)
     {
         
         NSLog(@"Block: Button at position %ld is clicked on alertView %ld.", (long)buttonIndex,(long)[alertView tag]);//CCC try
         
         if (buttonIndex == 0)
         {
             [alertView close];
         }
         else if (buttonIndex == 1)
         {
             pstrInputText = [pTxtView text];
             [self.m_pEventArray addObject:pstrInputText];
             [self.m_pMainTable reloadData];
             [alertView close];
         }
         
     }];

}

- ( IBAction )pressSubmitBtn:(id)sender
{
    if ( m_pstrEventID )
    {
        [self updateToServer];
    }
    else
    {
        [self submitToServer];
    }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.m_pSelTime = m_pTimePicker.date;
    [self.m_pBtnDate setTitle:[self getTimeFromDate:m_pSelTime] forState:UIControlStateNormal];
}

#pragma mark - LesEnphantsAPI Delegate
- ( void )callBackAddPregnantEventStatus:( NSDictionary * )pStatusDic
{
    NSLog(@"callBackAddPregnantEventStatus = %@", pStatusDic);
    
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [RHAppDelegate MessageBox:@"新增成功"];
        
        NSInteger point = [[pStatusDic objectForKey:@"Point"] integerValue];
        [self showAnimation:point];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%ld",(long)nError]];//CCC try
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    
    [RHAppDelegate hideLoadingHUD];
    
}

- ( void )callBackUpdateEventStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        //[RHAppDelegate MessageBox:@"更新成功"];
        [self pressBackBtn:nil];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%ld",(long)nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackUpdateNotesStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        //[RHAppDelegate MessageBox:@"更新成功"];
        [self pressBackBtn:nil];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%ld",(long)nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    
    [RHAppDelegate hideLoadingHUD];
}

#pragma mark -
- ( void )callBackGetPregnantEventStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSArray *pEventArray = [pStatusDic objectForKey:@"event"];
        if ( [pEventArray count] > 0 )
        {
            NSDictionary *pDic = [pEventArray objectAtIndex:0];
            self.m_pstrEventID = [pDic objectForKey:@"id"];
            
            BOOL isPrenatalExamination = [[pDic objectForKey:@"isPrenatalExamination"] boolValue];
            [self.m_pSwitch1 setOn:isPrenatalExamination];
            
            
            BOOL isEnablePush = [[pDic objectForKey:@"enablePush"] boolValue];
            [self.m_pswitch2 setOn:isEnablePush];
            
            
            //NSString *pstrTime = [pDic objectForKey:@"start"];
            
            NSString *pstrDateTime = [NSString stringWithFormat:@"%@ %@", [pDic objectForKey:@"date"], [pDic objectForKey:@"start"]];
            
            NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
            [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            self.m_pSelTime = [pFormatter dateFromString:pstrDateTime];
            self.m_pSelDate = [pFormatter dateFromString:pstrDateTime];
            [pFormatter release];//CCC try
            [self.m_pBtnDate setTitle:[self getTimeFromDate:m_pSelTime] forState:UIControlStateNormal];
            
            NSArray * pstrEventArray = [pDic objectForKey:@"notes"];
            
            self.m_pEventArray = [NSMutableArray arrayWithArray:pstrEventArray];
            
            //self.m_pEventArray = [pStatusDic objectForKey:@"event"];
            [self.m_pMainTable reloadData];

        }
        
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%ld",(long)nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

#pragma mark - UItableView
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = [m_pEventArray count];
    
    
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

    }
    
    // Configure the cell...
    
    NSUInteger nRow = [indexPath row];
    
    
    NSString *pstr = [m_pEventArray objectAtIndex:nRow];
    [cell.textLabel setText:pstr];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
    
}

// TableView Cell Delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //判斷編輯表格的類型為「刪除」
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //刪除對應的陣列元素
        //[[heroicaArray objectAtIndex:indexPath.section]removeObjectAtIndex:indexPath.row];
        [m_pEventArray removeObjectAtIndex:indexPath.row];
        
        //刪除對應的表格項目
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        //如果該分類已沒有任何項目則刪除整個分類
        //if ([[heroicaArray objectAtIndex:indexPath.section] count] == 0) {
            //[heroicaArray removeObjectAtIndex:indexPath.section];
            //[tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        //}
    }
}


@end
