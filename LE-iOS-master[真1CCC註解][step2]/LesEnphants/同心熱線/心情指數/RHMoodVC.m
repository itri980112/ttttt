//
//  RHMoodVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/26.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHMoodVC.h"
#import "RHProfileObj.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "RHMoodStatisticVC.h"
#import "AsyncImageView.h"
#import "CustomIOS7AlertView.h"
#import "RHColorPickerView.h"
#import "Utilities.h"
#import "GoldCoinAnimationVC.h"

@interface RHMoodVC () < UIImagePickerControllerDelegate, UINavigationControllerDelegate, RHColorPickerViewDelegate >
{
    NSInteger   m_nSelIdx;
    NSDictionary        *m_pMotherMoodDic;
    NSArray             *m_pLatestEmotionArray;
    NSString    *m_pstrPath;
}

- ( NSString * )safeGetApiReturnString:( id )oneObj;
- ( void )updateMomRelatedCollection;
@property ( nonatomic, retain ) NSDictionary        *m_pMotherMoodDic;
@property ( nonatomic, retain ) NSString    *m_pstrPath;
@property ( nonatomic, retain ) NSArray             *m_pLatestEmotionArray;
@end

@implementation RHMoodVC
@synthesize m_pMotherMoodDic;
@synthesize m_pstrPath;
@synthesize m_pLatestEmotionArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_nSelIdx =  3;  //中間那一個
        self.m_pMotherMoodDic = nil;
        self.m_pLatestEmotionArray = nil;
        self.m_pstrPath = [NSString stringWithFormat:@"%@/MomEmotion.plist", [Utilities getDocumentPath]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //判斷是Father Or Mother
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    
    if ( pObj.m_nType == 1 )
    {
        //Mother
        [self.m_pMainScrollView addSubview:self.m_pMotherView];
        [self.m_pMainScrollView setContentSize:self.m_pMotherView.frame.size];
        
        [self.m_pColorPicker setDelegate:self];
        [self updateMomRelatedCollection];
    }
    else
    {
        //Father
        [self.m_pMainScrollView addSubview:self.m_pFatherView];
        [self.m_pMainScrollView setContentSize:self.m_pFatherView.frame.size];
        
        NSString *pstr = [RHAppDelegate getFatherAsk];
        if ( pstr )
        {
            [self.m_pLblMsg setText:pstr];
        }

    }
    
    
    //Get Mother Mood
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI getMotherMood:nil Source:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [m_pLatestEmotionArray release];
    [_m_pMotherView release];
    [_m_pFatherView release];
    [_m_pMainScrollView release];
    [_m_pBigEmotionImg release];
    [_m_pBtnEmotion1 release];
    [_m_pBtnEmotion2 release];
    [_m_pBtnEmotion3 release];
    [_m_pBtnEmotion4 release];
    [_m_pBtnEmotion5 release];
    [_m_pBtnEmotion6 release];
    [_m_pBtnEmotion7 release];
    [_m_pLblMsg release];
    [_m_pBtnEmotionF1 release];
    [_m_pBtnEmotionF2 release];
    [_m_pBtnEmotionF3 release];
    [_m_pBtnEmotionF4 release];
    [_m_pBtnEmotionF5 release];
    [_m_pBtnEmotionF6 release];
    [_m_pBtnEmotionF7 release];
    [_m_pEmotionImgFromMom release];
    [m_pMotherMoodDic release];
    [_m_pColorPicker release];
    [_m_pMomRealtedCollection release];
    [super dealloc];
}

#pragma mark - Private Methods
- ( void )uploadUserIcon:( UIImage * )pImg
{
    //maybe resize
    
    
//    NSData *pImgData = UIImageJPEGRepresentation(pImg, 0.85f);
//    //upload
//    
//    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
//    [pParameter setObject:pImgData forKey:kImage];
//    [pParameter setObject:[NSString stringWithFormat:@"%ld", ( long )( m_nSelIdx )] forKey:kMood];
//    
//    [RHAppDelegate showLoadingHUD];
//    [RHLesEnphantsAPI uploadMoodImage:pParameter Source:self];
    
}

