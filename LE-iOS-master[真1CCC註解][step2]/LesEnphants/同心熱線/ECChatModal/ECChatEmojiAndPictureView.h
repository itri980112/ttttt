//
//  ECChatEmojiAndPictureView.h
//  ECChatBubbleView
//
//  Created by Soul on 2014/8/8.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ECChatEmojiTypeView.h"
#import "ECChatSymbolTypeView.h"
#import "ECChatPhotoTypeView.h"
#import "NSMutableArray+Convenience.h"

@protocol ECChatEmojiAndPictureViewDelegate <NSObject>

@required

- (void) callBackReturnPhotoMessage:(NSString *)pstrPIC;

- (void) callBackReturnEmojiMessage:(NSString *)pstrEmoji;

- (void) callBackDeleteButtonDidTapped;

@end

typedef enum
{
    ECEmoAndPicTypeOfEmoji            =   0,          //表情
    ECEmoAndPicTypeOfPicture          =   1,          //圖片
} ECEmoAndPicType;


@interface ECChatEmojiAndPictureView : UIView <ECChatEmojiTypeViewDelegate, ECChatSymbolTypeViewDelegate, ECChatPhotoTypeViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) id <ECChatEmojiAndPictureViewDelegate> delegate;

@property (nonatomic) ECEmoAndPicType m_eECEmoAndPicType;

@property (nonatomic, retain) IBOutlet UIView *m_pviewEmoji;

@property (nonatomic, retain) IBOutlet UIButton *m_pbtnEmoji;

@property (nonatomic, retain) IBOutlet UIScrollView *m_psclEmoji;

@property (nonatomic, retain) IBOutlet UIPageControl *m_ppvEmoji;

@property (nonatomic, retain) IBOutlet UIButton *m_pbtnPicture;

@property (nonatomic, retain) IBOutlet UIView *m_pviewPicture;

@property (nonatomic, retain) IBOutlet UIScrollView *m_psclPicture;

@property (nonatomic, retain) IBOutlet UIScrollView *m_psclBottom;

@property (nonatomic, retain) IBOutlet UIPageControl *m_ppvPicture;

@property (nonatomic, retain) NSMutableArray *m_parrSymbol;

@property (nonatomic, retain) NSMutableArray *m_parrPhoto;

@property (nonatomic, retain) NSMutableArray *m_parrHistory;

@property (nonatomic) BOOL isHistory;

- (void) createSymbolScroll;

@end
