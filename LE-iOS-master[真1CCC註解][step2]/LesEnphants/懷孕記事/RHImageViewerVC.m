//
//  RHImageViewerVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHImageViewerVC.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "GoldCoinAnimationVC.h"
#import "RHProfileObj.h"

@interface RHImageViewerVC ()

@end

@implementation RHImageViewerVC
@synthesize m_pstrImgURL;
@synthesize m_pImgView;
@synthesize m_pstrImageName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pstrImgURL = nil;
        self.m_pImgView = nil;
        self.m_pstrImageName = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ( m_pstrImgURL )
    {
        AsyncImageView *pImgView = [[AsyncImageView alloc] initWithFrame:self.m_pCntView.bounds];
        [pImgView setAutoresizingMask:self.m_pCntView.autoresizingMask];
        [pImgView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
        
        [self.m_pCntView addSubview:pImgView];
        [pImgView loadImageFromURL:[NSURL URLWithString:m_pstrImgURL]];
        
        self.m_pImgView = pImgView;
        [pImgView release];
    }
    else if ( m_pstrImageName )
    {
        [self.m_pBtnShare setHidden:YES];
        UIImageView *pImgView = [[UIImageView alloc] initWithFrame:self.m_pCntView.bounds];
        [pImgView setAutoresizingMask:self.m_pCntView.autoresizingMask];
        [pImgView setImage:[UIImage imageNamed:m_pstrImageName]];
        [pImgView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self.m_pCntView addSubview:[pImgView autorelease]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void )dealloc
{
    [m_pstrImgURL release];
    [m_pImgView release];
    [super dealloc];
}


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressShareBtn:(id)sender
{
    if ( m_pstrImgURL )
    {
        
        NSString *postText = self.m_pstrImgURL;
        
        
        
        UIImage *postImage = self.m_pImgView.m_pMainImg;
        
        NSArray *activityItems = @[postText, postImage];
        
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard];

        if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f ) {
            // iOS 8.0 不指定SourceView 會Crash
            activityController.popoverPresentationController.sourceView = sender;
        }
        
        [activityController setCompletionHandler:^(NSString *activityType, BOOL completed)
         {
             if (completed) {
                 [RHLesEnphantsAPI shareRecordLog:self];
             }
             else {
                 // Cancel
             }
            
         }];

        [self presentViewController:activityController animated:YES completion:nil];
    }
}

#pragma mark - ShowAnimation
- (void)showAnimation:(NSInteger)point
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType != 1 ) return;

    // 得到金幣,顯示動畫
    if (point >= kShowAnimationMinimumPoint) {
        GoldCoinAnimationVC *vc = nil;
        if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC~ipad" bundle:nil];
        }
        else {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC" bundle:nil];
        }
        
        vc.m_getPoint = point;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:^{
            [vc startAnimation];
        }];
    }
}

#pragma mark - LesEnphantsAPI Delegate
- ( void )callBackShareRecordStatus:( NSDictionary * )pStatusDic
{
    NSInteger point = [[pStatusDic objectForKey:@"Point"] integerValue];
    [self showAnimation:point];
}

@end
