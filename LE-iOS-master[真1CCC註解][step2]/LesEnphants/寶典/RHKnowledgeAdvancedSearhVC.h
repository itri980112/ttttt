//
//  RHKnowledgeAdvancedSearhVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/24.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RHKnowledgeAdvancedSearhVCDelegate <NSObject>

@optional
- ( void )callBackSearchFilter:( NSString * )pstrJSON Filter:( NSInteger )nFilter;

@end

@interface RHKnowledgeAdvancedSearhVC : UIViewController
{
    id<RHKnowledgeAdvancedSearhVCDelegate>  delegate;
    NSInteger           m_nSelTag;
    UIPickerView        *m_pPicker;
    NSInteger           m_nSelWeek;
    NSInteger           m_nSelType;
}

@property ( nonatomic ,retain ) id<RHKnowledgeAdvancedSearhVCDelegate>  delegate;
@property ( nonatomic ,retain ) UIPickerView        *m_pPicker;
@property (retain, nonatomic) IBOutlet UIButton *m_pbtnWeek;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnType;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnPrev;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnNext;
@property (retain, nonatomic) IBOutlet UITextField *m_pTFKeyword;

@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblKeyWordSearchTitle;

@property (strong, nonatomic) IBOutlet UILabel *m_pLblHint;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblWeek;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblPeople;



#pragma mark - Customized Methods


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender;
- ( IBAction )pressWeekBtn:(id)sender;
- ( IBAction )pressTypeBtn:(id)sender;
- ( IBAction )pressSearchBtn:(id)sender;
- ( IBAction )pressPrevBtn:(id)sender;
- ( IBAction )pressNextBtn:(id)sender;
@end
