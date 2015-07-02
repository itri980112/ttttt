//
//  RHPregnantMemoVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHLineMainVC.h"
#import "RevealController.h"
#import "RHEventHandler.h"
#import "RHMoodVC.h"
#import "RHAppDelegate.h"
#import "RHFriendCell.h"
#import "RHProfileObj.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "AsyncImageView.h"
#import "RHTodoCell.h"
#import "RHTodoListVC.h"
#import "RHChatVC.h"
#import "RHSQLManager.h"
#import "RHChatCell.h"
#import "GoldCoinAnimationVC.h"


static     BOOL g_SelIdx[7] = {0,0,0,0,0,0,0};
static     NSString *g_pstrSelString[7] = {@"日",@"一",@"二",@"三",@"四",@"五",@"六"};
@interface RHLineMainVC ( InternalMethods )
- ( void )switchToTab1;
- ( void )switchToTab2;
- ( void )switchToTab3;
- ( void )switchToTab4;
- ( void )closeAllSubViews;
- ( void )showQrCodeReader;
- ( void )showAlarmView;
- ( void )hideAlarmView;
- ( void )updateAlertData;
@end

@implementation RHLineMainVC
@synthesize m_pFriendDataArray;
@synthesize m_pToDoListArray;
@synthesize m_bForeceToTodoList;
@synthesize m_pChatList;
@synthesize m_pRHChatVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pFriendDataArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pToDoListArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pChatList = [NSMutableArray arrayWithCapacity:1];
        m_bForeceToTodoList = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //多國
    [self.m_pLblTab2 setText:NSLocalizedString(@"LE_LINE_MAIN_TAB2", nil)];
    [self.m_pLblTab3 setText:NSLocalizedString(@"LE_LINE_MAIN_TAB3", nil)];
    [self.m_pLblTab4 setText:NSLocalizedString(@"LE_LINE_MAIN_TAB4", nil)];
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_LINE_MAIN_TITLE", nil)];
    [self.m_pLblInputID setText:NSLocalizedString(@"LE_LINE_MAIN_INPUTID", nil)];
    [self.m_pLblMyQRCode setText:NSLocalizedString(@"LE_LINE_MAIN_MYQR", nil)];
    [self.m_pLblFa1 setText:NSLocalizedString(@"LE_LINE_MAIN_FA1", nil)];
    [self.m_pLblFa2 setText:NSLocalizedString(@"LE_LINE_MAIN_FA2", nil)];
    [self.m_pLblFa3 setText:NSLocalizedString(@"LE_LINE_MAIN_FA3", nil)];
    [self.m_pLblAddTodo setText:NSLocalizedString(@"LE_LINE_MAIN_ADDTODO", nil)];
    [self.m_pBtnConfirm setTitle:NSLocalizedString(@"LE_COMMON_CONFIRM", nil) forState:UIControlStateNormal];
    [self.m_pBtnMoodBtn setTitle:NSLocalizedString(@"LE_LINE_MAIN_MOOD", nil) forState:UIControlStateNormal];
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processRecieveNewMsg:) name:kReceiveRemoteMsg object:nil];
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.m_pNaviBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    [navigationBarPanGestureRecognizer release];//CCC try
	NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    [self.m_pBtnMenu addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    //判斷身份
    
    //判斷是Father Or Mother
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj.m_nType == 1 )
    {
        //Mother
        [self.m_pLblTab1 setText:NSLocalizedString(@"LE_LINE_MAIN_TAB1", nil)];
    }
    else if ( pObj.m_nType == 2 )
    {
        //Father
        [self.m_pLblTab1 setText:NSLocalizedString(@"LE_LINE_MAIN_TAB1-1", nil)];
        [self.m_pBtnTab1 setImage:[UIImage imageNamed:@"同心熱線_tab05"]
                         forState:UIControlStateNormal];
        [self.m_pBtnTab1 setImage:[UIImage imageNamed:@"同心熱線_tab05_feedback"]
                         forState:UIControlStateSelected];
    }
    else
    {
        //Other
        [self.m_pBtnTab3 setHidden:YES];
        [self.m_pLblTodo setHidden:YES];
        [self.m_pBtnMoodBtn setHidden:YES];
        
        // 修改按鈕寬度
        NSArray *btnArray = [NSArray arrayWithObjects:self.m_pBtnTab1, self.m_pBtnTab2, self.m_pBtnTab4, nil];
        NSArray *lblArray = [NSArray arrayWithObjects:self.m_pLblTab1, self.m_pLblTab2, self.m_pLblTab4, nil];
        CGFloat width = self.view.frame.size.width / btnArray.count;
        
        for (int i = 0; i<btnArray.count; i++) {
            UIButton *btn = btnArray[i];
            UILabel *lbl = lblArray[i];
            
            CGRect btnFrame = btn.frame;
            btnFrame.origin.x = width * i;
            btnFrame.size.width = width;
            btn.frame = btnFrame;
            
            CGRect lblFrame = lbl.frame;
            lblFrame.origin.x = width * i;
            lblFrame.size.width = width;
            lbl.frame = lblFrame;
        }
        
    }

    
    if ( m_bForeceToTodoList )
    {
        [self switchToTab3];
    }
    else
    {
        [self switchToTab1];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if ( [self.m_pBtnTab3 isSelected] )
    {
        //Load ToDo List
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:@"1" forKey:kFilter];
        [pParameter setObject:@"[0, 1700000000]" forKey:kKeyWord];
        
        
        [RHAppDelegate showLoadingHUD];
        [RHLesEnphantsAPI GetTodoList:pParameter Source:self];
    }
    
    if ( [self.m_pBtnTab1 isSelected] )
    {
        [self.m_pTFNotifyMSG setText:[RHAppDelegate getFatherAsk]];
    }
}

