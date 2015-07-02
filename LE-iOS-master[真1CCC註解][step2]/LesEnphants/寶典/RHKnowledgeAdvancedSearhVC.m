//
//  RHKnowledgeAdvancedSearhVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/24.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHKnowledgeAdvancedSearhVC.h"
#import "RHAppDelegate.h"
#import "RHActionSheet.h"


@interface RHKnowledgeAdvancedSearhVC () < UIPickerViewDataSource, UIPickerViewDelegate, RHActionSheetDelegate >
{
    NSInteger       m_nType;
    NSMutableArray      *m_pPstrType;
}

@property ( nonatomic, retain ) NSMutableArray      *m_pPstrType;

@end

@implementation RHKnowledgeAdvancedSearhVC
@synthesize m_pPicker;
@synthesize delegate;
@synthesize m_pPstrType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pPicker = nil;
        m_nType = 0;
        self.m_pPstrType = [NSMutableArray arrayWithCapacity:1];
        [m_pPstrType addObject:NSLocalizedString(@"LE_KNOWLEDGE_PEOPLE1", nil)];
        [m_pPstrType addObject:NSLocalizedString(@"LE_KNOWLEDGE_PEOPLE2", nil)];
        [m_pPstrType addObject:NSLocalizedString(@"LE_KNOWLEDGE_PEOPLE3", nil)];
        [m_pPstrType addObject:NSLocalizedString(@"LE_KNOWLEDGE_PEOPLE4", nil)];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"", nil)];
    [self.m_pLblHint setText:NSLocalizedString(@"", nil)];
    [self.m_pLblKeyWordSearchTitle setText:NSLocalizedString(@"", nil)];
    [self.m_pLblWeek setText:NSLocalizedString(@"", nil)];
    [self.m_pLblPeople setText:NSLocalizedString(@"", nil)];
    
    
    [self.m_pBtnType setTitle:m_pPstrType[m_nType] forState:UIControlStateNormal];
    

    [self.m_pBtnPrev setEnabled:NO];
    [self.m_pBtnNext setEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- ( void )dealloc
{

    [m_pPicker release];
    [_m_pbtnWeek release];
    [_m_pBtnType release];
    [_m_pBtnPrev release];
    [_m_pBtnNext release];
    [_m_pTFKeyword release];
    [super dealloc];
}

#pragma mark - Private Methods


#pragma mark - Customized Methods


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressWeekBtn:(id)sender
{
    m_nSelTag = 0;
    
    NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
    
    RHActionSheet *sheet = [[RHActionSheet alloc] initWithTitle: title
                                                       delegate: self
                                              cancelButtonTitle: @"確定"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet showInView: [[RHAppDelegate sharedDelegate] window]];
    [sheet release];
    
    //if (self.m_pPicker == nil)
    {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0,0, 320, 216)];
        picker.delegate = self;
        picker.showsSelectionIndicator = YES;
        picker.dataSource = self;
        self.m_pPicker = picker;
        [picker release];
    }
    
    //[m_pPicker selectRow:m_nSelTypeIdx inComponent:0 animated:NO];
    
    
    [sheet addSubview: self.m_pPicker];
    [self.m_pPicker reloadAllComponents];
}

- ( IBAction )pressTypeBtn:(id)sender
{
    m_nSelTag = 1;
    
    NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
    
    RHActionSheet *sheet = [[RHActionSheet alloc] initWithTitle: title
                                                       delegate: self
                                              cancelButtonTitle: @"確定"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet showInView: [[RHAppDelegate sharedDelegate] window]];
    [sheet release];
    //if (self.m_pPicker == nil)
    {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0,0, 320, 216)];
        picker.delegate = self;
        picker.showsSelectionIndicator = YES;
        picker.dataSource = self;
        self.m_pPicker = picker;
        [picker release];
    }
    
    //[m_pPicker selectRow:m_nSelTypeIdx inComponent:0 animated:NO];
    
    
    [sheet addSubview: self.m_pPicker];
    [self.m_pPicker reloadAllComponents];
}

- ( IBAction )pressSearchBtn:(id)sender
{
    //[身份，week，keyword]
    
    NSString *pstrFilter = @"[";
    
    pstrFilter = [pstrFilter stringByAppendingFormat:@"%ld,", (long)m_nType];
    //m_nSelWeek
    pstrFilter = [pstrFilter stringByAppendingFormat:@"%ld", (long)m_nSelWeek];
    
    NSString *pstrKeyword = [self.m_pTFKeyword text];
    NSInteger nFilter = 0;
    if ( [pstrKeyword compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        //沒填keyword
        pstrFilter = [pstrFilter stringByAppendingString:@"]"];
        nFilter = 3;//search by loginType and weeks
    }
    else
    {
        pstrFilter = [pstrFilter stringByAppendingFormat:@",\"%@\"]", pstrKeyword];
        nFilter = 4;//search by loginType and weeks and keyword
    }
    
    NSLog(@"Filter = %@", pstrFilter);
    
    if ( delegate && [delegate respondsToSelector:@selector(callBackSearchFilter:Filter:)])
    {
        [delegate callBackSearchFilter:pstrFilter Filter:nFilter];
    }
}


- ( IBAction )pressPrevBtn:(id)sender
{
    m_nType--;
    
    [self.m_pBtnType setTitle:m_pPstrType[m_nType] forState:UIControlStateNormal];
    
    if ( m_nType == 0 )
    {
        [self.m_pBtnPrev setEnabled:NO];
        [self.m_pBtnNext setEnabled:YES];
    }
}

- ( IBAction )pressNextBtn:(id)sender
{
    m_nType++;
    
    [self.m_pBtnType setTitle:m_pPstrType[m_nType] forState:UIControlStateNormal];
    
    if ( m_nType == 3 )
    {
        [self.m_pBtnPrev setEnabled:YES];
        [self.m_pBtnNext setEnabled:NO];
    }
}

#pragma mark - UIPickerView Delegate & DataSource
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger nCount = 0;
    
    switch ( m_nSelTag )
    {
        case 0:
        {
            nCount = 46;
        }
            break;
        default:
            break;
    }
    
    return nCount;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch ( m_nSelTag )
    {
        case 0:
        {
            return  [NSString stringWithFormat:@"第%d週", row];
        }
            break;
        case 1:
        {
            return  m_pPstrType[row];
        }
            break;
            
        default:
            break;
    }
    
    return @"Error";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch ( m_nSelTag )
    {
        case 0:
        {
            m_nSelWeek = row;
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( m_nSelWeek == 0 )
    {
        [self.m_pbtnWeek setTitle:@"無" forState:UIControlStateNormal];
    }
    else
    {
        [self.m_pbtnWeek setTitle:[NSString stringWithFormat:@"第%d週", m_nSelWeek] forState:UIControlStateNormal];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textField -> %ld", (long)textField.tag);
    
    
    [textField resignFirstResponder];
    
    return YES;
    
}



@end
