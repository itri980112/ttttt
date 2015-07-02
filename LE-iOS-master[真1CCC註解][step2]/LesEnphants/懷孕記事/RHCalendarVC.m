//
//  RHCalendarVC.m
//  FashionBeauty
//
//  Created by Rusty Huang on 2014/7/24.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHCalendarVC.h"
#import "RHAppDelegate.h"
#import "JZCalandarView.h"
#import "LesEnphantsApiDefinition.h"
#import "RHLesEnphantsAPI.h"

@interface RHCalendarVC () < JZCalandarViewDelegate, UIActionSheetDelegate >
{
    NSArray *m_pEventArray;
}

@property ( nonatomic, retain ) NSArray *m_pEventArray;

- ( NSString * )stringFromDate:( NSDate * )pDate;
- ( void )updateUI;
- ( void )loadEventFromServer;
- ( void )updateEvent;
@end

@implementation RHCalendarVC
@synthesize m_pSelDate;
@synthesize m_pHud;
@synthesize m_pJZCalandarView;
@synthesize delegate;
@synthesize m_pUIMonthYearPicker;
@synthesize m_pEventArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pSelDate = [NSDate date];
        self.m_pHud = nil;
        self.m_pJZCalandarView = nil;
        self.m_pUIMonthYearPicker = nil;
        self.m_pEventArray = nil;
    }
    return self;
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setAlpha:1.0f];
    [self updateUI];
    
    if (self.m_pJZCalandarView == nil) {
        JZCalandarView *pCalandar = [[JZCalandarView alloc] initWithFrame:self.m_pCalendarBgView.bounds];
        pCalandar.autoresizingMask = self.m_pCalendarBgView.autoresizingMask;
        self.m_pJZCalandarView = pCalandar;
        [m_pJZCalandarView setDelegate:self];
        [pCalandar release];
        [self.m_pCalendarBgView addSubview:m_pJZCalandarView];
        
        [m_pJZCalandarView setCalendarWithDate:[NSDate date]];
        [m_pJZCalandarView initCalandar];
        [m_pJZCalandarView moveToToday];
        [m_pJZCalandarView showDate];
        self.m_pSelDate = m_pJZCalandarView.m_pSpecifiedDate;
    }

}

- ( void )viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view setAlpha:0.0f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_NOTE_TITLE", nil)];
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    [m_pEventArray release];
    [_m_pLblDate release];
    [_m_pCalendarBgView release];
    [m_pUIMonthYearPicker release];
    [super dealloc];
}

#pragma mark - Private Methods
- ( NSString * )stringFromDate:( NSDate * )pDate
{
    NSString *pstrReturnString = @"";
    
    NSDateFormatter *pFormater = [[NSDateFormatter alloc] init];
    [pFormater setDateFormat:@"yyyy-MM"];
    pstrReturnString = [pFormater stringFromDate:pDate];
    [pFormater release];
    
    return pstrReturnString;
}

- ( void )updateUI
{
    [self.m_pLblDate setText:[self stringFromDate:m_pSelDate]];
    [self loadEventFromServer];
}

- ( void )loadEventFromServer
{
    //先取得年月
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"yyyy-MM"];
    NSString *pstrDate = [pFormatter stringFromDate:m_pSelDate];
    
    
    
    NSString *pstrStartDate = [NSString stringWithFormat:@"%@-01", pstrDate];
    
    
    [pFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *pStartDate = [pFormatter dateFromString:pstrStartDate];
    
    NSTimeInterval kStartTimeInterval = [pStartDate timeIntervalSince1970];
    NSTimeInterval kEndTImeInterval = kStartTimeInterval + ( 31 * 24 * 60 * 60);
    NSString *pstrSearchKey = [NSString stringWithFormat:@"[%.0f,%.0f]", kStartTimeInterval, kEndTImeInterval];
    NSLog(@"pstrSearchKey = %@", pstrSearchKey);
    
    
    
    //Load Event
    [RHAppDelegate showLoadingHUD];
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:@"1" forKey:kFilter];
    [pParameter setObject:pstrSearchKey forKey:kKeyWord];
    
    [RHLesEnphantsAPI getPregnantEvent:pParameter Source:self];

}

