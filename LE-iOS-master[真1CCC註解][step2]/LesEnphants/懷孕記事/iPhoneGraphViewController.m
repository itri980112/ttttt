//
//  iPhoneGraphViewController.m
//  Graph for iPhone
//
//  Created by Serghei Mazur on 11/26/13.
//  Copyright (c) 2013 Serghei Mazur. All rights reserved.
//

#import "iPhoneGraphViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation iPhoneGraphViewController
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


//- ( void )touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	[self handleTouchBegan:event];
//}
//
//- ( void )touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self handleTouchMoved:event];
//}
//
//- ( void )touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	[self handleTouchEnded:event];
//}
//
//- ( void )handleTouchBegan:( UIEvent * )event
//{
//    //NSLog(@"touchesMoved");
//	CGPoint             location;
//    CGPoint             previousLocation;
//	UITouch*			touch = [[event touchesForView:self] anyObject];
//    
//	location = [touch locationInView:self];
//	previousLocation = [touch previousLocationInView:self];
//}
//
//- ( void )handleTouchMoved:( UIEvent * )event
//{
//    //NSLog(@"touchesMoved");
//	CGPoint             location;
//    CGPoint             previousLocation;
//	UITouch*			touch = [[event touchesForView:self] anyObject];
//    
//	location = [touch locationInView:self];
//	previousLocation = [touch previousLocationInView:self];
//    
//    
//    NSInteger nX = location.x;
//    
//    nX = MIN(nX, [_fistArray count]);
//    
//    nX = nX / 2;
//    
//    NSString *pstrPower = [NSString stringWithFormat:@"%.0f", [[_fistArray objectAtIndex:nX] doubleValue]];
//    NSString *pstrCO2 = [NSString stringWithFormat:@"%.0f", [[_secondArray objectAtIndex:nX] doubleValue]];
//
//    
//    if ( delegate && [delegate respondsToSelector:@selector(callBackString:CO2:)] )
//    {
//        [delegate callBackString:pstrPower CO2:pstrCO2];
//    }
//    
//    NSLog(@"location = %f", location.x);
//    
//}
//
//- ( void )handleTouchEnded:( UIEvent * )event
//{
//    //NSLog(@"touchesMoved");
//	CGPoint             location;
//    CGPoint             previousLocation;
//	UITouch*			touch = [[event touchesForView:self] anyObject];
//    
//	location = [touch locationInView:self];
//	previousLocation = [touch previousLocationInView:self];
//}



