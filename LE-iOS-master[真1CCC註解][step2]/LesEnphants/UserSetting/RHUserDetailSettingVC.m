//
//  RHUserDetailSettingVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/18.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHUserDetailSettingVC.h"
#import "RHAppDelegate.h"
#import "Utilities.h"
#import "RHProfileObj.h"
#import "MBProgressHUD.h"
#import "RHLesEnphantsAPI.h"
#import "AsyncImageView.h"
#import "RHPointCollection.h"
#import "RHBgSelectionVC.h"
#import "RHMyIdEditVC.h"
#import "RHPromotePeopleEditVC.h"
#import "RHInfoVC.h"
#import "UIImage+RoundedCorner.h"
#import "RHMyNicknameEditVC.h"
#import "RHMyBirthdayEditVC.h"
#import "RHMyExpectedDateEditVC.h"
#import "GoldCoinAnimationVC.h"

static    NSString   *g_MenuTitle[8] = {@"暱稱", @"註冊",@"生日",@"預產期",@"我的ID",@"推薦人/店櫃ID",@"更換大頭貼",@"更換背景圖"};
static    NSString   *g_MenuTitle2[6] = {@"暱稱", @"註冊",@"我的ID",@"推薦人/店櫃ID",@"更換大頭貼",@"更換背景圖"};
static    NSString   *g_MenuTitle3[7] = {@"暱稱", @"註冊",@"生日",@"我的ID",@"推薦人/店櫃ID",@"更換大頭貼",@"更換背景圖"};
@interface RHUserDetailSettingVC () < UIImagePickerControllerDelegate, UINavigationControllerDelegate, RHLesEnphantsAPIDelegate >
{
    RHProfileObj *m_pProfileObj;
}
@property ( nonatomic, retain ) RHProfileObj *m_pProfileObj;

- ( void )uploadUserIcon:( UIImage * )pImg;
- ( void )updateUserIcon;

@end

