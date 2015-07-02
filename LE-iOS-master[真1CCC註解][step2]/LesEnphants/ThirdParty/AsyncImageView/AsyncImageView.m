//
//  AsyncImageView.m
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"

//
// Key's are URL strings.
// Value's are ImageCacheObject's
//

@implementation AsyncImageView

@synthesize delegate;
@synthesize imageCache;
@synthesize m_pMainImg;
@synthesize m_pBusyView;
#pragma mark -
#pragma mark private
- ( void )singleTap
{
    if (delegate != NULL && [delegate respondsToSelector:@selector(singleTap)]) 
    {
        [delegate singleTap];
    }                                
}

- ( void )doubleTap:( UITouch * )touch
{
    if (delegate != NULL && [delegate respondsToSelector:@selector(doubleTap:)]) 
    {
        [delegate doubleTap:[touch locationInView:self]];
    }                    
}

#pragma mark -
#pragma mark TouchEvent
- ( void )touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *pSet = [event allTouches];
    NSUInteger numTouches = [pSet count];    
    
    if ( numTouches == 1 )
    {
        UITouch *touch = [pSet anyObject];
        switch ( [touch tapCount] ) 
        {
            case 1:
                [self performSelector:@selector(singleTap) 
                           withObject:nil 
                           afterDelay:.4];
                break;
            case 2:
                [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                                         selector:@selector(singleTap) 
                                                           object:nil];
                [self doubleTap:touch];
                break;
        }
        
    }    
}

#pragma mark -
#pragma mark AsyncImageView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) 
    {
        self.m_pMainImg = nil;
        self.m_pBusyView = nil;
    }
    return self;
}

- ( id )initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super initWithCoder:aDecoder] )
    {
        self.m_pMainImg = nil;
        self.m_pBusyView = nil;
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}


- (void)dealloc 
{
    myRequest.delegate = nil;
    [myRequest cancel];
    [myRequest release];
    [connection cancel];
    [connection release];
    [data release];
    [defaultImage release];
    [m_pMainImg release];
    [m_pBusyView release];
    [super dealloc];
}

- ( void )setDefaultImage:( NSString * )pImageName
{
    defaultImage = [pImageName retain];
}

- ( void )setEmptyImage
{
    UIImage *pImage = nil;
    if ( defaultImage )
    {
        pImage = [UIImage imageNamed:defaultImage];
    }
    else 
    {
        pImage = [UIImage imageNamed:@"pic_loading.png"];        
    }
        
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:pImage] autorelease];
    imageView.userInteractionEnabled = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout];
    [self setNeedsLayout];    
}

-(void)loadImageFromURL:(NSURL*)url
{
    if ( myRequest != nil )
    {
        myRequest.delegate = nil;
        [myRequest cancel];
        [myRequest release];
        myRequest = nil;
    }
    
    if (connection != nil) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (data != nil) {
        [data release];
        data = nil;
    }
    
    if (imageCache == nil) // lazily create image cache
	{
		NSLog(@"imageCache == nil");
        return;
	}
//        imageCache = [[ImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
    [urlString release];
    urlString = [[url absoluteString] copy];
    UIImage *cachedImage = [imageCache imageForKey:urlString];
    
    if (cachedImage != nil) 
    {
        //NSLog(@"cachedImage != nil");
        self.m_pMainImg = cachedImage;
        if ([[self subviews] count] > 0) {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:cachedImage] autorelease];
        imageView.userInteractionEnabled = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = 
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        imageView.frame = self.bounds;
        [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
        [self setNeedsLayout];
        
        if ( delegate
            && [delegate respondsToSelector:@selector(hasImage:)] )
        {
            if (m_pBusyView )
            {
                NSLog(@"stop 3");
                [m_pBusyView stopAnimating];
            }
            [delegate hasImage:self.tag];
        }
        
        return;
	} 
	
	// andy@luibh.ie 6th March 2010 - including modified code by Robert A of http://photoaperture.com/
	// this shows a default place holder image if no cached image exists.
	else {
				
		// Use a default placeholder when no cached image is found
        UIImage *pImage = nil;
        if ( defaultImage )
        {
            pImage = [UIImage imageNamed:defaultImage];
        }
        else 
        {
            pImage = [UIImage imageNamed:@"pic_loading.png"];        
        }
        
		UIImageView *imageView = [[[UIImageView alloc] initWithImage:pImage] autorelease];
        imageView.userInteractionEnabled = NO;
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.autoresizingMask =
		UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:imageView];
		imageView.frame = self.bounds;
		[imageView setNeedsLayout];
		[self setNeedsLayout];
	}    
	
