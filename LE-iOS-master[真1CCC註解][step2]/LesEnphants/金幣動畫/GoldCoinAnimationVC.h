//
//  ViewController.h
//  GoldCoin
//
//  Created by Rich Fan on 2015/4/10.
//  Copyright (c) 2015年 Rich Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoldCoinAnimationVCDelegate;

@interface GoldCoinAnimationVC : UIViewController

@property (weak, nonatomic) id<GoldCoinAnimationVCDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIImageView *m_goldCoinAnimate;
@property (retain, nonatomic) IBOutlet UIImageView *m_goldCoinSingle;
@property (retain, nonatomic) IBOutlet UILabel     *m_goldCoinLabel;
@property (readonly) BOOL m_isAnimating;
@property (readwrite, nonatomic) NSInteger m_getPoint;

- (void)startAnimation;

@end

// Delegate
@protocol GoldCoinAnimationVCDelegate
@optional - (void)startAnimationFinish:(BOOL)completed;
@end

