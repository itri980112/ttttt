//
//  RHCreateAssociationVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHActionSheet.h"

@class RHCreateAssociationPurposeVC;
@interface RHCreateAssociationVC : UIViewController
{
    UIPickerView                    *m_pMainPicker;
    UIPickerView                    *m_pMainPicker2;
    RHCreateAssociationPurposeVC    *m_pRHCreateAssociationPurposeVC;
}

@property (strong, nonatomic) UIPickerView                      *m_pMainPicker;
@property (strong, nonatomic) UIPickerView                      *m_pMainPicker2;
@property (strong, nonatomic) RHCreateAssociationPurposeVC      *m_pRHCreateAssociationPurposeVC;
@property (strong, nonatomic) IBOutlet UILabel                  *m_pLblClassify;
@property (strong, nonatomic) IBOutlet UILabel                  *m_pLblRegion;
@property (strong, nonatomic) IBOutlet UITextField              *m_pTFName;
@property (strong, nonatomic) IBOutlet UISwitch                 *m_pPrivateSwitch;
@property (strong, nonatomic) IBOutlet UIButton                 *m_pBtnFinish;

@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblHint;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblStart;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblArea;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblPurpose;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblUpload;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblPublic;

@property (strong, nonatomic) IBOutlet UIImageView *m_pImgPublic;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressDoneBtn:(id)sender;
- ( IBAction )pressFunBtn1:(id)sender;
- ( IBAction )pressFunBtn2:(id)sender;
- ( IBAction )pressFunBtn3:(id)sender;
- ( IBAction )pressFunBtn4:(id)sender;




#pragma mark - Public


@end
