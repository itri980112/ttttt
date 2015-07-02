//
//  KeyboardStateListener.h
//  NFTU
//
//  Created by Soul on 2014/5/9.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardStateListener : NSObject
{
    BOOL _isVisible;
}

+ (KeyboardStateListener *)sharedInstance;

@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@end
