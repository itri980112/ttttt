//
//  NSMutableArray+Convenience.m
//  SingleBank
//
//  Created by Soul on 2014/8/12.
//  Copyright (c) 2014年 Shinren Pan. All rights reserved.
//

#import "NSMutableArray+Convenience.h"

@implementation NSMutableArray (Convenience)

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    id object = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    [self insertObject:object atIndex:toIndex];
}

@end
