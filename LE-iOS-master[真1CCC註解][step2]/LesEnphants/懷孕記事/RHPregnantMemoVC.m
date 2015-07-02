//
//  RHPregnantMemoVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHPregnantMemoVC.h"
#import "RevealController.h"
#import "RHEventHandler.h"
#import "RHCalendarVC.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "RHPregnantCntCell.h"
#import "RHAddEventVC.h"
#import "RHThumbnailView.h"
#import "RHImageViewerVC.h"
#import "CustomIOS7AlertView.h"
#import "RHWeightCntCell.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "RHVideoViewerVC.h"
#import "iPhoneGraphViewController.h"
#import "UIImage+Orientation.h"
#import "RHProfileObj.h"
#import "RHAlertView.h"
#import "GoldCoinAnimationVC.h"


@interface RHPregnantMemoVC () < RHLesEnphantsAPIDelegate, RHCalendarVCDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, iPhoneGraphViewControllerDelegate >
{
    NSMutableArray         *m_pDataArray;
    NSArray                *m_pWeightDataArray;
    NSArray                 *m_pDifferArray;
    BOOL                    m_bIsEdit;
}
//CCC:some private members and methods
@property ( nonatomic, retain ) iPhoneGraphViewController *m_pGraph;
@property ( nonatomic, retain ) NSMutableArray         *m_pDataArray;
@property ( nonatomic, retain ) NSArray                *m_pWeightDataArray;
@property ( nonatomic, retain ) NSArray                 *m_pDifferArray;
- ( void )uploadImage:( UIImage * )pImg;
- ( void )loadServerData;
- ( void )switchToTab1;
- ( void )switchToTab2;
- ( void )switchToTab3;
- ( void )switchToTab4;
- ( void )showInputDialog;
@end

@implementation RHPregnantMemoVC
@synthesize m_pDataArray;
@synthesize m_pWeightDataArray;
@synthesize m_pDifferArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pDataArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pWeightDataArray = nil;
        self.m_pDifferArray = nil;
        m_bIsEdit = NO;
    }
    return self;
}
//CCC important:只要在左邊選單點懷孕記事  就一定會執行本檔的viewDidLoad
//CCC:所以- (void)dealloc的  //CCC do 沒有問題
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_NOTE_TITLE", nil)];
    
    [self.m_pLblTab1 setText:NSLocalizedString(@"LE_NOTE_TAB1", nil)];
    [self.m_pLblTab2 setText:NSLocalizedString(@"LE_NOTE_TAB2", nil)];
    [self.m_pLblTab3 setText:NSLocalizedString(@"LE_NOTE_TAB3", nil)];
    [self.m_pLblTab4 setText:NSLocalizedString(@"LE_NOTE_TAB4", nil)];
    
    [self.m_pLbl1 setText:NSLocalizedString(@"LE_NOTE_S1", nil)];
    [self.m_pLbl2 setText:NSLocalizedString(@"LE_NOTE_S2", nil)];
    [self.m_pLbl3 setText:NSLocalizedString(@"LE_NOTE_S3", nil)];
    
    //[self.m_pBtnEdit setTitle:NSLocalizedString(@"LE_NOTE_EDIT", nil) forState:UIControlStateNormal];
    //CCC todo:點擊後跳到寶典   所以似乎要對RevealController作一些release
    [self.m_pBtn4 setTitle:NSLocalizedString(@"LE_NOTE_KNOWLEDGE", nil) forState:UIControlStateNormal];

    //CCC:當USER對頂端navigation bar往左拖移,下面的程式就是在做這種事
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.m_pNaviBar addGestureRecognizer:navigationBarPanGestureRecognizer];
	NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    [navigationBarPanGestureRecognizer release];//CCC try
    NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    
    [self.m_pBtnMenu addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBackToPreview:) name:kPostSelectedSectionAndRow object:nil];
    
    [self switchToTab1];
    
    
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
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPostSelectedSectionAndRow object:nil];
    
    [_m_pBtnMenu release];
    [_m_pNaviBar release];
    [_m_pBtnTab1 release];
    [_m_pBtnTab2 release];
    [_m_pBtnTab3 release];
    [_m_pBtnTab4 release];
    [_m_pCntView release];
    [_m_pCntTableView release];
    [_m_pBtnTakePic release];
    [_m_pBtnEdit release];
    [_m_pWeightView release];
    [_m_pTFWeight release];
    [_m_pWeightScrollView release];
    [_m_pWeightTable release];
    [m_pWeightDataArray release];
    [_m_pGraphView release];
    [m_pDifferArray release];
    
    
    [_m_pLblTitle release];//CCC do
    [_m_pLblTab1 release];//CCC do
    [_m_pLblTab2 release];//CCC do
    [_m_pLblTab3 release];//CCC do
    [_m_pLblTab4 release];//CCC do
    
    [_m_pLbl1 release];//CCC do
    [_m_pLbl2 release];//CCC do
    [_m_pLbl3 release];//CCC do
    [_m_pBtn4 release];//CCC do
    
    
    [super dealloc];
}