@implementation RHUserDetailSettingVC
@synthesize m_pMBProgressHUD;
@synthesize m_pRHPointCollection;
@synthesize m_pProfileObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pMBProgressHUD = nil;
        self.m_pRHPointCollection = nil;
        self.m_pProfileObj = nil;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.m_pProfileObj = [RHProfileObj getProfile];
    [self.m_pMainTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_MYDATA_TITLE", nil)];
    
    [Utilities setRoundCornor:self.m_pIconImgView];
    
    //Load User Profile
    self.m_pProfileObj = [RHProfileObj getProfile];
    

    if ( m_pProfileObj )
    {
        NSString *pstrURL = m_pProfileObj.m_pstrPhotoURL;
        
        if ( [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            AsyncImageView *pAsyncImg = [[[AsyncImageView alloc] initWithFrame:self.m_pIconImgView.bounds] autorelease];
            [self.m_pIconImgView addSubview:pAsyncImg];
            [pAsyncImg setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [pAsyncImg loadImageFromURL:[NSURL URLWithString:m_pProfileObj.m_pstrPhotoURL]];
        }
        else
        {
            if ( m_pProfileObj.m_nType == 1 )
            {
                [self.m_pIconImgView setImage:[UIImage imageNamed:@"default_mom"]];
            }
            else if ( m_pProfileObj .m_nType == 2 )
            {
                [self.m_pIconImgView setImage:[UIImage imageNamed:@"default_dad"]];
            }
            else if ( m_pProfileObj.m_nType == 0 )
            {
                [self.m_pIconImgView setImage:[UIImage imageNamed:@"default_mom"]];
            }
            else
            {
                [self.m_pIconImgView setImage:[UIImage imageNamed:@"default_others"]];
            }
        }
        
        
        if ( m_pProfileObj.m_nType == 0 )
        {
            //Guest
            [self.m_pBtnQuestion setHidden:NO];
            [self.m_pLblPair setHidden:YES];
            [self.m_pBtnPoint setHidden:NO];
            [self.m_pBtnPoint setEnabled:NO];
            [self.m_pIcon1 setHidden:NO];
        }
        
        if ( m_pProfileObj.m_nType == 1 )
        {
            //Mom
            [self.m_pBtnQuestion setHidden:YES];
            [self.m_pLblPair setHidden:YES];
            [self.m_pBtnPoint setHidden:NO];
            [self.m_pBtnPoint setEnabled:YES];
            [self.m_pIcon1 setHidden:NO];
        }
        
        if ( m_pProfileObj.m_nType == 4 )
        {
            //Other
            [self.m_pBtnQuestion setHidden:YES];
            [self.m_pLblPair setHidden:YES];
            [self.m_pBtnPoint setHidden:YES];
            [self.m_pBtnPoint setEnabled:YES];
            [self.m_pIcon1 setHidden:YES];
        }
        
        if ( m_pProfileObj.m_nType == 2 )
        {
            //Dad
            [self.m_pBtnQuestion setHidden:YES];
            [self.m_pLblPair setHidden:NO];
            [self.m_pBtnPoint setHidden:YES];
            [self.m_pIcon1 setHidden:YES];
            
            NSArray *pFriends = m_pProfileObj.m_pFriendsArray;
            
            for ( NSInteger i = 0; i < [pFriends count]; ++i )
            {
                NSDictionary *pDic = [pFriends objectAtIndex:i];
                NSInteger nType = [[pDic objectForKey:@"type"] integerValue];
                
                if ( nType == 1 )
                {
                    //配對的媽咪
                    NSString *pstr = [NSString stringWithFormat:@"配對的孕媽咪:%@", [pDic objectForKey:@"nickname"]];
                    [self.m_pLblPair setText:pstr];
                }
            }
            
        }
        
        
    }


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //退出設定時，就通知更新資料
    [[NSNotificationCenter defaultCenter] postNotificationName:kMenuViewReveal object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    [_m_pIconImgView release];
    [_m_pLblID release];
    [_m_pLblPhone release];
    [_m_pLblNickname release];
    [_m_pLblBirthday release];
    [_m_pLblPregnantDate release];
    [_m_pLblRegister release];
    [_m_pLblTitle release];
    [m_pMBProgressHUD release];
    [m_pRHPointCollection release];
    [_m_pIcon1 release];
    [_m_pBtnPoint release];
    [_m_pBtnQuestion release];
    [_m_pLblPair release];
    [super dealloc];
}

#pragma mark - Customized Methods


#pragma mark - Private Methods
- ( void )uploadUserIcon:( UIImage * )pImg
{
    //maybe resize
    
    UIImage *pCorpImage = [pImg makeRoundCropImage:pImg];
    
    //NSData *pImgData = UIImageJPEGRepresentation(pCorpImage, 1.0f);
    NSData *pImgData = UIImagePNGRepresentation(pCorpImage);
    //upload
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:pImgData forKey:@"photo"];

    [RHLesEnphantsAPI setuserPhoto:pParameter Source:self];
    
}

- ( void )updateUserIcon
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj )
    {
        NSString *pstrURL = pObj.m_pstrPhotoURL;
        
        if ( [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
        {
            AsyncImageView *pAsyncImg = [[[AsyncImageView alloc] initWithFrame:self.m_pIconImgView.bounds] autorelease];
            [self.m_pIconImgView addSubview:pAsyncImg];
            [pAsyncImg setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [pAsyncImg loadImageFromURL:[NSURL URLWithString:pObj.m_pstrPhotoURL]];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeUserIcon object:nil];
}

#pragma mark - ShowAnimation
- (void)showAnimation:(NSInteger)point
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType != 1 ) return;
    
    // 得到金幣,顯示動畫
    if (point >= kShowAnimationMinimumPoint) {
        GoldCoinAnimationVC *vc = nil;
        if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC~ipad" bundle:nil];
        }
        else {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC" bundle:nil];
        }
        
        vc.m_getPoint = point;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:^{
            [vc startAnimation];
        }];
    }
}

#pragma mark - IBAction
- ( IBAction )pressBacnBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- ( IBAction )pressChangeIconBtn:(id)sender
{
    
    m_enmuImageChoice = RH_CHOOSE_IMAGE_ICON;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePicker animated:YES completion:nil];

}
- ( IBAction )pressChangeBackgroundBtn:(id)sender
{
    m_enmuImageChoice = RH_CHOOSE_IMAGE_BG;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];

}