- (void)dealloc
{
    [_m_pBtnMenu release];
    [_m_pNaviBar release];
    [_m_pBtnTab1 release];
    [_m_pBtnTab2 release];
    [_m_pBtnTab3 release];
    [_m_pBtnTab4 release];
    [_m_pPairView release];
    [_m_pPairTFID release];
    [_m_pPairQrCodeView release];
    [_m_pCntScrollView release];
    [_m_pFriendTableView release];
    [_m_pFriendView release];
    [_m_pSettingView release];
    [_m_pTodoView release];
    [_m_pTodoTable release];
    [_m_pTodoFuncView release];
    [m_pToDoListArray release];
    [_m_pSwitchNotifyMother release];
    [_m_pTFNotifyMSG release];
    [_m_pSwitchAlarm release];
    [_m_pLblAlert release];
    [_m_pBtnDate0 release];
    [_m_pBtnDate1 release];
    [_m_pBtnDate2 release];
    [_m_pBtnDate3 release];
    [_m_pBtnDate4 release];
    [_m_pBtnDate5 release];
    [_m_pBtnDate6 release];
    [_m_pBtnConfirm release];
    [_m_pDatePicker release];
    [_m_pAlertView release];
    [super dealloc];
}


#pragma mark - Private Methods
- ( void )switchToTab1
{
    [self.m_pBtnTab1 setSelected:YES];
    [self.m_pBtnTab2 setSelected:NO];
    [self.m_pBtnTab3 setSelected:NO];
    [self.m_pBtnTab4 setSelected:NO];
    
    
    //Close other Views
    [self closeAllSubViews];
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj.m_nType == 1 )
    {
        //Mother
        if ( self.m_pFriendView )
        {
            [self.m_pCntScrollView addSubview:self.m_pFriendView];
            [self.m_pFriendView setFrame:CGRectMake(0, 0, self.m_pCntScrollView.frame.size.width, self.m_pCntScrollView.frame.size.height)];
            [self.m_pCntScrollView setContentSize:self.m_pFriendView.frame.size];
            
            //Get Profile for friends
            [RHAppDelegate showLoadingHUD];
            [RHLesEnphantsAPI getUserProfile:nil Source:self];
            
            
        }
    }
    else if ( pObj.m_nType == 2 )
    {
        //Father
        NSString *pstr = [RHAppDelegate getFatherAsk];
        if ( pstr )
        {
            [self.m_pTFNotifyMSG setText:pstr];
        }
        
        
        [self.m_pBtnMenu setTitle:@"問候設定" forState:UIControlStateNormal];
        if ( self.m_pSettingView )
        {
            [self.m_pCntScrollView addSubview:self.m_pSettingView];
            [self.m_pSettingView setFrame:CGRectMake(0, 0, self.m_pCntScrollView.frame.size.width, self.m_pCntScrollView.frame.size.height)];
            [self.m_pCntScrollView setContentSize:self.m_pSettingView.frame.size];
            [self updateAlertData];
        }
    }
    else if ( pObj.m_nType == 4 )
    {
        //Other
        if ( self.m_pFriendView )
        {
            [self.m_pCntScrollView addSubview:self.m_pFriendView];
            [self.m_pFriendView setFrame:CGRectMake(0, 0, self.m_pCntScrollView.frame.size.width, self.m_pCntScrollView.frame.size.height)];
            [self.m_pCntScrollView setContentSize:self.m_pFriendView.frame.size];
            
            //Get Profile for friends
            [RHAppDelegate showLoadingHUD];
            [RHLesEnphantsAPI getUserProfile:nil Source:self];
            
            
        }
    }
}
- ( void )switchToTab2
{
    [self.m_pBtnTab1 setSelected:NO];
    [self.m_pBtnTab2 setSelected:YES];
    [self.m_pBtnTab3 setSelected:NO];
    [self.m_pBtnTab4 setSelected:NO];
    
    // 更新親友名單 (bug issue)
    [RHLesEnphantsAPI getUserProfile:nil Source:self];

    NSArray *pArray = [[RHSQLManager instance] getChatList];
    
    self.m_pChatList = [NSMutableArray arrayWithArray:pArray];
    
    //Close other Views
    [self closeAllSubViews];
    
    [self.m_pCntScrollView addSubview:self.m_pChatView];
    [self.m_pChatView setFrame:CGRectMake(0, 0, self.m_pCntScrollView.frame.size.width, self.m_pCntScrollView.frame.size.height)];
    [self.m_pCntScrollView setContentSize:self.m_pChatView.frame.size];
    [self.m_pChatTable reloadData];
}
- ( void )switchToTab3
{
    [self.m_pBtnTab1 setSelected:NO];
    [self.m_pBtnTab2 setSelected:NO];
    [self.m_pBtnTab3 setSelected:YES];
    [self.m_pBtnTab4 setSelected:NO];
    
    //Close other Views
    [self closeAllSubViews];
    
    
    if ( self.m_pTodoView )
    {
        [self.m_pCntScrollView addSubview:self.m_pTodoView];
        [self.m_pTodoView setFrame:CGRectMake(0, 0, self.m_pCntScrollView.frame.size.width, self.m_pCntScrollView.frame.size.height)];
        [self.m_pCntScrollView setContentSize:self.m_pTodoView.frame.size];

        RHProfileObj *pObj = [RHProfileObj getProfile];
        
         //判斷身份
        if ( pObj.m_nType == 2 )
        {
            //Father，不能新增
            [self.m_pTodoFuncView setHidden:YES];
            [self.m_pTodoTable setFrame:self.m_pTodoView.bounds];
        }
        else if ( pObj.m_nType == 1 )
        {
            //Mother
        }

        if ( pObj )
        {
            //Load ToDo List
            NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
            [pParameter setObject:@"1" forKey:kFilter];
            [pParameter setObject:@"[0, 1700000000]" forKey:kKeyWord];
            
            
            [RHAppDelegate showLoadingHUD];
            [RHLesEnphantsAPI GetTodoList:pParameter Source:self];

        }
        
    }

    
}
- ( void )switchToTab4
{
    [self.m_pBtnTab1 setSelected:NO];
    [self.m_pBtnTab2 setSelected:NO];
    [self.m_pBtnTab3 setSelected:NO];
    [self.m_pBtnTab4 setSelected:YES];
    
    //Close other Views
    [self closeAllSubViews];
    
    if ( self.m_pPairView )
    {
        [self.m_pCntScrollView addSubview:self.m_pPairView];
        [self.m_pPairView setFrame:CGRectMake(0, 0, self.m_pCntScrollView.frame.size.width, self.m_pCntScrollView.frame.size.height)];
        [self.m_pCntScrollView setContentSize:self.m_pPairView.frame.size];
        
        
        //Load QrCode
        RHProfileObj *pObj = [RHProfileObj getProfile];
        
        if ( pObj )
        {
            NSString *pstrMatchID = pObj.m_pstrMatchID;
            
            NSDictionary *pParameter = [NSDictionary dictionaryWithObjectsAndKeys:pstrMatchID,kString, nil];
            
            [RHLesEnphantsAPI getQrCodeImage2:pParameter Source:self];
            
        }
        
    }
    
}