#pragma mark - Private Methods
- ( void )callBackToPreview:( NSNotification * )pNotification
{
    NSDictionary *pDic = [pNotification userInfo];
    
    NSInteger nSection = [[pDic objectForKey:@"Section"] integerValue];
    NSInteger nRow = [[pDic objectForKey:@"Row"] integerValue];
    
    NSDictionary *pReceiveDic = [[[m_pDataArray objectAtIndex:nSection] objectForKey:@"record"] objectAtIndex:nRow];
    NSLog(@"pReceiveDic = %@", pReceiveDic);
    
    
    if ( m_bIsEdit )
    {
        //delete image
        
        RHAlertView *alert = [[RHAlertView alloc]initWithTitle:@""
                                                       message:@"是否要刪除所選項目"
                                                      delegate:nil
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"刪除",nil];
        [alert showWithCallback:^(UIAlertView *alertView, NSInteger buttonIndex)
         {
             if ( buttonIndex == 1 )
             {
                 NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
                 NSInteger nID = [[pReceiveDic objectForKey:@"id"] integerValue];
                 [pParameter setObject:[NSString stringWithFormat:@"%ld",(long)nID] forKey:kRecordID];
                 [RHLesEnphantsAPI deletePreganatRecord:pParameter Source:self];
                 
             }
             else
             {
                 
             }
             
         }];
        
    }
    else
    {
        NSString *pstrURL = [pReceiveDic objectForKey:@"url"];
        
        //判斷是影片還是圖片
        
        NSRange kRange = [pstrURL rangeOfString:@"mp4" options:NSCaseInsensitiveSearch];
        if ( kRange.location != NSNotFound )
        {
            //是影片
            RHVideoViewerVC *pVC = [[RHVideoViewerVC alloc] initWithNibName:@"RHVideoViewerVC" bundle:nil];
            [pVC setM_pstrImgURL:pstrURL];
            [self.navigationController pushViewController:[pVC autorelease] animated:YES];
        }
        else
        {
            RHImageViewerVC *pVC = [[RHImageViewerVC alloc] initWithNibName:@"RHImageViewerVC" bundle:nil];
            [pVC setM_pstrImgURL:pstrURL];
            [self.navigationController pushViewController:[pVC autorelease] animated:YES];
        }

    }
}


