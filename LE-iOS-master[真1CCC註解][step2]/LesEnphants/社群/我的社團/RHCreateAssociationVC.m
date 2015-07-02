//
//  RHCreateAssociationVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHCreateAssociationVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAssociationListCell.h"
#import "RHCreateAssociationPurposeVC.h"
#import "RHAssociationDefinition.h"

#define kStartTag       1000
#define kAreaTag        2000


@interface RHCreateAssociationVC () < UITextFieldDelegate, RHActionSheetDelegate,
                                        UIPickerViewDelegate, UIPickerViewDataSource,
                                    UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
    NSInteger       m_nSelStart;
    NSInteger       m_nSelChina;
    NSInteger       m_nSelCity;
    UIImage         *m_pMainImage;
    NSInteger       m_nSelClassify;
    NSString        *m_pstrPurpose;
}

@property ( nonatomic, retain ) UIImage         *m_pMainImage;
@property ( nonatomic, retain ) NSString        *m_pstrPurpose;
- ( void )updateUI;

@end

@implementation RHCreateAssociationVC
@synthesize m_pMainPicker;
@synthesize m_pMainPicker2;
@synthesize m_pMainImage;
@synthesize m_pRHCreateAssociationPurposeVC;
@synthesize m_pstrPurpose;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pMainPicker = nil;
        self.m_pMainPicker2 = nil;
        m_nSelStart = -1;
        m_nSelChina = -1;
        m_nSelCity = -1;
        self.m_pMainImage = nil;
        self.m_pRHCreateAssociationPurposeVC = nil;
        self.m_pstrPurpose = @"";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    [self.m_pBtnFinish setTitle:NSLocalizedString(@"LE_COMMON_FINISH", nil) forState:UIControlStateNormal];
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_GROUP_NEWASSO_TITLE", nil)];
    [self.m_pLblHint setText:NSLocalizedString(@"LE_GROUP_NEWASSO_HINT", nil)];
    [self.m_pTFName setPlaceholder:NSLocalizedString(@"LE_GROUP_NEWASSO_PLACEHOLD", nil)];
    [self.m_pLblStart setText:NSLocalizedString(@"LE_GROUP_NEWASSO_STAR", nil)];
    [self.m_pLblArea setText:NSLocalizedString(@"LE_GROUP_NEWASSO_AREA", nil)];
    [self.m_pLblPurpose setText:NSLocalizedString(@"LE_GROUP_NEWASSO_PURPOSE", nil)];
    [self.m_pLblUpload setText:NSLocalizedString(@"LE_GROUP_NEWASSO_UPLOAD", nil)];
    [self.m_pLblPublic setText:NSLocalizedString(@"LE_GROUP_NEWASSO_Public", nil)];
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
    if ( m_nSelStart >= 0 && m_nSelChina >= 0 )
    {
        NSString *pstrClassify = [NSString stringWithFormat:@"%@,%@",g_pstrStart[m_nSelStart], g_pstrChina[m_nSelChina]];
        [self.m_pLblClassify setText:pstrClassify];
    }
    
    if ( m_nSelCity >= 0 )
    {
        [self.m_pLblRegion setText:g_pstrCity[m_nSelCity]];
    }
}

- (void)closeBtnView
{
    [self.m_pTFName resignFirstResponder];
}

