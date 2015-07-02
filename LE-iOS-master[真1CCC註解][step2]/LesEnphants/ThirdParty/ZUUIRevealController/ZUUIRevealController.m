#import "ZUUIRevealController.h"
@interface ZUUIRevealController() {
	BOOL enableSwipeAndTapGestures;
	
	UITapGestureRecognizer *tapGestureRecognizer;
	UISwipeGestureRecognizer *swipeGestureRecognizer;
	UISwipeGestureRecognizer *swipeLeftGestureRecognizer;
}


// Private Properties:
@property (retain, nonatomic) UIView *frontView;//CCC do strong->retain

@property (retain, nonatomic) UIView *rearView;//CCC do strong->retain
@property (assign, nonatomic) float previousPanOffset;

// Private Methods:
- (void)_loadDefaultConfiguration;

- (CGFloat)_calculateOffsetForTranslationInView:(CGFloat)x;
- (void)_revealAnimationWithDuration:(NSTimeInterval)duration;
- (void)_concealAnimationWithDuration:(NSTimeInterval)duration resigningCompletelyFromRearViewPresentationMode:(BOOL)resigning;
- (void)_concealPartiallyAnimationWithDuration:(NSTimeInterval)duration;


- (void)_handleRevealGestureStateChangedWithRecognizer:(UIPanGestureRecognizer *)recognizer;
- (void)_handleRevealGestureStateEndedWithRecognizer:(UIPanGestureRecognizer *)recognizer;

- (void)_addFrontViewControllerToHierarchy:(UIViewController *)frontViewController;
- (void)_addRearViewControllerToHierarchy:(UIViewController *)rearViewController;

- (void)removeFrontViewControllerFromHierarchy:(UIViewController *)frontViewController;
- (void)removeRearViewControllerFromHierarchy:(UIViewController *)rearViewController;


- (void)_swapCurrentFrontViewControllerWith:(UIViewController *)newFrontViewController animated:(BOOL)animated;

@end

@implementation ZUUIRevealController

@synthesize previousPanOffset = _previousPanOffset;
@synthesize currentFrontViewPosition = _currentFrontViewPosition;
@synthesize frontViewController ;//= _frontViewController;
@synthesize rearViewController ;//= _rearViewController;//CCC do
@synthesize frontView ;//= _frontView;//CCC do
@synthesize rearView ;//= _rearView;//CCC do
@synthesize delegate = _delegate;

@synthesize rearViewRevealWidth = _rearViewRevealWidth;
@synthesize maxRearViewRevealOverdraw = _maxRearViewRevealOverdraw;
@synthesize rearViewPresentationWidth = _rearViewPresentationWidth;
@synthesize revealViewTriggerWidth = _revealViewTriggerWidth;
@synthesize concealViewTriggerWidth = _concealViewTriggerWidth;
@synthesize quickFlickVelocity = _quickFlickVelocity;
@synthesize toggleAnimationDuration = _toggleAnimationDuration;
@synthesize frontViewShadowRadius = _frontViewShadowRadius;

#pragma mark - Initialization

- (id)initWithFrontViewController:(UIViewController *)frontViewController rearViewController:(UIViewController *)rearViewController
{
	self = [super init];
	
	if (nil != self)
	{
 
        //NSLog(@"00001  %ld    %ld   %p   %p ",(long)rearViewController.retainCount,(long)self.rearViewController.retainCount,self.rearViewController,rearViewController);
        
		 
        self.rearViewController= rearViewController;
        //NSLog(@"00001  %ld    %ld   %p   %p ",(long)rearViewController.retainCount,(long)self.rearViewController.retainCount,self.rearViewController,rearViewController);
        
        
        self.frontViewController=frontViewController;
               // self.frontViewController = frontViewController;//CCC do
        
		[self _loadDefaultConfiguration];
	}
	//NSLog(@"00001  %ld    %ld   %p   %p ",(long)rearViewController.retainCount,(long)self.rearViewController.retainCount,self.rearViewController,rearViewController);
	return self;
}

- (void)_loadDefaultConfiguration
{
	self.rearViewRevealWidth = 260.0f;
	self.maxRearViewRevealOverdraw = 60.0f;
	self.rearViewPresentationWidth = 320.0f;
	self.revealViewTriggerWidth = 125.0f;
	self.concealViewTriggerWidth = 200.0f;
	self.quickFlickVelocity = 1300.0f;
	self.toggleAnimationDuration = 0.25f;
	self.frontViewShadowRadius = 2.5f;
}

