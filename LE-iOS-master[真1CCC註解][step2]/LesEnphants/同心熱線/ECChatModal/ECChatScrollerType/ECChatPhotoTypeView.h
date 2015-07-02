//
//  ECChatPhotoTypeView.h
//  SingleBank
//
//  Created by Soul on 2014/8/12.
//  Copyright (c) 2014年 Shinren Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ImageCache.h"
#import "RHAppDelegate.h"

@protocol ECChatPhotoTypeViewDelegate <NSObject>

@required

- (void) callBackPhotoWithData:(NSMutableDictionary *)pdicPIC inView:(UIView *)view;

@end

@interface ECChatPhotoTypeView : UIView

@property (nonatomic, assign) id<ECChatPhotoTypeViewDelegate> delegate;

@property (nonatomic, retain) NSMutableDictionary *m_pdicData;

@property (nonatomic, retain) IBOutlet UIImageView *m_pimgPhoto;

@property (nonatomic, retain) IBOutlet UIButton *m_pbtnPhoto;

@property (nonatomic, retain) AsyncImageView *m_pImgSync;

- (void) setupInitial;

@end
