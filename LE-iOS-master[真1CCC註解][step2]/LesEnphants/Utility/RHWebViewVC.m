//
//  RHWebViewVC.m
//  iPolice
//
//  Created by Rusty Huang on 2014/9/2.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHWebViewVC.h"
#import "MBProgressHUD.h"
#import "RHAppDelegate.h"

@interface RHWebViewVC () < UIWebViewDelegate >

@property (retain, nonatomic) IBOutlet UILabel *m_pLblTitle;
@end

@implementation RHWebViewVC
@synthesize m_pstrTitle;
@synthesize m_pstrURL;
@synthesize m_pMBProgressHUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.m_pNaviBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    
	[navigationBarPanGestureRecognizer release];//CCC do
    NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    
    [self.m_pBtnMenu addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    //[self.m_pLblTitle setText:m_pstrTitle];
    
    NSURLRequest *pRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:m_pstrURL]];
    
    [self.m_pMainWebView loadRequest:pRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [m_pMBProgressHUD release];
    [m_pstrTitle release];
    [m_pstrURL release];
    [_m_pMainWebView release];
    [_m_pLblTitle release];
    [_m_pNaviBar release];
    [_m_pBtnMenu release];
    [super dealloc];
}
#pragma mark - IBAction
- ( IBAction )pressBackBtn:( id )sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIWebview Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [m_pMBProgressHUD hide:YES];
    
    
    self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:webView animated:YES];
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [m_pMBProgressHUD hide:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [m_pMBProgressHUD hide:YES];
}
@end
