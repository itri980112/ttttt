//
//  RHAssociationListVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RHAssociationPostListVC;
@interface RHAssociationWebVC : UIViewController

@property (retain, nonatomic) IBOutlet UILabel          *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UIWebView        *m_pWebView;


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;

@end
