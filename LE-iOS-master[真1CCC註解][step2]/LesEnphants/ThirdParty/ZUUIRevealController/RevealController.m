#import "RevealController.h"
#import "RHMainVC.h"
#import "RHMenuVC.h"
#import "RHAppDelegate.h"



@implementation RevealController
@synthesize m_pTmpView;

#pragma mark - Initialization

- (id)initWithFrontViewController:(UIViewController *)aFrontViewController rearViewController:(UIViewController *)aBackViewController
{
	self = [super initWithFrontViewController:aFrontViewController rearViewController:aBackViewController];
	
	if (nil != self)
	{
        self.m_pTmpView = nil;
		self.delegate = self;
        m_bSkip = NO;
	}
	
	return self;
}

#pragma - ZUUIRevealControllerDelegate Protocol.

/*
 * All of the methods below are optional. You can use them to control the behavior of the ZUUIRevealController, 
 * or react to certain events.
 */
- (BOOL)revealController:(ZUUIRevealController *)revealController shouldRevealRearViewController:(UIViewController *)rearViewController
{
	return YES;
}

- (BOOL)revealController:(ZUUIRevealController *)revealController shouldHideRearViewController:(UIViewController *)rearViewController 
{
	return YES;
}

- (void)revealController:(ZUUIRevealController *)revealController willRevealRearViewController:(UIViewController *)rearViewController 
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
    
    //Menu要出現時，就通知更新資料
    [[NSNotificationCenter defaultCenter] postNotificationName:kMenuViewReveal object:nil];

    // Update User Profile
    [[NSNotificationCenter defaultCenter] postNotificationName:kMainViewtUserProfile object:nil];
}

- (void)revealController:(ZUUIRevealController *)revealController didRevealRearViewController:(UIViewController *)rearViewController
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
    
    
    if ( m_pTmpView == nil )
    {
        UIView *pVIew = [[UIView alloc] initWithFrame:self.view.bounds];
        [pVIew setBackgroundColor:[UIColor clearColor]];
        self.m_pTmpView = pVIew;
        [pVIew release];
    }
    
    if ( m_bSkip )
    {
        m_bSkip = NO;
    }
    else
    {
        [self.frontViewController.view addSubview:self.m_pTmpView];
    }
    
}

- (void)revealController:(ZUUIRevealController *)revealController willHideRearViewController:(UIViewController *)rearViewController
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(ZUUIRevealController *)revealController didHideRearViewController:(UIViewController *)rearViewController 
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ( self.m_pTmpView )
    {
        if (self.m_pTmpView.superview )
        {
            [self.m_pTmpView removeFromSuperview];
        }
        else
        {
            //skip once
            m_bSkip = YES;
        }
    }
    else
    {
        m_bSkip = YES;
        
    }
    
}

- (void)revealController:(ZUUIRevealController *)revealController willResignRearViewControllerPresentationMode:(UIViewController *)rearViewController
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(ZUUIRevealController *)revealController didResignRearViewControllerPresentationMode:(UIViewController *)rearViewController
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(ZUUIRevealController *)revealController willEnterRearViewControllerPresentationMode:(UIViewController *)rearViewController
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(ZUUIRevealController *)revealController didEnterRearViewControllerPresentationMode:(UIViewController *)rearViewController
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end