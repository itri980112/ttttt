//
//  RHCreateAssociationPurposeVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHActionSheet.h"

@protocol RHCreateAssociationPurposeVCDelegate <NSObject>

@optional
- ( void )callBackSelClassID:( NSInteger )nID Purpose:( NSString * )pstrPurpose;

@end

@interface RHCreateAssociationPurposeVC : UIViewController
{
    UIPickerView        *m_pMainPicker;
    NSInteger       m_nSelClass;
    NSString        *m_pstrPurpose;
    BOOL            m_bReadOnly;
}

@property   NSInteger       m_nSelClass;
@property   BOOL            m_bReadOnly;
@property ( nonatomic, retain ) NSString        *m_pstrPurpose;
@property ( assign, nonatomic ) id< RHCreateAssociationPurposeVCDelegate >  delegate;
@property (strong, nonatomic) UIPickerView        *m_pMainPicker;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblCLassify;
@property (strong, nonatomic) IBOutlet UITextField *m_pTFPurpose;
@property (strong, nonatomic) IBOutlet UIButton                 *m_pBtnFinish;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblTYpe;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblPurpose;




#pragma mark - Public
- ( void )setupInitailValue:( NSInteger )nID Purpose:( NSString * )pstrPurpose;

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressDoneBtn:(id)sender;
- ( IBAction )pressClassifyBtn:(id)sender;


@end