#pragma mark - Reveal


- (void)revealToggle:(id)sender
{
    //NSLog(@"%ld    tefg1-",(long)self.frontViewController.retainCount   );
	[self revealToggle:sender animationDuration:self.toggleAnimationDuration];//CCC:self.toggleAnimationDuration 就是取出0.25的時間值
}


- (void)revealToggle:(id)sender animationDuration:(NSTimeInterval)animationDuration
{
//CCC猜:如果右邊的view蓋過左邊的view
	if (FrontViewPositionLeft == self.currentFrontViewPosition)
	{
		 		 
		
		 		
		[self _revealAnimationWithDuration:animationDuration];//CCC:讓右邊的view往右移，讓左邊的view現形
		
		self.currentFrontViewPosition = FrontViewPositionRight;
	}
	else if (FrontViewPositionRight == self.currentFrontViewPosition)////CCC猜:如果右邊的view已經被往右移
	{
		 //NSLog(@"%ld    tefg1-",(long)self.frontViewController.retainCount   );
		[self _concealAnimationWithDuration:animationDuration resigningCompletelyFromRearViewPresentationMode:NO];//CCC:實際在做事情的函數，只有CGRectMake那一行有實際作用，就是把右邊的view往左移，蓋在左view上
		
		self.currentFrontViewPosition = FrontViewPositionLeft;//CCC:指出右邊的view已經往左移
	}
	else
	{
		 		
		[self showFrontViewCompletely:YES];
	}
    //NSLog(@"%ld    tefg1-",(long)self.frontViewController.retainCount   );

}
//CCC:讓右邊的view往右移，讓左邊的view現形
- (void)_revealAnimationWithDuration:(NSTimeInterval)duration
{	
	[UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^
	{
		self.frontView.frame = CGRectMake(self.rearViewRevealWidth, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
	}
	completion:^(BOOL finished)
	{
		 
	}];
}
//CCC:只有CGRectMake那一行有實際作用，就是把右邊的view往左移，蓋在左view上
- (void)_concealAnimationWithDuration:(NSTimeInterval)duration resigningCompletelyFromRearViewPresentationMode:(BOOL)resigning
{
    //NSLog(@"%ld    tefg1-",(long)self.frontViewController.retainCount   );

	[UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^
	{
		self.frontView.frame = CGRectMake(0.0f, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
	}
	completion:^(BOOL finished)
	{
	}];
}

- (void)_concealPartiallyAnimationWithDuration:(NSTimeInterval)duration
{
	[UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^
	{
		self.frontView.frame = CGRectMake(self.rearViewRevealWidth, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
	}
	completion:^(BOOL finished)
	{
	}];
}

- (void)_revealCompletelyAnimationWithDuration:(NSTimeInterval)duration
{
 
	[UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^
	{
	//CCC:下面一行是把右邊的view往右移，並且附帶動畫效果
		self.frontView.frame = CGRectMake(self.rearViewPresentationWidth, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
	}
	completion:^(BOOL finished)
	{
		
	}];
}
//CCC:把右邊區往右移
- (void)hideFrontView
{
	if (self.currentFrontViewPosition == FrontViewPositionRightMost)
	{
		return;
	}
	[self _revealCompletelyAnimationWithDuration:self.toggleAnimationDuration*0.5f];
	self.currentFrontViewPosition = FrontViewPositionRightMost;
}

- (void)showFrontViewCompletely:(BOOL)completely
{
	if (self.currentFrontViewPosition != FrontViewPositionRightMost)
	{
		return;
	}
	
	 	
	if (completely)
	{
		 		
		[self _concealAnimationWithDuration:self.toggleAnimationDuration resigningCompletelyFromRearViewPresentationMode:YES];
		self.currentFrontViewPosition = FrontViewPositionLeft;
	}
	else
	{
		[self _concealPartiallyAnimationWithDuration:self.toggleAnimationDuration*0.5f];
		self.currentFrontViewPosition = FrontViewPositionRight;
	}
}

#pragma mark - Gesture Based Reveal

//CCC do
- (void)setEnableSwipeAndTapGesturesForRear {
    
        UITapGestureRecognizer *CCCtapGestureRecognizer;
        UISwipeGestureRecognizer *CCCswipeGestureRecognizer;
        UISwipeGestureRecognizer *CCCswipeLeftGestureRecognizer;
        
        
        CCCtapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                initWithTarget:self
                                action:@selector(_tap:)];
        CCCtapGestureRecognizer.numberOfTapsRequired = 1;
        CCCtapGestureRecognizer.numberOfTouchesRequired = 1;
        CCCtapGestureRecognizer.cancelsTouchesInView = NO;
        tapGestureRecognizer=CCCtapGestureRecognizer;
        
        CCCswipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(_swipe:)];
        
        CCCswipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        swipeGestureRecognizer=CCCswipeGestureRecognizer;
        
        
        CCCswipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(_swipeLeft:)];
        
        CCCswipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeLeftGestureRecognizer=CCCswipeLeftGestureRecognizer;
        [self.frontViewController.view addGestureRecognizer:CCCtapGestureRecognizer];
        [self.frontViewController.view addGestureRecognizer:CCCswipeGestureRecognizer];
        [self.frontViewController.view addGestureRecognizer:CCCswipeLeftGestureRecognizer];
        //NSLog(@"%ld    GZZZ3",(long)CCCtapGestureRecognizer.retainCount   );
        //NSLog(@"%ld    GZZZ3",(long)CCCswipeGestureRecognizer.retainCount   );
        //NSLog(@"%ld    GZZZ3",(long)CCCswipeLeftGestureRecognizer.retainCount   );
        [CCCtapGestureRecognizer release];
        [CCCswipeGestureRecognizer release];
        [CCCswipeLeftGestureRecognizer release];
        
        //NSLog(@"%ld    ZZZ3",(long)self.rearViewController.retainCount   );
        [self.rearViewController.view addGestureRecognizer:swipeLeftGestureRecognizer];
        //NSLog(@"%ld  %ld ZZZ3",(long)self.rearViewController.retainCount , (long)self.rearView.retainCount );
     
    
}
 
- (BOOL)enableSwipeAndTapGestures {
	return enableSwipeAndTapGestures;
}


-(void)_tap:(id)sender {
	if(self.currentFrontViewPosition != FrontViewPositionLeft) {
		[self revealToggle:self];
	}
}

-(void)_swipe:(id)sender {
	if(self.currentFrontViewPosition == FrontViewPositionLeft) {
		[self revealToggle:self];
	}
}

-(void)_swipeLeft:(id)sender {
	if(self.currentFrontViewPosition != FrontViewPositionLeft) {
		[self revealToggle:self];
	}
}

/* Slowly reveal or hide the rear view based on the translation of the finger.
 */
- (void)revealGesture:(UIPanGestureRecognizer *)recognizer
{
	switch ([recognizer state])
	{
		 
			
		case UIGestureRecognizerStateChanged:
		{
			[self _handleRevealGestureStateChangedWithRecognizer:recognizer];
		}
			break;
			
		case UIGestureRecognizerStateEnded:
		{
			[self _handleRevealGestureStateEndedWithRecognizer:recognizer];
		}
			break;
			
		default:
			break;
	}
}



- (void)_handleRevealGestureStateChangedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
	if (FrontViewPositionLeft == self.currentFrontViewPosition)
	{
		if ([recognizer translationInView:self.view].x < 0.0f)
		{
			self.frontView.frame = CGRectMake(0.0f, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		}
		else
		{
			float offset = [self _calculateOffsetForTranslationInView:[recognizer translationInView:self.view].x];//CCC:[recognizer translationInView:self.view].x是self.view往x方向的拖移位移量
			self.frontView.frame = CGRectMake(offset, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		}
	}
	else
	{
		if ([recognizer translationInView:self.view].x > 0.0f)
		{
			float offset = [self _calculateOffsetForTranslationInView:([recognizer translationInView:self.view].x+self.rearViewRevealWidth)];
			self.frontView.frame = CGRectMake(offset, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		}
		else if ([recognizer translationInView:self.view].x > -self.rearViewRevealWidth)
		{
			self.frontView.frame = CGRectMake([recognizer translationInView:self.view].x+self.rearViewRevealWidth, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		}
		else
		{
			self.frontView.frame = CGRectMake(0.0f, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
		}
	}
}

- (void)_handleRevealGestureStateEndedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{//CCC:(UIPanGestureRecognizer *)recognizer，這大概就是當user用手指拖動UIView時，就會呼叫本方法(_handleRevealGestureStateEndedWithRecognizer)
//CCC:但是_handleRevealGestureStateEndedWithRecognizer還要跟某UIView關聯起來才能監聽該UIView的拖動事件
	// Case a): Quick finger flick fast enough to cause instant change:
	if (fabs([recognizer velocityInView:self.view].x) > self.quickFlickVelocity)
	{
		if ([recognizer velocityInView:self.view].x > 0.0f)
		{				
			[self _revealAnimationWithDuration:self.toggleAnimationDuration];//CCC:讓右邊的view往右移，讓左邊的view現形
		}
		else
		{
			[self _concealAnimationWithDuration:self.toggleAnimationDuration resigningCompletelyFromRearViewPresentationMode:NO];//CCC:只有CGRectMake那一行有實際作用，就是把右邊的view往左移，蓋在左view上
		}
	}
	// Case b) Slow pan/drag ended:
	else
	{
		float dynamicTriggerLevel = (FrontViewPositionLeft == self.currentFrontViewPosition) ? self.revealViewTriggerWidth : self.concealViewTriggerWidth;
		
		if (self.frontView.frame.origin.x >= dynamicTriggerLevel && self.frontView.frame.origin.x != self.rearViewRevealWidth)
		{
			[self _revealAnimationWithDuration:self.toggleAnimationDuration];//CCC:讓右邊的view往右移，讓左邊的view現形
		}
		else
		{
			[self _concealAnimationWithDuration:self.toggleAnimationDuration resigningCompletelyFromRearViewPresentationMode:NO];//CCC:只有CGRectMake那一行有實際作用，就是把右邊的view往左移，蓋在左view上
		}
	}
	
	// Now adjust the current state enum.
	if (self.frontView.frame.origin.x == 0.0f)
	{
		self.currentFrontViewPosition = FrontViewPositionLeft;
	}
	else
	{
		self.currentFrontViewPosition = FrontViewPositionRight;
	}
}

#pragma mark - Helper

/* Note: If someone wants to bother to implement a better (smoother) function. Go for it and share!
 */
- (CGFloat)_calculateOffsetForTranslationInView:(CGFloat)x
{
	CGFloat result;
	
	if (x <= self.rearViewRevealWidth)
	{
		// Translate linearly.
		result = x;
	}
	else if (x <= self.rearViewRevealWidth+(M_PI*self.maxRearViewRevealOverdraw/2.0f))
	{
		// and eventually slow translation slowly.
		result = self.maxRearViewRevealOverdraw*sin((x-self.rearViewRevealWidth)/self.maxRearViewRevealOverdraw)+self.rearViewRevealWidth;
	}
	else
	{
		// ...until we hit the limit.
		result = self.rearViewRevealWidth+self.maxRearViewRevealOverdraw;
	}
	
	return result;
}

- (void)_swapCurrentFrontViewControllerWith:(UIViewController *)newFrontViewController animated:(BOOL)animated
{
    //NSLog(@"%ld  %ld FFFr1-",(long)self.frontViewController.retainCount , (long)newFrontViewController.retainCount );

    //NSLog(@"%ld  %ld tefg1-",(long)self.frontViewController.retainCount , (long)self.rearViewController.retainCount );

    [self.frontViewController viewWillDisappear:animated];
    [self removeFrontViewControllerFromHierarchy:self.frontViewController];//front
    //NSLog(@"%ld  %ld tefgwwwww1-",(long)self.frontViewController.retainCount , (long)self.rearViewController.retainCount );
        
    //NSLog(@"%ld  %ld FFFr1--",(long)self.frontViewController.retainCount , (long)newFrontViewController.retainCount );
    [self.frontViewController viewDidDisappear:animated];
 
		//[newFrontViewController retain];//CCC do
        //NSLog(@"%ld  %ld tefgwwwww5-",(long)self.frontViewController.retainCount , (long)self.rearViewController.retainCount );
		//[self.frontViewController release];//CCC3
        //NSLog(@"%ld  %ld tefgwwwww4-",(long)self.frontViewController.retainCount , (long)self.rearViewController.retainCount );
        //NSLog(@"%ld  %ld FFFr3---",(long)self.frontViewController.retainCount , (long)newFrontViewController.retainCount );
        UIViewController *rgrgrgr=self.frontViewController;
         //NSLog(@"%ld  %ld tefgwwwww2-",(long)rgrgrgr.retainCount , (long)self.rearViewController.retainCount );
		self.frontViewController = newFrontViewController;
 //NSLog(@"%ld  %ld tefgwwwww2-",(long)rgrgrgr.retainCount , (long)self.rearViewController.retainCount );
        
        //NSLog(@"%ld  %ld FFFr1----",(long)self.frontViewController.retainCount , (long)newFrontViewController.retainCount );
		
		[newFrontViewController viewWillAppear:animated];
		[self _addFrontViewControllerToHierarchy:newFrontViewController];
		[newFrontViewController viewDidAppear:animated];
		
		if ([self.delegate respondsToSelector:@selector(revealController:didSwapToFrontViewController:)])
		{
			[self.delegate revealController:self didSwapToFrontViewController:newFrontViewController];
		}
		
		[self revealToggle:self];
         //NSLog(@"%ld  %ld tefgwwwww2-",(long)rgrgrgr.retainCount , (long)self.rearViewController.retainCount );
	 
}

#pragma mark - Accessors

//CCC error!
- (void)setFrontViewController:(UIViewController *)frontViewController animated:(BOOL)animated
{
    //NSLog(@"%ld  %ld tefg1-",(long)self.frontViewController.retainCount , (long)self.rearViewController.retainCount );
	 if (nil != frontViewController)
	{
		[self _swapCurrentFrontViewControllerWith:frontViewController animated:animated];
	}
	[self setEnableSwipeAndTapGesturesForRear ];
}

#pragma mark - UIViewController Containment

- (void)_addFrontViewControllerToHierarchy:(UIViewController *)frontViewController
{
    //NSLog(@"%ld  %ld VVV3",(long)self.frontViewController.retainCount , (long)self.frontView.retainCount );
	[self addChildViewController:frontViewController];
	
	// iOS 4 doesn't adjust the frame properly if in landscape via implicit loading from a nib.
	frontViewController.view.frame = CGRectMake(0.0f, 0.0f, self.frontView.frame.size.width, self.frontView.frame.size.height);
	
	[self.frontView addSubview:frontViewController.view];
	
	if ([frontViewController respondsToSelector:@selector(didMoveToParentViewController:)])
	{
		[frontViewController didMoveToParentViewController:self];
	}
    
    //NSLog(@"%ld  %ld VVV3",(long)self.frontViewController.retainCount , (long)self.frontView.retainCount );
}

- (void)_addRearViewControllerToHierarchy:(UIViewController *)rearViewController
{
    //NSLog(@"%ld  %ld ZZZ3",(long)rearViewController.retainCount , (long)self.rearView.retainCount );
	[self addChildViewController:rearViewController];
    //NSLog(@"%ld  %ld ZZZ3",(long)rearViewController.retainCount , (long)self.rearView.retainCount );
	[self.rearView addSubview:rearViewController.view];
	//NSLog(@"%ld  %ld ZZZ3g",(long)rearViewController.retainCount , (long)self.rearView.retainCount );
	if ([rearViewController respondsToSelector:@selector(didMoveToParentViewController:)])
	{
        //NSLog(@"%ld  %ld ZZZ3",(long)rearViewController.retainCount , (long)self.rearView.retainCount );
		[rearViewController didMoveToParentViewController:self];
        //NSLog(@"%ld  %ld ZZZ3",(long)rearViewController.retainCount , (long)self.rearView.retainCount );
	}
}

- (void)removeFrontViewControllerFromHierarchy:(UIViewController *)FrontviewController
{
    //NSLog(@"%ld  ZZZ1",(long)FrontviewController.retainCount   );
	[FrontviewController.view removeFromSuperview];
	//NSLog(@"%ld  ZZZ2",(long)FrontviewController.retainCount   );
	if ([FrontviewController respondsToSelector:@selector(removeFromParentViewController)])
	{
        //NSLog(@"%ld  ZZZ3",(long)FrontviewController.retainCount   );
		[FrontviewController removeFromParentViewController];
        //NSLog(@"%ld  ZZZ4",(long)FrontviewController.retainCount   );
	}
}
- (void)removeRearViewControllerFromHierarchy:(UIViewController *)RearviewController
{
    //NSLog(@"%p  ZZZ",RearviewController    );
    [RearviewController.view removeFromSuperview];
    
    if ([RearviewController respondsToSelector:@selector(removeFromParentViewController)])
    {
        //NSLog(@"%ld  ZZZ",(long)RearviewController.retainCount   );
        [RearviewController removeFromParentViewController];
        //NSLog(@"%ld  ZZZ",(long)RearviewController.retainCount   );
    }
}

#pragma mark - View Event Forwarding

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
	return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.frontViewController viewWillAppear:animated];
    //NSLog(@"%ld  %ld  ZZZ11",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
	[self.rearViewController viewWillAppear:animated];
    //NSLog(@"%ld  %ld  ZZZ11",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"%ld  %ld  ZZZ12",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );

	[super viewDidAppear:animated];
	[self.frontViewController viewDidAppear:animated];
    //NSLog(@"%ld  %ld  ZZZ12",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
	[self.rearViewController viewDidAppear:animated];
    //NSLog(@"%ld  %ld  ZZZ12",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.frontViewController viewWillDisappear:animated];
    //NSLog(@"%ld  %ld  ZZZ13",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
	[self.rearViewController viewWillDisappear:animated];
    //NSLog(@"%ld  %ld  ZZZ13",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self.frontViewController viewDidDisappear:animated];
    //NSLog(@"%ld  %ld  ZZZ14",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
	[self.rearViewController viewDidDisappear:animated];
    //NSLog(@"%ld  %ld  ZZZ14",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.frontViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.rearViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.frontViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.rearViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self.frontViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self.rearViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    UIView *CCCFrontview=[[UIView alloc] initWithFrame:self.view.bounds] ;//CCC do remove autorelease
    
	self.frontView = CCCFrontview;
    [CCCFrontview release];//CCC do
    //NSLog(@"%ld  %ld  ZZZ5",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
	UIView *CCCRearview=[[UIView alloc] initWithFrame:self.view.bounds] ;//CCC do remove autorelease
    self.rearView =CCCRearview;//CCC do
    
    [CCCRearview release];//CCC do
    //NSLog(@"%ld  %ld  ZZZ5",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
 
	
	self.frontView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.rearView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	
    //NSLog(@"%ld  %ld  ZZZ5",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
	[self.view addSubview:self.rearView];
    //NSLog(@"%ld  %ld  ZZZ5",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
	[self.view addSubview:self.frontView];
	
	 
	UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.frontView.bounds];
	self.frontView.layer.masksToBounds = NO;
	self.frontView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.frontView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	self.frontView.layer.shadowOpacity = 1.0f;
	self.frontView.layer.shadowRadius = self.frontViewShadowRadius;
	self.frontView.layer.shadowPath = shadowPath.CGPath;
	
	// Init the position with only the front view visible.
	self.previousPanOffset = 0.0f;
	self.currentFrontViewPosition = FrontViewPositionLeft;
	
    //NSLog(@"%ld    ZZZ2---",(long)self.rearViewController.retainCount   );
	[self _addRearViewControllerToHierarchy:self.rearViewController];
    //NSLog(@"%ld    ZZZ2-d",(long)self.rearViewController.retainCount   );
	
    
    
    [self _addFrontViewControllerToHierarchy:self.frontViewController];
    [self setEnableSwipeAndTapGesturesForRear];//CCC do
     
    
}

- (void)viewDidUnload
{
	[self removeFrontViewControllerFromHierarchy:self.frontViewController];
    //NSLog(@"%ld  ZZZ",(long)self.rearViewController.retainCount   );
	[self removeRearViewControllerFromHierarchy:self.rearViewController];
	//NSLog(@"%ld  ZZZ",(long)self.rearViewController.retainCount   );
	self.frontView = nil;
	self.rearView = nil;
    [super viewDidUnload];//CCC3
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_5_1
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
#endif

#pragma mark - Memory Management


- (void)dealloc
{
	[self.frontViewController release], self.frontViewController = nil;
    //NSLog(@"%ld  %ld  ZZZ16",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
    //[_rearViewController release];//CCC do
    [self.rearViewController release];//CCC do
    //NSLog(@"%ld  %ld  ZZZ16",(long)self.rearViewController.retainCount,  (long)self.rearView.retainCount );
    //_rearViewController = nil;
    self.rearViewController=nil;//CCC do
	[self.frontView release], self.frontView = nil;
	//[_rearView release], _rearView = nil;//CCC do
    [self.rearView release];//CCC do
	self.rearView=nil;//CCC do
	if(tapGestureRecognizer != nil) {
		[tapGestureRecognizer release], tapGestureRecognizer = nil;
		[swipeGestureRecognizer release], swipeGestureRecognizer = nil;
		[swipeLeftGestureRecognizer release], swipeLeftGestureRecognizer = nil;
	}
	
	[super dealloc];
}


@end