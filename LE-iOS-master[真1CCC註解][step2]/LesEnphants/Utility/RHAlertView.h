//
//  RHAlertView.h
//  RHAlertView
//
//  Created by Rusty Huang on 14/5/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RHAlertViewBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@interface RHAlertView : UIAlertView <UIAlertViewDelegate>

@property (nonatomic, copy) RHAlertViewBlock callback;

- (void)showWithCallback:(RHAlertViewBlock)callback;
@end