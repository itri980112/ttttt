//
//  JZCalandarView.m
//  CalendarDemo
//
//  Created by Rusty Huang on 13/2/22.
//  Copyright (c) 2013年 Rusty Huang. All rights reserved.
//

#import "JZCalandarView.h"

static int g_nSpace[13]={-1,0,0,0,0,0,0,0,0,0,0,0,0};
static int g_nDays[13]={-1,31,28,31,30,31,30,31,31,30,31,30,31};


@interface JZCalandarView ( Private)
- ( void )reDrawCalandar;
- ( void )processDate;
- ( NSString * )getDateStringWithDate:( NSDate * )pDate;
- ( NSString * )getYearStringFromDate:( NSDate * )pDate;
- ( NSString * )getMonthStringFromDate:( NSDate * )pDate;
- ( NSString * )getDayStringFromDate:( NSDate * )pDate;
- ( NSString * )getDateStringWithFormat:( NSDate * )pDate Formate:( NSString * )pstrFormat;
- ( NSDate * )getDateFromSpecifiedDateString:( NSString * )pstrDateString;
- ( NSString * )getDayStringWithDiffDays:( NSString * )pstrBaseDateString WithShiftDay:( NSInteger )nDay;
- ( IBAction )pressDateBtn:(id)sender;
@end


@implementation JZCalandarView
@synthesize m_pSpecifiedDate;
@synthesize m_bShowDate;
@synthesize m_pCalendarCellArray;
@synthesize m_pCalendarStringArray;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_fWidth = frame.size.width;
        m_fHeight = frame.size.height;
        self.m_pSpecifiedDate = nil;
        m_bShowDate = YES;
        
        m_fCalendarCellHeight = 0.0f;
        m_fCalendarCellWidth = 0.0f;
        
        self.m_pCalendarCellArray = [NSMutableArray arrayWithCapacity:42];
        self.m_pCalendarStringArray = [NSMutableArray arrayWithCapacity:42];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- ( void )dealloc
{
    [m_pSpecifiedDate release];
    [m_pCalendarCellArray release];
    [m_pCalendarStringArray release];
    [super dealloc];
}

#pragma mark - Private Methods
- ( void )reDrawCalandar
{
    if ( !m_bShowDate )
    {
        return;
    }
}

- ( void )processDate
{
    NSInteger nYear;
    NSInteger nMonth;
    NSInteger nFirst_space;
    NSInteger nFeb_days;
    
    nYear = [[self getYearStringFromDate:m_pSpecifiedDate] integerValue];
    nMonth = [[self getMonthStringFromDate:m_pSpecifiedDate] integerValue];
    
    nFirst_space = 1;
    if( nMonth <= 12 && nMonth >= 1 )
    {
        for( NSInteger q = 0 ; q < ( nYear - 1900 ); q++ )
        {
            if( (( q % 4 == 0 ) && ( q % 100 != 0 ) ) || ( q % 400 == 100 ) )
            {
                //閏年
                nFirst_space = ( nFirst_space + 366 ) % 7;
            }
            else
            {
                //非閏年
                nFirst_space = ( nFirst_space + 365 ) % 7;
            }
        }
    }
    
    //計算2月天數
    if( (nYear % 4 == 0 && nYear % 100 != 0) || nYear % 400 == 0 )
    {
        nFeb_days =29;
    }
    else
    {
        nFeb_days =28;
    }
    
    //修改陣列值
    g_nSpace[1] = nFirst_space;
    for ( NSInteger i = 1; i < 12; ++i )
    {
        g_nSpace[i+1] = ( g_nSpace[i] + g_nDays[i] ) % 7;
    }
    
    //修改2月的值
    g_nDays[2] = nFeb_days;
    
    
    NSString *pstrSpaceCount = @"";
    NSString *pstrDayCount = @"";
    for ( NSInteger i = 1; i < 13; ++i )
    {
        NSString *pstrTmp = [NSString stringWithFormat:@"%d, ", g_nSpace[i]];
        pstrSpaceCount = [pstrSpaceCount stringByAppendingString:pstrTmp];
    }
    
    NSLog(@"%d年，每個月的Space為:%@", nYear, pstrSpaceCount);
    
    for ( NSInteger i = 1; i < 13; ++i )
    {
        NSString *pstrTmp = [NSString stringWithFormat:@"%d, ", g_nDays[i]];
        pstrDayCount = [pstrDayCount stringByAppendingString:pstrTmp];
    }
    
    NSLog(@"%d年，每個月的天數為:%@", nYear, pstrDayCount);

    
    //處理日期陣列
    [m_pCalendarStringArray removeAllObjects];
    NSString *pstrMonth = [self getMonthStringFromDate:m_pSpecifiedDate];
    NSString *pstrYear = [self getYearStringFromDate:m_pSpecifiedDate];
    NSInteger nProcessSpace = g_nSpace[[pstrMonth intValue]];
    NSInteger nProcessDays = g_nDays[[pstrMonth intValue]];
    
    //缺口處先填上上個月的日期
    for ( NSInteger i = 0; i < nProcessSpace; ++i )
    {
        //當月的第一天
       NSString *pstrBaseString = [NSString stringWithFormat:@"%@-%@-%02d", pstrYear, pstrMonth,1];
        [m_pCalendarStringArray addObject:[self getDayStringWithDiffDays:pstrBaseString WithShiftDay:(i - nProcessSpace)]];
    }
    
    //把當月的日期都加上去
    for ( NSInteger i = 0; i < nProcessDays; ++i )
    {
        NSString *pstr = [NSString stringWithFormat:@"%@-%@-%02d", pstrYear, pstrMonth,i+1];
        [m_pCalendarStringArray addObject:pstr];
    }
    
    NSLog(@"m_pCalendarStringArray count = %d", [m_pCalendarStringArray count]);
    
    NSInteger nDiff = 42 - [m_pCalendarStringArray count];
    
    
    NSString *pstrLastDateInThisMonth = [m_pCalendarStringArray objectAtIndex:(nProcessSpace+nProcessDays-1)];
    NSLog(@"pstrLastDateInThisMonth = %@", pstrLastDateInThisMonth);
    //處理下個月的資料
    for ( NSInteger i = 0; i < nDiff; ++i )
    {
        [m_pCalendarStringArray addObject:[self getDayStringWithDiffDays:pstrLastDateInThisMonth WithShiftDay:(i+1)]];
    }
    
    
    
    NSLog(@"m_pCalendarStringArray = %@", m_pCalendarStringArray);
}

