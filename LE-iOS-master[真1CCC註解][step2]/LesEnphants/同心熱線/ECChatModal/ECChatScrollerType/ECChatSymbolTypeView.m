//
//  ECChatSymbolTypeView.m
//  SingleBank
//
//  Created by Soul on 2014/8/12.
//  Copyright (c) 2014年 Shinren Pan. All rights reserved.
//

#import "ECChatSymbolTypeView.h"

@implementation ECChatSymbolTypeView

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
    _m_pdicData = [[NSMutableDictionary alloc] init];
}

- (void) setupInitial
{
    [self setupUI];
    [self setupParam];
}

- (void) setupUI
{
    if (self.tag == 0)
    {
        [_m_pimgSymbol setImage:[UIImage imageNamed:@"chatroom_expression_history.png"]];
    }
    else
    {
//        [_m_pimgSymbol setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[kPicGateway stringByAppendingString:_m_pdicData[@"PIC"]]]]]];
    }
}

- (void) setupParam
{
    
}

#pragma mark - Button Action Did Tapped

- (IBAction) setSymbolButtonDidTapped:(UIButton *)sender
{
    if (sender.selected)
    {
        return;
    }
    else
    {
        if (self.tag == 0)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(callBackHistoryinView:)])
            {
                [_delegate callBackHistoryinView:self];
            }
        }
        else
        {
            NSInteger cID = [_m_pdicData[@"ID"] integerValue];
            
            if (_delegate && [_delegate respondsToSelector:@selector(callBackSymbolwithCategoryID:inView:)])
            {
                [_delegate callBackSymbolwithCategoryID:cID inView:self];
            }
        }
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