- ( void )switchToTab1
{
    m_enumPregnantPageType = RH_PregnantPage_Beat;
    [self.m_pBtnTab1 setSelected:YES];
    [self.m_pBtnTab2 setSelected:NO];
    [self.m_pBtnTab3 setSelected:NO];
    [self.m_pBtnTab4 setSelected:NO];
    [self.m_pCntView setHidden:NO];
    [self.m_pWeightScrollView setHidden:YES];
    [self.m_pBtnTakePic setHidden:NO];
    [self.m_pBtnEdit setHidden:NO];
    [self.m_pBtnTakePic setTitle:@"錄影" forState:UIControlStateNormal];
    
    [self.m_pTFWeight resignFirstResponder];
    //Load 胎心音資料
    [self loadServerData];

    
}
- ( void )switchToTab2
{
    m_enumPregnantPageType = RH_PregnantPage_Echo;
    [self.m_pBtnTab1 setSelected:NO];
    [self.m_pBtnTab2 setSelected:YES];
    [self.m_pBtnTab3 setSelected:NO];
    [self.m_pBtnTab4 setSelected:NO];
    [self.m_pCntView setHidden:NO];
    [self.m_pWeightScrollView setHidden:YES];
    [self.m_pBtnTakePic setHidden:NO];
    [self.m_pBtnEdit setHidden:NO];
    [self.m_pBtnTakePic setTitle:@"拍照" forState:UIControlStateNormal];
    
    [self.m_pTFWeight resignFirstResponder];
    //Load超音波資料
    [self loadServerData];
    
}
- ( void )switchToTab3
{
    m_enumPregnantPageType = RH_PregnantPage_Shape;
    [self.m_pBtnTab1 setSelected:NO];
    [self.m_pBtnTab2 setSelected:NO];
    [self.m_pBtnTab3 setSelected:YES];
    [self.m_pBtnTab4 setSelected:NO];
    [self.m_pCntView setHidden:NO];
    [self.m_pWeightScrollView setHidden:YES];
    [self.m_pBtnTakePic setHidden:NO];
    [self.m_pBtnEdit setHidden:NO];
    [self.m_pBtnTakePic setTitle:@"拍照" forState:UIControlStateNormal];
    
    [self.m_pTFWeight resignFirstResponder];
    //身型資料
    [self loadServerData];
}
- ( void )switchToTab4
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    m_enumPregnantPageType = RH_PregnantPage_Weight;
    [self.m_pBtnTab1 setSelected:NO];
    [self.m_pBtnTab2 setSelected:NO];
    [self.m_pBtnTab3 setSelected:NO];
    [self.m_pBtnTab4 setSelected:YES];
    [self.m_pCntView setHidden:YES];
    [self.m_pWeightScrollView setHidden:NO];
    [self.m_pBtnTakePic setHidden:YES];
    [self.m_pBtnEdit setHidden:YES];
    [self.m_pWeightScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.m_pWeightView.frame.origin.y + self.m_pWeightView.frame.size.height)];
    
    NSLog(@"%@", NSStringFromCGSize(self.m_pWeightScrollView.contentSize));
    
    if ( pObj.m_nType == 1 || pObj.m_nType == 0  )
    {
        //Mom
        //檢查是否有留下懷孕前的體重身高
        //NSString *pstrHeight = [NSString stringWithFormat:@"%d", pObj.m_nHeight];
        //NSString *pstrWeight = [RHAppDelegate getWeight];
        
        BOOL bNeedShowInputDialog = NO;
        
        if ( pObj.m_nHeight != 0  )
        {
            //有資料
        }
        else
        {
            bNeedShowInputDialog = YES;
        }
        
        NSInteger nCheckWeight = pObj.m_nWeight;
        
        
        
        if ( nCheckWeight == 0 )
        {
            nCheckWeight = [[RHAppDelegate getWeight] integerValue];
        }
        
        
        if ( nCheckWeight != 0 )
        {
            //有資料
        }
        else
        {
            bNeedShowInputDialog = YES;
        }
        
        
        if ( bNeedShowInputDialog )
        {
            [self showInputDialog];
        }
        else
        {
            //體重資料
            [self loadServerData];
        }

    }
    else
    {
        //Dad
        //體重資料
        [self.m_pTFWeight setEnabled:NO];
        [self loadServerData];
    }
}
- ( void )loadServerData
{
    [RHAppDelegate showLoadingHUD];
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    /** Type
     0 -> ￼unknow
     1 -> ￼mother’s body
     2 -> baby’s heart
     3 -> ￼baby’s ultrasonic photo
     **/
    
    switch ( m_enumPregnantPageType )
    {
        case RH_PregnantPage_Beat:
        {
            [pParameter setObject:@"2" forKey:kType];
            [pParameter setObject:@"1" forKey:kFilter];
            [pParameter setObject:@"[0, 1800000000]" forKey:kKeyWord];
            [RHLesEnphantsAPI getPreganatRecord:pParameter Source:self];
        }
            break;
        case RH_PregnantPage_Echo:
        {
            [pParameter setObject:@"3" forKey:kType];
            [pParameter setObject:@"1" forKey:kFilter];
            [pParameter setObject:@"[0, 1800000000]" forKey:kKeyWord];
            [RHLesEnphantsAPI getPreganatRecord:pParameter Source:self];

        }
            break;
        case RH_PregnantPage_Shape:
        {
            [pParameter setObject:@"1" forKey:kType];
            [pParameter setObject:@"1" forKey:kFilter];
            [pParameter setObject:@"[0, 1800000000]" forKey:kKeyWord];
            [RHLesEnphantsAPI getPreganatRecord:pParameter Source:self];
        }
            break;
        case RH_PregnantPage_Weight:
        {
            [pParameter setObject:@"1" forKey:kType];
            [pParameter setObject:@"1" forKey:kFilter];
            [pParameter setObject:@"[0, 1800000000]" forKey:kKeyWord];
            [RHLesEnphantsAPI getWeightRecord:pParameter Source:self];
        }
            break;
            
        default:
            break;
    }
}