- ( IBAction )pressPromoteBtn:(id)sender
{
    NSString *postText = @"下載app, https://appsto.re/tw/H5JF4.i";
    
    
    
    UIImage *postImage = [UIImage imageNamed:@"Icon-120.png"];
    
    NSArray *activityItems = @[postText, postImage];
    
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems applicationActivities:nil];
    
    activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard];
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f )
    {
        // iOS 8.0 不指定SourceView 會Crash
        activityController.popoverPresentationController.sourceView = sender;
    }
    
    [activityController setCompletionHandler:^(NSString *activityType, BOOL completed)
     {
         if (completed) {
             [RHLesEnphantsAPI shareAppLog:self];
         }
         else {
             // Cancel
         }
         
     }];
    
    [self presentViewController:activityController animated:YES completion:nil];

}

- ( IBAction )pressPointBtn:(id)sender
{
    RHPointCollection   *pVC = [[RHPointCollection alloc] initWithNibName:@"RHPointCollection" bundle:nil];
    self.m_pRHPointCollection = pVC;
    [pVC release];
    
    [self.navigationController pushViewController:m_pRHPointCollection animated:YES];
}

- ( IBAction )pressQeuestionBtn:(id)sender
{
    RHInfoVC    *pVC = [[RHInfoVC alloc] initWithNibName:@"RHInfoVC" bundle:nil];
    [pVC setM_bIsRule_1:YES];
    [self.navigationController pushViewController:[pVC autorelease] animated:YES];
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
        
        if ( m_enmuImageChoice == RH_CHOOSE_IMAGE_ICON )
        {
            self.m_pMBProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //上傳
            [self uploadUserIcon:image];
        }
        else
        {
            //save background
            
            //通知改變background
        }
        
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RHLesEnphantsAPIDelegate
- ( void )callBackSetUserPhotoStatus:( NSDictionary * )pStatusDic
{
    NSLog(@"pStatusDic = %@", pStatusDic);
    
    NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nStatus == 0 )
    {
        //取得目前obj
        RHProfileObj *pObj = [RHProfileObj getProfile];
        
        pObj.m_pstrPhotoURL = [pStatusDic objectForKey:@"photoUrl"];
        
        [pObj saveProfile];
        
        [self updateUserIcon];
    }
    else
    {
        [RHAppDelegate MessageBox:@"上傳大頭貼失敗"];
    }
    
    
    [m_pMBProgressHUD hide:YES];
}

- (void)callBackShareAppStatus:(NSDictionary *)pStatusDic
{
    NSInteger point = [[pStatusDic objectForKey:@"Point"] integerValue];
    [self showAnimation:point];
}