- ( void )updateEvent
{
    
    NSArray *pCalendarArray = m_pJZCalandarView.m_pCalendarStringArray;
    
    
    NSLog(@"pCalendarArray = %@", pCalendarArray);

    
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *pstrToday = [pFormatter stringFromDate:[NSDate date]];

    //recover all
    for ( NSInteger i = 0;  i < [m_pJZCalandarView.m_pCalendarCellArray count] ; ++i )
    {
        UIView *pView = [m_pJZCalandarView.m_pCalendarCellArray objectAtIndex:i];
        UILabel *pLbl = (UILabel*)[pView viewWithTag:1000];
        UIImageView *pImgView = (UIImageView*)[pView viewWithTag:2000];
        [pLbl setHidden:YES];
        [pImgView setHidden:YES];
        //順便標示今日
        
        NSString *pstrDate = [m_pJZCalandarView.m_pCalendarStringArray objectAtIndex:i];
        
        UIButton *pBtn = ( UIButton * )[pView viewWithTag:3000];
        if ( [pstrToday compare:pstrDate options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            [pBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
            [pBtn setBackgroundColor:[UIColor redColor]];
        }
        else
        {
            [pBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        
    }
    
    
    
    for ( NSInteger i = 0; i < [pCalendarArray count]; ++i )
    {
        NSString *pstrDate = [pCalendarArray objectAtIndex:i];
        
        for ( NSInteger x = 0; x < [m_pEventArray count]; ++x )
        {
            NSDictionary *pDic = [m_pEventArray objectAtIndex:x];
            
            NSString *pstrEventDate = [pDic objectForKey:@"date"];
            
            if ( [pstrEventDate compare:pstrDate options:NSCaseInsensitiveSearch] == NSOrderedSame )
            {
                //找到一樣的
                UIView *pView = [m_pJZCalandarView.m_pCalendarCellArray objectAtIndex:i];
                UILabel *pLbl = (UILabel*)[pView viewWithTag:1000];
                UIImageView *pImgView = (UIImageView*)[pView viewWithTag:2000];
                
                BOOL bIsPregnantExamination = [[pDic objectForKey:@"isPrenatalExamination"] boolValue];
                //BOOL bIsEnablePush = [[pDic objectForKey:@"enablePush"] boolValue];
                
                NSArray *notes = [pDic objectForKey:@"notes"];
                BOOL bIsExistNotes = (notes && notes.count > 0) ? YES : NO ;
                
                if ( bIsPregnantExamination )
                {
                    [pLbl setHidden:NO];
                    [pImgView setHidden:NO];
                    [pImgView setImage:[UIImage imageNamed:@"懷孕記事_tag_feedback.png"]];
                }
                else
                {
                    [pLbl setHidden:YES];
                    [pImgView setHidden:NO];
                    [pImgView setImage:[UIImage imageNamed:@"懷孕記事_tag.png"]];
                }
                
                
                if ( bIsPregnantExamination == NO && bIsExistNotes == NO )
                {
                    [pImgView setImage:nil];
                }
                
                NSLog(@"pDic = %@", [pDic description]);
                
                continue;
            }
        }
        
    }
    
}

#pragma mark - IBAction
- ( IBAction )pressnNextBtn:( id )sender
{
    //go to next month
    [m_pJZCalandarView moveToNextMonth];
    [m_pJZCalandarView showDate];
    self.m_pSelDate = m_pJZCalandarView.m_pSpecifiedDate;
    [self updateUI];
}

- ( IBAction )pressPrevBtn:( id )sender
{
    //go to prev month
    [m_pJZCalandarView moveToPreMonth];
    [m_pJZCalandarView showDate];
    self.m_pSelDate = m_pJZCalandarView.m_pSpecifiedDate;
    [self updateUI];
}

- ( IBAction )pressBackBtn:( id )sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - JZCalandarViewDelegate
- ( void )callBackSelectedDate:( NSDate * )pDate
{
    if ( delegate && [delegate respondsToSelector:@selector(callBackSelectedDate:)] )
    {
        [delegate callBackSelectedDate:pDate];
    }
}

#pragma mark - UIMonthYearPickerDelegate
- (void)pickerView:(UIPickerView *)pickerView didChangeDate:(NSDate*)newDate
{
    self.m_pSelDate = newDate;
    [self.m_pJZCalandarView setCalendarWithDate:newDate];
    [m_pJZCalandarView showDate];

}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self updateUI];
}

#pragma mark - 
- ( void )callBackGetPregnantEventStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        self.m_pEventArray = [pStatusDic objectForKey:@"event"];
        [self updateEvent];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}


@end
