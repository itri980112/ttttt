//
//  RHKnowledgeContentVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/26.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHKnowledgeContentVC.h"
#import "MBProgressHUD.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"


@interface RHKnowledgeContentVC () < RHLesEnphantsAPIDelegate >
{
    MBProgressHUD           *m_pMBProgressHUD;
}

@property ( nonatomic ,retain ) MBProgressHUD           *m_pMBProgressHUD;

@end

@implementation RHKnowledgeContentVC
@synthesize m_pMBProgressHUD;
@synthesize m_pContentData;
@synthesize m_pstrTitle;
@synthesize m_plblTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pContentData = nil;
        self.m_pstrTitle = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //load html
    
    if ( m_pContentData )
    {
        NSString *pstrContent = [m_pContentData objectForKey:@"content"];
        
        
        [self.m_pMainWebView loadHTMLString:pstrContent baseURL:nil];
        
        [m_plblTitle setText:[m_pContentData objectForKey:@"subject"]];
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