- ( NSString * )getDateStringWithDate:( NSDate * )pDate
{
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *pstrDateString = [pFormatter stringFromDate:pDate];
    [pFormatter release];
    
    return pstrDateString;
}

- ( NSString * )getYearStringFromDate:( NSDate * )pDate
{
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"yyyy"];
    NSString *pstrDateString = [pFormatter stringFromDate:pDate];
    [pFormatter release];
    
    return pstrDateString;
}

- ( NSString * )getMonthStringFromDate:( NSDate * )pDate
{
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"MM"];
    NSString *pstrDateString = [pFormatter stringFromDate:pDate];
    [pFormatter release];
    
    return pstrDateString;
}

- ( NSString * )getDayStringFromDate:( NSDate * )pDate
{
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"dd"];
    NSString *pstrDateString = [pFormatter stringFromDate:pDate];
    [pFormatter release];
    
    return pstrDateString;
}

- ( NSString * )getDateStringWithFormat:( NSDate * )pDate Formate:( NSString * )pstrFormat
{
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:pstrFormat];
    NSString *pstrDateString = [pFormatter stringFromDate:pDate];
    [pFormatter release];
    
    return pstrDateString;
}

- ( IBAction )pressDateBtn:(id)sender
{
    UIButton *pBtn = ( UIButton * )sender;
    NSInteger nIdx = pBtn.tag;
    
    NSLog(@"pressDateBtn : %d", nIdx);
    
    if ( delegate && [delegate respondsToSelector:@selector(callBackSelectedDate:)] )
    {
        NSString *pstrDateString = [m_pCalendarStringArray objectAtIndex:nIdx];
        NSDate *pDate = [self getDateFromSpecifiedDateString:pstrDateString];
        [delegate callBackSelectedDate:pDate];
    }
    
}


- ( NSString * )getDayStringWithDiffDays:( NSString * )pstrBaseDateString WithShiftDay:( NSInteger )nDay
{
    NSString *pstrReturn = @"";
    
    NSInteger nDiff = nDay * 86400;
    NSDate *pDate = [self getDateFromSpecifiedDateString:pstrBaseDateString];
    NSTimeInterval dTimeInterval = [pDate timeIntervalSince1970];
    
    dTimeInterval += nDiff;
    
    NSDate *pNewDate = [NSDate dateWithTimeIntervalSince1970:dTimeInterval];
    
    pstrReturn = [self getDateStringWithDate:pNewDate];
    
    
    return pstrReturn;
}
                                   
