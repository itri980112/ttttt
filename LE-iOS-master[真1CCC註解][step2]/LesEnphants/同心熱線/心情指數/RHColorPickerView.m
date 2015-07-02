//
//  RHColorPickerView.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/10/5.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHColorPickerView.h"

@interface RHColorPickerView()
{
    NSInteger m_nCount;
}

@end


@implementation RHColorPickerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- ( void )touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self handleTouchBegan:event];
}


- ( void )touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    if ( m_nCount % 3 == 0 )
//    {
//        m_nCount = 0;
//        
//        //處理一次
//        [self handleTouchMoved:event];
//        return;
//    }
//    
//    m_nCount++;
}

- ( void )setSelectedTag:( NSInteger )nTag
{
    NSInteger nCenter = self.frame.size.width / 7.0f * nTag - (self.frame.size.width / 7.0f / 2.0f);
    UIImageView *pView = ( UIImageView * )[self viewWithTag:1000];
    [pView setCenter:CGPointMake(nCenter, pView.center.y)];
}

- ( void )touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouchEnded:event];
}



- ( void )handleTouchBegan:( UIEvent * )event
{
    //NSLog(@"touchesMoved");
	CGPoint             location;
    CGPoint             previousLocation;
	UITouch*			touch = [[event touchesForView:self] anyObject];
    
	location = [touch locationInView:self];
	previousLocation = [touch previousLocationInView:self];
    
    UIImageView *pView = ( UIImageView * )[self viewWithTag:1000];
    
    NSInteger nX = MIN(301, location.x);
    
    nX = MAX(19, location.x);
    
    [pView setCenter:CGPointMake(nX, pView.center.y)];
}

- ( void )handleTouchMoved:( UIEvent * )event
{
    //NSLog(@"touchesMoved");
	CGPoint             location;
    CGPoint             previousLocation;
	UITouch*			touch = [[event touchesForView:self] anyObject];
    
	location = [touch locationInView:self];
	previousLocation = [touch previousLocationInView:self];
    
    UIImageView *pView = ( UIImageView * )[self viewWithTag:1000];
    
    NSInteger nX = MIN(301, location.x);
    
    nX = MAX(19, location.x);
    
    [pView setCenter:CGPointMake(nX, pView.center.y)];

}

- ( void )handleTouchEnded:( UIEvent * )event
{
    //NSLog(@"touchesMoved");
	CGPoint             location;
    CGPoint             previousLocation;
	UITouch*			touch = [[event touchesForView:self] anyObject];
    
	location = [touch locationInView:self];
	previousLocation = [touch previousLocationInView:self];
    
    UIImageView *pView = ( UIImageView * )[self viewWithTag:1000];
    
    NSInteger nX = MIN(301, location.x);
    
    nX = MAX(19, location.x);
    
    [pView setCenter:CGPointMake(nX, pView.center.y)];
    
    if ( delegate && [delegate respondsToSelector:@selector(callBackXValue:)] )
    {
        [delegate callBackXValue:(NSInteger)location.x];
    }
}


@end
