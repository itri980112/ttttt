//
//  RHGroupVC.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RHMyAssociationVC;
@class RHCreateAssociationVC;
@class RHAssociationPostListVC;

@interface RHGroupVC : UIViewController
{
    RHMyAssociationVC           *m_pRHMyAssociationVC;
    RHCreateAssociationVC       *m_pRHCreateAssociationVC;
    RHAssociationPostListVC     *m_pRHAssociationPostListVC;
    
    NSInteger                   m_nCityIdx;
    NSInteger                   m_nStarIdx;
    NSInteger                   m_nChinaIdx;
    
    UIPickerView                    *m_pMainPicker;
    UIPickerView                    *m_pMainPicker2;
    
    NSMutableArray         *m_pCreatedArray;
    NSMutableArray         *m_pJoinedArray;
    
}

@property (retain, nonatomic) UIPickerView                    *m_pMainPicker;
@property (retain, nonatomic) UIPickerView                    *m_pMainPicker2;
@property (retain, nonatomic) RHMyAssociationVC             *m_pRHMyAssociationVC;
@property (retain, nonatomic) RHCreateAssociationVC         *m_pRHCreateAssociationVC;
@property (retain, nonatomic) RHAssociationPostListVC       *m_pRHAssociationPostListVC;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnMenu;
@property (retain, nonatomic) IBOutlet UIView *m_pNaviBar;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab1;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab2;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab3;
@property (retain, nonatomic) IBOutlet UIButton *m_pBtnTab4;
@property (strong, nonatomic) IBOutlet UITableView *m_pAssociationListTable;
@property (strong, nonatomic) IBOutlet UIView *m_pCntView;

//SearchView
@property (strong, nonatomic) IBOutlet UIView *m_pSearchView;
@property (strong, nonatomic) IBOutlet UITextField *m_pTFKeyword;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnCity;
@property (strong, nonatomic) IBOutlet UIButton *m_pBtnType;

@property (strong, nonatomic) IBOutlet UILabel *m_pLblTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblBtn1;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblBtn2;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblBtn3;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblBtn4;

@property (strong, nonatomic) IBOutlet UILabel *m_pLblKeywordTItle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblStarTitle;
@property (strong, nonatomic) IBOutlet UILabel *m_pLblAreaTitle;

//MyGroup
@property (strong, nonatomic) IBOutlet UITableView          *m_pGCreatedTable;
@property (strong, nonatomic) IBOutlet UITableView          *m_pGJoinedTable;
@property (strong, nonatomic) IBOutlet UIScrollView         *m_pGMainScrollView;
@property (strong, nonatomic) IBOutlet UIView               *m_pGCreatedView;
@property (strong, nonatomic) IBOutlet UIView               *m_pGJoinedView;

@property (strong, nonatomic) IBOutlet UILabel *m_pGLblMine;
@property (strong, nonatomic) IBOutlet UILabel *m_pGLblJoin;


#pragma mark - IBAction
- ( IBAction )pressTab1:(id)sender;
- ( IBAction )pressTab2:(id)sender;
- ( IBAction )pressTab3:(id)sender;
- ( IBAction )pressTab4:(id)sender;
- ( IBAction )pressMyAssociationBtn:(id)sender;
- ( IBAction )pressMyAuthorityBtn:(id)sender;

- ( IBAction )pressCityBtn:(id)sender;
- ( IBAction )pressTypeBtn:(id)sender;
- ( IBAction )pressSearchBtn:(id)sender;
- ( IBAction )pressAddBtn:(id)sender;

@end
