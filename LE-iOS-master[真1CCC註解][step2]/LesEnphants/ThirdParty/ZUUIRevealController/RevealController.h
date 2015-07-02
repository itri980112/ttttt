
#import <UIKit/UIKit.h>
#import "ZUUIRevealController.h"

@class RHMainVC;
@class RHMenuVC;

@interface RevealController : ZUUIRevealController <ZUUIRevealControllerDelegate>
{
    UIView      *m_pTmpView;
    BOOL        m_bSkip;
}

@property ( nonatomic, retain ) UIView      *m_pTmpView;

@end