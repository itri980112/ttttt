//
//  AsyncImageView.h
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


//
// Code heavily lifted from here:
// http://www.markj.net/iphone-asynchronous-table-image/
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ImageCache.h"

@protocol AsyncImageViewDelegate<NSObject>

@optional
- ( void )hasImage:( NSInteger )nTag;
- ( void )singleTap;
- ( void )doubleTap:( CGPoint )kTapPosition;
@end


@interface AsyncImageView : UIView 
    <ASIHTTPRequestDelegate>
{
    id<AsyncImageViewDelegate> delegate;
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
    ASIHTTPRequest *myRequest;
    ImageCache *imageCache;
    NSString *defaultImage;
    UIImage *m_pMainImg;
    UIActivityIndicatorView *m_pBusyView;
}

@property ( nonatomic, assign ) id<AsyncImageViewDelegate> delegate;
@property ( nonatomic, assign ) ImageCache *imageCache;
@property ( nonatomic, retain ) UIImage *m_pMainImg;
@property ( nonatomic, retain ) UIActivityIndicatorView *m_pBusyView;
- ( void )loadImageFromURL:(NSURL*)url;
- ( void )setEmptyImage;
- ( void )setDefaultImage:( NSString * )pImageName;
- ( UIImage * )getImage;
- ( void )stopConnect;
- ( BOOL )isLoading;
@end
