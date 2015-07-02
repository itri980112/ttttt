/**
 *	@file		RHKnowledgeCell.h
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


#import "RHKnowledgeCell.h"
#import "RHAppDelegate.h"
#import "AsyncImageView.h"


@implementation RHKnowledgeCell

@synthesize m_pIconImageView;
@synthesize m_pLblContent;
@synthesize m_pMainDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        // Initialization code
        self.m_pMainDic = nil;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
}


- (void)dealloc 
{
	[m_pIconImageView release];
    [m_pLblContent release];
    [m_pMainDic release];
    [super dealloc];
}

- ( void )setupData:( NSDictionary * )pDic;
{
    self.m_pMainDic = pDic;
}

- ( void )updateUI
{
    if ( m_pMainDic )
    {
        [self.m_pLblContent setText:[m_pMainDic objectForKey:@"subject"]];
        
        NSString *pstrColor = [m_pMainDic objectForKey:@"color"];
        
        pstrColor = [pstrColor stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
        
        unsigned int hexValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:pstrColor];
        [scanner setScanLocation:0]; // depends on your exact string format you may have to use location 1
        [scanner scanHexInt:&hexValue];
        
        [self setBackgroundColor:UIColorFromRGB(hexValue)];
        
        
        NSString *pstrIcon = [m_pMainDic objectForKey:@"iconUrl"];
        
        if ( [pstrIcon compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            NSArray *pArray = [self.m_pIconImageView subviews];
            
            for ( id oneView in pArray )
            {
                if ( [oneView isKindOfClass:[AsyncImageView class]] )
                {
                    AsyncImageView *pView = ( AsyncImageView * )oneView;
                    [pView removeFromSuperview];
                }
            }
            
            
            AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pIconImageView.bounds];
            [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [self.m_pIconImageView addSubview:pAsync];
            NSLog(@"pstrIcon = %@", pstrIcon);
            pstrIcon = [pstrIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [pAsync loadImageFromURL:[NSURL URLWithString:pstrIcon]];
            [pAsync release];
        }
        
        
    }
    
}


@end