- ( void )showInputDialog
{
    UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 160)] autorelease];
    [pView setBackgroundColor:[UIColor lightGrayColor]];
    
    
    UILabel *pLblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 40)] autorelease];
    [pLblTitle setTextAlignment:NSTextAlignmentCenter];
    [pLblTitle setTextColor:[UIColor blackColor]];
    [pLblTitle setText:@"問候內容"];
    
    UITextField *pTxtView = [[[UITextField alloc] initWithFrame:CGRectMake(10, 50, 240, 40)] autorelease];
    [pTxtView setBorderStyle:UITextBorderStyleRoundedRect];
    [pTxtView setText:self.m_pLblMsg.text];
    
    
    [pView addSubview:pLblTitle];
    [pView addSubview:pTxtView];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    //        alertView.tag = kVisitTag;
    // Add some custom content to the alert view
    [alertView setContainerView:pView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"確認", nil]];
    
    [alertView show];
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex)
     {
         
         NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex,[alertView tag]);
         
         if (buttonIndex == 0)
         {
             [alertView close];
         }
         else if (buttonIndex == 1)
         {
             NSString *pstrInPut = [pTxtView text];
             [self.m_pLblMsg setText:pstrInPut];
              [RHAppDelegate setFatherAsk:pstrInPut];
             
             [RHAppDelegate showLoadingHUD];
             NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
             [pParameter setObject:pstrInPut forKey:kBody];
             [RHLesEnphantsAPI pushMotherMood:pParameter Source:self];
        }
         
     }];
}

- ( NSString * )safeGetApiReturnString:( id )oneObj
{
    NSString *pstrReturn = @"";
    
    if ( ![oneObj isKindOfClass:[NSNull class]] )
    {
        pstrReturn = ( NSString * )oneObj;
    }
    
    return pstrReturn;
}