- ( void )uploadImage:( UIImage * )pImg
{
    [RHAppDelegate showLoadingHUD];
    
    pImg = [pImg imageByNormalizingOrientation];
    
    if ( m_enumPregnantPageType == RH_PregnantPage_Echo )
    {
        //上傳超音波照片
        
        //upload data to server
        NSDateFormatter *pFormater = [[NSDateFormatter alloc] init];
        [pFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *pstrDateString = [pFormater stringFromDate:[NSDate date]];
        
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [pParameter setObject:@"3" forKey:kType];
        [pParameter setObject:pstrDateString forKey:kTime];
        
        
        [pParameter setObject:@"" forKey:kMeta];//yyyy-MM-DD HH:mm:ss
        [pFormater release];
        
        NSData *jpegData = UIImageJPEGRepresentation(pImg, 0.85f);
        
        [pParameter setObject:jpegData forKey:kFile];
        
        [RHLesEnphantsAPI addPreganatRecord:pParameter Source:self];

    }
    else if ( m_enumPregnantPageType == RH_PregnantPage_Shape )
    {
        //上傳身型照片
        //upload data to server
        NSDateFormatter *pFormater = [[NSDateFormatter alloc] init];
        [pFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *pstrDateString = [pFormater stringFromDate:[NSDate date]];
        
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [pParameter setObject:@"1" forKey:kType];
        [pParameter setObject:pstrDateString forKey:kTime];
        
        
        [pParameter setObject:@"" forKey:kMeta];//yyyy-MM-DD HH:mm:ss
        [pFormater release];
        
        NSData *jpegData = UIImageJPEGRepresentation(pImg, 0.85f);
        
        [pParameter setObject:jpegData forKey:kFile];
        
        [RHLesEnphantsAPI addPreganatRecord:pParameter Source:self];

    }
}


- ( void )showInputDialog
{
    __block NSString *pstrInputWeightText = @"";
    __block NSString *pstrInputHeightText = @"";
    
    UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 160)] autorelease];
    [pView setBackgroundColor:[UIColor lightGrayColor]];
    
    
    UILabel *pLblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 40)] autorelease];
    [pLblTitle setTextAlignment:NSTextAlignmentCenter];
    [pLblTitle setTextColor:[UIColor blackColor]];
    [pLblTitle setText:@"請輸入懷孕前身高、體重"];
    
    UITextField *pTxtView1 = [[[UITextField alloc] initWithFrame:CGRectMake(10, 50, 240, 40)] autorelease];
    [pTxtView1 setPlaceholder:@"請輸入身高（公分）"];
    [pTxtView1 setBorderStyle:UITextBorderStyleRoundedRect];
    
    UITextField *pTxtView = [[[UITextField alloc] initWithFrame:CGRectMake(10, 100, 240, 40)] autorelease];
    [pTxtView setPlaceholder:@"請輸入體重（公斤）"];
    [pTxtView setBorderStyle:UITextBorderStyleRoundedRect];
    
    [pView addSubview:pLblTitle];
    [pView addSubview:pTxtView];
    [pView addSubview:pTxtView1];
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nHeight != 0 )
    {
        [pTxtView1 setText:[NSString stringWithFormat:@"%d", pObj.m_nHeight]];
    }
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    //        alertView.tag = kVisitTag;
    // Add some custom content to the alert view
    [alertView setContainerView:pView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"送出", nil]];
    
    [alertView show];
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex)
     {
         
         NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex,[alertView tag]);
         
         if (buttonIndex == 0)
         {
             [alertView close];
         }
         else if (buttonIndex == 1)
         {
             pstrInputWeightText = [pTxtView text];
             pstrInputHeightText = [pTxtView1 text];
             
             CGFloat fHeight = [pstrInputHeightText floatValue];
             CGFloat fWeight = [pstrInputWeightText floatValue];
             
             BOOL bIsValid = YES;
             
             
             if ( [pstrInputHeightText compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
             {
                 bIsValid = NO;
                 [RHAppDelegate MessageBox:@"請輸入身高"];
             }
             else
             {
                 if ( [pstrInputWeightText compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
                 {
                     bIsValid = NO;
                     [RHAppDelegate MessageBox:@"請輸入體重"];
                 }
                 else
                 {
                     if ( fWeight > fHeight )
                     {
                         bIsValid = NO;
                         [RHAppDelegate MessageBox:@"身高體重輸入有誤"];
                     }
                 }
             }
             
             
             if ( bIsValid )
             {
                 //save data
                 [RHAppDelegate saveHeightAndWeight:pstrInputHeightText Weight:pstrInputWeightText];
                 
                 //save height to server
                 
                 [RHAppDelegate showLoadingHUD];
                 NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
                 [pParameter setObject:pstrInputHeightText forKey:kHeight];
                 [pParameter setObject:pstrInputWeightText forKey:kWeight];
                 [RHLesEnphantsAPI setUserProfile:pParameter Source:self];
                 
             }
             else
             {
                 [self performSelector:@selector(showInputDialog) withObject:nil afterDelay:0.50f];
             }
         }
         
     }];
}


- ( void )updateGraph:( NSArray * )pArray
{
    NSLog(@"pArray = %@", pArray);
    
    if ( self.m_pGraph )
    {
        if ( self.m_pGraph.superview )
        {
            [self.m_pGraph removeFromSuperview];
        }
    }
    
//    CGFloat fHeight = [[RHAppDelegate getHeight] floatValue] / 100.0f;
//    CGFloat fBMI = [[RHAppDelegate getWeight] floatValue] / (fHeight * fHeight);
//    NSLog(@"fBMI = %f", fBMI);
//    
//    NSInteger nIncreaseStep = 0;
//    NSInteger nLowerBound = 0;
//    NSInteger nUpperBound = 0;
//    if ( fBMI < 19.8 )
//    {
//        nIncreaseStep = 0.5;
//        nLowerBound = 12.5;
//        nUpperBound = 18;
//    }
//    else if ( fBMI < 26 )
//    {
//        nIncreaseStep = 0.4;
//        nLowerBound = 11.5;
//        nUpperBound = 16;
//
//    }
//    else
//    {
//        nIncreaseStep = 0.3;
//        nLowerBound = 7;
//        nUpperBound = 11.5;
//
//    }
//    
//    NSMutableArray *pLowerBoundArray = [NSMutableArray arrayWithCapacity:1];
//    NSMutableArray *pUpperBoundArray = [NSMutableArray arrayWithCapacity:1];
//    
//    for ( NSInteger i = 0; i < [pArray count]; ++i )
//    {
//        id obj = [pArray objectAtIndex:i];
//        if ( [obj isKindOfClass:[NSNull class]] )
//        {
//            //空的一週，沒有填資料
//            [pLowerBoundArray addObject:obj];
//            [pUpperBoundArray addObject:obj];
//        }
//        else
//        {
//            //有填資料
//        }
//    }
    
    
    
    
    iPhoneGraphViewController *pPhoneGraph = [[iPhoneGraphViewController alloc] initWithFrame:self.m_pGraphView.bounds];
    pPhoneGraph.contentMode = self.m_pGraphView.contentMode;
    [pPhoneGraph setDelegate:self];
    pPhoneGraph.fistArray = pArray;
    pPhoneGraph.secondArray = pArray;
    
    //change style graph (Yes = For lines, No = For charts)
    [pPhoneGraph setLinesGraph:YES];
    [self.m_pGraphView addSubview:pPhoneGraph];
    
    NSLog(@"pPhoneGraph.frame %@", NSStringFromCGRect(pPhoneGraph.frame));
    
    self.m_pGraph = pPhoneGraph;
    [pPhoneGraph release];
    
    [RHAppDelegate hideLoadingHUD];
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

- ( IBAction )pressCalendarBtn:(id)sender
{
    RHCalendarVC *pVC = [[RHCalendarVC alloc] initWithNibName:@"RHCalendarVC" bundle:nil];
    [pVC setDelegate:self];
    [self.navigationController pushViewController:pVC animated:YES];
}

- ( IBAction )pressCameraBtn:( id )sender
{
    [RHAppDelegate showLoadingHUD];

    if ( m_enumPregnantPageType == RH_PregnantPage_Beat )
    {

        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.showsCameraControls = YES;
        picker.allowsEditing = YES;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        [picker setVideoMaximumDuration:15.0f];
        [self presentViewController:picker animated:YES completion:nil];

    }
    else if ( m_enumPregnantPageType != RH_PregnantPage_Weight)
    {
        if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }

    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( IBAction )pressKnowledgeBtn:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOpenKnowledgePage object:nil userInfo:nil];
}


- ( IBAction )pressEditBtn:(id)sender
{
    m_bIsEdit = !m_bIsEdit;

    [self.m_pCntTableView reloadData];
}

#pragma mark - LesEnphantsAPI Delegate
- ( void )callBackSetUserProfileStatus:( NSDictionary * )pStatusDic
{
    
    
    
    [RHAppDelegate hideLoadingHUD];
    [self loadServerData];
}

- ( void )callBackAddPregnantRecordStatus:( NSDictionary * )pStatusDic
{
    NSLog(@"callBackAddPregnantRecordStatus -> %@", pStatusDic);
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [self loadServerData];
        
        NSInteger point = [[pStatusDic objectForKey:@"Point"] integerValue];
        [self showAnimation:point];
    }
    else
    {
        [RHAppDelegate MessageBox:@"上傳失敗"];
        [RHAppDelegate hideLoadingHUD];
    }
}