#define SPINNY_TAG 5555   
    
    UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinny.tag = SPINNY_TAG;
    self.m_pBusyView = spinny;
//    CGPoint kCenter = self.center;
    CGRect kFrame = spinny.frame;
    kFrame.origin.x = self.frame.size.width / 2 - spinny.frame.size.width / 2;
    kFrame.origin.y = self.frame.size.height / 2 - spinny.frame.size.height / 2;
    spinny.frame = kFrame;
    spinny.autoresizingMask = self.autoresizingMask;
//    spinny.center = kCenter;
    [spinny startAnimating];
    [self addSubview:spinny];
    [spinny release];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url 
//                                             cachePolicy:NSURLRequestUseProtocolCachePolicy 
//                                         timeoutInterval:60.0];
//    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSLog(@"requet url = %@", [url description]);
    
    myRequest = [[ASIHTTPRequest requestWithURL:url] retain];
    [myRequest setDelegate:self];
    [myRequest startAsynchronous];
    
}

- ( UIImage * )getImage
{
    return m_pMainImg;
}

- ( void )stopConnect
{
    if ( ![myRequest isCancelled] )
    {
        NSLog(@"cancel at %d", self.tag);
        [myRequest cancel];
    }
}

- ( BOOL )isLoading
{
    return ![myRequest isCancelled];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    myRequest.delegate = nil;
    [myRequest release];
    myRequest = nil;
    
    UIImage *image = [UIImage imageWithData:[request responseData]];
    if ( image )
    {
        //NSLog(@"requestFinished, has image");
        self.m_pMainImg = image;
        if ([[self subviews] count] > 0)
        {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        
        UIView *spinny = [self viewWithTag:SPINNY_TAG];
        [spinny removeFromSuperview];
        
        [imageCache insertImage:image withSize:[data length] forKey:urlString];
        
        UIImageView *imageView = [[[UIImageView alloc] 
                                   initWithImage:image] autorelease];
        imageView.userInteractionEnabled = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = 
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        imageView.frame = self.bounds;
        [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
        [self setNeedsLayout];
        
        if ( delegate
            && [delegate respondsToSelector:@selector(hasImage:)] )
        {
            if (m_pBusyView )
            {
                NSLog(@"stop 1");
                [m_pBusyView stopAnimating];
            }
            [delegate hasImage:self.tag];
        }
    }
    
}

#pragma mark -
#pragma mark NSConnectionDelegate
- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)incrementalData 
{
    NSLog(@"didReceiveData");
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection 
{
    NSLog(@"connectionDidFinishLoading");
    [connection release];
    connection = nil;
    
    UIView *spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];
        
    UIImage *image = [UIImage imageWithData:data];
    if ( image )
    {
        NSLog(@"connectionDidFinishLoading and has image");
        self.m_pMainImg = image;
        if ([[self subviews] count] > 0) {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        
        [imageCache insertImage:image withSize:[data length] forKey:urlString];
        
        UIImageView *imageView = [[[UIImageView alloc] 
                                   initWithImage:image] autorelease];
        imageView.userInteractionEnabled = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = 
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        imageView.frame = self.bounds;
        [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
        [self setNeedsLayout];
        
        if ( delegate
            && [delegate respondsToSelector:@selector(hasImage:)] )
        {
            if (m_pBusyView )
            {
                NSLog(@"stop 2");
                [m_pBusyView stopAnimating];
            }
            [delegate hasImage:self.tag];
        }
    }
    [data release];
    data = nil;
}

@end
