/**
 *	@file		RHAppListCell.m
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


#import "RHAppListCell.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"

@implementation RHAppListCell

@synthesize m_pLblContent;
@synthesize delegate;
@synthesize m_pDataDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
}


- (void)dealloc 
{
    [m_pLblContent release];
    [_m_pIconView release];
    [m_pDataDic release];
    [super dealloc];
}

- ( void )setupDataDic:( NSDictionary * )pDataDic
{
    self.m_pDataDic = pDataDic;
}

- ( IBAction )pressDownloadBtn:(id)sender
{
    if ( delegate && [delegate respondsToSelector:@selector(callBackSelectedTag:)] )
    {
        [delegate callBackSelectedTag:self.tag];
    }
}
- ( void )updateUI
{
    [self.m_pLblContent setText:[m_pDataDic objectForKey:@"name"]];
    
    AsyncImageView *pAsyncView = [[AsyncImageView alloc] initWithFrame:self.m_pIconView.bounds];
    [pAsyncView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
    [self.m_pIconView addSubview:pAsyncView];

    NSString *urlString = [m_pDataDic objectForKey:@"icon_url"];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [pAsyncView loadImageFromURL:url];
}


@end
