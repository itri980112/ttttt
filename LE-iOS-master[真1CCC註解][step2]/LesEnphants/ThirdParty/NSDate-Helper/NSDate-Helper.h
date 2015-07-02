//
//  NSDate-Helper.h
//  ASE
//
//  Created by Soul on 2014/3/3.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Helpers)

//取得年月日如:19871127.
- (NSString *)getFormatYearMonthDay;

//轉換NSDate string格式(yyyy/MM/dd MM:hh)
- (NSDate *) changeDateFromString:(NSString *)time;

//返回當前月一共有幾周(可能為4,5,6)
- (int)getWeekNumOfMonth;

//該日期是该年的第幾周
- (int)getWeekOfYear;

//返回day天後的日期(若day為日期,則為|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day;

//month個月後的日期
- (NSDate *)dateafterMonth:(int)month;

//取得日
- (NSUInteger)getDay;

//取得月
- (NSUInteger)getMonth;

//取得年
- (NSUInteger)getYear;

//取得小時
- (int)getHour;
- (int)getHour:(NSDate *)date;

//取得分鐘
- (int)getMinute;
- (int)getMinute:(NSDate *)date;

//在當前日期前幾天
- (NSUInteger)daysAgo;

//午夜時間距今幾天
- (NSUInteger)daysAgoAgainstMidnight;

- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;

//返回一周的第幾天(周末為第一天)
- (NSUInteger)weekday;

//轉為NSString類型的
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;

+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

//返回周日的的開始時間
- (NSDate *)beginningOfWeek;

//返回當前天的年月日.
- (NSDate *)beginningOfDay;

//返回該月的第一天
- (NSDate *)beginningOfMonth;

//該月的最後一天
- (NSDate *)endOfMonth;

//返回當前周的周末
- (NSDate *)endOfWeek;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
