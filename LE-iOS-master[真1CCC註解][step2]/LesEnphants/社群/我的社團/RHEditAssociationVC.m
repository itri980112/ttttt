//
//  RHCreateAssociationVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHEditAssociationVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAssociationListCell.h"
#import "RHCreateAssociationPurposeVC.h"
#import "RHAssociationDefinition.h"
#import "RHAssoMemberMnanageVC.h"
@interface RHEditAssociationVC () < UITextFieldDelegate, RHCreateAssociationPurposeVCDelegate,
                                    UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
    UIImage         *m_pMainImage;
    NSInteger       m_nSelClassify;
    NSString        *m_pstrPurpose;
}

@property ( nonatomic, retain ) UIImage         *m_pMainImage;
@property ( nonatomic, retain ) NSString        *m_pstrPurpose;
- ( void )updateUI;

@end

@implementation RHEditAssociationVC
@synthesize m_pMainImage;
@synthesize m_pRHCreateAssociationPurposeVC;
@synthesize m_pstrPurpose;
@synthesize m_pOldMetaDataDic;
@synthesize m_pRHAssoMemberMnanageVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pMainImage = nil;
        self.m_pRHCreateAssociationPurposeVC = nil;
        self.m_pstrPurpose = @"";
        self.m_pOldMetaDataDic = nil;
        self.m_pRHAssoMemberMnanageVC = nil;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_GROUP_EDITINFO_TITLE", nil)];
    [self.m_pLblHint setText:NSLocalizedString(@"LE_GROUP_EDITINFO_HINT", nil)];
    [self.m_pLblStartTitle setText:NSLocalizedString(@"LE_GROUP_EDITINFO_START", nil)];
    [self.m_pLblAreaTitle setText:NSLocalizedString(@"LE_GROUP_EDITINFO_AREA", nil)];
    [self.m_pLblPurposeTItle setText:NSLocalizedString(@"LE_GROUP_EDITINFO_PURPOSE", nil)];
    [self.m_pLblUploadImageTItle setText:NSLocalizedString(@"LE_GROUP_EDITINFO_UPLOAD", nil)];
    [self.m_pLblPublicTitle setText:NSLocalizedString(@"LE_GROUP_EDITINFO_PUBLIC", nil)];
    [self.m_pLblManagementTitle setText:NSLocalizedString(@"LE_GROUP_EDITINFO_MANAGEMENT", nil)];
    [self.m_pBtnFinish setTitle:NSLocalizedString(@"LE_COMMON_FINISH", nil) forState:UIControlStateNormal];
    
    
    // Do any additional setup after loading the view from its nib.

    self.m_pstrPurpose = [m_pOldMetaDataDic objectForKey:@"purpose"];
    
    NSString *pstrClassify = [NSString stringWithFormat:@"%@, %@", [m_pOldMetaDataDic objectForKey:@"signStar"], [m_pOldMetaDataDic objectForKey:@"signChina"]];
    
    [self.m_pLblClassify setText:pstrClassify];
    [self.m_pLblRegion setText:[m_pOldMetaDataDic objectForKey:@"city"]];
    m_nSelClassify = [[m_pOldMetaDataDic objectForKey:@"class"] integerValue];
    
    
    BOOL bIsPrivate = [[m_pOldMetaDataDic objectForKey:@"isPrivate"] boolValue];
    
    [self.m_pPrivateSwitch setOn:!bIsPrivate];
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

}

#pragma mark - Public

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressDoneBtn:(id)sender
{
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:[m_pOldMetaDataDic objectForKey:@"id"] forKey:kAssoASID];
    [pParameter setObject:[m_pOldMetaDataDic objectForKey:@"signStar"] forKey:kAssoSignStar];
    [pParameter setObject:[m_pOldMetaDataDic objectForKey:@"signChina"] forKey:kAssoSignChina];
    [pParameter setObject:@"2015-07-12" forKey:kExpectedDate];
    [pParameter setObject:[m_pOldMetaDataDic objectForKey:@"city"] forKey:kAssoCity];
    [pParameter setObject:[m_pOldMetaDataDic objectForKey:@"class"] forKey:kAssoClass];
    [pParameter setObject:m_pstrPurpose forKey:kAssoPurpost];
    [pParameter setObject:[m_pOldMetaDataDic objectForKey:@"name"] forKey:kAssoName];
    
    if ( m_pMainImage )
    {
        NSData *pImgData = UIImageJPEGRepresentation(m_pMainImage, 0.85f);
        [pParameter setObject:pImgData forKey:kAssoImage];
    }

    NSString *pstrPrivate = @"1";
    if ( [self.m_pPrivateSwitch isOn])
    {
       pstrPrivate = @"0";
    }
    
    [pParameter setObject:pstrPrivate forKey:kAssoIsPrivate];
    
    
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI updateAssociation:pParameter Source:self];
    
}


- ( IBAction )pressFunBtn1:(id)sender
{
    //進下一頁，社團分類和宗旨
    
    self.m_pRHCreateAssociationPurposeVC = [[RHCreateAssociationPurposeVC alloc] initWithNibName:@"RHCreateAssociationPurposeVC" bundle:nil];
    [m_pRHCreateAssociationPurposeVC setDelegate:self];
    [m_pRHCreateAssociationPurposeVC setM_pstrPurpose:self.m_pstrPurpose];
    [m_pRHCreateAssociationPurposeVC setM_nSelClass:m_nSelClassify];
    [self.navigationController pushViewController:m_pRHCreateAssociationPurposeVC animated:YES];
    
}
- ( IBAction )pressFunBtn2:(id)sender
{
    //選圖
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- ( IBAction )pressFunBtn3:(id)sender
{
    //管理人數
    self.m_pRHAssoMemberMnanageVC = [[RHAssoMemberMnanageVC  alloc] initWithNibName:@"RHAssoMemberMnanageVC" bundle:nil];
    [m_pRHAssoMemberMnanageVC setupAssoID:[m_pOldMetaDataDic objectForKey:@"id"]];
    [self.navigationController pushViewController:m_pRHAssoMemberMnanageVC animated:YES];
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - API
- ( void )callBackUpdateAssociationByClassStatus:( NSDictionary * )pStatusDic
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
        self.m_pLblPublicTitle.text = @"公開";
    }
    else {
        self.m_pImgPublic.image = [UIImage imageNamed:@"06非公開設定.png"];
        self.m_pLblPublicTitle.text = @"非公開";
    }
}

@end
