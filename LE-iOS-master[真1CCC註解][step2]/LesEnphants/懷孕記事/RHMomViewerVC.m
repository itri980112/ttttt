//
//  RHMomViewerVC.m
//  LesEnphants
//
//  Created by Rich Fan on 2015/4/21.
//  Copyright (c) 2015年 Rusty Huang. All rights reserved.
//

#import "RHMomViewerVC.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAppDelegate.h"
#import "RHBabyChildViewerVC.h"
#import "UIImage+Resize2.h"

@interface RHMomViewerVC () {
    NSArray *m_pContentData;
}

@end

@implementation RHMomViewerVC

static const int m_pContentCount = 40;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Disable MENU
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:nil];
    [self.view addGestureRecognizer:panGR];
    
    // View From Web
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self.pageController.view setFrame:self.m_pCntView.frame];
    [self.view addSubview:self.pageController.view];
    
    // If Data From Local
    m_pContentData = [self getMomList];
    if (self.m_nWeek >= m_pContentCount) {
        self.m_nWeek = m_pContentCount-1;
    }
    [self setViewTitle:self.m_nWeek];
    
    self.pageController.dataSource = self;
    RHBabyChildViewerVC *initialViewController = [self viewControllerAtIndex:self.m_nWeek];
    [self.pageController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - DataFrom Plist

- (NSArray *)getMomList {
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mommy_weeks" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile: path];
    
    // XML
    //NSPropertyListFormat format;
    //NSArray *plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:nil];
    
    // JSON
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return [json objectForKey:@"data"];
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPageViewControllDelegate

- (void)setViewTitle:(NSUInteger)index {
    
    NSString *title = [NSString stringWithFormat:@"第%d週的孕婦變化", (int)index+1];
    [self.m_strTitle setText:title];
}

- (RHBabyChildViewerVC *)viewControllerAtIndex:(NSUInteger)index {
    
    RHBabyChildViewerVC *childViewController = [[RHBabyChildViewerVC alloc] initWithNibName:@"RHBabyChildViewerVC" bundle:nil];
    childViewController.index = index;
    [childViewController.view setFrame:childViewController.view.frame];
    
    childViewController.textView.hidden = YES;
    childViewController.webView.opaque = NO;

    // Data from JSON
    if ([[[m_pContentData objectAtIndex:index] class] isSubclassOfClass:[NSDictionary class]]) {
        NSDictionary *dataRow = [m_pContentData objectAtIndex:index];
        NSString *pstrContent = [dataRow objectForKey:@"content"];
        if (pstrContent) {
            [childViewController.webView loadHTMLString:pstrContent baseURL:nil];
        }
    }
    // Data from file
    /*else {
        NSString *fileName = [NSString stringWithFormat:@"mommy_weeks_%d.html", (int)index+1];
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        
        NSString *dataString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [childViewController.webView loadHTMLString:dataString baseURL:nil];
    }*/
    
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(RHBabyChildViewerVC *)viewController index];
    [self setViewTitle:index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(RHBabyChildViewerVC *)viewController index];
    [self setViewTitle:index];
    
    index++;
    
    if (index == m_pContentCount) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
