/**
 *	@file		RHChatCell.m
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


#import "RHChatCell.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"
#import "RHProfileObj.h"
#import "SBJson.h"

@implementation RHChatCell
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

- ( void )updateUI
{
    if ( m_pMainDic )
    {
        NSDictionary *pDic = [[m_pMainDic objectForKey:@"LastMsg"] JSONValue];
        
        NSInteger nType = [[pDic objectForKey:@"type"] integerValue];
        
        if ( nType == 1 )
        {
            [self.m_pLblCnt setText:@"貼圖"];
        }
        else
        {
            [self.m_pLblCnt setText:[pDic objectForKey:@"body"]];
        }
        
        NSTimeInterval dTime = [[m_pMainDic objectForKey:@"Timestamp"] doubleValue];
        
        NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:dTime];
        
        NSDateFormatter *pDateFormatter = [[NSDateFormatter alloc] init];
        [pDateFormatter setDateFormat:@"MM/dd aa HH:mm"];
        NSString *pstrDate = [pDateFormatter stringFromDate:pDate];
        
        [self.m_pLblTime setText:pstrDate];
        
        //判斷ICON
        
        NSArray *pArray = [RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pFriendsArray;
        
        NSString *pstrURL = @"";
        
        NSString *pstrID = [m_pMainDic objectForKey:@"JID"];
        
        for ( NSInteger i = 0; i < [pArray count]; ++i )
        {
            NSDictionary *pDic = [pArray objectAtIndex:i];
            NSString *pstrJID = [pDic objectForKey:@"jid"];
            
            if ( [pstrJID compare:pstrID] == NSOrderedSame )
            {
                pstrURL = [pDic objectForKey:@"photoUrl"];
            }
        }
        
        if ( [pstrURL compare:@""] != NSOrderedSame )
        {
            AsyncImageView *pImgV = [[AsyncImageView alloc] initWithFrame:self.m_pStatusImgView.bounds];
            [pImgV setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [self.m_pStatusImgView addSubview:pImgV];
            [pImgV loadImageFromURL:[NSURL URLWithString:pstrURL]];
        }
        
        
    }
}

@end
