//
//  RHBabyTextView.m
//  LesEnphants
//
//  Created by Rich Fan on 2015/4/21.
//  Copyright (c) 2015年 Rusty Huang. All rights reserved.
//

#import "RHTextView.h"

@implementation RHTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.dataDetectorTypes != UIDataDetectorTypeLink) {
        self.dataDetectorTypes = UIDataDetectorTypeLink;
        
        //self.backgroundColor = [UIColor clearColor];
        self.editable = NO;
        self.selectable = YES;
    }
    
}

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    return YES;
}


@end
