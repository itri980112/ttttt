//
//  RHImageViewerVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageView;
@interface RHImageViewerVC : UIViewController
{
    NSString        *m_pstrImgURL;
    AsyncImageView  *m_pImgView;
    NSString        *m_pstrImageName;
}

@property ( nonatomic, retain ) NSString        *m_pstrImageName;
@property ( nonatomic, retain ) AsyncImageView *m_pImgView;
@property ( nonatomic, retain ) NSString        *m_pstrImgURL;
@property ( nonatomic, retain ) IBOutlet UIView        *m_pCntView;
@property ( nonatomic, retain ) IBOutlet UIButton        *m_pBtnShare;
#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressShareBtn:(id)sender;

@end
