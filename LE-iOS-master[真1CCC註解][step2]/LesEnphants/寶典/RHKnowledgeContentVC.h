//
//  RHKnowledgeContentVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/26.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHKnowledgeContentVC : UIViewController
{
    NSDictionary        *m_pContentData;
    NSString            *m_pstrTitle;
}

@property ( nonatomic, retain ) NSDictionary        *m_pContentData;
@property ( nonatomic, retain ) NSString            *m_pstrTitle;
@property (retain, nonatomic) IBOutlet UIWebView *m_pMainWebView;
@property (retain, nonatomic) IBOutlet UILabel *m_plblTitle;

#pragma mark - Customized Methods


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;


@end
