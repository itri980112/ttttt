//
//  ViewController.m
//  GoldCoin
//
//  Created by Rich Fan on 2015/4/10.
//  Copyright (c) 2015年 Rich Fan. All rights reserved.
//

#import "GoldCoinAnimationVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>

@interface GoldCoinAnimationVC () {
    UIImageView *m_goldCoinAnimate;
    UIImageView *m_goldCoinSingle;
    UILabel     *m_goldCoinLabel;
    BOOL m_isAnimating;
    
    NSUInteger m_animateTimes;
    
    CMMotionManager *m_motionManager;
    NSDate *m_accelerationLastTime;
    CMAcceleration m_accelerationMin;
    CMAcceleration m_accelerationMax;
}

@end


@implementation GoldCoinAnimationVC
@synthesize m_goldCoinAnimate, m_goldCoinSingle, m_goldCoinLabel, m_isAnimating;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    // UILabel Gold Number
    m_goldCoinLabel.text = [NSString stringWithFormat:@"+%d", self.m_getPoint];

    [self setAnimations];
    
    // Sensor
    //m_motionManager = [[CMMotionManager alloc] init];
    //m_motionManager.accelerometerUpdateInterval = 1.0f/10.0f;
    //[self accelerometerMethod];

    m_goldCoinSingle.alpha = 0.0;
    m_goldCoinLabel.alpha = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup
- (void)setAnimations {
    
    // UIIImageView GoldCoins
    NSArray *paths = [[NSBundle mainBundle]pathsForResourcesOfType:@"png" inDirectory:@"金幣特效"];
    NSMutableArray *animationAnimateImgs = [[NSMutableArray alloc] init];
    
    for(NSString *path in paths) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        [animationAnimateImgs addObject:image];
    }
    [m_goldCoinAnimate setAnimationImages:animationAnimateImgs];
    [m_goldCoinAnimate setAnimationDuration:1.2];
    [m_goldCoinAnimate setAnimationRepeatCount:1];
    
    
    // UIImageView GoldCoin Single
    NSMutableArray *animationSingleImgs = [[NSMutableArray alloc] init];
    for (int i=1; i<=2; i++) {
        NSString *imageFileName = [NSString stringWithFormat:@"GoldCoin%02d.png", i];
        UIImage *image = [UIImage imageNamed:imageFileName];
        if (image) {
            [animationSingleImgs addObject:image];
        }
    }
    [m_goldCoinSingle setAnimationImages:animationSingleImgs];
    [m_goldCoinSingle setAnimationDuration:0.2];
}

- (void)accelerometerMethod
{
    if ([m_motionManager isAccelerometerAvailable]) {
        
        NSOperationQueue *queue = [NSOperationQueue currentQueue];
        [m_motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData,NSError *error) {
            
            CMAcceleration acceleration = accelerometerData.acceleration;
            //NSLog(@"%f %f %f %f", acceleration.x, acceleration.y, acceleration.z, time);
            
            NSTimeInterval time = [m_accelerationLastTime timeIntervalSinceNow];
            if (time == 0) {
                m_accelerationLastTime = [NSDate date];
                m_accelerationMax = acceleration;
                m_accelerationMin = acceleration;
            }
            
            m_accelerationMax.x = MAX(m_accelerationMax.x, acceleration.x);
            m_accelerationMax.y = MAX(m_accelerationMax.y, acceleration.y);
            m_accelerationMax.z = MAX(m_accelerationMax.z, acceleration.z);
            
            m_accelerationMin.x = MIN(m_accelerationMin.x, acceleration.x);
            m_accelerationMin.y = MIN(m_accelerationMin.y, acceleration.y);
            m_accelerationMin.z = MIN(m_accelerationMin.z, acceleration.z);
            
            CMAcceleration accelerationDiff;
            accelerationDiff.x = m_accelerationMax.x - m_accelerationMin.x;
            accelerationDiff.y = m_accelerationMax.y - m_accelerationMin.y;
            accelerationDiff.z = m_accelerationMax.z - m_accelerationMin.z;
            NSLog(@"%f %f %f %f", accelerationDiff.x, accelerationDiff.y, accelerationDiff.z, time);
            
            
            NSUInteger sensorCount = 0;
            CGFloat sensorPressure = 1.0;
            if (accelerationDiff.x > sensorPressure) {
                sensorCount++;
            }
            if (accelerationDiff.y > sensorPressure) {
                sensorCount++;
            }
            if (accelerationDiff.z > sensorPressure) {
                sensorCount++;
            }
            
            if (sensorCount >= 2) {
                
                if (m_isAnimating == NO) {
                    [self performSelector:@selector(buttonTouched:) withObject:nil afterDelay:0.1];
                }
            }
            
            if (time <= -0.2) {
                m_accelerationLastTime = [NSDate date];
                m_accelerationMax = acceleration;
                m_accelerationMin = acceleration;
            }
            
        }];
    }
    else {
        NSLog(@"Accelerometer is not available.");
    }
}

#pragma mark - Button

- (void)buttonTouched:(id)sender {
    
    [self startAnimation];
}

- (void)startAnimation {
    
    if (m_isAnimating == NO) {
        [self playAnimation];
    }
}

#pragma mark - Animate

- (void)playAnimation {

    m_isAnimating = YES;

    [m_goldCoinAnimate stopAnimating];
    [m_goldCoinAnimate startAnimating];
    
    // Sound effect
    NSString *effectfile = @"GoldCoinSound.wav";
    NSURL *soundfileURL=[NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:effectfile]];
    SystemSoundID soundFileObject;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundfileURL, &soundFileObject);
    AudioServicesRemoveSystemSoundCompletion (soundFileObject);
    AudioServicesPlaySystemSound (soundFileObject);
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    
    NSTimeInterval animateEnd = m_goldCoinAnimate.animationDuration;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(goldCoinRotate) object:nil];
    [self performSelector:@selector(goldCoinRotate) withObject:nil afterDelay:animateEnd / 2.0];
}

- (void)goldCoinRotate {
    
    UIView *animateView = m_goldCoinSingle;
    UIView *animateView2 = m_goldCoinLabel;
    
    m_animateTimes++;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        // First Time
        if (m_animateTimes == 1) {
            animateView.alpha = 1.0;
            animateView2.alpha = 1.0;
        }
        
        if (m_animateTimes % 2 == 0) {
            animateView.transform = CGAffineTransformMakeScale(1, 1);
        }
        else {
            animateView.transform = CGAffineTransformMakeScale(-1, 1);
        }
        
        
    } completion:^(BOOL finished) {
        
        // Repeat Loop
        if (m_animateTimes < 4) {
            [self goldCoinRotate];
        }
        // Last Time
        else {
            
            [UIView animateWithDuration:1.0 animations:^{
                
                animateView.alpha = 0.0;
                animateView2.alpha = 0.0;
                
                CGRect frame = animateView2.frame;
                frame.origin.y -= animateView.frame.size.height;
                animateView2.frame = frame;
                
            } completion:^(BOOL finished) {
                
                CGRect frame = animateView2.frame;
                frame.origin.y += animateView.frame.size.height;
                animateView2.frame = frame;
                
                m_animateTimes = 0;
                
                m_isAnimating = NO;
                
                
                [self dismissViewControllerAnimated:NO completion:^{
                    
                    // Delegate Finish
                    NSObject *delegate = (NSObject *)self.delegate;
                    if ([delegate respondsToSelector:@selector(startAnimationFinish:)]) {
                        [self.delegate startAnimationFinish:finished];
                    }
                    
                }];
                
            }];
            
        }
        
    }];
}

@end
