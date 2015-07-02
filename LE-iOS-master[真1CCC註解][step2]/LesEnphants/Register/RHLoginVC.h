//
//  RHLoginVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/14.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHLoginVC : UIViewController
{
    
}

@property (retain, nonatomic) IBOutlet UITextField *m_pTFEMail;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFPW;
@property (retain, nonatomic) IBOutlet UITextView *m_pResultTV;



#pragma mark - IBAction
- ( IBAction )pressCloseBtn:(id)sender;
- ( IBAction )pressEmailLoginBtn:(id)sender;
- ( IBAction )pressGuestLoginBtn:(id)sender;
- ( IBAction )pressFBLoginBtn:(id)sender;

@end
