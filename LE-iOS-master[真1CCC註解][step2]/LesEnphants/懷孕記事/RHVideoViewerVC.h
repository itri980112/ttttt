//
//  RHVideoViewerVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface RHVideoViewerVC : UIViewController
{
    NSString                    *m_pstrImgURL;
    MPMoviePlayerController     *m_pPlayer;
}
@property ( nonatomic, retain ) MPMoviePlayerController     *m_pPlayer;
@property ( nonatomic, retain ) NSString                    *m_pstrImgURL;
@property ( nonatomic, retain ) IBOutlet UIView             *m_pCntView;
#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressShareBtn:(id)sender;

@end