- ( void )closeAllSubViews
{
    //Tab 1 for Mother
    if ( self.m_pFriendView.superview )
    {
        [self.m_pFriendView removeFromSuperview];
    }
    
    //Tab 1 for Father
    if ( self.m_pSettingView.superview )
    {
        [self.m_pSettingView removeFromSuperview];
    }

    //Tab 2 for Chat
    if ( self.m_pChatView.superview )
    {
        [self.m_pChatView removeFromSuperview];
    }
    
    //Tab 3
    if ( self.m_pTodoView.superview )
    {
        [self.m_pTodoView removeFromSuperview];
    }
    
    //Tab 4
    if ( self.m_pPairView.superview )
    {
        [self.m_pPairView removeFromSuperview];
    }
}

- ( void )showQrCodeReader
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    
    self.m_pReader = reader;
    self.m_pReader.supportedOrientationsMask = UIInterfaceOrientationPortrait;
    self.m_pReader.showsZBarControls = NO;
    
    
    [self presentViewController:self.m_pReader animated:NO completion:nil];
    
    
    //    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //    if ([device hasTorch])
    //    {
    //        [device lockForConfiguration:nil];
    //        [device setTorchMode: AVCaptureTorchModeOff];
    //        [device setFlashMode:AVCaptureFlashModeOff];
    //        [device unlockForConfiguration];
    //
    //    }
    
    
    
    UIView *vw = (UIView*)[[self.m_pReader.view subviews]objectAtIndex:0];
    UIImageView *topBarImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    
    if ( [UIScreen mainScreen].bounds.size.height < 500 )
    {
        topBarImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        topBarImgView1.image = [UIImage imageNamed:@"mask_i4.png"];
    }
    else
    {
        topBarImgView1.image = [UIImage imageNamed:@"mask.png"];
    }
    
    [vw addSubview:topBarImgView1];
    
    UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pBtn setTitle:@"Back" forState:UIControlStateNormal];
    [pBtn addTarget:self action:@selector(pressCloseQrCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [pBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [vw addSubview:pBtn];
    
    //    UIImageView *topBarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 71)];
    //    topBarImage.image = [UIImage imageNamed:@"header.png"];
    //    [vw addSubview:topBarImage];
}


- ( void )showInputDialog
{
    RHTodoListVC     *pVC = [[RHTodoListVC alloc] initWithNibName:@"RHTodoListVC" bundle:nil];
    [self.navigationController pushViewController:[pVC autorelease] animated:YES];
}

- ( void )showAlarmView
{
    //清空selected State
    [self.m_pBtnDate0 setSelected:NO];
    [self.m_pBtnDate1 setSelected:NO];
    [self.m_pBtnDate2 setSelected:NO];
    [self.m_pBtnDate3 setSelected:NO];
    [self.m_pBtnDate4 setSelected:NO];
    [self.m_pBtnDate5 setSelected:NO];
    [self.m_pBtnDate6 setSelected:NO];
    memset(g_SelIdx, 0, 7);
    
    
    
    if ( self.m_pAlertView.superview == nil )
    {
        [self.view addSubview:self.m_pAlertView];
        [self.m_pAlertView setFrame:CGRectMake(0,
                                               self.view.frame.size.height,
                                               self.m_pAlertView.frame.size.width,
                                               self.m_pAlertView.frame.size.height)];
        //Move
        [UIView beginAnimations:@"Move" context:nil];
        
        [self.m_pAlertView setFrame:CGRectMake(0,
                                               self.view.frame.size.height - self.m_pAlertView.frame.size.height,
                                               self.m_pAlertView.frame.size.width,
                                               self.m_pAlertView.frame.size.height)];

        [UIView commitAnimations];
    }

}
- ( void )hideAlarmView
{
    if ( self.m_pAlertView.superview )
    {
        //Move
        [UIView beginAnimations:@"Move" context:nil];
        
        [self.m_pAlertView setFrame:CGRectMake(0,
                                               self.view.frame.size.height,
                                               self.m_pAlertView.frame.size.width,
                                               self.m_pAlertView.frame.size.height)];
        [self.m_pAlertView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.50f];
        [UIView commitAnimations];
    }

}

- ( void )updateAlertData
{
    //Get Data From Pasteboard
    UIPasteboard *pPasteboard = [UIPasteboard pasteboardWithName:@"LES" create:YES];
    
    NSData *payload = [pPasteboard dataForPasteboardType:@"LES"];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:payload];
    NSDictionary *pDic = [[unarchiver decodeObjectForKey:kArchiveKey] retain];
    [unarchiver finishDecoding];
    [unarchiver release];
    
    NSLog(@"pDic = %@", pDic);
    
    if ( pDic )
    {
        NSDate *pDate = [pDic objectForKey:@"Time"];
        NSString *pstrWeek = [pDic objectForKey:@"Week"];
        
        NSArray *pWeekArray = [pstrWeek componentsSeparatedByString:@","];
        
        
        NSString *pstrShowString = @"每週";
        for ( NSInteger i = 0; i < [pWeekArray count]; ++i )
        {
            NSInteger nWeek = [[pWeekArray objectAtIndex:i] integerValue];
            if ( nWeek == 1 )
            {
                pstrShowString = [pstrShowString stringByAppendingFormat:@"%@,",g_pstrSelString[i]];
            }
        }
        
        if ( [pstrShowString rangeOfString:@"," options:NSBackwardsSearch].location != NSNotFound )
        {
            //如果反過來找，有找到[,]，就移掉最後一個字
            pstrShowString = [pstrShowString substringToIndex:[pstrShowString length]-1];
        }
        
        NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
        [pFormatter setDateFormat:@"aaa HH:mm"];
        NSString *pstrTime = [pFormatter stringFromDate:pDate];
        
        pstrShowString = [pstrShowString stringByAppendingFormat:@"  %@",pstrTime];
        
        NSLog(@"pstrShowString = %@", pstrShowString);
        [self.m_pLblAlert setText:pstrShowString];
        
        [self.m_pSwitchAlarm setOn:YES];
    }
    else
    {
        [self.m_pLblAlert setText:@""];
    }

}

- ( void )addToLocalPushNotification:( NSDictionary * )pDic
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"cc"];
    NSInteger nTodayOfWeek = [[dateFormatter stringFromDate:[NSDate date]] intValue] - 1;
    NSDate *pNow = [NSDate date];
    NSDate *pSpecifiedDate = [pDic objectForKey:@"Time"];
    
    
    double dTargetValue = [pSpecifiedDate timeIntervalSince1970];
    double dNowValue = [pNow timeIntervalSince1970];
    NSString *pstrPeroid = [pDic objectForKey:@"Week"];
    
    NSArray *pArray = [pstrPeroid componentsSeparatedByString:@","];
    NSInteger nCount = 0;
    //處理有每週重複的部份
    for ( NSInteger i = 0; i < [pArray count]; ++i )
    {
        NSString *pstrEnable = [pArray objectAtIndex:i];
        
        NSInteger nDayOfWeek = i; // i是0～6
        if ( [pstrEnable isEqualToString:@"1"] )
        {
            NSLog(@"一週的第%d天需要重複鬧鐘", nDayOfWeek);
            //NSLog(@"今天是%@", [self ])
            NSInteger nDiff = i - nTodayOfWeek;
            NSLog(@"差異的天數 = %d", nDiff);
            double dDiff = dTargetValue - dNowValue;
            NSLog(@"差異的秒數 = %f", dDiff);
            double dNewTargetValue = 0;
            
            if ( nDiff > 0 )
            {
                NSLog(@"今天以後");
                dNewTargetValue = dTargetValue + ( nDiff * 86400 );
            }
            else
            {
                NSLog(@"當天或是今天以前");
                if ( dDiff < 0 )
                {
                    NSLog(@"設定的日期比現在小");
                    dNewTargetValue = dTargetValue + ( ( nDiff+ 7 ) * 86400 );
                }
                else
                {
                    NSLog(@"設定的日期比現在大");
                    dNewTargetValue = dTargetValue + ( nDiff * 86400 );
                }
            }
            
            NSDate *pSaveDate = [NSDate dateWithTimeIntervalSince1970:dNewTargetValue];
            NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
            [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *pstr = [pFormatter stringFromDate:pSaveDate];
            NSLog(@"下一個鬧鐘的時間:%@", pstr);
            
            nCount++;
            UIApplication* app = [UIApplication sharedApplication];
            UILocalNotification* alarm = [[[UILocalNotification alloc] init] autorelease];
            if (alarm)
            {
                alarm.fireDate = pSaveDate;
                alarm.timeZone = [NSTimeZone defaultTimeZone];
                alarm.repeatInterval = NSWeekCalendarUnit;
                alarm.alertBody = @"該問候媽媽囉～～";
                [app scheduleLocalNotification:alarm];
            }
        }
    }
    
    //沒有設定重複，所以只有一次
    if ( nCount == 0 )
    {
        NSLog(@"沒有重複，所以只設定一次");
        UIApplication* app = [UIApplication sharedApplication];
        UILocalNotification* alarm = [[[UILocalNotification alloc] init] autorelease];
        if (alarm)
        {
            NSDate *pSpecifiedDate = [pDic objectForKey:@"Time"];
            double dTimeStamp = [pSpecifiedDate timeIntervalSince1970];
            double dCurTimeStamp = [[NSDate date] timeIntervalSince1970];
            double dDiff = dTimeStamp - dCurTimeStamp;
            
            double dNewTargetValue = 0;
            if ( dTimeStamp > dCurTimeStamp )
            {
                NSLog(@"本週的時間:%f", dDiff);
                dNewTargetValue = dTargetValue;
            }
            else
            {
                NSLog(@"下週的時間:%f", dDiff);
                dNewTargetValue = dTargetValue + ( 7 * 86400 );
            }
            
            NSDate *pSaveDate = [NSDate dateWithTimeIntervalSince1970:dNewTargetValue];
            
            alarm.fireDate = pSaveDate;
            alarm.timeZone = [NSTimeZone defaultTimeZone];
            alarm.repeatInterval = 0;

            alarm.alertBody = @"該問候媽媽囉～～";
            [app scheduleLocalNotification:alarm];
        }
    }
}