- ( NSDate * )getDateFromSpecifiedDateString:( NSString * )pstrDateString
{
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *pDate = [pFormatter dateFromString:pstrDateString];
    [pFormatter release];
    
    return pDate;
}
                                   

#pragma mark - Customized Methods
- ( void )setupCalendarCell:( CGSize )kCellSize
{
    m_fCalendarCellWidth = kCellSize.width;
    m_fCalendarCellHeight = kCellSize.height;
    
}

- ( CGSize )initCalandar
{
    CGSize kReturnSize = CGSizeZero;
    if ( m_fCalendarCellWidth == 0 || m_fCalendarCellHeight == 0 )
    {
        //沒有設定Cell大小，就會用frame的大小來計算
        m_fCalendarCellWidth = m_fWidth / 7;
        m_fCalendarCellHeight = m_fHeight / 6;
    }
    
    NSLog(@"Cell Size = %f, %f", m_fCalendarCellWidth, m_fCalendarCellHeight);
    
    //重新計算frame
    //如果有設定Cell大小，那View的大小就會受到影響
    CGRect rect = self.frame;
    rect.size.width = m_fCalendarCellWidth * 7;
    rect.size.height = m_fCalendarCellHeight * 6;
    kReturnSize = rect.size;
    [self setFrame:rect];
    
    
    CGFloat fStartY = 0;
    CGFloat fStartX = 0;
    CGFloat fGap = 0;
    NSInteger nCell = 0;
    NSInteger nRow = 0;
    
    NSInteger nWidth = self.frame.size.width / 7;
    NSInteger nHeight = self.frame.size.height / 6;
    NSLog(@"nWidth = %d, nHeight = %d", nWidth, nHeight);
    
    for ( NSInteger i = 0; i < 42; ++i )
    {
        nCell = i % 7;
        nRow = i / 7;
        
        CGFloat fNewX = fStartX + nCell * ( fGap + m_fCalendarCellWidth );
        CGRect curRect = CGRectMake(fNewX,
                                    fStartY,
                                    m_fCalendarCellWidth,
                                    m_fCalendarCellHeight);
        
        if ( nCell == 6 )
        {
            //換行
            fStartX = 0;
            fStartY = fStartY + m_fCalendarCellHeight + fGap;
        }
        
        UIView *pView = [[UIView alloc] initWithFrame:curRect];
        [pView setBackgroundColor:[UIColor clearColor]];
        
        
        UIImageView *pImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"懷孕記事_tag_feedback.png"]];
        [pImgView setFrame:CGRectMake(0, 0, nWidth, nWidth)];
        [pImgView setTag:2000];
        [pView addSubview:pImgView];
        [pImgView release];
        
        UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pBtn setFrame:CGRectMake(1, 1, nWidth-2, nHeight-2)];
        [pBtn addTarget:self action:@selector(pressDateBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pBtn setTag:3000];
        [pBtn setTitle:@"" forState:UIControlStateNormal];
        pBtn.tag = i;
        [pBtn setBackgroundColor:[UIColor whiteColor]];
        [pBtn setTitleEdgeInsets:UIEdgeInsetsMake(-23, 0, 0, 0 )];
        [pBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [pBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [pBtn setBackgroundColor:[UIColor clearColor]];
        [pView addSubview:pBtn];
        
        UILabel *pLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, pBtn.frame.size.height - 15, pBtn.frame.size.width, 15)];
        [pLbl setText:@"產檢"];
        [pLbl setTag:1000];
        [pLbl setFont:[UIFont boldSystemFontOfSize:12]];
        [pLbl setBackgroundColor:[UIColor clearColor]];
        [pLbl setTextAlignment:NSTextAlignmentCenter];
        [pView addSubview:pLbl];
        [pLbl release];

        [pLbl setHidden:YES];
        [pImgView setHidden:YES];
        
        [self addSubview:pView];
        [m_pCalendarCellArray addObject:pView];
        [pView release];
    }
    
    return kReturnSize;
}

- ( void )setCalendarWithDate:( NSDate * )pDate
{
    self.m_pSpecifiedDate = pDate;
    
    [self processDate];
}

- ( NSDate * )moveToNextMonth
{
    NSDate *pNewDate = nil;
    
    if ( m_pSpecifiedDate )
    {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setMonth:1];
        NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        pNewDate = [calender dateByAddingComponents:comps toDate:m_pSpecifiedDate options:0];
        [comps release];
        [calender release];
        self.m_pSpecifiedDate = pNewDate;
    }
    
    //重新計算
    [self processDate];
    
    return pNewDate;
}

