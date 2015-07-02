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


#import "RHStoreSubCell.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"

@implementation RHStoreSubCell

@synthesize m_pLblContent;
@synthesize m_bGovCard;
@synthesize m_bBabyRoom;
@synthesize m_bOutlet;
@synthesize m_pLblAddress;

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


- ( void )updateUI
{
    [self.m_pGovCardImgView setHidden:!m_bGovCard];
    [self.m_pBabyRoomImgView setHidden:!m_bBabyRoom];
    [self.m_pOutletImgView setHidden:!m_bOutlet];
    
}


@end
