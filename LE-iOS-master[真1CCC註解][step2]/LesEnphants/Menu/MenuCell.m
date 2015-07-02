/**
 *	@file		MenuCell.h
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


#import "MenuCell.h"


@implementation MenuCell

@synthesize m_pIconImageView;
@synthesize m_pLblContent;
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
	[m_pIconImageView release];
    [m_pLblContent release];
    [super dealloc];
}


@end
