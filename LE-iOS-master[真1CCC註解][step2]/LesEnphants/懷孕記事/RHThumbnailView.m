//
//  RHThumbnailView.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/13.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHThumbnailView.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"

@implementation RHThumbnailView
@synthesize m_nID;
@synthesize m_pstrURL;
@synthesize m_pAsyncImageView;
@synthesize m_nSection;
@synthesize m_bIsEditing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.m_pAsyncImageView = nil;
        m_nID = -1;
        m_nSection = -1;
        m_bIsEditing = NO;
    }
    return self;
}

- ( void )dealloc
{
    [m_pAsyncImageView release];
    [m_pstrURL release];
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- ( void )updateUI
{
    if ( [m_pstrURL compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        //沒有傳網址
        UIImageView *pImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [pImgView setImage:[UIImage imageNamed:@"VideoIcon"]];
        [self addSubview:pImgView];
    }
    else
    {
        AsyncImageView      *pImgView = [[AsyncImageView alloc] initWithFrame:self.bounds];
        self.m_pAsyncImageView = pImgView;
        [pImgView release];
        
        m_pAsyncImageView.imageCache = [RHAppDelegate sharedDelegate].m_pImageCache;
        [m_pAsyncImageView loadImageFromURL:[NSURL URLWithString:m_pstrURL]];
        [self addSubview:m_pAsyncImageView];
        [m_pAsyncImageView setBackgroundColor:[UIColor clearColor]];
    }
    
    if (m_bIsEditing )
    {
        //UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[pBtn setImage:[UIImage imageNamed:@"Hint_close.png"] forState:UIControlStateNormal];
        UIImageView *pImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Hint_close.png"]];
        [pImgView setFrame:CGRectMake(self.frame.size.width - 20, 0, 20, 20)];
        [self addSubview:pImgView];
    }
    
    
}


- ( void )touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:m_nSection], @"Section", [NSNumber numberWithInteger:m_nID], @"Row", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPostSelectedSectionAndRow object:nil userInfo:pDic];
}

@end
