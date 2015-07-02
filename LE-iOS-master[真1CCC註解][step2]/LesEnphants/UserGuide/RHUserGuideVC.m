//
//  RHUserGuideVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/17.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHUserGuideVC.h"
#import "RHAppDelegate.h"

@interface RHUserGuideVC () < UIScrollViewDelegate >

@end

@implementation RHUserGuideVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //設定為已Launch
    [RHAppDelegate setLaunched];
    
    
    
    //prepare UserGuide
    
    //Test Content, 3個畫面
    
    CGRect kRect = [UIScreen mainScreen].bounds;
    NSInteger nWidth = kRect.size.width;
    NSInteger nHeight = kRect.size.height;
    
    
    NSInteger nStartX = 0;
    
    for ( NSInteger i = 0; i < 4; ++i )
    {
        UIImageView *pView = [[UIImageView alloc] initWithFrame:CGRectMake(nStartX, 0, nWidth, nHeight)];
        
        
        NSString *pstr = [NSString stringWithFormat:@"welcoming page%02ld.png", (long)(i+1)];//CCC try
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            pstr = [NSString stringWithFormat:@"welcoming page%02ld~iPad.png", (long)(i+1)];//CCC try
        }
        [pView setImage:[UIImage imageNamed:pstr]];
        [self.m_pMainScrollView addSubview:pView];
        
        
        nStartX += nWidth;
    }
    
    //Dummy Page
     UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(nStartX, 0, nWidth, nHeight)] autorelease];
    [self.m_pMainScrollView addSubview:pView];
    nStartX += nWidth;
    
    
    [self.m_pPageControl setNumberOfPages:4];
    [self.m_pPageControl setCurrentPage:0];
    
    [self.m_pMainScrollView setContentSize:CGSizeMake(nStartX, self.m_pMainScrollView.frame.size.height)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - IBAction
- ( IBAction )pressCloseBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [_m_pMainScrollView release];
    [_m_pPageControl release];
    [super dealloc];
}


#pragma mark - UISCrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect kRect = [UIScreen mainScreen].bounds;
    NSInteger nWidth = kRect.size.width;
    NSInteger nPage = scrollView.contentOffset.x / nWidth;
    
    [self.m_pPageControl setCurrentPage:nPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGRect kRect = [UIScreen mainScreen].bounds;
    NSInteger nWidth = kRect.size.width;
    
    NSInteger nPage = scrollView.contentOffset.x / nWidth;
    if ( nPage > 3 )
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
