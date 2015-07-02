//
//  RHInfoVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/10/10.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHInfoVC.h"

@interface RHInfoVC ()

@end

@implementation RHInfoVC
@synthesize m_bIsRule_1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        m_bIsRule_1 = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_POINTEXCHANGE_TITLE", nil)];
    
    if ( m_bIsRule_1 )
    {
        [self.m_pMainScrollView addSubview:self.m_pRuleImgView1];
    }
    else
    {
        [self.m_pMainScrollView addSubview:self.m_pRuleImgView2];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ( m_bIsRule_1 )
    {
        [self.m_pMainScrollView setContentSize:self.m_pRuleImgView1.frame.size];
    }
    else
    {
        [self.m_pMainScrollView setContentSize:self.m_pRuleImgView2.frame.size];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_pMainScrollView release];
    [_m_pRuleImgView2 release];
    [_m_pRuleImgView1 release];
    [super dealloc];
}

- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
