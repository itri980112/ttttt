//
//  RHCalendarVC.h
//  FashionBeauty
//
//  Created by Rusty Huang on 2014/7/24.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol RHCalendarVCDelegate <NSObject>

@optional
- ( void )callBackSelectedDate:( NSDate * )pDate;

@end

@class JZCalandarView;
@class UIMonthYearPicker;
@interface RHCalendarVC : UIViewController
{
    id<RHCalendarVCDelegate>    delegate;
    NSDate      *m_pSelDate;
    MBProgressHUD   *m_pHud;
    
    JZCalandarView      *m_pJZCalandarView;
    UIMonthYearPicker       *m_pUIMonthYearPicker;
}

@property ( nonatomic, assign ) id<RHCalendarVCDelegate>    delegate;
@property ( nonatomic, retain ) JZCalandarView      *m_pJZCalandarView;
@property ( nonatomic, retain ) MBProgressHUD       *m_pHud;
@property ( nonatomic, retain ) NSDate              *m_pSelDate;
@property ( nonatomic, retain ) UIMonthYearPicker       *m_pUIMonthYearPicker;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblDate;
@property (retain, nonatomic) IBOutlet UIView *m_pCalendarBgView;

@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;

#pragma mark - IBaction
- ( IBAction )pressnNextBtn:( id )sender;
- ( IBAction )pressPrevBtn:( id )sender;
- ( IBAction )pressBackBtn:( id )sender;
@end
