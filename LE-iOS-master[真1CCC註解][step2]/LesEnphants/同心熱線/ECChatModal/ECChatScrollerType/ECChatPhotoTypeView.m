//
//  ECChatPhotoTypeView.m
//  SingleBank
//
//  Created by Soul on 2014/8/12.
//  Copyright (c) 2014年 Shinren Pan. All rights reserved.
//

#import "ECChatPhotoTypeView.h"

@implementation ECChatPhotoTypeView

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
    
    if (![self.subviews containsObject:self.m_pImgSync])
    {
        /* Cache */
        self.m_pImgSync = [[AsyncImageView alloc] initWithFrame:self.m_pimgPhoto.bounds];
        self.m_pImgSync.imageCache = [RHAppDelegate sharedDelegate].m_pImageCache;
        [self.m_pImgSync setBackgroundColor:[UIColor clearColor]];
        [self.m_pimgPhoto addSubview:_m_pImgSync];
    }
}

- (void) setupInitial
{
    [self setupUI];
    [self setupParam];
}

- (void) setupUI
{
//    [self.m_pImgSync loadImageFromURL:[NSURL URLWithString:[kPicGateway stringByAppendingString:_m_pdicData[@"SPIC"]]]];
}

- (void) setupParam
{
    
}

#pragma mark - Button Action Did Tapped

- (IBAction) setPhotoButtonDidTapped:(UIButton *)sender
{
    NSString *pstrPIC = _m_pdicData[@"BPIC"];
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackPhotoWithData:inView:)])
    {
        [_delegate callBackPhotoWithData:_m_pdicData inView:self];
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
