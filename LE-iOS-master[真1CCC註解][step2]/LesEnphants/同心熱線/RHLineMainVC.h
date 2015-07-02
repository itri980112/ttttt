//
//  RHLineMainVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@class RHChatVC;
@interface RHLineMainVC : UIViewController < ZBarReaderDelegate >
{
    NSMutableArray          *m_pFriendDataArray;
    NSMutableArray          *m_pToDoListArray;
    
    BOOL                    m_bForeceToTodoList;
    
    NSMutableArray          *m_pChatList;
    RHChatVC                *m_pRHChatVC;
}
@property BOOL                    m_bForeceToTodoList;
@property (nonatomic, retain) NSMutableArray          *m_pFriendDataArray;
@property (nonatomic, retain) NSMutableArray          *m_pToDoListArray;
@property (nonatomic, retain) NSMutableArray          *m_pChatList;
@property (nonatomic, retain) ZBarReaderViewController *m_pReader;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTab1;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnMoodBtn;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTodo;


@property (nonatomic, retain) ZBarImageScanner *m_pScanner;
@property (nonatomic, retain) RHChatVC                *m_pRHChatVC;

@property (retain, nonatomic) IBOutlet UIButton *m_pBtnMenu;
@property (retain, nonatomic) IBOutlet UIView *m_pNaviBar;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab1;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab2;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab3;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab4;
@property (retain, nonatomic) IBOutlet UIScrollView *m_pCntScrollView;

//Tab1
//Mother
@property (retain, nonatomic) IBOutlet UIView *m_pFriendView;
@property (retain, nonatomic) IBOutlet UITableView *m_pFriendTableView;
//Father
@property (retain, nonatomic) IBOutlet UIView *m_pSettingView;
@property (retain, nonatomic) IBOutlet UISwitch *m_pSwitchNotifyMother;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFNotifyMSG;
@property (retain, nonatomic) IBOutlet UISwitch *m_pSwitchAlarm;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblAlert;




//Tab2
@property (strong, nonatomic) IBOutlet UIView *m_pChatView;
@property (strong, nonatomic) IBOutlet UITableView *m_pChatTable;

//Tab3
@property (retain, nonatomic) IBOutlet UIView *m_pTodoView;
@property (retain, nonatomic) IBOutlet UITableView *m_pTodoTable;
@property (retain, nonatomic) IBOutlet UIView *m_pTodoFuncView;

//Tab4
@property (retain, nonatomic) IBOutlet UIView *m_pPairView;
@property (retain, nonatomic) IBOutlet UITextField *m_pPairTFID;
@property (retain, nonatomic) IBOutlet UIView *m_pPairQrCodeView;

//Alert Setting

@property (retain, nonatomic) IBOutlet UIButton *m_pBtnDate0;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnDate1;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnDate2;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnDate3;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnDate4;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnDate5;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnDate6;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnConfirm;
@property (retain, nonatomic) IBOutlet UIDatePicker *m_pDatePicker;
@property (retain, nonatomic) IBOutlet UIView *m_pAlertView;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTab2;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTab3;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTab4;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblInputID;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblMyID;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblMyQRCode;

@property (strong, nonatomic) IBOutlet UILabel *m_pLblFa1;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblFa2;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblFa3;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblAddTodo;


#pragma mark - IBAction
- ( IBAction )pressTab1:(id)sender;
- ( IBAction )pressTab2:(id)sender;
- ( IBAction )pressTab3:(id)sender;
- ( IBAction )pressTab4:(id)sender;
- ( IBAction )pressMoodBtn:(id)sender;
- ( IBAction )pressAddTodoBtn:(id)sender;

//Tab 1 Father
- ( IBAction )pressNotifyMotherBtn:(id)sender;
- ( IBAction )pressAlertBtn:(id)sender;

//Tab4
- ( IBAction )pressPairScanQrCodeBtn:(id)sender;

//Date
- ( IBAction )pressDateBtn:(id)sender;
- ( IBAction )pressConfirmBtn:(id)sender;
@end
