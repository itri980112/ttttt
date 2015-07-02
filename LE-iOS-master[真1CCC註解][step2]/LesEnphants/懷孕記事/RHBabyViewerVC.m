//
//  RHBabyViewerVC.m
//  LesEnphants
//
//  Created by Rich Fan on 2015/4/16.
//  Copyright (c) 2015年 Rusty Huang. All rights reserved.
//

#import "RHBabyViewerVC.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAppDelegate.h"
#import "RHBabyChildViewerVC.h"
#import "UIImage+Resize2.h"

@interface RHBabyViewerVC () {
    NSArray *m_pContentData;
}

@end

@implementation RHBabyViewerVC

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
    m_pContentData = [self getBabyList];
    if (self.m_nWeek >= m_pContentData.count) {
        self.m_nWeek = m_pContentData.count-1;
    }
    [self setViewTitle:self.m_nWeek];

    self.pageController.dataSource = self;
    RHBabyChildViewerVC *initialViewController = [self viewControllerAtIndex:self.m_nWeek];
    [self.pageController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    // API Get Data
    //NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    //[pParameter setObject:@"0" forKey:kFilter];
    //[pParameter setObject:@"42" forKey:kKeyWord];
    //[RHLesEnphantsAPI getKnowledgeContent:pParameter Source:self];
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

- (NSArray *)getBabyList {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RHBabyList" ofType:@"plist"];
    NSData *data = [[NSData alloc] initWithContentsOfFile: path];
    
    NSString *error;
    NSPropertyListFormat format;
    NSArray *plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    if (plist) {
        return plist;
    }
    
    return nil;
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RHLesEnphantsAPIDelegate
- ( void )callBackGetKnowledgeContentStatus:( NSDictionary * )pStatusDic
{
    NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
    if ( nStatus == 0 )
    {
        m_pContentData = [pStatusDic objectForKey:@"data"];

        if (self.m_nWeek >= m_pContentData.count) {
            self.m_nWeek = m_pContentData.count-1;
        }

        self.pageController.dataSource = self;
        RHBabyChildViewerVC *initialViewController = [self viewControllerAtIndex:self.m_nWeek];
        [self.pageController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

        [self setViewTitle:self.m_nWeek];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",(int)nStatus]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
}

#pragma mark - UIPageViewControllDelegate


- (void)setViewTitle:(NSUInteger)index {
    
    // Data From API
    if ([[[m_pContentData objectAtIndex:index] class] isSubclassOfClass:[NSDictionary class]]) {
        NSDictionary *dataRow = [m_pContentData objectAtIndex:index];
        [self.m_strTitle setText:[dataRow objectForKey:@"subject"]];
    }
    else {
        NSString *title = [NSString stringWithFormat:@"第%d週的胎兒教育", (int)index+1];
        [self.m_strTitle setText:title];
    }
}

- (RHBabyChildViewerVC *)viewControllerAtIndex:(NSUInteger)index {
    
    RHBabyChildViewerVC *childViewController = [[RHBabyChildViewerVC alloc] initWithNibName:@"RHBabyChildViewerVC" bundle:nil];
    childViewController.index = index;
    [childViewController.view setFrame:childViewController.view.frame];
    
    // Data From API
    if ([[[m_pContentData objectAtIndex:index] class] isSubclassOfClass:[NSDictionary class]]) {
        childViewController.textView.hidden = YES;
        
        NSDictionary *dataRow = [m_pContentData objectAtIndex:index];
        NSString *pstrContent = [dataRow objectForKey:@"content"];
        if (pstrContent) {
            [childViewController.webView loadHTMLString:pstrContent baseURL:nil];
        }
    }
    // Data From Local
    else {
        childViewController.webView.hidden = YES;

        // String
        NSString *content = [m_pContentData objectAtIndex:index];
        content = [content stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];

        // Image
        NSString *pstrWeekImgName = nil;
        if (index+1 <= 40) {
            pstrWeekImgName = [NSString stringWithFormat:@"Baby-W%02d.png", (int)index+1];
        }
        else {
            pstrWeekImgName = [NSString stringWithFormat:@"Baby-W40.png"];
        }
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:pstrWeekImgName];
        CGFloat oldWidth = textAttachment.image.size.width;
        
        // Change Image Size
        CGFloat width = childViewController.view.frame.size.width;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            width = 500;
        }

        CGFloat scaleFactor = oldWidth / (width - 10);
        CGSize imageSize = CGSizeMake( ceilf(textAttachment.image.size.width / scaleFactor),
                                       ceilf(textAttachment.image.size.height / scaleFactor));
        textAttachment.image = [UIImage imageWithImage:textAttachment.image scaledToFitToSize:imageSize];
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attributedString insertAttributedString:attrStringWithImage atIndex:0];
        
        NSAttributedString *attrStringWithBreak = [[NSAttributedString alloc] initWithString:@"\n"];
        [attributedString insertAttributedString:attrStringWithBreak atIndex:attrStringWithImage.length];
    
        // Change Style
        NSMutableParagraphStyle *paragraphImageStyle = [[NSMutableParagraphStyle alloc] init] ;
        [paragraphImageStyle setAlignment:NSTextAlignmentCenter];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphImageStyle range:NSMakeRange(0, 1)];

        NSRange fontRange = NSMakeRange(1, attributedString.length - 1);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        paragraphStyle.headIndent = 10.0;
        paragraphStyle.firstLineHeadIndent = 10.0;
        paragraphStyle.tailIndent = -10.0;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:fontRange];
        
        // Change Font Size
        CGFloat fontSize = 16;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            fontSize = 24;
        }
        UIFont *font = [UIFont systemFontOfSize:fontSize];
        [attributedString addAttribute:NSFontAttributeName value:font range:fontRange];
        
        
        childViewController.textView.attributedText = attributedString;
    }
    
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
    
    if (index == m_pContentData.count) {
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
