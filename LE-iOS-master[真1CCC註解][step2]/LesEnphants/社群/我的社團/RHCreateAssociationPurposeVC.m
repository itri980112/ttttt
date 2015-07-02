//
//  RHCreateAssociationVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHCreateAssociationPurposeVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAssociationListCell.h"

@interface RHCreateAssociationPurposeVC () < UITextFieldDelegate, RHActionSheetDelegate,
                                        UIPickerViewDelegate, UIPickerViewDataSource,
                                    UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{

}


- ( void )updateUI;

@end

@implementation RHCreateAssociationPurposeVC
@synthesize m_pMainPicker;
@synthesize delegate;
@synthesize m_pstrPurpose;
@synthesize m_nSelClass;
@synthesize m_bReadOnly;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pMainPicker = nil;
        m_nSelClass = -1;
        self.m_pstrPurpose = @"";
        m_bReadOnly = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.m_pLblTitle setText:NSLocalizedString(@"LE_GROUP_PURPOSE_TITLE", nil)];
    [self.m_pLblTYpe setText:NSLocalizedString(@"LE_GROUP_PURPOSE_TYPE", nil)];
    [self.m_pLblCLassify setText:NSLocalizedString(@"LE_GROUP_PURPOSE_CHOOSE", nil)];
    [self.m_pLblPurpose setText:NSLocalizedString(@"LE_GROUP_PURPOSE_PURPOSE", nil)];
    [self.m_pBtnFinish setTitle:NSLocalizedString(@"LE_COMMON_FINISH", nil) forState:UIControlStateNormal];
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - Private Methods
- ( void )updateUI
{
    
    [self.m_pTFPurpose setUserInteractionEnabled:!m_bReadOnly];
    
    [self.m_pBtnFinish setHidden:m_bReadOnly];
    [self.m_pTFPurpose setText:m_pstrPurpose];

    if ( m_nSelClass >= 0 )
    {
        NSDictionary *pDic = [[[RHAppDelegate sharedDelegate] getAssociationArray] objectAtIndex:m_nSelClass];
        [self.m_pLblCLassify setText:[pDic objectForKey:@"name"]];
    }
}

#pragma mark - Public
- ( void )setupInitailValue:( NSInteger )nID Purpose:( NSString * )pstrPurpose
{
    m_nSelClass = nID;
    self.m_pstrPurpose = pstrPurpose;
}
#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressDoneBtn:(id)sender
{
    if ( m_nSelClass == -1 )
    {
        [RHAppDelegate MessageBox:@"請選擇分類"];
        return;
    }
    
    
    if ( [[self.m_pTFPurpose text] compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        [RHAppDelegate MessageBox:@"請輸入社團宗旨"];
        return;
    }
    
    
    if ( delegate && [delegate respondsToSelector:@selector(callBackSelClassID:Purpose:)] )
    {
        [delegate callBackSelClassID:m_nSelClass Purpose:[self.m_pTFPurpose text]];
    }
}

- ( IBAction )pressClassifyBtn:(id)sender
{
    if ( m_bReadOnly )
    {
        return;
    }
    //picker, 星座和生肖
    
    NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
    
    
    RHActionSheet *sheet = [[RHActionSheet alloc] initWithTitle: title
                                                       delegate: self
                                              cancelButtonTitle: @"確定"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet showInView: [[RHAppDelegate sharedDelegate] window]];
    
    if ( m_pMainPicker == nil )
    {
        self.m_pMainPicker = [[UIPickerView alloc] initWithFrame: CGRectMake(0,0, 320, 216)];
        m_pMainPicker.delegate = self;
        m_pMainPicker.dataSource = self;
    }
    
    [sheet addSubview: self.m_pMainPicker];

}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - API


#pragma mark - UIPickerView Delegate & DataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pstrTitle = @"";
    
    NSDictionary *pDic = [[[RHAppDelegate sharedDelegate] getAssociationArray] objectAtIndex:row];
    pstrTitle = [pDic objectForKey:@"name"];
    
    return pstrTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    m_nSelClass = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger nCount = [[[RHAppDelegate sharedDelegate] getAssociationArray] count];
    
    return nCount;
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self updateUI];
}
@end
