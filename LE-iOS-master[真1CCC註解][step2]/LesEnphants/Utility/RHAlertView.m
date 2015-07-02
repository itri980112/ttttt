//
//  RHAlertView.m
//  RHAlertView
//
//  Created by Rusty Huang on 14/5/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//
#import "RHAlertView.h"

@implementation RHAlertView


#pragma mark - LifeCycle

- (void)dealloc
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    [super dealloc];
}

- (void)showWithCallback:(RHAlertViewBlock)callback
{
    if(callback)
    {
        self.callback = callback;
        self.delegate = self;
    }
    
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.callback)
    {
        _callback(alertView, buttonIndex);
    }
}
@end