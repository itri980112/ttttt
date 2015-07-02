//
//  RHNewsContentVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/26.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHNewsContentVC.h"
#import "MBProgressHUD.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"


@interface RHNewsContentVC () < RHLesEnphantsAPIDelegate >
{
    MBProgressHUD           *m_pMBProgressHUD;
}

@property ( nonatomic ,retain ) MBProgressHUD           *m_pMBProgressHUD;

@end

@implementation RHNewsContentVC
@synthesize m_pMBProgressHUD;
@synthesize m_pContentData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pContentData = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pTitleLabel setText:NSLocalizedString(@"", nil)];
    
    //load html
    
//    NSArray *pArray = [m_pContentData objectForKey:@"SubNews"];
//    
//    if ( [pArray count] > 0 )
//    {
//        NSDictionary *pDic = [pArray objectAtIndex:0];
//        [self.m_pTitleLabel setText:[pDic objectForKey:@"subject"]];
//        NSString *pstrContent = [pDic objectForKey:@"content"];
//        
//        [self.m_pMainWebView loadHTMLString:pstrContent baseURL:nil];
//        [self.m_pMainWebView setScalesPageToFit:YES];
//    }
    
    
    if ( m_pContentData )
    {
        [self.m_pTitleLabel setText:[m_pContentData objectForKey:@"subject"]];
        NSString *pstrContent = [m_pContentData objectForKey:@"content"];

        [self.m_pMainWebView loadHTMLString:pstrContent baseURL:nil];
        [self.m_pMainWebView setScalesPageToFit:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods


#pragma mark - Customized Methods


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_m_pMainWebView release];
    [super dealloc];
}
@end
