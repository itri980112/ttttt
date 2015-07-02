/**
 *	@file		RHPregnantCntCell.m
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


#import "RHPregnantCntCell.h"
#import "RHThumbnailView.h"
@interface RHPregnantCntCell ()
{
    
}

- ( NSString * )getPrensentDate:( NSString * )pstrDate;

@end

@implementation RHPregnantCntCell
@synthesize m_pMainData;
@synthesize m_nSection;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
        // Initialization code
        self.m_pMainData = nil;
        m_nSection = -1;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
}


- (void)dealloc 
{
    [_m_pCntScroll release];
    [_m_pLblDate release];
    [m_pMainData release];
    [super dealloc];
}

#pragma mark - Private
- ( NSString * )getPrensentDate:( NSString * )pstrDate
{
    //Input Date -> "2015-05-12
    //Output Date - > 2015-05-12 星期一
    NSString *pstrDateString = @"";
    
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //先取得今天
    NSString *pstrToday = [pFormatter stringFromDate:[NSDate date]];
    
    if ( [pstrToday compare:pstrDate options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        //當天
        pstrDateString = [NSString stringWithFormat:@"%@ 今天", pstrDate];
    }
    else
    {
        NSDate *pDate = [pFormatter dateFromString:pstrDate];
        
        [pFormatter setDateFormat:@"yyyy-MM-dd EEEE"];
        pstrDateString = [pFormatter stringFromDate:pDate];

    }

    return pstrDateString;
}

#pragma mark - Customized Methods
- ( void )setupData:( NSDictionary * )pDicData Section:( NSInteger )nSection
{
    NSLog(@"pDicData = %@", pDicData);
    m_nSection = nSection;
    self.m_pMainData = pDicData;
}

- ( void )prepareUI:( BOOL )bIsEdit
{
    NSInteger nX = 20;
    
    NSArray *pArray = [m_pMainData objectForKey:@"record"];
    NSString *pstrDate = [self getPrensentDate:[m_pMainData objectForKey:@"date"]];
    
    [self.m_pLblDate setText:pstrDate];
    
    for ( NSInteger i = 0; i < [pArray count]; ++i )
    {
        NSDictionary *pDic = [pArray objectAtIndex:i];
        NSLog(@"pDic = %@", pDic);
        CGRect kRect = CGRectMake(nX, 0, 100, 100);
        RHThumbnailView *pView = [[[RHThumbnailView alloc] initWithFrame:kRect] autorelease];
        pView.m_bIsEditing = bIsEdit;
        NSString *pstrThumb = [pDic objectForKey:@"thumb"];
        
        if ( [pstrThumb compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            //沒有回傳縮圖
            [pView setM_pstrURL:@""];
        }
        else
        {
            [pView setM_pstrURL:pstrThumb];
        }
        
        [pView setM_nID:i];
        [pView setM_nSection:m_nSection];
        nX += 120;
        [self.m_pCntScroll addSubview:pView];
        [pView updateUI];
    }
    
    [self.m_pCntScroll setContentSize:CGSizeMake(nX, self.m_pCntScroll.frame.size.height)];
}



@end
