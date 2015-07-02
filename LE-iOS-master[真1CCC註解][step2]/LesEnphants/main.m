//
//  main.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/13.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RHAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {//CCC:UIApplicationMain的第三個參數是nil，則 UIApplication
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([RHAppDelegate class]));
    }
}
/*
UIApplicationMain的函數定義為
int UIApplicationMain(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName)
此函數根據第三個參數principalClassName所指定的類別建立UIApplication物件(每個app在運作過程只有保持唯一一個UIApplication物件)，
然後根據delegateClassName建立一個delegate物件，並將該delegate物件assign給UIApplication物件的delegate屬性
所以principalClassName所指向的類別必須繼承UIApplication
如果principalClassName接收到nil，則預設使用UIApplication來建立物件

UIApplication物件(第三個參數建立的物件)首先呼叫delegate物件(由第四個參數建立的物件)的didFinishLaunchingWithOptions方法
*/
/*
如果UIApplicationMain的第三個參數為nil，如果在之後要取得UIApplication的物件instance，則呼叫
[UIApplication sharedApplication]
*/
