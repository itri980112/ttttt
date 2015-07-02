//
//  RHAssociationAddPostVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHAssociationAddPostVC : UIViewController
{

}


@property (strong, nonatomic) IBOutlet UITextField      *m_pTFPurpose;
@property (strong, nonatomic) IBOutlet UITextView       *m_pTVCnt;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnSend;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitleType;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitlePic;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;

#pragma mark - Public 
- ( void )setupAssoID:( NSString * )pstrID;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressDoneBtn:(id)sender;
- ( IBAction )presssChooseImageBtn:(id)sender;


@end