#pragma mark - Public

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressDoneBtn:(id)sender
{
    if ( [[self.m_pTFName text] compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        [RHAppDelegate MessageBox:@"請輸入社團名稱"];
        return;
    }
    
    if ( m_nSelStart <= 0 )
    {
        //[RHAppDelegate MessageBox:@"請設定星座與生肖"];
        //return;
    }
    
    if ( m_nSelCity <= 0 )
    {
        [RHAppDelegate MessageBox:@"請選擇地區"];
        return;
    }
    
    if ( m_nSelClassify <= 0 )
    {
        [RHAppDelegate MessageBox:@"請設定社團分類"];
        return;
    }
    
    if ( [m_pstrPurpose compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        [RHAppDelegate MessageBox:@"請設定社團宗旨"];
        return;
    }
    
    if ( m_pMainImage == nil )
    {
        [RHAppDelegate MessageBox:@"請設定圖片"];
        return;
    }
    
    NSDictionary *pDic = [[[RHAppDelegate sharedDelegate] getAssociationArray] objectAtIndex:m_nSelClassify];
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    //[pParameter setObject:[pDic objectForKey:@"id"] forKey:@"asid"];
    [pParameter setObject:g_pstrStart[m_nSelStart] forKey:kAssoSignStar];
    [pParameter setObject:g_pstrChina[m_nSelChina] forKey:kAssoSignChina];
    [pParameter setObject:@"2015-07-12" forKey:kExpectedDate];
    [pParameter setObject:g_pstrCity[m_nSelCity] forKey:kAssoCity];
    [pParameter setObject:[pDic objectForKey:@"id"] forKey:kAssoClass];
    [pParameter setObject:m_pstrPurpose forKey:kAssoPurpost];
    [pParameter setObject:[self.m_pTFName text] forKey:kAssoName];
    
    NSData *pImgData = UIImageJPEGRepresentation(m_pMainImage, 0.85f);
    [pParameter setObject:pImgData forKey:kAssoImage];
    
    NSString *pstrPrivate = @"1";
    if ( [self.m_pPrivateSwitch isOn])
    {
       pstrPrivate = @"0";
    }
    
    [pParameter setObject:pstrPrivate forKey:kAssoIsPrivate];
    
    
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI newAssociation:pParameter Source:self];
    
}


- ( IBAction )pressFunBtn1:(id)sender
{
    [self closeBtnView];
    
    //picker, 星座和生肖
    
    NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
    
    
    RHActionSheet *sheet = [[RHActionSheet alloc] initWithTitle: title
                                                       delegate: self
                                              cancelButtonTitle: @"確定"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet showInView: [[RHAppDelegate sharedDelegate] window]];
    sheet.tag = kStartTag;
    
    if ( m_pMainPicker == nil )
    {
        self.m_pMainPicker = [[UIPickerView alloc] initWithFrame: CGRectMake(0,0, 320, 216)];
        m_pMainPicker.tag = kStartTag;
        m_pMainPicker.delegate = self;
        m_pMainPicker.dataSource = self;
    }
    
    [sheet addSubview: self.m_pMainPicker];

}
- ( IBAction )pressFunBtn2:(id)sender
{
    [self closeBtnView];

    //City
    
    NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
    
    
    RHActionSheet *sheet = [[RHActionSheet alloc] initWithTitle: title
                                                       delegate: self
                                              cancelButtonTitle: @"確定"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet showInView: [[RHAppDelegate sharedDelegate] window]];
    sheet.tag = kAreaTag;
    
    if ( m_pMainPicker2 == nil )
    {
        self.m_pMainPicker2 = [[UIPickerView alloc] initWithFrame: CGRectMake(0,0, 320, 216)];
        m_pMainPicker2.tag = kAreaTag;
        m_pMainPicker2.delegate = self;
        m_pMainPicker2.dataSource = self;
    }
    
    [sheet addSubview: self.m_pMainPicker2];
}
- ( IBAction )pressFunBtn3:(id)sender
{
    [self closeBtnView];

    //進下一頁，社團分類和宗旨
    
    self.m_pRHCreateAssociationPurposeVC = [[RHCreateAssociationPurposeVC alloc] initWithNibName:@"RHCreateAssociationPurposeVC" bundle:nil];
    [m_pRHCreateAssociationPurposeVC setDelegate:self];
    [self.navigationController pushViewController:m_pRHCreateAssociationPurposeVC animated:YES];
    
}
- ( IBAction )pressFunBtn4:(id)sender
{
    [self closeBtnView];

    //選圖
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePicker animated:YES completion:nil];
}



#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - API
- ( void )callBackNewAssociationByClassStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

#pragma mark - UIPickerView Delegate & DataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pstrTitle = @"";
    
    if ( pickerView.tag == kStartTag )
    {
        if ( component == 0 )
        {
            pstrTitle = g_pstrStart[row];
        }
        else
        {
            pstrTitle = g_pstrChina[row];
        }
    }
    else
    {
        pstrTitle = g_pstrCity[row];
    }
    
    return pstrTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ( pickerView.tag == kStartTag )
    {
        if ( component == 0 )
        {
            m_nSelStart = row;
        }
        else
        {
            m_nSelChina = row;
        }
    }
    else
    {
        m_nSelCity = row;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger nCount = 0;
    if ( pickerView.tag == kStartTag )
    {
        nCount = 2;
    }
    else
    {
        nCount = 1;
    }
    
    return nCount;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger nCount = 0;
    if ( pickerView.tag == kStartTag )
    {
        nCount = sizeof(g_pstrStart) / sizeof(g_pstrStart[0]);
    }
    else
    {
        nCount = sizeof(g_pstrCity) / sizeof(g_pstrCity[0]);
    }
    
    return nCount;
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self updateUI];
}

#pragma mark - Image Picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSString *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSLog(@"info:%@",[info description]);
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSLog(@"Edit image:%@",NSStringFromCGSize(image.size));
        self.m_pMainImage = image;
    
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RHCreateAssociationPurposeVC Delegate
- ( void )callBackSelClassID:( NSInteger )nID Purpose:( NSString * )pstrPurpose
{
    m_nSelClassify = nID;
    self.m_pstrPurpose = pstrPurpose;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISwitch action

- (IBAction)switchChangeValue:(id)sender {
    
    UISwitch *m_switch = (UISwitch *)sender;
    
    if (m_switch.on) {
        self.m_pImgPublic.image = [UIImage imageNamed:@"06公開設定.png"];
        self.m_pLblPublic.text = @"公開";
    }
    else {
        self.m_pImgPublic.image = [UIImage imageNamed:@"06非公開設定.png"];
        self.m_pLblPublic.text = @"非公開";
    }
}

@end
