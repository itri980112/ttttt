//
//  ECChatTableCell.h
//  ECChatBubbleView
//
//  Created by Soul on 2014/5/25.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "NSAttributedString+Attributes.h"
#import "MarkupParser.h"
#import "OHAttributedLabel.h"
#import "CustomMethod.h"
#import "CustomLongPressGestureRecognizer.h"
#import "AsyncImageView.h"
#import "ImageCache.h"

#import "RHAppDelegate.h"

typedef enum
{
    ECAvatarTypeOfElse          =   0,          //對方
    ECAvatarTypeOfMine          =   1,          //本人
} ECAvatarType;

typedef enum
{
    ECSourceTypeOfMessage       =   0,          //訊息
    ECSourceTypeOfImage         =   1,          //圖片
} ECSourceType;

@class OHAttributedLabelDelegate;

@interface ECChatTableCell : UITableViewCell <OHAttributedLabelDelegate>

/**
 *  傳入訊息資料
 */
@property (nonatomic, retain) NSMutableDictionary *m_pMSGData;

/**
 *  表情對照清單
 */
@property (nonatomic, retain) NSDictionary *m_pdicEmoji;

/**
 *  長壓的手勢
 */
@property (nonatomic, retain) CustomLongPressGestureRecognizer *recognizer;

/**
 *  顯示訊息的框架
 */
@property (nonatomic, strong) OHAttributedLabel *m_plblMSG;

/**
 *  UIImageView
 */
@property (nonatomic, retain) UIImageView *m_pimgPIC;

/**
 *  裝載資訊的View
 */
@property (nonatomic, retain) UIView *m_pContentView;

/**
 *  顯示日期
 */
@property (nonatomic, retain) UILabel *m_plblDate;

/**
 *  顯示時間
 */
@property (nonatomic, retain) UILabel *m_plblTime;

/**
 *  讀取狀態
 */
@property (nonatomic, retain) UILabel *m_plblRead;

/**
 *  泡泡框架
 */
@property (nonatomic, retain) UIImageView *m_pimgBubble;

/**
 *  來自
 */
@property (nonatomic) ECAvatarType m_eECAvatarType;

/**
 *  訊息來源
 */
@property (nonatomic) ECSourceType m_eECSourceType;

/**
 *  訊息內容
 */
@property (nonatomic, retain) NSString *m_pstrMSG;

/**
 *  訊息時間
 */
@property (nonatomic, retain) NSString *m_pstrTime;

/**
 *  訊息日期
 */
@property (nonatomic, retain) NSString *m_pstrDate;

/**
 *  讀取狀態
 */
@property (nonatomic, retain) NSString *m_pstrRead;



@property (nonatomic, retain) AsyncImageView *m_pImgSync;


@property (nonatomic, retain) NSURL *requestURL;

- (void) setInitial;


/* 回傳訊息高度 */
+ (CGFloat) neededHeightForMessageData:(NSMutableDictionary *)messageData;

/* 回傳圖片高度 */
+ (CGFloat) neededHeightForImageData:(NSMutableDictionary *)messageData;

@end
