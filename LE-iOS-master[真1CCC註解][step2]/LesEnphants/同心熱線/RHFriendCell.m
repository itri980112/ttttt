/**
 *	@file		RHFriendCell.m
 *	@brief		Implement of Customize Table Cell
 *	@author     Rusty Huang
 *	@version	0.1
 *	@date		2014/09/04
 *	@warning	Copyright by Rusty Huang
 *
 *
 *	Update History:\n
 *	2014/09/04 Rusty Huang Version 1.0 is created
 *
 *
 **/


#import "RHFriendCell.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"

@implementation RHFriendCell

@synthesize m_pLblName;
@synthesize m_IconImgView;
@synthesize m_pDataDic;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        // Initialization code
        self.m_pDataDic = nil;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
}


- (void)dealloc 
{
    [m_pLblName release];
    [m_IconImgView release];
    [m_pDataDic release];
    [super dealloc];
}

- ( void )updateUI
{
    [self.m_pLblName setText:[m_pDataDic objectForKey:@"nickname"]];
    
    NSString *pstrURL = [m_pDataDic objectForKey:@"photoUrl"];
    
    if ( [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
    {
        AsyncImageView *pImgAsynView = [[AsyncImageView alloc] initWithFrame:self.m_IconImgView.bounds];
        [pImgAsynView setTag:1000];
        [pImgAsynView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
        [self.m_IconImgView addSubview:pImgAsynView];
        [pImgAsynView loadImageFromURL:[NSURL URLWithString:pstrURL]];
    }
    else
    {
        NSArray *pSubViews = [self.m_IconImgView subviews];
        

        for ( id obj in pSubViews)
        {
            if ( [obj isKindOfClass:[AsyncImageView class]] )
            {
                AsyncImageView *pView = ( AsyncImageView * )obj;
                [pView removeFromSuperview];
            }
        }
    }
    
}

@end