#pragma mark - Notificatio
- ( void )processRecieveNewMsg:( NSNotification * )pNotification
{
    if ( [self.m_pBtnTab2 isSelected] )
    {
        //get new Msg Data
        NSArray *pArray = [[RHSQLManager instance] getChatList];
        
        self.m_pChatList = [NSMutableArray arrayWithArray:pArray];
        
        [self.m_pChatTable reloadData];
    }
}

#pragma mark - IBAction
- ( IBAction )pressTab1:(id)sender
{
    if ( [self.m_pBtnTab1 isSelected ] )
    {
        return;
    }
    
    [self switchToTab1];
    
}
- ( IBAction )pressTab2:(id)sender
{
    if ( [self.m_pBtnTab2 isSelected ] )
    {
        return;
    }
    
    [self switchToTab2];
}
- ( IBAction )pressTab3:(id)sender
{
    if ( [self.m_pBtnTab3 isSelected ] )
    {
        return;
    }
    
    [self switchToTab3];
}
- ( IBAction )pressTab4:(id)sender
{
    if ( [self.m_pBtnTab4 isSelected ] )
    {
        return;
    }
    
    [self switchToTab4];
}
- ( IBAction )pressMoodBtn:(id)sender
{
    RHMoodVC *pVC = [[RHMoodVC alloc] initWithNibName:@"RHMoodVC" bundle:nil];
    [self.navigationController pushViewController:[pVC autorelease] animated:YES];
}

