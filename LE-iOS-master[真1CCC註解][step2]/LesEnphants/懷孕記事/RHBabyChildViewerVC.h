//
//  RHBabyChildViewerVC.h
//  LesEnphants
//
//  Created by Rich Fan on 2015/4/20.
//  Copyright (c) 2015年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHBabyChildViewerVC : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
