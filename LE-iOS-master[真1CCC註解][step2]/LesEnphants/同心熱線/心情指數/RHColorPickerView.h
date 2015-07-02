//
//  RHColorPickerView.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/10/5.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RHColorPickerViewDelegate <NSObject>

@optional
- ( void )callBackXValue:( NSInteger )nXValue;

@end

@interface RHColorPickerView : UIView
{
    id<RHColorPickerViewDelegate>       delegate;
    
}

@property ( nonatomic, retain ) id<RHColorPickerViewDelegate>       delegate;


- ( void )setSelectedTag:( NSInteger )nTag;

@end
