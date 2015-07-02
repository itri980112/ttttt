//
//  ECChatInputView.h
//  ECChatBubbleView
//
//  Created by Soul on 2014/8/8.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ECChatEmojiAndPictureView.h"



#define TXTVINPUT_HEIGHT_MIN 65     //單行高度
#define TXTVINPUT_HEIGHT_MAX 145    //四行高度

typedef enum
{
    ECModeTypeOfNone                =   0,
    ECModeTypeOfWrite               =   1,          //寫
    ECModeTypeOfPicture             =   2,          //圖片
} ECModeType;

typedef enum
{
    ECMessageSendTypeOfMessage       =   0,          //訊息
    ECMessageSendTypeOfImage         =   1,          //圖片
} ECMessageSourceType;

@protocol ECChatInputViewDelegate <NSObject>

@required

- (void) callBackInputBarFrame:(CGRect)frame;

- (void) callBackReturnInitial;

- (void) callBackShowPicture:(ECModeType)eECModeType;

- (void) callBackMessageData:(NSString *)pstrMSG MessageSendType:(ECMessageSourceType)eECMessageSourceType;

@end

@interface ECChatInputView : UIView <UITextFieldDelegate, UITextViewDelegate, ECChatEmojiAndPictureViewDelegate>


@property (nonatomic, assign) id <ECChatInputViewDelegate> delegate;

@property (nonatomic, retain) ECChatEmojiAndPictureView *m_pECChatEmojiAndPictureView;

@property (nonatomic) ECModeType m_eECModeType;

/**
 *  輸入框
 */
@property (nonatomic, retain) IBOutlet UITextView *m_ptxtvInput;

/**
 *  改變模式 Button
 */
@property (nonatomic, retain) IBOutlet UIButton *m_pbtnMode;

/**
 *  送出 Button
 */
@property (nonatomic, retain) IBOutlet UIButton *m_pbtnSend;

/**
 *  遮罩 Button
 */
@property (nonatomic, retain) IBOutlet UIButton *m_pbtnCover;

- (void) callBackInputbarHeightAndCalculateTxtvHeight:(UITextView *)ptxtvTemp ShowKeyBoard:(BOOL)isShow;

- (void) setDismissInputBarButtonDidTapped:(UIButton *)sender;

+ (void) playMessageReceivedSound;

+ (void) playSoundWithName:(NSString *)name type:(NSString *)type;

@end
