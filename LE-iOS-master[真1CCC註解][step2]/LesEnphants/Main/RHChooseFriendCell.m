/**
 *	@file		RHChooseFriendCell.h
 *	@brief		Implement of Customize Table Cell
 *	@author     Rusty Huang
 *	@version	0.1
 *	@date		2012/03/15
 *	@warning	Copyright by Rusty Huang
 *
 *
 *	Update History:\n
 *	2012/03/15 Rusty Huang Version 1.0 is created
 *
 *
 **/


#import "RHChooseFriendCell.h"
#import "RHAppDelegate.h"
#import "AsyncImageView.h"


@implementation RHChooseFriendCell

@synthesize m_pIconImageView;
@synthesize m_pLblContent;
@synthesize m_pStatusImageView;
@synthesize m_pMainDic;
@synthesize m_bIsHighlight;

- ( BOOL )checkHighlight
{
    BOOL bReturn = NO;
    
    
    NSMutableArray *pArray = [NSMutableArray arrayWithArray:[RHAppDelegate getHightData]];
    
    for ( NSInteger i = 0; i < [pArray count]; ++i )
    {
        NSDictionary *pOldData = [pArray objectAtIndex:i];
        NSString *pstrOldJID = [pOldData objectForKey:@"jid"];
        NSString *pstrNewJID = [m_pMainDic objectForKey:@"jid"];
        
        if ( [pstrOldJID compare:pstrNewJID options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            bReturn = YES;
            break;
        }
    }
    
    return bReturn;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        // Initialization code
        self.m_pMainDic = nil;
        m_bIsHighlight = NO;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
}


- (void)dealloc 
{
    [m_pMainDic release];
	[m_pIconImageView release];
    [m_pStatusImageView release];
    [m_pLblContent release];
    [super dealloc];
}

#pragma mark - Customized Methods
- ( void )updateUI
{
    if ( m_pMainDic )
    {
        NSLog(@"m_pMainDic = %@", m_pMainDic);
        [self.m_pLblContent setText:[m_pMainDic objectForKey:@"nickname"]];
        
        AsyncImageView *pImgView = [[AsyncImageView alloc] initWithFrame:self.m_pIconImageView.bounds];
        [pImgView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
        [self.m_pIconImageView addSubview:pImgView];
        [pImgView loadImageFromURL:[NSURL URLWithString:[m_pMainDic objectForKey:@"photoUrl"]]];
        [pImgView release];
        
        
        m_bIsHighlight = [self checkHighlight];
        
        if ( m_bIsHighlight )
        {
            [self.m_pStatusImageView setImage:[UIImage imageNamed:@"同心熱線_selected@3x.png"]];
        }
        else
        {
            [self.m_pStatusImageView setImage:[UIImage imageNamed:@"同心熱線_select@3x.png"]];
        }
    }
}

@end