- ( NSDate * )moveToPreMonth
{
    NSDate *pNewDate = nil;
    
    if ( m_pSpecifiedDate )
    {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setMonth:-1];
        NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        pNewDate = [calender dateByAddingComponents:comps toDate:m_pSpecifiedDate options:0];
        [comps release];
        [calender release];
        self.m_pSpecifiedDate = pNewDate;
    }
    
    //重新計算
    [self processDate];
    
    return pNewDate;
}

- ( NSDate * )moveToNextYear
{
    NSDate *pNewDate = nil;
    
    if ( m_pSpecifiedDate )
    {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:1];
        NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        pNewDate = [calender dateByAddingComponents:comps toDate:m_pSpecifiedDate options:0];
        [comps release];
        [calender release];
        self.m_pSpecifiedDate = pNewDate;
    }
    
    //重新計算
    [self processDate];
    
    return pNewDate;
}

- ( NSDate * )moveToPreYear
{
    NSDate *pNewDate = nil;
    
    if ( m_pSpecifiedDate )
    {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-1];
        NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        pNewDate = [calender dateByAddingComponents:comps toDate:m_pSpecifiedDate options:0];
        [comps release];
        [calender release];
        self.m_pSpecifiedDate = pNewDate;
    }
    
    //重新計算
    [self processDate];
    
    return pNewDate;
}

- ( NSDate * )moveToToday;
{
    self.m_pSpecifiedDate = [NSDate date];
    
    //重新計算
    [self processDate];
    
    return m_pSpecifiedDate;
}

- ( NSString * )getDateWithFormat:( NSString * )pstrFormat
{
    if ( m_pSpecifiedDate == nil )
    {
        return @"當未指定時間";
    }
    
    NSString *pstrReturnString = @"";
    
    NSDateFormatter *pformater = [[NSDateFormatter alloc] init];
    [pformater setDateFormat:pstrFormat];
    pstrReturnString = [pformater stringFromDate:m_pSpecifiedDate];
    
    
    return pstrReturnString;
}
- ( void )showDate
{
    //先清空
    for ( NSInteger i = 0; i < [m_pCalendarCellArray count]; ++i )
    {
        UIView *pView = [m_pCalendarCellArray objectAtIndex:i];
        
        NSArray *pSubArray = [pView subviews];
        
        for ( id oneView in pSubArray )
        {
            if ( [oneView isKindOfClass:[UIButton class]])
            {
                UIButton *pBtn = ( UIButton * )oneView;
                [pBtn setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
    
    NSString *pstrTOday = [self getDateStringWithDate:[NSDate date]];
    
    //依照缺口，去畫日期
    NSInteger nMonth = [[self getMonthStringFromDate:m_pSpecifiedDate] integerValue];
    
    NSInteger nSpace = g_nSpace[nMonth];
    NSInteger nDay = g_nDays[nMonth];
    for ( NSInteger i = 0; i < [m_pCalendarStringArray count]  ; ++i )
    {
        UIView *pView = [m_pCalendarCellArray objectAtIndex:i];
        
        NSArray *pSubArray = [pView subviews];
        
        for ( id oneView in pSubArray )
        {
            if ( [oneView isKindOfClass:[UIButton class]])
            {
                UIButton *pBtn = ( UIButton * )oneView;
                NSString *pstrDateString = [m_pCalendarStringArray objectAtIndex:i];
                NSDate *pDate = [self getDateFromSpecifiedDateString:pstrDateString];
                NSString *pstrDay = [self getDateStringWithFormat:pDate Formate:@"d"];
                
                [pBtn setTitle:pstrDay forState:UIControlStateNormal];
                [pBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
                
                //設定上個月的顏色
                if ( i < nSpace || i >= ( nSpace + nDay) )
                {
                    [pBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                }
                
                
                if ( [pstrDateString compare:pstrTOday options:NSCaseInsensitiveSearch] == NSOrderedSame )
                {
                    
                    [pBtn setTitleColor:UIColorFromRGB(0xDDDD00) forState:UIControlStateNormal];
                }

                
                
            }
        }
    }

}

- ( NSInteger )getCurrentStartCount
{
    return g_nSpace[[[self getMonthStringFromDate:m_pSpecifiedDate] integerValue]];
}


@end
