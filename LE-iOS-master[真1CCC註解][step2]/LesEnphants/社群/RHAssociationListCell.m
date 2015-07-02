/**
 *	@file		RHAssociationListCell.m
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


#import "RHAssociationListCell.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"
#import "RHProfileObj.h"
#import "SBJson.h"
#import "RHAssociationDefinition.h"


@implementation RHAssociationListCell
@synthesize m_pIconImgView;
@synthesize m_pLblCnt;
@synthesize m_pStatusImgView;
@synthesize m_pLblStatus;
@synthesize m_pLblMember;
@synthesize m_pLblPosts;
@synthesize m_pLblLocation;
@synthesize m_nID;

@synthesize m_pMainDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        // Initialization code
        self.m_pMainDic = nil;
        m_nID = 0;
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
        BOOL bPrivate = [[m_pMainDic objectForKey:@"isPrivate"] boolValue];
        
        if ( bPrivate )
        {
            [self.m_pLblStatus setText:@"不公開"];
        }
        else
        {
            [self.m_pLblStatus setText:@"公開"];
        }
        
        NSInteger nMember = [[m_pMainDic objectForKey:@"memberCount"] integerValue];
        [self.m_pLblMember setText:[NSString stringWithFormat:@"%d", nMember]];
        
        NSInteger nPosts = [[m_pMainDic objectForKey:@"postsCount"] integerValue];
        [self.m_pLblPosts setText:[NSString stringWithFormat:@"%d", nPosts]];
        
        [self.m_pLblLocation setText:[m_pMainDic objectForKey:@"city"]];
        
        [self.m_pLblCnt setText:[m_pMainDic objectForKey:@"name"]];

        AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pIconImgView.bounds];
        [pAsync setBackgroundColor:[UIColor clearColor]];
        [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
        
        NSString *pstrURL = [m_pMainDic objectForKey:@"classIconUrl"];
        pstrURL = [pstrURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ( pstrURL && [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            [self.m_pIconImgView addSubview:pAsync];
            [pAsync loadImageFromURL:[NSURL URLWithString:pstrURL]];
        }
        
        
        
//        NSString *pstrImageName = g_pstrCellImage[m_nID-1];
//        
//        [self.m_pIconImgView setImage:[UIImage imageNamed:pstrImageName]];
    }
}

@end