- ( IBAction )pressPairScanQrCodeBtn:(id)sender
{
    [self showQrCodeReader];
}

- ( IBAction )pressCloseQrCodeBtn:(id)sender
{
    if ( self.m_pReader )
    {
        [self.m_pReader dismissViewControllerAnimated:YES completion:nil];
    }
}

- ( IBAction )pressAddTodoBtn:(id)sender
{
    [self showInputDialog];
}

- ( IBAction )pressDateBtn:(id)sender
{
    UIButton *pBtn = ( UIButton * )sender;
    [pBtn setSelected:![pBtn isSelected]];
    
    NSInteger nTag = [pBtn tag];
    
    if ( [pBtn isSelected] )
    {
        g_SelIdx[nTag] = 1;
    }
    else
    {
        g_SelIdx[nTag] = 0;
    }
}

- ( IBAction )pressConfirmBtn:(id)sender
{
    //確認Selected Date & selected Time
    NSDate *pDate = self.m_pDatePicker.date;
    NSLog(@"pDate = %@", [pDate description]);
    
    NSString *pstrDate = @"";
    for ( NSInteger i = 0;  i < 7; ++i )
    {
        NSString *pstr = [NSString stringWithFormat:@",%ld", (long)g_SelIdx[i]];
        pstrDate = [pstrDate stringByAppendingString:pstr];
    }
    
    //去掉第一個
    pstrDate = [pstrDate substringFromIndex:1];
    
    NSLog(@"pstrDate = %@", pstrDate);
    
    //Add To Pasteboard
    NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:pDate,@"Time", pstrDate, @"Week", nil];
    
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"LES" create:YES];
    
    [pasteboard setPersistent:YES]; // Makes sure the pasteboard lives beyond app termination.
    
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:pDic forKey:kArchiveKey];
    [archiver finishEncoding];
    [archiver release];
    
    // Write The Data
    [pasteboard setData:data forPasteboardType:@"LES"];
    
    
    //update UI
    [self updateAlertData];
    
    //Add To Local Notification
    [self addToLocalPushNotification:pDic];
    //hide Alarm
    [self hideAlarmView];
}

//Tab 1 Father
- ( IBAction )pressNotifyMotherBtn:(id)sender
{
    UISwitch *pSwitch = ( UISwitch * )sender;
    
    
    UIPasteboard *pPasteboard = [UIPasteboard pasteboardWithName:@"LES" create:YES];
    
    NSData *payload = [pPasteboard dataForPasteboardType:@"LES"];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:payload];
    NSDictionary *pDic = [[unarchiver decodeObjectForKey:kArchiveKey] retain];
    [unarchiver finishDecoding];
    [unarchiver release];
    
    NSLog(@"pDic = %@", pDic);
    
    if ( pDic )
    {
        NSDate *pDate = [pDic objectForKey:@"Time"];
        NSString *pstrWeek = [pDic objectForKey:@"Week"];
        
        NSArray *pWeekArray = [pstrWeek componentsSeparatedByString:@","];
        
        
        NSString *pstrShowString = @"每週";
        for ( NSInteger i = 0; i < [pWeekArray count]; ++i )
        {
            NSInteger nWeek = [[pWeekArray objectAtIndex:i] integerValue];
            if ( nWeek == 1 )
            {
                pstrShowString = [pstrShowString stringByAppendingFormat:@"%@,",g_pstrSelString[i]];
            }
        }
        
        if ( [pstrShowString rangeOfString:@"," options:NSBackwardsSearch].location != NSNotFound )
        {
            //如果反過來找，有找到[,]，就移掉最後一個字
            pstrShowString = [pstrShowString substringToIndex:[pstrShowString length]-1];
        }
        
        NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
        [pFormatter setDateFormat:@"aaa HH:mm"];
        NSString *pstrTime = [pFormatter stringFromDate:pDate];
        
        pstrShowString = [pstrShowString stringByAppendingFormat:@"  %@",pstrTime];
        
        NSLog(@"pstrShowString = %@", pstrShowString);
        [self.m_pLblAlert setText:pstrShowString];
        
        [self.m_pSwitchAlarm setOn:YES];
    }
    else
    {
        [self.m_pLblAlert setText:@""];
    }

    
    
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    BOOL bEnablePush = pSwitch.on;
    
    if ( bEnablePush )
    {
        [pParameter setObject:@"1" forKey:kEnableMoodChange];
        [pParameter setObject:self.m_pTFNotifyMSG.text forKey:kBody];
        
        if ( self.m_pSwitchAlarm.on )
        {
            UIPasteboard *pPasteboard = [UIPasteboard pasteboardWithName:@"LES" create:YES];
            
            NSData *payload = [pPasteboard dataForPasteboardType:@"LES"];
            
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:payload];
            NSDictionary *pDic = [[unarchiver decodeObjectForKey:kArchiveKey] retain];
            [unarchiver finishDecoding];
            [unarchiver release];
            
            NSLog(@"pDic = %@", pDic);
            
            if ( pDic )
            {
                NSString *pstrWeek = [pDic objectForKey:@"Week"];
                
                NSArray *pWeekArray = [pstrWeek componentsSeparatedByString:@","];
                
                [pParameter setObject:[pWeekArray objectAtIndex:0] forKey:kSun];
                [pParameter setObject:[pWeekArray objectAtIndex:1] forKey:kMon];
                [pParameter setObject:[pWeekArray objectAtIndex:2] forKey:kTues];
                [pParameter setObject:[pWeekArray objectAtIndex:3] forKey:kWed];
                [pParameter setObject:[pWeekArray objectAtIndex:4] forKey:kThur];
                [pParameter setObject:[pWeekArray objectAtIndex:5] forKey:kFri];
                [pParameter setObject:[pWeekArray objectAtIndex:6] forKey:kSat];
                
                
                NSDate *pDate = [pDic objectForKey:@"Time"];
                NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
                [pFormatter setDateFormat:@"HH:mm"];
                NSString *pstrTime = [pFormatter stringFromDate:pDate];
                [pParameter setObject:pstrTime forKey:kTime];
                
                
            }
        }
        
    }
    else
    {
        [pParameter setObject:@"0" forKey:kEnableMoodChange];
        [pParameter setObject:@"0" forKey:kMon];
        [pParameter setObject:@"0" forKey:kTues];
        [pParameter setObject:@"0" forKey:kWed];
        [pParameter setObject:@"0" forKey:kThur];
        [pParameter setObject:@"0" forKey:kFri];
        [pParameter setObject:@"0" forKey:kSat];
        [pParameter setObject:@"0" forKey:kSun];
        [pParameter setObject:@"" forKey:kBody];
        [pParameter setObject:@"" forKey:kTime];
    }
    
    
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI setRegard:pParameter Source:self];
}
- ( IBAction )pressAlertBtn:(id)sender
{
    UISwitch *pSwitch = ( UISwitch * )sender;
    
    
    if ( [pSwitch isOn] )
    {
        [self showAlarmView];
    }
    else
    {
        //Clear Pasteboard
        UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"LES" create:YES];
        
        [pasteboard setPersistent:YES]; // Makes sure the pasteboard lives beyond app termination.

        // Write The Data
        [pasteboard setData:nil forPasteboardType:@"LES"];
        
        
        //Delete Alert Data
        NSLog(@"deleteFromLocalPushNotification");
        UIApplication* app = [UIApplication sharedApplication];
        NSArray *pPushArray = [app scheduledLocalNotifications];
        for ( NSInteger i = 0; i < [pPushArray count]; ++i )
        {
            UILocalNotification *pAlarm = [pPushArray objectAtIndex:i];
            [app cancelLocalNotification:pAlarm];
        }

        
        //Update UI
        [self updateAlertData];
    }
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

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textField -> %ld", (long)textField.tag);

    
    [textField resignFirstResponder];
    
    
    if ( textField.tag == 10000 )
    {
        //Send Match ID to get QrCode
        NSString *pstrMatchID = [textField text];
        
        if ( ![pstrMatchID compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            //Call API
            
            NSDictionary *pParameter = [NSDictionary dictionaryWithObjectsAndKeys:pstrMatchID,kPostMatchID, nil];
            
            [RHAppDelegate showLoadingHUD];
            [RHLesEnphantsAPI AddUserToFreindByMatchID:pParameter Source:self];
        }
    }
    
    if ( textField == self.m_pTFNotifyMSG )
    {
        NSString *pstrText = [self.m_pTFNotifyMSG text];
        [RHAppDelegate setFatherAsk:pstrText];
    }
    
    
    return YES;
    
}

