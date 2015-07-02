//
//  ECChatEmojiTypeView.h
//  ECChatBubbleView
//
//  Created by Soul on 2014/8/8.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ECChatEmojiTypeViewDelegate <NSObject>

@required

- (void) callBackEmojiButton:(NSString *)pstrEmoji withTypeButtonTag:(NSInteger)iTag;

@end

@interface ECChatEmojiTypeView : UIView

@property (nonatomic, assign) id<ECChatEmojiTypeViewDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIButton *m_pbtnEmoji;

@end