- ( void )callBackGetPregnantRecordStatus:( NSDictionary * )pStatusDic
{
    NSLog(@"callBackGetPregnantRecordStatus -> %@", pStatusDic);
    [m_pDataArray removeAllObjects];

    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSArray *pArray = [pStatusDic objectForKey:@"recordSet"];
        for ( NSInteger i = [pArray count]-1; i >= 0; i-- )
        {
            [m_pDataArray addObject:[pArray objectAtIndex:i]];
        }
        
        if (pArray.count == 0) {
            [self.m_pBtnEdit setHidden:YES];
        }
        else {
            [self.m_pBtnEdit setHidden:NO];
        }
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [self.m_pCntView setHidden:NO];
    [self.m_pCntTableView reloadData];
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackDelPregnantRecordStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [self loadServerData];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
}

- ( void )callBackGetPregnantWeightStatus:( NSDictionary * )pStatusDic
{
    
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        self.m_pWeightDataArray = [pStatusDic objectForKey:@"weight"];
        
        
        NSMutableArray *pArray = [NSMutableArray arrayWithCapacity:1];
        
        for ( NSInteger i = 0;  i < 45; ++i )
        {
            [pArray addObject:[NSNull null]];
        }
        
        RHProfileObj *pObj = [RHProfileObj getProfile];
        
        //需與一起始的體重做處理
        NSInteger nOriWeight = pObj.m_nWeight;
        
        if ( nOriWeight == 0 )
        {
            nOriWeight = [[RHAppDelegate getWeight] integerValue];
        }
        
        
        
        for ( NSInteger i = 0;  i < [m_pWeightDataArray count]; ++i )
        {
            NSDictionary *pDic = [m_pWeightDataArray objectAtIndex:i];
            NSInteger nWeight = [[pDic objectForKey:@"weight"] integerValue];
            
            
            NSInteger nDiff = nWeight - nOriWeight;
            nDiff = MAX(nDiff, 0);
            
            NSInteger nWeek = [[pDic objectForKey:@"weeks"] integerValue];
            
            [pArray removeObjectAtIndex:nWeek];
            [pArray insertObject:[NSString stringWithFormat:@"%d", nDiff] atIndex:nWeek];
            
        }
        
        
        
        self.m_pDifferArray = pArray;
        
        [self updateGraph:pArray];
        
        
        [self.m_pWeightTable reloadData];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackAddPregnantWeightStatus:( NSDictionary * )pStatusDic
{
    
    NSInteger point = [[pStatusDic objectForKey:@"Point"] integerValue];
    [self showAnimation:point];

    [self loadServerData];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = 0;
    
    if ( [tableView tag] == 1000 )
    {
        if ( m_pWeightDataArray )
        {
            nCount = [m_pWeightDataArray count];
        }
    }
    else
    {
        if ( m_pDataArray )
        {
            nCount = [m_pDataArray count];
        }
    }
    
    NSLog(@"nCount = %d", nCount);
    
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [tableView tag] == 1000 )
    {
        static NSString *RHWeightCntCellIdentifier = @"RHWeightCntCellIdentifier";
        
        RHWeightCntCell *cell = [tableView dequeueReusableCellWithIdentifier:RHWeightCntCellIdentifier];
        if (cell == nil)
        {
            //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RHWeightCntCellIdentifier] autorelease];
            NSArray *pArray =  [[NSBundle mainBundle] loadNibNamed:@"RHWeightCntCell" owner:self options:nil];
            
            for ( id oneView in pArray )
            {
                if ( [oneView isKindOfClass:[RHWeightCntCell class]] )
                {
                    cell = oneView;
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        // Configure the cell...
        
        NSUInteger nRow = [indexPath row];
        
        NSDictionary *pDic = [m_pWeightDataArray objectAtIndex:([m_pWeightDataArray count] - nRow - 1)];

        NSInteger nWeeks = [[pDic objectForKey:@"weeks"] integerValue];
        CGFloat nWeight = [[pDic objectForKey:@"weight"] floatValue];

        [cell.m_pLblWeek setText:[NSString stringWithFormat:@"%d", nWeeks]];
        [cell.m_pLblWeight setText:[NSString stringWithFormat:@"%.0f", nWeight]];
        
        
//        if ( nRow == 0 )
//        {
//            [cell.m_pLblDiff setText:@"0"];
//        }
//        else
        {
//            NSDictionary *pLastWeek = [m_pWeightDataArray objectAtIndex:nRow-1];
//            NSInteger nLastWeight = [[pLastWeek objectForKey:@"weight"] integerValue];
//            NSInteger nDiff = nWeight - nLastWeight;
            
            CGFloat nDiff = [[m_pDifferArray objectAtIndex:nWeeks] floatValue];
            
            [cell.m_pLblDiff setText:[NSString stringWithFormat:@"%.0f", nDiff]];
        }
        
        
        return cell;

    }
    else
    {
        static NSString *RHPregnantCntCellIdentifier = @"RHPregnantCntCellIdentifier";
        
        RHPregnantCntCell *cell = [tableView dequeueReusableCellWithIdentifier:RHPregnantCntCellIdentifier];
        if (cell == nil)
        {
            //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            NSArray *pArray =  [[NSBundle mainBundle] loadNibNamed:@"RHPregnantCntCell" owner:self options:nil];
            
            for ( id oneView in pArray )
            {
                if ( [oneView isKindOfClass:[RHPregnantCntCell class]] )
                {
                    cell = oneView;
                }
            }
        }
        
        // Configure the cell...
        
        NSUInteger nRow = [indexPath row];
        
        
        
        [cell setupData:[m_pDataArray objectAtIndex:nRow] Section:nRow];
        [cell prepareUI:m_bIsEdit];
        
        
        return cell;

    }

}

#pragma mark - RHCalendarVC Delegate
- ( void )callBackSelectedDate:( NSDate * )pDate
{
    RHAddEventVC *pVC = [[RHAddEventVC alloc] initWithNibName:@"RHAddEventVC" bundle:nil];
    [pVC setM_pSelDate:pDate];
    [self.navigationController pushViewController:[pVC autorelease] animated:YES];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    NSLog(@"mediaType = %@", mediaType);
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"original image:%@",NSStringFromCGSize(image.size));
        [self performSelector:@selector(uploadImage:) withObject:image afterDelay:0.25f];
    }
    else
    {
        NSString *videoPath1 = @"";

        
        //Video
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
        {
            NSString *moviePath = (NSString*)[[info objectForKey:UIImagePickerControllerMediaURL] path];
            
            NSLog(@"moviePath = %@", moviePath);
            
            
            NSString *videoURL = info[UIImagePickerControllerMediaURL];
            NSLog(@"videoURL = %@", videoURL);

            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath))
            {
                NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                videoPath1 =[NSString stringWithFormat:@"%@/xyz.mov",docDir];
                NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
                NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
                [videoData writeToFile:videoPath1 atomically:NO];
            }
        }
        
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath1] options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        
        if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
        {
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *videoPath = [NSString stringWithFormat:@"%@/123.mp4", [paths objectAtIndex:0]];
            exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
            NSLog(@"videopath of your mp4 file = %@",videoPath);  // PATH OF YOUR .mp4 FILE
            exportSession.outputFileType = AVFileTypeMPEG4;
            
            //  CMTime start = CMTimeMakeWithSeconds(1.0, 600);
            //  CMTime duration = CMTimeMakeWithSeconds(3.0, 600);
            //  CMTimeRange range = CMTimeRangeMake(start, duration);
            //   exportSession.timeRange = range;
            //  UNCOMMENT ABOVE LINES FOR CROP VIDEO
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                NSLog(@"exportAsynchronouslyWithCompletionHandler = %d",[exportSession status] );
                switch ([exportSession status])
                {
                        
                    case AVAssetExportSessionStatusFailed:
                        NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                        
                        break;
                        
                    case AVAssetExportSessionStatusCancelled:
                        
                        NSLog(@"Export canceled");
                        
                        break;
                        
                        case AVAssetExportSessionStatusCompleted:
                    {
                        //上傳影片
                        
                        //upload data to server
                        NSDateFormatter *pFormater = [[NSDateFormatter alloc] init];
                        [pFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *pstrDateString = [pFormater stringFromDate:[NSDate date]];
                        
                        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
                        
                        [pParameter setObject:@"2" forKey:kType];
                        [pParameter setObject:pstrDateString forKey:kTime];
                        
                        
                        [pParameter setObject:@"" forKey:kMeta];//yyyy-MM-DD HH:mm:ss
                        [pFormater release];

                        NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:videoPath]];
                        
                        [pParameter setObject:videoData forKey:kFile];
                        
                        [RHLesEnphantsAPI addPreganatRecord:pParameter Source:self];
                        
                        [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
                        
                    }
                        break;
                    default:
                        
                        break;
                        
                }
                [exportSession release];
                
            }];
            
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [picker release];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textField -> %d", textField.tag);
    
    // 體重不正確就跳出
    /*CGFloat weight = [textField.text floatValue];
    if (weight <=0 || weight > 20) {
        
        [textField resignFirstResponder];

        MBProgressHUD *m_HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        m_HUD.mode = MBProgressHUDModeText;
        m_HUD.labelText = @"不正確的數字";
        //m_HUD.detailsLabelText = nil;
        m_HUD.removeFromSuperViewOnHide = YES;
        [m_HUD hide:YES afterDelay:2.0];

        return YES;
    }*/
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSDateFormatter *pFormater = [[NSDateFormatter alloc] init];
    [pFormater setDateFormat:@"yyyy-MM-dd"];
    NSString *pstrDateString = [pFormater stringFromDate:[NSDate date]];
    
    
    [pParameter setObject:pstrDateString forKey:kDate];
    [pParameter setObject:[textField text] forKey:kWeight];
    NSLog(@"%@", textField.text);
    
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI addWeightRecord:pParameter Source:self];
    
    textField.text = nil;
    
    [textField resignFirstResponder];
    
    return YES;
    
}


@end
