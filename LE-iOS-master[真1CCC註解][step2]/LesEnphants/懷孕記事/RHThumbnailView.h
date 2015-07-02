//
//  RHThumbnailView.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/13.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPostSelectedSectionAndRow      @"PostSelectedSectionAndRow"


@class AsyncImageView;
@interface RHThumbnailView : UIView
{
    NSInteger       m_nSection;
    NSInteger       m_nID;
    NSString        *m_pstrURL;
    
    AsyncImageView      *m_pAsyncImageView;
    BOOL            m_bIsEditing;
}

@property ( nonatomic, retain ) AsyncImageView      *m_pAsyncImageView;
@property ( nonatomic, retain ) NSString        *m_pstrURL;
@property   NSInteger       m_nID;
@property   NSInteger       m_nSection;
@property   BOOL            m_bIsEditing;
- ( void )updateUI;


@end