- (void)drawRect:(CGRect)rect
{
    if ( [_fistArray count] > 0 && [_secondArray count] > 0 )
    {
        //第一條線，Power
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIColor *currentColor = [UIColor colorWithRed:85/255.0f green:188/255.0f blue:0/255.0f alpha:1.0f];
        CGContextBeginPath(context); // <---- this
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, currentColor.CGColor);
        
        double maxY = 0;
        bool  minusValue = NO;
        
        for ( id obj in _fistArray)
        {
            if ( [obj isKindOfClass:[NSNull class]])
            {
                continue;
            }
            
            NSNumber *number = ( NSNumber * )obj;
            
            if (maxY < abs([number doubleValue]))
            {
                maxY = abs([number doubleValue]);
            }
            if ([number doubleValue] < 0) {
                minusValue = YES;
            }
            
            if ( maxY == 0 )
            {
                maxY = 1;
            }
        }
        
        
        double coefficient = 75/maxY;
        
        
        CGFloat firstPoint = 0;
        
        
        
        
        double distanceNextYline = 6.78*self.frame.size.width/280.0;  //每個x的距離
        double bizieLineAligm = 0;
        
        double nextX = 0;
        double downToXline = 0;
        double corectPointer1 = 0;
        
        
        CGMutablePathRef spadePath = CGPathCreateMutable();
        
        BOOL bFineFirstNotNull = NO;
        
        for (int i = 0; i < [_fistArray count]; i++)
        {
            id obj = [_fistArray objectAtIndex:i];
            
            if ( [obj isKindOfClass:[NSNull class]] )
            {
                nextX +=distanceNextYline;
                continue;
            }
            
            if ( bFineFirstNotNull == NO )
            {
                CGFloat firstPoint = [[_fistArray objectAtIndex:i] doubleValue];
                downToXline = self.frame.size.height - firstPoint;
                corectPointer1 = downToXline - firstPoint * coefficient ;
                NSLog(@"FirstPOint:  %f , %f", nextX, downToXline -firstPoint * coefficient);
                bFineFirstNotNull = YES;
                CGPathMoveToPoint(spadePath, NULL, nextX, corectPointer1 );
                continue;
            }
            
            
            
            CGFloat point = [[_fistArray objectAtIndex:i] doubleValue];
            
            double corectPointer = downToXline - ( point * 9.5 *self.frame.size.width/280.0);
            
            CGPathAddCurveToPoint(spadePath, NULL, nextX+bizieLineAligm, corectPointer1, nextX+distanceNextYline-bizieLineAligm, corectPointer, nextX + distanceNextYline, corectPointer);
            //NSLog(@"POint %d: %f , %f %f %f %f %f",i,nextX+bizieLineAligm, corectPointer1, nextX+distanceNextYline-bizieLineAligm, corectPointer1, nextX+distanceNextYline, corectPointer);
            nextX +=distanceNextYline;
            corectPointer1 = corectPointer;
        }
        
        [[UIColor colorWithRed:85/255.0f green:188/255.0f blue:255/255.0f alpha:1.0f] set];
        CGContextSetLineWidth(context, 2);
        CGContextAddPath(context, spadePath);
        
        CGContextStrokePath(context);
        
        
//        //第二個點
//        
//        CGFloat firstPoint2 = [[_secondArray objectAtIndex:0] doubleValue];
//        
//        nextX = 20;
//        double downToXline2 = 180 - ( firstPoint2 );
//        double corectPointer2 = downToXline2 - firstPoint2 * coefficient;
//        NSLog(@"FirstPOint:  %f , %f", nextX, downToXline2 -firstPoint2 * coefficient);
//        
//        
//        CGMutablePathRef spadePath2 = CGPathCreateMutable();
//        CGPathMoveToPoint(spadePath2, NULL, nextX, corectPointer2 );
//        
//        for (int i = 1; i < [_secondArray count]; i++)
//        {
//            CGFloat point = [[_secondArray objectAtIndex:i] doubleValue]; //需與第一條線做正規化
//            
//            double corectPointer = downToXline2 - point * coefficient;
//            
//            CGPathAddCurveToPoint(spadePath2, NULL, nextX+bizieLineAligm, corectPointer2, nextX+distanceNextYline - bizieLineAligm, corectPointer, nextX + distanceNextYline, corectPointer);
//            NSLog(@"POint %d: %f , %f %f %f %f %f",i,nextX+bizieLineAligm, corectPointer2, nextX+distanceNextYline - bizieLineAligm, corectPointer, nextX+distanceNextYline, corectPointer);
//            nextX += distanceNextYline;
//            corectPointer2 = corectPointer;
//        }
//        
//        [[UIColor colorWithRed:255/255.0f green:168/255.0f blue:0/255.0f alpha:1.0f] set];
//        CGContextSetLineWidth(context, 2);
//        CGContextAddPath(context, spadePath2);
//        
//        CGContextStrokePath(context);
    }
}


