/**
 *	@file		RHWeightCntCell.h
 *	@brief		Declaration Customize Table Cell
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

#import <UIKit/UIKit.h>

@interface RHWeightCntCell : UITableViewCell
{
    UILabel *m_pLblWeek;
    UILabel *m_pLblWeight;
    UILabel *m_pLblDiff;
}

@property (retain, nonatomic) IBOutlet UILabel *m_pLblWeek;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblWeight;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblDiff;


@end