#pragma mark - UITableView Delgegate & DataSource
- (NSIndexPath *)tableView: (UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 )
    {
        return nil;
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger nRow = [indexPath row];

    switch ( nRow )
    {
        case 0:
        {
            RHMyNicknameEditVC *pVC = [[RHMyNicknameEditVC alloc] initWithNibName:@"RHMyNicknameEditVC" bundle:nil];
            [self.navigationController pushViewController:[pVC autorelease] animated:YES];
        }
            break;
        case 2:
        {
            if (m_pProfileObj.m_nType == 4 )
            {
                RHMyIdEditVC *pVC = [[RHMyIdEditVC alloc] initWithNibName:@"RHMyIdEditVC" bundle:nil];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
            else
            {
                RHMyBirthdayEditVC *pVC = [[RHMyBirthdayEditVC alloc] initWithNibName:@"RHMyBirthdayEditVC" bundle:nil];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
            
        }
            break;
        case 3:
        {
            if (m_pProfileObj.m_nType == 4 )
            {
                RHPromotePeopleEditVC *pVC = [[RHPromotePeopleEditVC alloc] initWithNibName:@"RHPromotePeopleEditVC" bundle:nil];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
            else if (m_pProfileObj.m_nType == 1)
            {
                RHMyExpectedDateEditVC *pVC = [[RHMyExpectedDateEditVC alloc] initWithNibName:@"RHMyExpectedDateEditVC" bundle:nil];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
            else if (m_pProfileObj.m_nType == 0)
            {
                RHMyIdEditVC *pVC = [[RHMyIdEditVC alloc] initWithNibName:@"RHMyIdEditVC" bundle:nil];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
        }
            break;
            
        case 4:
        {
            if (m_pProfileObj.m_nType == 4 )
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:imagePicker animated:YES completion:nil];

            }
            if (m_pProfileObj.m_nType == 0 ) {
                RHPromotePeopleEditVC *pVC = [[RHPromotePeopleEditVC alloc] initWithNibName:@"RHPromotePeopleEditVC" bundle:nil];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
            else
            {
                RHMyIdEditVC *pVC = [[RHMyIdEditVC alloc] initWithNibName:@"RHMyIdEditVC" bundle:nil];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
            
            
        }
            break;
        case 5:
        {
            if (m_pProfileObj.m_nType == 4 )
            {
                RHBgSelectionVC *pVC = [[RHBgSelectionVC alloc] initWithNibName:@"RHBgSelectionVC" bundle:nil];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
            else if (m_pProfileObj.m_nType == 0 )
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
                RHPromotePeopleEditVC *pVC = [[RHPromotePeopleEditVC alloc] initWithNibName:@"RHPromotePeopleEditVC" bundle:nil];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }

        }
            break;
        case 6:
        {
            if (m_pProfileObj.m_nType == 0 )
            {
                RHBgSelectionVC *pVC = [[RHBgSelectionVC alloc] initWithNibName:@"RHBgSelectionVC" bundle:nil];
                [self.navigationController pushViewController:[pVC autorelease] animated:YES];
            }
            else
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
            break;
        case 7:
        {
            RHBgSelectionVC *pVC = [[RHBgSelectionVC alloc] initWithNibName:@"RHBgSelectionVC" bundle:nil];
            [self.navigationController pushViewController:[pVC autorelease] animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (m_pProfileObj.m_nType == 0 )
    {
        return sizeof(g_MenuTitle3) / sizeof(g_MenuTitle3[0]);
    }
    else if (m_pProfileObj.m_nType == 4 )
    {
        return sizeof(g_MenuTitle2) / sizeof(g_MenuTitle2[0]);
    }
    
    return sizeof(g_MenuTitle) / sizeof(g_MenuTitle[0]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 以上兩行是制式寫法
    //if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // cell就是我們表格的內容了
    
    NSInteger nRow = [indexPath row];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if ( m_pProfileObj.m_nType == 0 )
    {
        [[cell textLabel] setText:g_MenuTitle3[nRow]];
    }
    else if ( m_pProfileObj.m_nType == 4 )
    {
        [[cell textLabel] setText:g_MenuTitle2[nRow]];
    }
    else
    {
        [[cell textLabel] setText:g_MenuTitle[nRow]];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if (indexPath.row < 4 )
    {
        UILabel *pLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 44)];
        [pLbl setTag:1000];
        
        switch ( [indexPath row] )
        {
            case 0:
            {
                [pLbl setText:m_pProfileObj.m_pstrNickName];
            }
                break;
            case 1:
            {
                NSString *pstrEmail = [RHAppDelegate getEmail];
                NSString *pstrFB = [RHAppDelegate getFBID];
                if ( pstrEmail )
                {
                    [pLbl setText:pstrEmail];
                }
                else if ( pstrFB )
                {
                    //[pLbl setText:pstrFB];
                    [pLbl setText:@""]; //先留白
                }
                else
                {
                    [pLbl setText:@"Guest"];
                }
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
                break;
            case 2:
            {
                if (m_pProfileObj.m_nType != 4 )
                {
                    [pLbl setText:m_pProfileObj.m_pstrBirthDate];
                }
                
            }
                break;
            case 3:
            {
                if (m_pProfileObj.m_nType != 4 )
                {
                    [pLbl setText:m_pProfileObj.m_pstrExpectedDate];
                    
                    if (m_pProfileObj.m_nType != 1) {
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    }
                }
            }
                break;
                
            default:
                break;
        }
        
        [[cell contentView] addSubview:pLbl];
        
        
        
    }
//    else
//    {
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    }
    
    return cell;
}

@end
