

#import <UIKit/UIKit.h>

// Required for the shadow, cast by the front view.
#import <QuartzCore/QuartzCore.h>

typedef enum
{
	FrontViewPositionLeft,
	FrontViewPositionRight,
	FrontViewPositionRightMost
} FrontViewPosition;

@protocol ZUUIRevealControllerDelegate;
@interface ZUUIRevealController : UIViewController <UITableViewDelegate>

#pragma mark - Public Properties:
@property (retain, nonatomic) IBOutlet UIViewController *frontViewController;//CCC do
@property (retain, nonatomic) IBOutlet UIViewController *rearViewController;//CCC do
@property (assign, nonatomic) FrontViewPosition currentFrontViewPosition;
@property (assign, nonatomic) id<ZUUIRevealControllerDelegate> delegate;

@property (assign, nonatomic) BOOL enableSwipeAndTapGestures;


@property (assign, nonatomic) CGFloat rearViewRevealWidth;


@property (assign, nonatomic) CGFloat maxRearViewRevealOverdraw;


@property (assign, nonatomic) CGFloat rearViewPresentationWidth;


@property (assign, nonatomic) CGFloat revealViewTriggerWidth;


@property (assign, nonatomic) CGFloat concealViewTriggerWidth;


@property (assign, nonatomic) CGFloat quickFlickVelocity;


@property (assign, nonatomic) NSTimeInterval toggleAnimationDuration;


@property (assign, nonatomic) CGFloat frontViewShadowRadius;

#pragma mark - Public Methods:
- (id)initWithFrontViewController:(UIViewController *)aFrontViewController rearViewController:(UIViewController *)aBackViewController;
- (void)revealGesture:(UIPanGestureRecognizer *)recognizer;
- (void)revealToggle:(id)sender;
- (void)revealToggle:(id)sender animationDuration:(NSTimeInterval)animationDuration;

//- (void)setFrontViewController:(UIViewController *)frontViewController;
- (void)setFrontViewController:(UIViewController *)frontViewController animated:(BOOL)animated;

- (void)hideFrontView;
- (void)showFrontViewCompletely:(BOOL)completely;

@end

#pragma mark - Delegate Protocol:

@protocol ZUUIRevealControllerDelegate<NSObject>

@optional

- (BOOL)revealController:(ZUUIRevealController *)revealController shouldRevealRearViewController:(UIViewController *)rearViewController;
- (BOOL)revealController:(ZUUIRevealController *)revealController shouldHideRearViewController:(UIViewController *)rearViewController;

 
- (void)revealController:(ZUUIRevealController *)revealController willRevealRearViewController:(UIViewController *)rearViewController;
- (void)revealController:(ZUUIRevealController *)revealController didRevealRearViewController:(UIViewController *)rearViewController;

- (void)revealController:(ZUUIRevealController *)revealController willHideRearViewController:(UIViewController *)rearViewController;
- (void)revealController:(ZUUIRevealController *)revealController didHideRearViewController:(UIViewController *)rearViewController;

- (void)revealController:(ZUUIRevealController *)revealController willSwapToFrontViewController:(UIViewController *)frontViewController;
- (void)revealController:(ZUUIRevealController *)revealController didSwapToFrontViewController:(UIViewController *)frontViewController;

#pragma mark New in 0.9.9
- (void)revealController:(ZUUIRevealController *)revealController willResignRearViewControllerPresentationMode:(UIViewController *)rearViewController;
- (void)revealController:(ZUUIRevealController *)revealController didResignRearViewControllerPresentationMode:(UIViewController *)rearViewController;

- (void)revealController:(ZUUIRevealController *)revealController willEnterRearViewControllerPresentationMode:(UIViewController *)rearViewController;
- (void)revealController:(ZUUIRevealController *)revealController didEnterRearViewControllerPresentationMode:(UIViewController *)rearViewController;

@end