#pragma mark - Scan Delegate

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    id<NSFastEnumeration> results =
    
    [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    
    for(symbol in results)
        break;
    
    
    NSString *pstr = ( NSString * )symbol.data;
    NSLog(@"pstr = %@", pstr);

    //[RHAppDelegate MessageBox:pstr];
    [self.m_pPairTFID setText:pstr];
    
    NSString *pstrMatchID = pstr;
    
    if ( ![pstrMatchID compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        //Call API
        
        NSDictionary *pParameter = [NSDictionary dictionaryWithObjectsAndKeys:pstrMatchID,kPostMatchID, nil];
        
        [RHAppDelegate showLoadingHUD];
        [RHLesEnphantsAPI AddUserToFreindByMatchID:pParameter Source:self];
    }
    
    
    
    if ( self.m_pReader )
    {
        [self.m_pReader dismissViewControllerAnimated:YES completion:nil];
    }

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( [tableView tag] == 2000 )
    {
        //交辦事項
        NSUInteger nRow = [indexPath row];
        NSDictionary *pDic = [m_pToDoListArray objectAtIndex:nRow];
        
        BOOL bReported = [[pDic objectForKey:@"reported"] boolValue];
        BOOL bConfirmed = [[pDic objectForKey:@"confirmed"] boolValue];
        BOOL bDisable = [[pDic objectForKey:@"disabled"] boolValue];
        
        if ( bDisable )
        {
            //Do Nothing
        }
        else
        {
            //先判斷身份
            RHProfileObj *pObj = [RHProfileObj getProfile];
            
            if ( pObj.m_nType == 1 )
            {
                //Mother
                if ( bReported )
                {
                    //爸爸已回覆，在此媽媽要確認
                    NSDictionary *pParameter = [NSDictionary dictionaryWithObjectsAndKeys:[pDic objectForKey:@"id"], kToDoID, nil];
                    [RHAppDelegate showLoadingHUD];
                    [RHLesEnphantsAPI ConfirmTodoWithID:pParameter Source:self];
                }
                else
                {
                    //媽媽已確認，所以不用處理
                }
            }
            else
            {
                //Father
                if ( bReported == NO )
                {
                    //爸爸尚未回覆，在此要回覆
                    NSDictionary *pParameter = [NSDictionary dictionaryWithObjectsAndKeys:[pDic objectForKey:@"id"], kToDoID, nil];
                    [RHAppDelegate showLoadingHUD];
                    [RHLesEnphantsAPI ReportTodoWithID:pParameter Source:self];
                }
                else
                {
                    //爸爸已回覆，等媽媽確認，所以不用處理
                }

            }

        }

        
    }
    else if ( [tableView tag] == 1000 )
    {
        NSUInteger nRow = [indexPath row];
        NSUInteger nSection = [indexPath section];
        
        
        NSArray *pArray = [m_pFriendDataArray objectAtIndex:nSection];
        NSDictionary *pDic = [pArray objectAtIndex:nRow];
        NSLog(@"pDic= %@", pDic);

        RHChatVC *pVC = [[RHChatVC alloc] initWithNibName:@"RHChatVC" bundle:nil];
        self.m_pRHChatVC = pVC;
        [pVC release];
        [m_pRHChatVC setupDataDic:pDic];
        [self.navigationController pushViewController:m_pRHChatVC animated:YES];
        
        
    }
    else if ( [tableView tag] == 3000 )
    {
        //依據JID找到Friend
        NSDictionary *pDic = [m_pChatList objectAtIndex:[indexPath row]];
        
        NSString *pstrID = [pDic objectForKey:@"JID"];
        NSDictionary *pFriendDic = [[RHAppDelegate sharedDelegate] getFriendDicFromJID:pstrID];
        
        if ( pFriendDic )
        {
            RHChatVC *pVC = [[RHChatVC alloc] initWithNibName:@"RHChatVC" bundle:nil];
            self.m_pRHChatVC = pVC;
            [pVC release];
            [m_pRHChatVC setupDataDic:pFriendDic];
            [self.navigationController pushViewController:m_pRHChatVC animated:YES];
        }
        else
        {
            [RHAppDelegate MessageBox:@"無法取得好友的詳細資料"];
        }

    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSUInteger nRow = [indexPath row];
        NSUInteger nSection = [indexPath section];
        
        
        NSArray *pArray = [m_pFriendDataArray objectAtIndex:nSection];
        NSDictionary *pDic = [pArray objectAtIndex:nRow];
        NSLog(@"pDic= %@", pDic);
        
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:[pDic objectForKey:@"matchId"] forKey:kPostMatchID];
        
        [RHAppDelegate showLoadingHUD];
        [RHLesEnphantsAPI DeleteUserToFreindByMatchID:pParameter Source:self];
    }
}

