/**
 *	@file		RHTodoCell.m
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


#import "RHTodoCell.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"

@implementation RHTodoCell
@synthesize m_pStatusImgView;
@synthesize m_pLblCnt;
@synthesize m_pLblTime;
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
    [m_pStatusImgView release];
    [m_pLblTime release];
    [m_pLblCnt release];
    [m_pMainDic release];
    [super dealloc];
}

- ( void )updateUI
{
    if ( m_pMainDic )
    {
        [self.m_pLblCnt setText:[m_pMainDic objectForKey:@"subject"]];
        NSTimeInterval dTime = [[m_pMainDic objectForKey:@"createdat"] doubleValue];
        
        NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:dTime];
        
        NSDateFormatter *pDateFormatter = [[NSDateFormatter alloc] init];
        [pDateFormatter setDateFormat:@"MM/dd aa HH:mm"];
        NSString *pstrDate = [pDateFormatter stringFromDate:pDate];
        
        [self.m_pLblTime setText:pstrDate];
        
        //判斷狀態
        //{"id":12,"subject":"ttttt","reported":false,"confirmed":false,"disabled":false,"createdat":1412271973}
        
        BOOL bReported = [[m_pMainDic objectForKey:@"reported"] boolValue];
        BOOL bConfirmed = [[m_pMainDic objectForKey:@"confirmed"] boolValue];
        BOOL bDisable = [[m_pMainDic objectForKey:@"disabled"] boolValue];
        
        if ( bDisable )
        {
            [self.m_pStatusImgView setHidden:YES];
        }
        else
        {
            [self.m_pStatusImgView setHidden:NO];
            if ( bReported == NO )
            {
                //爸爸尚未回覆
                [self.m_pStatusImgView setImage:[UIImage imageNamed:@"同心熱線_tesk_icon1.png"]];
            }
            else
            {
                //爸爸已回覆，看看媽媽是否有確認
                if ( bConfirmed )
                {
                    //媽媽已確認
                    [self.m_pStatusImgView setImage:[UIImage imageNamed:@"同心熱線_tesk_icon3.png"]];
                }
                else
                {
                    //媽媽尚未確認
                    [self.m_pStatusImgView setImage:[UIImage imageNamed:@"同心熱線_tesk_icon2.png"]];
                }
            }

        }
        
        
        
    }
}

@end
