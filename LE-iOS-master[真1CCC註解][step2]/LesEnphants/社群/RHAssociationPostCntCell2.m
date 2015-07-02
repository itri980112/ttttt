/**
 *	@file		RHAssociationPostCntCell2.m
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


#import "RHAssociationPostCntCell2.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"
#import "RHProfileObj.h"
#import "SBJson.h"
#import "RHAssociationDefinition.h"
#import "RHTextView.h"


@implementation RHAssociationPostCntCell2
@synthesize m_pIconImgView;
@synthesize m_pMainDic;
@synthesize m_bCanEdit;
@synthesize delegate;
@synthesize m_pImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        // Initialization code
        self.m_pMainDic = nil;
        m_bCanEdit = YES;
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
        [self.m_pBtnComment setTitle:NSLocalizedString(@"LE_GROUP_COMMENT_LEAVEMSG", nil) forState:UIControlStateNormal];
        
        
        [self.m_pLblCnt setText:[m_pMainDic objectForKey:@"content"]];
        [self.m_pTxtCnt setText:[m_pMainDic objectForKey:@"content"]];
        NSArray *pCommentArray = [m_pMainDic objectForKey:@"comment"];
        
        [self.m_pLblComment setText:[NSString stringWithFormat:@"%ld",(long)[pCommentArray count]]];
        
        [self.m_pLblLite setText:[NSString stringWithFormat:@"%d",[[m_pMainDic objectForKey:@"liked"] integerValue]]];
        
        [self.m_pLblViolation setText:[NSString stringWithFormat:@"%d",[[m_pMainDic objectForKey:@"reportCount"] integerValue]]];
        
        BOOL bLiked = [[m_pMainDic objectForKey:@"liked"] boolValue];
        
        [self.m_pBtnLike setSelected:bLiked];

        
        
        CGFloat fTime = [[m_pMainDic objectForKey:@"createdAt"] floatValue];
        NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
        [pFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:fTime];
        NSString *pstrDateTimeSgring = [pFormatter stringFromDate:pDate];
        [self.m_plblDatetime setText:pstrDateTimeSgring];
        
        [self.m_pLblClass setText:[m_pMainDic objectForKey:@"subject"]];
        
        NSDictionary *pCreator = [m_pMainDic objectForKey:@"creator"];
        
        if ( pCreator )
        {
            AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pIconImgView.bounds];
            [pAsync setBackgroundColor:self.m_pIconImgView.backgroundColor];
            [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            
            NSString *pstrURL = [pCreator objectForKey:@"photoUrl"];
            
            if ( pstrURL && [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
            {
                [self.m_pIconImgView addSubview:pAsync];
                [pAsync loadImageFromURL:[NSURL URLWithString:pstrURL]];
            }
            
            [self.m_pLblName setText:[pCreator objectForKey:@"nickname"]];
        }
        
        NSString *pstrImageUrl = [m_pMainDic objectForKey:@"imageUrl"];
        
        if ( pstrImageUrl )
        {
            if ( [pstrImageUrl compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
            {
                AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pImageView.bounds];
                [pAsync setAutoresizingMask:self.m_pImageView.autoresizingMask];
                [pAsync setContentMode:self.m_pImageView.contentMode];
                [pAsync setBackgroundColor:[UIColor clearColor]];
                [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
                
                [self.m_pImageView addSubview:pAsync];
                [pAsync loadImageFromURL:[NSURL URLWithString:pstrImageUrl]];
            }
        }

    }
    
    if ( m_bCanEdit )
    {
        [self.m_pBtnDelete setTitle:NSLocalizedString(@"LE_GROUP_COMMENT_DELETEARTICLE", nil) forState:UIControlStateNormal];
    }
    else
    {
        [self.m_pBtnDelete setTitle:NSLocalizedString(@"LE_GROUP_COMMENT_DELETEARTICLE2", nil) forState:UIControlStateNormal];
    }
}


#pragma mark - IBAction
- ( IBAction )pressLikeBtn:(id)sender
{
    if ( [self.m_pBtnLike isSelected] )
    {
        return;
    }
    
    
    if ( delegate && [delegate respondsToSelector:@selector(callBackLike:)] )
    {
        [delegate callBackLike:self.tag];
    }
}
- ( IBAction )pressCommentBtn:(id)sender
{
    if ( delegate && [delegate respondsToSelector:@selector(callBackComment:)] )
    {
        [delegate callBackComment:self.tag];
    }
}
- ( IBAction )pressDeleteBtn:(id)sender
{
    if ( m_bCanEdit )
    {
        if ( delegate && [delegate respondsToSelector:@selector(callBackDelete:)] )
        {
            [delegate callBackDelete:self.tag];
        }
    }
    else
    {
        if ( delegate && [delegate respondsToSelector:@selector(callBackReport:)] )
        {
            [delegate callBackReport:self.tag];
        }
    }
}

@end
