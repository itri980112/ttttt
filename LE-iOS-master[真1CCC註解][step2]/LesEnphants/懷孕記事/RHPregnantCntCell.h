/**
 *	@file		RHPregnantCntCell.h
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

@interface RHPregnantCntCell : UITableViewCell
{
    NSDictionary        *m_pMainData;
    NSInteger           m_nSection;
}

@property ( nonatomic, retain ) NSDictionary        *m_pMainData;
@property NSInteger       m_nSection;
@property (retain, nonatomic) IBOutlet UILabel *m_pLblDate;
@property (retain, nonatomic) IBOutlet UIScrollView *m_pCntScroll;


#pragma mark - Customized Methods
- ( void )setupData:( NSDictionary * )pDicData Section:( NSInteger )nSection;
- ( void )prepareUI:( BOOL )bIsEdit;


@end
