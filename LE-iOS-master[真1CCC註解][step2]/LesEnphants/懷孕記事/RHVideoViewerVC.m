//
//  RHVideoViewerVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHVideoViewerVC.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "GoldCoinAnimationVC.h"
#import "RHProfileObj.h"

@interface RHVideoViewerVC ()

@end

@implementation RHVideoViewerVC
@synthesize m_pstrImgURL;
@synthesize m_pPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pstrImgURL = nil;
        self.m_pPlayer = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ( m_pstrImgURL )
    {
        NSURL *pURL = [NSURL URLWithString:m_pstrImgURL];
        
        MPMoviePlayerController *pPlayer = [[MPMoviePlayerController alloc] initWithContentURL:pURL];
        self.m_pPlayer = pPlayer;
        [pPlayer release];
        
        
        //使用Observer製作完成播放時要執行的動作
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:m_pPlayer];
        
        //設定影片比例的縮放、重複、控制列等參數
        m_pPlayer.scalingMode = MPMovieScalingModeAspectFill;
        m_pPlayer.repeatMode = MPMovieRepeatModeNone;
        m_pPlayer.controlStyle = MPMovieControlStyleNone;
        
        //將影片加至主畫面上
        m_pPlayer.view.frame = self.view.bounds;
        m_pPlayer.view.autoresizingMask = self.view.autoresizingMask;
        [self.m_pCntView addSubview:m_pPlayer.view];
        
        [m_pPlayer play];
    }
    
}

//影片播放完畢函式
- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    
    //因為只播放一次所以在這就直接移除此Observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:m_pPlayer];
    [m_pPlayer stop];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void )dealloc
{
    [m_pPlayer release];
    [m_pstrImgURL release];
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
        
        
        NSArray *activityItems = @[postText];
        
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard ];

        // iOS 8.0 不指定SourceView 會Crash
        if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f ) {
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

        [self presentViewController:activityController
                           animated:YES completion:nil];
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