- ( void )updateMomRelatedCollection
{
    NSDictionary *pDic = [NSDictionary dictionaryWithContentsOfFile:m_pstrPath];
    
    if ( pDic == nil )
    {
        //清空
        NSArray *pArray = [self.m_pMomRealtedCollection subviews];
        
        for ( UIButton *pBtn in pArray )
        {
            [pBtn setImage:nil forState:UIControlStateNormal];
            [pBtn setUserInteractionEnabled:NO];
            [pBtn setHidden:YES];
            
        }
    }
    else
    {
        
        self.m_pLatestEmotionArray = [pDic objectForKey:@"Latest"];
        
        NSInteger nViewTag = 1;
        for ( NSInteger i = 0; i < [m_pLatestEmotionArray count]; ++i )
        {
            NSInteger nTag = nViewTag + i;
            UIButton *pBtn = (UIButton*)[self.m_pMomRealtedCollection viewWithTag:nTag];
            NSInteger invertTag  = m_pLatestEmotionArray.count - 1 - i;
            NSInteger nImgTag = [[m_pLatestEmotionArray objectAtIndex:invertTag] integerValue];
            NSLog(@"nImgTag = %d", nImgTag);
            NSString *pstrImageName = [NSString stringWithFormat:@"同心熱線_thumb0%ld.png", (long)(nImgTag+1)];
            [pBtn setBackgroundImage:[UIImage imageNamed:pstrImageName] forState:UIControlStateNormal];
            [pBtn setUserInteractionEnabled:YES];
            [pBtn setHidden:NO];
        }
    }
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
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressLogBtn:(id)sender
{
    
    RHMoodStatisticVC *pVC = [[RHMoodStatisticVC alloc] initWithNibName:@"RHMoodStatisticVC" bundle:nil];
    [self.navigationController pushViewController:[pVC autorelease] animated:YES];
    
}

- ( IBAction )pressChangeImgBtn:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- ( IBAction )pressRecordBtn:(id)sender
{
    [RHAppDelegate showLoadingHUD];
    
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSString *pstr = [NSString stringWithFormat:@"%ld", (long)( m_nSelIdx-3 )]; //1 mapping to -3
    
    [pParameter setObject:pstr forKey:kMood];
    
    [RHLesEnphantsAPI setMotherMood:pParameter Source:self];
}

- ( IBAction )pressEmotionBtn:(id)sender
{
    UIButton *pBtn = ( UIButton * )sender;
    NSInteger nTag = [pBtn tag];
    m_nSelIdx = nTag;
    
    
    NSArray *pSubVies = [self.m_pBigEmotionImg subviews];
    
    for (id oneView in pSubVies )
    {
        if ( [oneView isKindOfClass:[AsyncImageView class]])
        {
            AsyncImageView *pView = ( AsyncImageView * )oneView;
            [pView removeFromSuperview];
        }
    }
    
    
    //檢查是否有Customized EmotionImg
//    if ( m_pMotherMoodDic )
//    {
//        NSString *pstrURL = @"";
//        switch ( nTag )
//        {
//            case 1:
//            {
//                pstrURL = [m_pMotherMoodDic objectForKey:@"moodUrl_1"];
//            }
//                break;
//            case 2:
//            {
//                pstrURL = [m_pMotherMoodDic objectForKey:@"moodUrl_2"];
//            }
//                break;
//            case 3:
//            {
//                pstrURL = [m_pMotherMoodDic objectForKey:@"moodUrl_3"];
//            }
//                break;
//            case 4:
//            {
//                pstrURL = [m_pMotherMoodDic objectForKey:@"moodUrl_4"];
//            }
//                break;
//            case 5:
//            {
//                pstrURL = [m_pMotherMoodDic objectForKey:@"moodUrl_5"];
//            }
//                break;
//            case 6:
//            {
//                pstrURL = [m_pMotherMoodDic objectForKey:@"moodUrl_6"];
//            }
//                break;
//            case 7:
//            {
//                pstrURL = [m_pMotherMoodDic objectForKey:@"moodUrl_7"];
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        if ( [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
//        {
//            //有值
//            AsyncImageView *pView = [[AsyncImageView alloc] initWithFrame:self.m_pBigEmotionImg.bounds];
//            [pView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
//            [self.m_pBigEmotionImg addSubview:pView];
//            [pView loadImageFromURL:[NSURL URLWithString:pstrURL]];
//            [pView release];
//        }
//        else
//        {
//            //同心熱線_emotion01.png
//            NSString *pstrImgName = [NSString stringWithFormat:@"同心熱線_emotion0%ld.png", (long)nTag];
//            
//            [self.m_pBigEmotionImg setImage:[UIImage imageNamed:pstrImgName]];
//        }
//    }
//    else
//    {
        //同心熱線_emotion01.png
//        NSString *pstrImgName = [NSString stringWithFormat:@"同心熱線_emotion0%ld.png", (long)nTag];
//    
//        [self.m_pBigEmotionImg setImage:[UIImage imageNamed:pstrImgName]];
//    }
    
    if (nTag <= m_pLatestEmotionArray.count) {
        NSInteger invertTag = (m_pLatestEmotionArray.count - 1) - (nTag - 1);
        NSInteger nImgTag = [[m_pLatestEmotionArray objectAtIndex:invertTag] integerValue];
        NSString *pstrImgName = [NSString stringWithFormat:@"同心熱線_emotion0%ld.png", (long)nImgTag+1];
        [self.m_pBigEmotionImg setImage:[UIImage imageNamed:pstrImgName]];
    }

}

- ( IBAction )pressNotifyMotherBtn:(id)sender
{
    [self showInputDialog];
}

#pragma mark - API
- ( void )callBackSetMotherMoodImage:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [RHAppDelegate MessageBox:@"孕媽咪已更新心情指數！"];
        
        
        //更新Collection
        NSDictionary *pDic = [NSDictionary dictionaryWithContentsOfFile:m_pstrPath];
        NSMutableArray *pArray = [NSMutableArray arrayWithArray:[pDic objectForKey:@"Latest"]];
        
        while ( [pArray count] >= 7 )
        {
            [pArray removeObjectAtIndex:0];
        }
        
        NSNumber *pCurrentNum = [NSNumber numberWithInteger:m_nSelIdx];
        [pArray addObject:pCurrentNum];
        
        NSDictionary *pSaveDic = [NSDictionary dictionaryWithObjectsAndKeys:pArray, @"Latest", nil];
        [pSaveDic writeToFile:m_pstrPath atomically:YES];
        [self updateMomRelatedCollection];
        
        RHProfileObj *pObj = [RHProfileObj getProfile];
        
        // 如果是媽咪才顯示金幣動畫
        if ( pObj.m_nType == 1 ) {
            
            NSInteger point = [[pStatusDic objectForKey:@"Point"] integerValue];
            [self showAnimation:point];
            
        }
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
    
}
- ( void )callBackGetMotherMoodImage:( NSDictionary * )pStatusDic
{
    
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        //設定目前心情，爸爸與媽媽都要
        self.m_pMotherMoodDic = pStatusDic;
        
        id mood = [pStatusDic objectForKey:@"mood"];
        
        NSInteger nCurrentMood = 0;
        
        
        if ( ![mood isKindOfClass:[NSNull class]] )
        {
            nCurrentMood = [[pStatusDic objectForKey:@"mood"] integerValue];
        }

        
        NSString *pstrImgName = [NSString stringWithFormat:@"同心熱線_emotion0%ld", (long)(nCurrentMood+4)];
        [self.m_pBigEmotionImg setImage:[UIImage imageNamed:pstrImgName]];
        [self.m_pEmotionImgFromMom setImage:[UIImage imageNamed:pstrImgName]];
        m_nSelIdx = nCurrentMood; //之後都會加4,所以這裡要減回來
        m_nSelIdx += 3;
        [self.m_pColorPicker setSelectedTag:nCurrentMood+4];
        
        
//        NSString *pstrURL_1 =  [self safeGetApiReturnString:[pStatusDic objectForKey:@"moodUrl_1"]];
//        NSString *pstrURL_2 =  [self safeGetApiReturnString:[pStatusDic objectForKey:@"moodUrl_2"]];
//        NSString *pstrURL_3 =  [self safeGetApiReturnString:[pStatusDic objectForKey:@"moodUrl_3"]];
//        NSString *pstrURL_4 =  [self safeGetApiReturnString:[pStatusDic objectForKey:@"moodUrl_4"]];
//        NSString *pstrURL_5 =  [self safeGetApiReturnString:[pStatusDic objectForKey:@"moodUrl_5"]];
//        NSString *pstrURL_6 =  [self safeGetApiReturnString:[pStatusDic objectForKey:@"moodUrl_6"]];
//        NSString *pstrURL_7 =  [self safeGetApiReturnString:[pStatusDic objectForKey:@"moodUrl_7"]];
//        
//        
//        if ( [pstrURL_1 compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame)
//        {
//            [self.m_pBtnEmotion1 setImage:nil forState:UIControlStateNormal];
//            AsyncImageView *pImgView = [[AsyncImageView alloc] initWithFrame:self.m_pBtnEmotion1.bounds];
//            [pImgView setUserInteractionEnabled:NO];
//            [pImgView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
//            [self.m_pBtnEmotion1 addSubview:pImgView];
//            [pImgView loadImageFromURL:[NSURL URLWithString:pstrURL_1]];
//            [pImgView release];
//        }
//        if ( [pstrURL_2 compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame)
//        {
//            [self.m_pBtnEmotion2 setImage:nil forState:UIControlStateNormal];
//            AsyncImageView *pImgView = [[AsyncImageView alloc] initWithFrame:self.m_pBtnEmotion2.bounds];
//            [pImgView setUserInteractionEnabled:NO];
//            [pImgView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
//            [self.m_pBtnEmotion2 addSubview:pImgView];
//            [pImgView loadImageFromURL:[NSURL URLWithString:pstrURL_2]];
//            [pImgView release];
//        }
//        if ( [pstrURL_3 compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame)
//        {
//            [self.m_pBtnEmotion3 setImage:nil forState:UIControlStateNormal];
//            AsyncImageView *pImgView = [[AsyncImageView alloc] initWithFrame:self.m_pBtnEmotion3.bounds];
//            [pImgView setUserInteractionEnabled:NO];
//            [pImgView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
//            [self.m_pBtnEmotion3 addSubview:pImgView];
//            [pImgView loadImageFromURL:[NSURL URLWithString:pstrURL_3]];
//            [pImgView release];
//        }
//        if ( [pstrURL_4 compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame)
//        {
//            [self.m_pBtnEmotion4 setImage:nil forState:UIControlStateNormal];
//            AsyncImageView *pImgView = [[AsyncImageView alloc] initWithFrame:self.m_pBtnEmotion4.bounds];
//            [pImgView setUserInteractionEnabled:NO];
//            [pImgView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
//            [self.m_pBtnEmotion4 addSubview:pImgView];
//            [pImgView loadImageFromURL:[NSURL URLWithString:pstrURL_4]];
//            [pImgView release];
//        }
//        if ( [pstrURL_5 compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame)
//        {
//            [self.m_pBtnEmotion5 setImage:nil forState:UIControlStateNormal];
//            AsyncImageView *pImgView = [[AsyncImageView alloc] initWithFrame:self.m_pBtnEmotion5.bounds];
//            [pImgView setUserInteractionEnabled:NO];
//            [pImgView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
//            [self.m_pBtnEmotion5 addSubview:pImgView];
//            [pImgView loadImageFromURL:[NSURL URLWithString:pstrURL_5]];
//            [pImgView release];
//        }
//        if ( [pstrURL_6 compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame)
//        {
//            [self.m_pBtnEmotion6 setImage:nil forState:UIControlStateNormal];
//            AsyncImageView *pImgView = [[AsyncImageView alloc] initWithFrame:self.m_pBtnEmotion6.bounds];
//            [pImgView setUserInteractionEnabled:NO];
//            [pImgView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
//            [self.m_pBtnEmotion6 addSubview:pImgView];
//            [pImgView loadImageFromURL:[NSURL URLWithString:pstrURL_6]];
//            [pImgView release];
//        }
//        if ( [pstrURL_7 compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame)
//        {
//            [self.m_pBtnEmotion7 setImage:nil forState:UIControlStateNormal];
//            AsyncImageView *pImgView = [[AsyncImageView alloc] initWithFrame:self.m_pBtnEmotion7.bounds];
//            [pImgView setUserInteractionEnabled:NO];
//            [pImgView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
//            [self.m_pBtnEmotion7 addSubview:pImgView];
//            [pImgView loadImageFromURL:[NSURL URLWithString:pstrURL_7]];
//            [pImgView release];
//        }
        
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackPushMotherMoodStatus:( NSDictionary * )pStatusDic
{
    if ( pStatusDic )
    {
        NSInteger nStatus = [[pStatusDic objectForKey:@"error"] integerValue];
        
        if ( nStatus == 0 )
        {
            [RHAppDelegate MessageBox:@"已通知媽咪"];
        }
        else
        {
            [RHAppDelegate MessageBox:@"發送失敗"];
        }
    }
    else
    {
        
    }
    
    [RHAppDelegate hideLoadingHUD];
    
}

#pragma mark - Image Picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSString *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    //NSLog(@"url:%@",url);
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"original image:%@",NSStringFromCGSize(image.size));
        

        [self uploadUserIcon:image];

        
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - API
- ( void )callBackuploadMoodImage:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {

    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

#pragma mark - RHColor Picker View Delefate
- ( void )callBackXValue:( NSInteger )nXValue
{
    NSInteger nTag = ( nXValue / self.m_pColorPicker.frame.size.width ) * 7;
    m_nSelIdx = nTag;
    
    NSLog(@"%d", nTag);
    NSString *pstrImgName = [NSString stringWithFormat:@"同心熱線_emotion0%ld.png", (long)(nTag+1)];
    
    [self.m_pBigEmotionImg setImage:[UIImage imageNamed:pstrImgName]];

}

@end
