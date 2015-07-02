//
//  RHEventHandler.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/21.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHEventHandler : NSObject



+ ( NSString * )saveEchoImage:( NSData * )pJpegData;

+ ( NSString * )saveLastEchoImg:( NSData * )pJpegData;
+ ( NSString * )getLastEchoImg;
+ ( NSString * )saveLastShapeImg:( NSData * )pJpegData;
+ ( NSString * )getLastShapeImg;;
@end
