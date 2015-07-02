/**
 *	@file		RHAssoMemberMnanageCell.m
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


#import "RHAssoMemberMnanageCell.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"
#import "RHProfileObj.h"
#import "SBJson.h"
#import "RHAssociationDefinition.h"


@implementation RHAssoMemberMnanageCell
@synthesize m_pIconImgView;
@synthesize m_pLblCnt;
@synthesize m_nID;

@synthesize m_pMainDic;
@synthesize m_enumMemberType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        // Initialization code
        self.m_pMainDic = nil;
        m_nID = 0;
        m_bHasGrant = NO;
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
        NSString *pstrImageUrl = [m_pMainDic objectForKey:@"photoUrl"];
        
        if ( pstrImageUrl && [pstrImageUrl compare:@""] != NSOrderedSame )
        {
            AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pIconImgView.bounds];
            [pAsync setBackgroundColor:[UIColor clearColor]];
            [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            
            [self.m_pIconImgView addSubview:pAsync];
            [pAsync loadImageFromURL:[NSURL URLWithString:pstrImageUrl]];
        }

        
        
        if ( m_enumMemberType == MEMBER_TYPE_PEDDING )
        {
            NSInteger nType = [[m_pMainDic objectForKey:@"type"] integerValue];
            NSInteger nWeeks = [[m_pMainDic objectForKey:@"weeks"] integerValue];
            NSString *pstrTypeName = @"孕媽咪";
            
            if ( nType == 2 )
            {
                pstrTypeName = @"準爸爸";
            }
            else if ( nType == 3 )
            {
                pstrTypeName = @"親友";
            }
            
            NSString *pstrCnt = [NSString stringWithFormat:@"%@ %@(%@)",[m_pMainDic objectForKey:@"nickname"], pstrTypeName, [NSString stringWithFormat:@"%d", nWeeks] ];
            [self.m_pLblCnt setText:pstrCnt];
            
            
            [self.m_pFunBtn setImage:[UIImage imageNamed:@"confirm"] forState:UIControlStateNormal];
        }
        else
        {
            [self.m_pLblCnt setText:[m_pMainDic objectForKey:@"nickname"]];
            
            //判斷權限
            if ( m_enumMemberType == MEMBER_TYPE_MANAGER )
            {
                [self.m_pFunBtn setImage:[UIImage imageNamed:@"授權"] forState:UIControlStateNormal];
            }
            else
            {
                [self.m_pFunBtn setImage:[UIImage imageNamed:@"授權_feedback"] forState:UIControlStateNormal];
            }
            
        }
    }
}

@end
