//
//  RHImageViewerVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHShareViewerVC.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"

@interface RHShareViewerVC ()

@end

@implementation RHShareViewerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setQRCode:0];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    }
    else {
        
        CGRect screenFrame = [UIScreen mainScreen].applicationFrame;
        if (screenFrame.size.height <= 480)
        {
            CGRect frame = self.m_pBottomView.frame;
            frame.origin.y += 40;
            self.m_pBottomView.frame = frame;
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void )dealloc
{
    [super dealloc];
}

- (void)setQRCode:(int)type {
    
    NSString *m_pstrImageName = nil;
    switch (type) {
        case 0:
            m_pstrImageName = @"iOS LE QR Code.png";
            break;

            
        case 1:
            m_pstrImageName = @"Android LE QRCode.png";
            break;
            
        default:
            break;
    }
    
    if (m_pstrImageName) {
        UIImage *image = [UIImage imageNamed:m_pstrImageName];
        if (image) {
            self.m_pCntView.image = image;
        }
    }
    
    
}


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressiOSBtn:(id)sender {
    
    self.m_pCntTitle.text = @"iOS";
    [self setQRCode:0];
    
    [self.m_pBtniOS     setBackgroundImage:[UIImage imageNamed:@"推薦好孕邦_selected"] forState:UIControlStateNormal];
    [self.m_pBtnAndroid setBackgroundImage:[UIImage imageNamed:@"推薦好孕邦_select"]   forState:UIControlStateNormal];
}

- ( IBAction )pressAndroidBtn:(id)sender {

    self.m_pCntTitle.text = @"Android";
    [self setQRCode:1];
    
    [self.m_pBtniOS     setBackgroundImage:[UIImage imageNamed:@"推薦好孕邦_select"]   forState:UIControlStateNormal];
    [self.m_pBtnAndroid setBackgroundImage:[UIImage imageNamed:@"推薦好孕邦_selected"] forState:UIControlStateNormal];
}
 

@end