#pragma mark - UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *pstrHeader = nil;
    if ( [tableView tag] == 1000 )
    {
        if ( section == 0 )
        {
            pstrHeader = @"小倆口";
        }
        else
        {
            pstrHeader = @"親友";

        }
    }
    
    return pstrHeader;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView.tag == 1000 )
    {
        //if ( [indexPath section] != 0 )
        {
            return YES;
        }
    }
    
    return NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger nCount = 1;
    if ( [tableView tag] == 1000 )
    {
        nCount = [m_pFriendDataArray count];
    }
    else if ( [tableView tag] == 2000 )
    {
        nCount = 1;
    }
    return nCount;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = 0;
    if ( [tableView tag] == 1000 )
    {
        nCount = [[m_pFriendDataArray objectAtIndex:section] count];
    }
    else if ( [tableView tag] == 2000 )
    {
        nCount = [m_pToDoListArray count];
    }
    else if ( [tableView tag] == 3000 )
    {
        nCount = [m_pChatList count];
    }
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [tableView tag] == 1000 )
    {
        static NSString *RHFriendCellIdentifier = @"RHFriendCellIdentifier";
        
        RHFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:RHFriendCellIdentifier];
        if (cell == nil)
        {
            cell = [[[RHFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RHFriendCellIdentifier] autorelease];
            NSArray *pArray =  [[NSBundle mainBundle] loadNibNamed:@"RHFriendCell" owner:self options:nil];
            
            for ( id oneView in pArray )
            {
                if ( [oneView isKindOfClass:[RHFriendCell class]] )
                {
                    cell = oneView;
                }
            }
        }
        
        // Configure the cell...
        
        NSUInteger nRow = [indexPath row];
        NSUInteger nSection = [indexPath section];
        
        
        NSArray *pArray = [m_pFriendDataArray objectAtIndex:nSection];
        NSDictionary *pDic = [pArray objectAtIndex:nRow];
        
        [cell setM_pDataDic:pDic];
        [cell updateUI];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        return cell;

    }
     else if ( [tableView tag] == 2000 )
     {
         static NSString *RHTodoCellIdentifier = @"RHTodoCellIdentifier";
         
         RHTodoCell *cell = [tableView dequeueReusableCellWithIdentifier:RHTodoCellIdentifier];
         if (cell == nil)
         {
             cell = [[[RHTodoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RHTodoCellIdentifier] autorelease];
             NSArray *pArray =  [[NSBundle mainBundle] loadNibNamed:@"RHTodoCell" owner:self options:nil];
             
             for ( id oneView in pArray )
             {
                 if ( [oneView isKindOfClass:[RHTodoCell class]] )
                 {
                     cell = oneView;
                 }
             }
         }
         
         // Configure the cell...
         
         NSUInteger nRow = [indexPath row];
         NSDictionary *pDic = [m_pToDoListArray objectAtIndex:nRow];
         
         [cell setM_pMainDic:pDic];
         [cell updateUI];
         [cell setAccessoryType:UITableViewCellAccessoryNone];
         return cell;

     }
     else if ( [tableView tag] == 3000 )
     {
         static NSString *RHChatCellIdentifier = @"RHChatCellIdentifier";
         
         RHChatCell *cell = [tableView dequeueReusableCellWithIdentifier:RHChatCellIdentifier];
         if (cell == nil)
         {
             cell = [[[RHChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RHChatCellIdentifier] autorelease];
             NSArray *pArray =  [[NSBundle mainBundle] loadNibNamed:@"RHChatCell" owner:self options:nil];
             
             for ( id oneView in pArray )
             {
                 if ( [oneView isKindOfClass:[RHChatCell class]] )
                 {
                     cell = oneView;
                 }
             }
         }
         
         // Configure the cell...
         
         NSUInteger nRow = [indexPath row];
         NSDictionary *pDic = [m_pChatList objectAtIndex:nRow];
         
         [cell setM_pMainDic:pDic];
         [cell updateUI];
         [cell setAccessoryType:UITableViewCellAccessoryNone];
         return cell;

     }
    
    
    
    return nil;
}


#pragma mark - Gateway
- ( void )callBackQrCodeImage2:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSString *pstrURL = [pStatusDic objectForKey:@"url"];
        
        AsyncImageView *pImgAsynView = [[AsyncImageView alloc] initWithFrame:self.m_pPairQrCodeView.bounds];
        [pImgAsynView setTag:1000];
        pImgAsynView.backgroundColor = [UIColor clearColor];
        [pImgAsynView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
        [self.m_pPairQrCodeView addSubview:pImgAsynView];
        [pImgAsynView loadImageFromURL:[NSURL URLWithString:pstrURL]];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
}

- ( void )callBackAddUserToFriendByMatchID:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [RHAppDelegate MessageBox:@"加入好友成功"];
        
        NSInteger point = [[pStatusDic objectForKey:@"Point"] integerValue];
        [self showAnimation:point];

    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackGetUserProfileStatus:( NSDictionary * )pStatusDic
{
    if ( pStatusDic )
    {
        NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
        
        if ( nStatus == 0 )
        {
            [[RHAppDelegate sharedDelegate] keepLoginProfile:[pStatusDic objectForKey:@"profile"]];
            
            [m_pFriendDataArray removeAllObjects];
            NSDictionary *pProfile = [pStatusDic objectForKey:@"profile"];
            
            NSArray *pFriends = [pProfile objectForKey:@"friends"];
            NSMutableArray *pArray1 = [NSMutableArray arrayWithCapacity:1];
            NSMutableArray *pArray2 = [NSMutableArray arrayWithCapacity:1];
            for ( NSInteger i = 0; i < [pFriends count]; ++i )
            {
                NSDictionary *pDic = [pFriends objectAtIndex:i];
                
                NSInteger nType = [[pDic objectForKey:@"type"] integerValue];
                if ( nType == 2 )   //先生
                {
                    [pArray1 addObject:pDic];
                }
                else    //親友團
                {
                    [pArray2 addObject:pDic];
                }
                
            }
            
            [m_pFriendDataArray addObject:pArray1];
            [m_pFriendDataArray addObject:pArray2];
            
            [self.m_pFriendTableView reloadData];
            
            
            // 設定我的ID
            NSString *pMatchId = [pProfile objectForKey:@"matchId"];
            if (pMatchId) {
                self.m_pLblMyID.text = [NSString stringWithFormat:@"我的ID: %@", pMatchId];
            }
            else {
                self.m_pLblMyID.text = nil;
            }
                
        }
        else
        {
            NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatus]];
            [RHAppDelegate MessageBox:pstrErrorMsg];
        }

    }
    
    
    [RHAppDelegate hideLoadingHUD];
}


