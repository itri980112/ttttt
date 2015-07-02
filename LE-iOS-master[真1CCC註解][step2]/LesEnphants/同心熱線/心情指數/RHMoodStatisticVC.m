//
//  RHMoodStatisticVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/10/5.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHMoodStatisticVC.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"

@interface RHMoodStatisticVC ()
{
    NSInteger   m_nCurIdx;
}

- ( void )updateData;
- ( void )processStatisticData:( NSArray * )pArray;
@end

@implementation RHMoodStatisticVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        m_nCurIdx = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.m_pStatisticView setHidden:YES];
    
    [self.m_pMainScrollView setContentSize:self.m_pCntView.frame.size];
    
    [self updateData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- ( void )dealloc
{
    [_m_pbtnPrev release];
    [_m_pBtnNext release];
    [_m_plblTitle release];
    [_m_pValue1 release];
    [_m_pValue2 release];
    [_m_pValue3 release];
    [_m_pValue4 release];
    [_m_pValue5 release];
    [_m_pValue6 release];
    [_m_pValue7 release];
    [_m_pLblValue1 release];
    [_m_pLblValue2 release];
    [_m_pLblValue3 release];
    [_m_pLblValue4 release];
    [_m_pLblValue5 release];
    [_m_pLblValue6 release];
    [_m_pLblValue7 release];
    [_m_pStatisticView release];
    [_m_pMainScrollView release];
    [_m_pCntView release];
    [super dealloc];
}

#pragma mark - Private Methods
- ( void )updateData
{
    NSString *pstrKeyWord = @"";
    NSDate *pNow = [NSDate date];
    NSTimeInterval dNowTime = [pNow timeIntervalSince1970];
    
    if ( m_nCurIdx == 0 )
    {
        [self.m_pBtnNext setEnabled:YES];
        [self.m_pbtnPrev setEnabled:NO];
        [self.m_plblTitle setText:@"所有心情記錄"];
        pstrKeyWord = @"[0, 1700000000]";
    }
    else if ( m_nCurIdx == 2 )
    {
        [self.m_pBtnNext setEnabled:NO];
        [self.m_pbtnPrev setEnabled:YES];
        [self.m_plblTitle setText:@"過去七天心情"];
        //一週 24 * 60 *60 * 7 = 604800
        
        pstrKeyWord = [NSString stringWithFormat:@"[%.0f, %.0f]", dNowTime - 604800, dNowTime];
    }
    else
    {
        [self.m_pBtnNext setEnabled:YES];
        [self.m_pbtnPrev setEnabled:YES];
        [self.m_plblTitle setText:@"今天心情記錄"];
        
        pstrKeyWord = [NSString stringWithFormat:@"[%.0f, %.0f]", dNowTime - 86400, dNowTime];
    }
    
    
    [RHAppDelegate showLoadingHUD];
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:@"1" forKey:kFilter];
    [pParameter setObject:pstrKeyWord forKey:kKeyWord];
    
    [RHLesEnphantsAPI getMoodStatistics:pParameter Source:self];
    
    //update statistic
}

- ( void )processStatisticData:( NSArray * )pArray
{
    //全部歸零
    for (NSInteger i = -3; i <= 3; ++i )
    {
        UIView *pView = [self.m_pStatisticView viewWithTag:i];
        NSInteger nHeight = 0;
        CGRect kRect = [pView frame];
        kRect.size.height = nHeight;
        kRect.origin.y = self.m_pStatisticView.frame.size.height - nHeight + 30; //30是起始位置
        [pView setFrame:kRect];
        
        UILabel *pLbl = ( UILabel *)[self.m_pStatisticView viewWithTag:(i*10+100)];
        [pLbl setText:@"0"];
    }
    
    
    for ( NSInteger i = 0; i < [pArray count]; ++i )
    {
        NSDictionary *pDic = [pArray objectAtIndex:i];
        NSInteger nX = [[pDic objectForKey:@"x"] integerValue];
        NSInteger nY = [[pDic objectForKey:@"y"] integerValue];

        UIView *pView = [self.m_pStatisticView viewWithTag:nX];
        NSInteger nHeight = (self.m_pStatisticView.frame.size.height - 60) * nY / 100;
        CGRect kRect = [pView frame];
        kRect.size.height = nHeight;
        kRect.origin.y = self.m_pStatisticView.frame.size.height - nHeight;// + 30; //30是起始位置
        [pView setFrame:kRect];
        
        UILabel *pLbl = ( UILabel *)[self.m_pStatisticView viewWithTag:(nX*10+100)];
        [pLbl setText:[NSString stringWithFormat:@"%ld", (long)nY]];
    }
    
    //調整UILabel的位置
    for (NSInteger i = -3; i <= 3; ++i )
    {
        UIView *pView = [self.m_pStatisticView viewWithTag:i];
        UILabel *pLbl = ( UILabel *)[self.m_pStatisticView viewWithTag:(i*10+100)];
        
        CGRect kRect = [pView frame];
        CGRect kRectUILabel= [pLbl frame];
        
        kRectUILabel.origin.y = kRect.origin.y - 30;
        [pLbl setFrame:kRectUILabel];
    }
    
    
    
    [self.m_pStatisticView setHidden:NO];
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressPrevBtn:(id)sender
{
    m_nCurIdx--;
    [self updateData];
}
- ( IBAction )pressNextBtn:(id)sender
{
    m_nCurIdx++;
    [self updateData];
}

#pragma mark - API
- ( void )callBackGetMotherMoodStatistics:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSArray *pData = [pStatusDic objectForKey:@"data"];
        [self processStatisticData:pData];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

@end
