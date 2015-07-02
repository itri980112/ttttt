//
//  RHAssociationAddPostVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHAssociationAddPostVC.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"

@interface RHAssociationAddPostVC () < UITextFieldDelegate,
                                    UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
    NSString        *m_pstrAssoID;
    UIImage         *m_pMainImage;
}

@property ( nonatomic, retain ) NSString        *m_pstrAssoID;
@property ( nonatomic, retain ) UIImage         *m_pMainImage;
@end

@implementation RHAssociationAddPostVC
@synthesize m_pstrAssoID;
@synthesize m_pMainImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.m_pstrAssoID = @"";
        self.m_pMainImage = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.m_pLblTitle setText:NSLocalizedString(@"LE_GROUP_NEWARTICLE_TITLE", nil)];
    [self.m_pLblTitleType setText:NSLocalizedString(@"LE_GROUP_NEWARTICLE_TYPE", nil)];
    [self.m_pLblTitlePic setText:NSLocalizedString(@"LE_GROUP_NEWARTICLE_NEWPIC", nil)];
    [self.m_pBtnSend setTitle:NSLocalizedString(@"LE_COMMON_SEND", nil) forState:UIControlStateNormal];
    
    [self.m_pTFPurpose setPlaceholder:NSLocalizedString(@"LE_GROUP_NEWARTICLE_TYPEHINT", nil)];
    
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


#pragma mark - Public
- ( void )setupAssoID:( NSString * )pstrID
{
    if ( pstrID )
    {
        self.m_pstrAssoID = pstrID;
    }

}


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressDoneBtn:(id)sender
{

    if ( [[self.m_pTFPurpose text] compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        [RHAppDelegate MessageBox:NSLocalizedString(@"LE_GROUP_NEWARTICLE_POPUPHINT", nil)];
        return;
    }
    
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:m_pstrAssoID forKey:kAssoID];
    [pParameter setObject:[self.m_pTFPurpose text] forKey:kAssoSubject];
    [pParameter setObject:[self.m_pTVCnt text] forKey:kAssoContent];
    
    if ( m_pMainImage )
    {
        NSData *pImgData = UIImageJPEGRepresentation(m_pMainImage, 0.85f);
        [pParameter setObject:pImgData forKey:kAssoImage];
    }
    
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI newAssociationPost:pParameter Source:self];
    

}
- ( IBAction )presssChooseImageBtn:(id)sender
{
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


#pragma mark - API
- ( void )callBackNewAssociationPostStatus:( NSDictionary * )pStatusDic
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

@end
