//
//  ECChatEmojiTypeView.m
//  ECChatBubbleView
//
//  Created by Soul on 2014/8/8.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import "ECChatEmojiTypeView.h"

@implementation ECChatEmojiTypeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - LifeCircle

- (void) awakeFromNib
{
    [self setupInitial];
}

- (void) setupInitial
{
    [self setupUI];
    [self setupParam];
}

- (void) setupUI
{
    
}

- (void) setupParam
{
    
}

#pragma mark - Button Action Did Tapped

- (IBAction) setEmojiButtonDidTapped:(UIButton *)sender
{
    NSString *pstrEmoji = [NSString stringWithFormat:@"<img=%03d>", sender.tag];
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackEmojiButton:withTypeButtonTag:)])
    {
        [_delegate callBackEmojiButton:pstrEmoji withTypeButtonTag:sender.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