//- (void)drawRect:(CGRect)rect {
//    double maxY = 0;
//    bool  minusValue = NO;
//    bool nothingShow = NO;
//    
//    for (NSNumber *number in _fistArray) {
//        if (maxY < abs([number doubleValue])) {
//            maxY = abs([number doubleValue]);
//        }
//        if ([number doubleValue] < 0) {
//            minusValue = YES;
//        }
//    }
//    for (NSNumber *number in _secondArray) {
//        if (maxY < abs([number doubleValue])) {
//            maxY = abs([number doubleValue]);
//        }
//        if ([number doubleValue] < 0) {
//            minusValue = YES;
//        }
//    }
//    
//    if (maxY == 0) {
//        maxY = 100;
//        nothingShow = YES;
//    }
//    
//    //coefficient
//    double coefficient = 75/maxY;
//    
//    UIColor *currentColor = [UIColor blackColor];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextBeginPath(context); // <---- this
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetStrokeColorWithColor(context, currentColor.CGColor);
//    
//    // line X
//    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//    CGContextMoveToPoint(context,    5, 75);
//    CGContextAddLineToPoint(context, 260, 75);
//    CGContextAddLineToPoint(context, 252, 71);
//    CGContextAddLineToPoint(context, 260, 75);
//    CGContextAddLineToPoint(context, 252, 79);
//    CGContextStrokePath(context);
//    
//    //Create 5 strike line for see difference
//    //And for +  and -
//    int halfGraph = 75;
//    double yNumber = 0;
//    for (int i = 0; i<2; i++) {
//        for (int j = 0; j<5; j++) {
//            halfGraph -= 15;
//            yNumber +=maxY/5;
//            CGFloat dashes[] = { 1, 1 };
//            CGContextSetLineDash( context, 0.0, dashes, 2 );
//            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
//            CGContextMoveToPoint(context, 0,halfGraph);
//            CGContextAddLineToPoint(context, 260, halfGraph);
//            CGContextStrokePath(context);
//            
//            UILabel *gradationLabel = [[UILabel alloc]initWithFrame:CGRectMake(-45, halfGraph, 50, 15)];
//            gradationLabel.backgroundColor = [UIColor clearColor];
//            gradationLabel.textAlignment = NSTextAlignmentRight;
//            [gradationLabel setFont:[UIFont systemFontOfSize:10]];
//            [gradationLabel setAdjustsFontSizeToFitWidth:YES];
//            
//            if (!nothingShow) {
//                if (!minusValue && i > 0) {
//                    
//                } else{
//                    gradationLabel.text = [NSString stringWithFormat:yNumber == (int)yNumber?@"%.0f":@"%.0f",yNumber];
//                }
//            }
//            gradationLabel.textColor = [UIColor grayColor];
//            [self addSubview:gradationLabel];
//        }
//        halfGraph = 165;
//        yNumber = -maxY-maxY/5;
//        
//        //If Graph don't have < 0 value  No need wite numbers with minus (i = 2 exit loop)
//    }
//    
//    //Create 12 strike line for month
//    
//    halfGraph = 4;
//    if (_months == nil) {
//        _months = [[NSArray alloc]initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
//    }
//    
//    for (int i = 0; i<12; i++) {
//        halfGraph += 20;
//        CGFloat dashes[] = { 1, 1 };
//        CGContextSetLineDash( context, 0.0, dashes, 2 );
//        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
//        CGContextMoveToPoint(context, halfGraph,0);
//        CGContextAddLineToPoint(context, halfGraph, 150);
//        CGContextStrokePath(context);
//        
//        UILabel *gradationLabel = [[UILabel alloc]initWithFrame:CGRectMake(halfGraph-40, 150, 50, 20)];
//        gradationLabel.backgroundColor = [UIColor clearColor];
//        gradationLabel.textAlignment = NSTextAlignmentRight;
//        [gradationLabel setFont:[UIFont systemFontOfSize:10]];
//        [gradationLabel setAdjustsFontSizeToFitWidth:YES];
//        gradationLabel.text = [NSString stringWithFormat:@"%@",[_months objectAtIndex:i]];
//        gradationLabel.textColor = [UIColor grayColor];
//        [self addSubview:gradationLabel];
//    }
//    
//    CGContextSetLineDash(context, 0, NULL, 0);
//    UILabel *xLabel = [[UILabel alloc]initWithFrame:CGRectMake(-10, -25, 100, 30)];
//    xLabel.backgroundColor = [UIColor clearColor];
//    [xLabel setFont:[UIFont systemFontOfSize:11]];
//    xLabel.textColor = [UIColor darkGrayColor];
//    xLabel.text = @"Money";
//    [self addSubview:xLabel];
//    
//    UILabel *zeroLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 72, 30, 20)];
//    zeroLabel.backgroundColor = [UIColor clearColor];
//    zeroLabel.textColor = [UIColor grayColor];
//    [zeroLabel setFont:[UIFont systemFontOfSize:11]];
//    zeroLabel.text = @"0";
//    [self addSubview:zeroLabel];
//    
//    // line Y
//    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//    CGContextMoveToPoint(context, 10,150);
//    CGContextAddLineToPoint(context, 10, 5);
//    CGContextAddLineToPoint(context, 6, 10);
//    CGContextAddLineToPoint(context, 10, 5);
//    CGContextAddLineToPoint(context, 14, 10);
//    CGContextStrokePath(context);
//    
//    UILabel *yLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 70, 100, 30)];
//    yLabel.backgroundColor = [UIColor clearColor];
//    [yLabel setFont:[UIFont systemFontOfSize:11]];
//    yLabel.textColor = [UIColor darkGrayColor];
//    yLabel.text = @"Month";
//    [self addSubview:yLabel];
//    
//    CGContextSetLineWidth(context, 1.0);
//    
//    //FirstArray
//    
//    if (_linesGraph) {
//        double demoData[31] = {[[_fistArray objectAtIndex:0] doubleValue],[[_fistArray objectAtIndex:1] doubleValue],[[_fistArray objectAtIndex:2] doubleValue],[[_fistArray objectAtIndex:3] doubleValue],[[_fistArray objectAtIndex:4] doubleValue],[[_fistArray objectAtIndex:5] doubleValue],[[_fistArray objectAtIndex:6] doubleValue],[[_fistArray objectAtIndex:7] doubleValue],[[_fistArray objectAtIndex:8] doubleValue],[[_fistArray objectAtIndex:9] doubleValue],[[_fistArray objectAtIndex:10] doubleValue],[[_fistArray objectAtIndex:11] doubleValue]};
//        yLabel.text = @"Month";
//        double distanceNextYline = 20;
//        double bizieLineAligm = 10;
//        
//        double nextX = 24;
//        double downToXline = 75;
//        double corectPointer1 = downToXline - demoData[0]*coefficient;
//        //        NSLog(@"FirstPOint:  %f , %f",nextX,downToXline - demoData[0]*coefficient);
//        
//        CGMutablePathRef spadePath = CGPathCreateMutable();
//        CGPathMoveToPoint(spadePath, NULL, nextX, downToXline - demoData[0]*coefficient);
//        
//        
//        for (int i = 1; i < [_fistArray count]; i++) {
//            CGPathAddCurveToPoint(spadePath, NULL, nextX+bizieLineAligm, corectPointer1, nextX+distanceNextYline-bizieLineAligm, downToXline - demoData[i]*coefficient, nextX+distanceNextYline, downToXline - demoData[i]*coefficient);
//            //            NSLog(@"POint %d: %f , %f %f %f %f %f",i,nextX+bizieLineAligm, corectPointer1, nextX+distanceNextYline-bizieLineAligm, downToXline - demoData[i], nextX+distanceNextYline, downToXline - demoData[i]);
//            nextX +=distanceNextYline;
//            corectPointer1 = downToXline - demoData[i]*coefficient;
//        }
//        [[UIColor colorWithRed:54.0/255.0f green:133.0f/255.0f blue:37.0f/255.0f alpha:1.0f] set];
//        CGContextSetLineWidth(context, 2);
//        CGContextAddPath(context, spadePath);
//        
//        CGContextStrokePath(context);
//
//        
//    } else {
//        
//        
//        if ([_fistArray count] == 12) {
//            double demoData[12] = {[[_fistArray objectAtIndex:0] doubleValue],[[_fistArray objectAtIndex:1] doubleValue],[[_fistArray objectAtIndex:2] doubleValue],[[_fistArray objectAtIndex:3] doubleValue],[[_fistArray objectAtIndex:4] doubleValue],[[_fistArray objectAtIndex:5] doubleValue],[[_fistArray objectAtIndex:6] doubleValue],[[_fistArray objectAtIndex:7] doubleValue],[[_fistArray objectAtIndex:8] doubleValue],[[_fistArray objectAtIndex:9] doubleValue],[[_fistArray objectAtIndex:10] doubleValue],[[_fistArray objectAtIndex:11] doubleValue]};
//            
//            int coor = 22;
//            for (int i = 0; i<12; i++) {
//                
//                    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:96.0f/255.0f green:172.0f/255.0f blue:96.0f/255.0f alpha:1].CGColor);
//                    CGContextSetRGBFillColor(context, 96.0f/255.0f, 172.0f/255.0f, 96.0f/255.0f, 1.0);
//                
//                CGContextSetShadow(context,CGSizeMake(2, 2) , 2);
//                CGMutablePathRef pathRef = CGPathCreateMutable();
//                CGPathMoveToPoint(pathRef, NULL, coor, 75);
//                CGPathAddLineToPoint(pathRef, NULL, coor, -demoData[i]*coefficient+75);
//                CGPathAddLineToPoint(pathRef, NULL, coor+8, -demoData[i]*coefficient+75);
//                CGPathAddLineToPoint(pathRef, NULL, coor+8, 75);
//                CGPathCloseSubpath(pathRef);
//                CGContextAddPath(context, pathRef);
//                CGContextFillPath(context);
//                CGContextAddPath(context, pathRef);
//                CGContextStrokePath(context);
//                
//                
//                CGPathRelease(pathRef);
//                int negCor;
//                if (demoData[i]>0) {
//                    negCor = 15;
//                } else {
//                    negCor = 3;
//                }
//                UILabel *oneLabel = [[UILabel alloc]initWithFrame:CGRectMake(coor+1.5, -demoData[i]*coefficient+75-negCor, 50, 20)];
//                oneLabel.backgroundColor = [UIColor clearColor];
//                
//                    oneLabel.textColor = [UIColor colorWithRed:96.0f/255.0f green:172.0f/255.0f blue:96.0f/255.0f alpha:1];
//                
//                oneLabel.text = [NSString stringWithFormat:demoData[i] == (int)demoData[i]?@"%.0f":@"%.0f",demoData[i]];
//                oneLabel.shadowColor = [UIColor darkGrayColor];
//                oneLabel.shadowOffset = CGSizeMake(0.3, 0.3);
//                [oneLabel setFont:[UIFont systemFontOfSize:10]];
//                [oneLabel setAdjustsFontSizeToFitWidth:YES];
//                [self addSubview:oneLabel];
//                
//                coor += 20;
//            }
//        }
//    }
//    
//    //SecondArray
//    
//    if (_linesGraph) {
//        double demoData[31] = {[[_secondArray objectAtIndex:0] doubleValue],[[_secondArray objectAtIndex:1] doubleValue],[[_secondArray objectAtIndex:2] doubleValue],[[_secondArray objectAtIndex:3] doubleValue],[[_secondArray objectAtIndex:4] doubleValue],[[_secondArray objectAtIndex:5] doubleValue],[[_secondArray objectAtIndex:6] doubleValue],[[_secondArray objectAtIndex:7] doubleValue],[[_secondArray objectAtIndex:8] doubleValue],[[_secondArray objectAtIndex:9] doubleValue],[[_secondArray objectAtIndex:10] doubleValue],[[_secondArray objectAtIndex:11] doubleValue]};
//        yLabel.text = @"Month";
//        double distanceNextYline = 20;
//        double bizieLineAligm = 10;
//        
//        double nextX = 24;
//        double downToXline = 75;
//        double corectPointer1 = downToXline - demoData[0]*coefficient;
//        //        NSLog(@"FirstPOint:  %f , %f",nextX,downToXline - demoData[0]*coefficient);
//        
//        CGMutablePathRef spadePath = CGPathCreateMutable();
//        CGPathMoveToPoint(spadePath, NULL, nextX, downToXline - demoData[0]*coefficient);
//        
//        
//        for (int i = 1; i < [_fistArray count]; i++) {
//            CGPathAddCurveToPoint(spadePath, NULL, nextX+bizieLineAligm, corectPointer1, nextX+distanceNextYline-bizieLineAligm, downToXline - demoData[i]*coefficient, nextX+distanceNextYline, downToXline - demoData[i]*coefficient);
//            nextX +=distanceNextYline;
//            corectPointer1 = downToXline - demoData[i]*coefficient;
//        }
//        [[UIColor colorWithRed:229.0/255.0f green:168.0/255.0f blue:10.0/255.0f alpha:1.0f] set];
//        CGContextSetLineWidth(context, 2);
//        CGContextAddPath(context, spadePath);
//        
//        CGContextStrokePath(context);
//        
//        
//        
//    } else {
//        
//        
//        
//        if ([_secondArray count] == 12) {
//            //seconArray
//            double demoData2[12] = {[[_secondArray objectAtIndex:0] doubleValue],[[_secondArray objectAtIndex:1] doubleValue],[[_secondArray objectAtIndex:2] doubleValue],[[_secondArray objectAtIndex:3] doubleValue],[[_secondArray objectAtIndex:4] doubleValue],[[_secondArray objectAtIndex:5] doubleValue],[[_secondArray objectAtIndex:6] doubleValue],[[_secondArray objectAtIndex:7] doubleValue],[[_secondArray objectAtIndex:8] doubleValue],[[_secondArray objectAtIndex:9] doubleValue],[[_secondArray objectAtIndex:10] doubleValue],[[_secondArray objectAtIndex:11] doubleValue]};
//            
//            
//            int coor = 18;
//            for (int i = 0; i<12; i++) {
//                CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:229.0f/255.0f green:168.0f/255.0f blue:10.0f/255.0f alpha:1].CGColor);
//                CGContextSetRGBFillColor(context, 229.0f/255.0f, 168.0f/255.0f, 10.0f/255.0f, 1.0);
//                CGMutablePathRef pathRef = CGPathCreateMutable();
//                CGPathMoveToPoint(pathRef, NULL, coor, 75);
//                CGPathAddLineToPoint(pathRef, NULL, coor, -demoData2[i]*coefficient+75);
//                CGPathAddLineToPoint(pathRef, NULL, coor+8, -demoData2[i]*coefficient+75);
//                CGPathAddLineToPoint(pathRef, NULL, coor+8, 75);
//                CGPathCloseSubpath(pathRef);
//                CGContextAddPath(context, pathRef);
//                CGContextFillPath(context);
//                CGContextAddPath(context, pathRef);
//                CGContextStrokePath(context);
//                CGContextSetShadow(context,CGSizeMake(2, 2) , 2);
//                
//                CGPathRelease(pathRef);
//                int negCor;
//                if (demoData2[i]>0) {
//                    negCor = 15;
//                } else {
//                    negCor = 3;
//                }
//                UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(coor-45, -demoData2[i]*coefficient+75-negCor, 50, 20)];
//                secondLabel.textAlignment = NSTextAlignmentRight;
//                secondLabel.backgroundColor = [UIColor clearColor];
//                secondLabel.textColor = [UIColor colorWithRed:229.0f/255.0f green:168.0f/255.0f blue:10.0f/255.0f alpha:1];
//                secondLabel.text = [NSString stringWithFormat:demoData2[i] == (int)demoData2[i]?@"%.0f":@"%.0f",demoData2[i]];
//                secondLabel.shadowColor = [UIColor darkGrayColor];
//                secondLabel.shadowOffset = CGSizeMake(0.3, 0.3);
//                [secondLabel setFont:[UIFont systemFontOfSize:10]];
//                [secondLabel setAdjustsFontSizeToFitWidth:YES];
//                [self addSubview:secondLabel];
//                
//                coor += 20;
//            }
//        }
//    }
//}


@end
