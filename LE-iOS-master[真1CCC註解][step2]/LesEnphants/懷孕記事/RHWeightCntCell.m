/**
 *	@file		RHWeightCntCell.m
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


#import "RHWeightCntCell.h"
@interface RHWeightCntCell ()
{
    
}
@end

@implementation RHWeightCntCell
@synthesize m_pLblWeek;
@synthesize m_pLblDiff;
@synthesize m_pLblWeight;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
}


- (void)dealloc 
{
    [m_pLblWeek release];
    [m_pLblWeight release];
    [m_pLblDiff release];
    [super dealloc];
}
@end
