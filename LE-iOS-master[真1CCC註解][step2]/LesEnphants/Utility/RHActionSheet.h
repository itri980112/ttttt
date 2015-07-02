//
//  RHActionSheet.h
//  iPolice
//
//  Created by Rusty Huang on 2014/9/26.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RHActionSheet;

@protocol RHActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(RHActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)actionSheetCancel:(RHActionSheet *)actionSheet;
@end

@interface RHActionSheet : UIView
{
    
}


- (id)initWithTitle:(NSString *)title delegate:(id<RHActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void)showInView:(UIView *)view;

@end