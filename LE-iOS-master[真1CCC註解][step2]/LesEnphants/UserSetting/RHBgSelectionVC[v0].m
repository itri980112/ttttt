//
//  RHBgSelectionVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/16.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHBgSelectionVC.h"
#import "RHAppDelegate.h"
#import "RHProfileObj.h"

@interface RHBgSelectionVC () < UIScrollViewDelegate >
{
    NSInteger       m_nSelIdx;
}
@end

@implementation RHBgSelectionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_nSelIdx = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_CHANGEPIC_TITLE", nil)];
    [self.m_pBtnConfirm setTitle:NSLocalizedString(@"LE_COMMON_CONFIRM", nil) forState:UIControlStateNormal];
    
    [self.view setFrame:[UIScreen mainScreen].bounds];
    
    NSLog(@"UISceen = %@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    NSLog(@"self.view = %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"Scroll = %@", NSStringFromCGRect(self.m_pMainScrollView.frame));
    
    
    NSInteger nStartX = 0;
    
    NSString *pstrName = @"home_others";
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj.m_nType == 1 )
    {
        pstrName = @"home_mom";
    }
    else if ( pObj.m_nType == 2 )
    {
        pstrName = @"home_dad";
    }
    
    for ( NSInteger i = 0; i < 5; ++i )
    {
        CGRect kRect = CGRectMake(nStartX, 0, self.view.frame.size.width, self.m_pMainScrollView.frame.size.height);
        UIImageView *pImgView = [[UIImageView alloc] initWithFrame:kRect];
        [pImgView setContentMode:UIViewContentModeScaleAspectFit];
        NSInteger nImgIdx = i;
        
        NSString *pstrImgName = [NSString stringWithFormat:@"%@%02d.png", pstrName,nImgIdx+1];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            pstrImgName = [NSString stringWithFormat:@"%@%02d~iPad.png", pstrName,nImgIdx+1];
        }
        [pImgView setImage:[UIImage imageNamed:pstrImgName]];
        
        [self.m_pMainScrollView addSubview:pImgView];
        
        nStartX += self.view.frame.size.width;
        
    }
    
    
    [self.m_pMainScrollView setContentSize:CGSizeMake(nStartX, self.m_pMainScrollView.frame.size.height)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_m_pMainScrollView release];
    [super dealloc];
}

#pragma mark - IBAction
- ( IBAction )pressConfirmBtn:(id)sender
{
   NSString *pstrName = @"home_others";
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj.m_nType == 1 )
    {
        pstrName = @"home_mom";
    }
    else if ( pObj.m_nType == 2 )
    {
        pstrName = @"home_dad";
    }
    
    
    NSString *pstrImgName = [NSString stringWithFormat:@"%@%02d.png", pstrName,m_nSelIdx+1];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        pstrImgName = [NSString stringWithFormat:@"%@%02d~iPad.png", pstrName,m_nSelIdx+1];
    }
    
    [RHAppDelegate saveHomeImg:pstrImgName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeBackgroundImg object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIscrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    m_nSelIdx = scrollView.contentOffset.x / self.view.frame.size.width;
    NSLog(@"m_nSelIdx = %d", m_nSelIdx);
}

@end