- ( void )callBackGetTodoList:( NSDictionary * )pStatusDic
{
    if ( pStatusDic )
    {
        NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
        
        if ( nStatus == 0 )
        {
            [m_pToDoListArray removeAllObjects];
            
            NSArray *pArray = [pStatusDic objectForKey:@"todo"];
            
            for ( id obj in pArray )
            {
                [m_pToDoListArray addObject:obj];
            }

            [self.m_pTodoTable reloadData];
        }
        else
        {
            NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatus]];
            [RHAppDelegate MessageBox:pstrErrorMsg];
        }
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackReportTodoStatus:( NSDictionary * )pStatusDic
{
    if ( pStatusDic )
    {
        NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
        
        if ( nStatus == 0 )
        {
            //Load ToDo List
            NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
            [pParameter setObject:@"1" forKey:kFilter];
            [pParameter setObject:@"[0, 1700000000]" forKey:kKeyWord];
            
            [RHLesEnphantsAPI GetTodoList:pParameter Source:self];
        }
        else
        {
            [RHAppDelegate hideLoadingHUD];
        }
    }
    else
    {
        [RHAppDelegate hideLoadingHUD];
    }

    
}

- ( void )callBackConfirmTodoStatus:( NSDictionary * )pStatusDic
{
    if ( pStatusDic )
    {
        NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
        
        if ( nStatus == 0 )
        {
            NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
            [pParameter setObject:@"1" forKey:kFilter];
            [pParameter setObject:@"[0, 1700000000]" forKey:kKeyWord];
            
            [RHLesEnphantsAPI GetTodoList:pParameter Source:self];
        }
        else
        {
            NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatus]];
            [RHAppDelegate MessageBox:pstrErrorMsg];
            [RHAppDelegate hideLoadingHUD];
        }
    }
    else
    {
        [RHAppDelegate hideLoadingHUD];
    }

}

- ( void )callBackPushMotherMoodStatus:( NSDictionary * )pStatusDic
{
    if ( pStatusDic )
    {
        NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
        
        if ( nStatus == 0 )
        {
            [RHAppDelegate MessageBox:@"已通知媽咪"];
        }
        else
        {
            NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatus]];
            [RHAppDelegate MessageBox:pstrErrorMsg];
        }
    }
    else
    {
        
    }
    
    [RHAppDelegate hideLoadingHUD];

}

- ( void )callBackSetRegardStatus:( NSDictionary * )pStatusDic
{
    if ( pStatusDic )
    {
        NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
        
        if ( nStatus == 0 )
        {
            [RHAppDelegate MessageBox:@"設定成功"];
        }
        else
        {
            NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatus]];
            [RHAppDelegate MessageBox:pstrErrorMsg];
        }
    }
    else
    {
        
    }
    
    [RHAppDelegate hideLoadingHUD];

}

- ( void )callBackDeleteUserToFriendByMatchID:( NSDictionary * )pStatusDic
{
    BOOL bNeedHide = YES;
    
    if ( pStatusDic )
    {
        NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
        
        if ( nStatus == 0 )
        {
            //Reload Friend List
            bNeedHide = NO;
            [RHLesEnphantsAPI getUserProfile:nil Source:self];

        }
        else
        {
            NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nStatus]];
            [RHAppDelegate MessageBox:pstrErrorMsg];
        }
    }
    else
    {
        
    }
    
    if ( bNeedHide )
    {
        [RHAppDelegate hideLoadingHUD];
    }
}


@end
