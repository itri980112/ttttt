//
//  JZCalandarView.h
//  CalendarDemo
//
//  Created by Rusty Huang on 13/2/22.
//  Copyright (c) 2013年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JZCalandarViewDelegate <NSObject>

@optional
- ( void )callBackPressIdx:( NSInteger )nIdx;
- ( void )callBackSelectedDate:( NSDate * )pDate;
- ( void )callBackSelectedDateString:( NSString * )pDateString;
@end

@interface JZCalandarView : UIView
{
    id< JZCalandarViewDelegate >    delegate;
    CGFloat         m_fWidth;
    CGFloat         m_fHeight;
    
    CGFloat         m_fCalendarCellWidth;
    CGFloat         m_fCalendarCellHeight;
    
    NSDate          *m_pSpecifiedDate;
    
    BOOL            m_bShowDate;
    
    NSMutableArray          *m_pCalendarCellArray;
    NSMutableArray          *m_pCalendarStringArray;
}

@property ( nonatomic ,assign ) id< JZCalandarViewDelegate >    delegate;
@property ( nonatomic, retain ) NSDate                  *m_pSpecifiedDate;
@property ( nonatomic, retain ) NSMutableArray          *m_pCalendarCellArray;
@property ( nonatomic, retain ) NSMutableArray          *m_pCalendarStringArray;
@property                       BOOL                    m_bShowDate;
#pragma mark - Customized Methods
- ( void )setupCalendarCell:( CGSize )kCellSize;

- ( CGSize )initCalandar;

- ( void )setCalendarWithDate:( NSDate * )pDate;
- ( NSDate * )moveToNextMonth;
- ( NSDate * )moveToPreMonth;
- ( NSDate * )moveToNextYear;
- ( NSDate * )moveToPreYear;
- ( NSDate * )moveToToday;
- ( NSString * )getDateWithFormat:( NSString * )pstrFormat;
- ( void )showDate;
- ( NSInteger )getCurrentStartCount;




@end
