//
//  RHAssociationPostDetailVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/12/15.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHAssociationPostDetailVC.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "AsyncImageView.h"
#import "RHProfileObj.h"
#import "RHAlertView.h"
#import "RHTextView.h"

@interface RHAssociationPostDetailVC() < UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
    NSMutableArray      *m_pCommentArray;
    NSDictionary        *m_pMainDic;
    UIImage             *m_pUploadImg;
    NSInteger           m_nDelTag;
    
}

@property ( nonatomic, retain ) NSMutableArray      *m_pCommentArray;
@property ( nonatomic, retain ) NSDictionary        *m_pMainDic;
@property ( nonatomic, retain ) UIImage             *m_pUploadImg;
- ( void )updateCommentUI;

@end


@implementation RHAssociationPostDetailVC
@synthesize m_pCommentArray;
@synthesize m_pMainDic;
@synthesize m_bCanEdit;
@synthesize m_pstrAssoID;
@synthesize m_pUploadImg;


- ( id )initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if ( self )
    {
        self.m_pCommentArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pMainDic  = nil;
        self.m_pstrAssoID = nil;
        self.m_pUploadImg = nil;
    }
    
    return self;
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- ( void )viewWillDisappear:(BOOL)animated
{
    [self unRegisterForKeyboardNotifications];
    [super viewWillDisappear:animated];
}

- ( void )viewDidLoad
{
    if (m_pMainDic )
    {
        
        [self.m_pLblMainCnt setText:[m_pMainDic objectForKey:@"content"]];
        [self.m_pLblMainCnt setText:[m_pMainDic objectForKey:@"content"]];
        NSArray *pCommentArray = [m_pMainDic objectForKey:@"comment"];
        
        [self.m_pLblMessageCount setText:[NSString stringWithFormat:@"%ld",(long)[pCommentArray count]]];
        
        [self.m_plblLikeCount setText:[NSString stringWithFormat:@"%d",[[m_pMainDic objectForKey:@"liked"] integerValue]]];
        
        [self.m_pLblReportCount setText:[NSString stringWithFormat:@"%d",[[m_pMainDic objectForKey:@"reportCount"] integerValue]]];
        
        BOOL bLiked = [[m_pMainDic objectForKey:@"liked"] boolValue];
        
        [self.m_pBtnLike setSelected:bLiked];
        
        
        
        CGFloat fTime = [[m_pMainDic objectForKey:@"createdAt"] floatValue];
        NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
        [pFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:fTime];
        NSString *pstrDateTimeSgring = [pFormatter stringFromDate:pDate];
        [self.m_pLblDateTIme setText:pstrDateTimeSgring];
        
        [self.m_pLblClass setText:[m_pMainDic objectForKey:@"subject"]];
        
        NSDictionary *pCreator = [m_pMainDic objectForKey:@"creator"];
        
        if ( pCreator )
        {
            AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pIocnImageView.bounds];
            [pAsync setBackgroundColor:[UIColor clearColor]];
            [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            
            NSString *pstrURL = [pCreator objectForKey:@"photoUrl"];
            
            if ( pstrURL && [pstrURL compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
            {
                [self.m_pIocnImageView addSubview:pAsync];
                [pAsync loadImageFromURL:[NSURL URLWithString:pstrURL]];
            }
            
            [self.m_pLblNickName setText:[pCreator objectForKey:@"nickname"]];
        }
        
        NSString *pstrImageUrl = [m_pMainDic objectForKey:@"imageUrl"];
        
        if ( pstrImageUrl )
        {
            if ( [pstrImageUrl compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
            {
                AsyncImageView *pAsync = [[AsyncImageView alloc] initWithFrame:self.m_pIocnImageView.bounds];
                [pAsync setBackgroundColor:[UIColor clearColor]];
                [pAsync setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
                
                [self.m_pIocnImageView addSubview:pAsync];
                [pAsync loadImageFromURL:[NSURL URLWithString:pstrImageUrl]];
            }
        }
        
        //處理文字
        
        CGRect kRect = self.m_pLblMainCnt.frame;
        CGFloat fOldHeight = kRect.size.height;
        NSLog(@"kRect Old = %@", NSStringFromCGRect(self.m_pLblMainCnt.frame));
        [self.m_pLblMainCnt sizeToFit];
        [self.m_pTxtMainCnt sizeToFit];
        NSLog(@"kRect New = %@", NSStringFromCGRect(self.m_pLblMainCnt.frame));
        CGFloat fDiff = self.m_pLblMainCnt.frame.size.height - fOldHeight;
        
        //調整View
        CGRect kRectView = [self.m_pMainInfoView frame];
        
        kRectView.size.height += fDiff;
        
        [self.m_pMainInfoView setFrame:kRectView];
        
        
        [self updateCommentUI];
    }
    
    
    if ( m_bCanEdit )
    {
        [self.m_pBtnManage setTitle:NSLocalizedString(@"LE_GROUP_COMMENT_DELETEARTICLE", nil) forState:UIControlStateNormal];
    }
    else
    {
        [self.m_pBtnManage setTitle:NSLocalizedString(@"LE_GROUP_COMMENT_DELETEARTICLE2", nil) forState:UIControlStateNormal];
    }

    //visit
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:m_pstrAssoID forKey:kAssoID];
    [pParameter setObject:[m_pMainDic objectForKey:@"id"] forKey:kAssoPostID];
    [RHLesEnphantsAPI visitAssociationPost:pParameter Source:self];
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
        self.m_pUploadImg = image;
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private
- ( void )updateCommentUI
{
    NSArray *pSubViews = [self.m_pMainScrollView subviews];
    
    for ( NSInteger i = 0; i < [pSubViews count]; ++i )
    {
        id oneView = [pSubViews objectAtIndex:i];
        if ( [oneView isKindOfClass:[UIView class]] )
        {
            UIView *pView = ( UIView * )oneView;
            
            if ( pView.tag == 1001 )
            {
                [pView removeFromSuperview];
            }
        }
    }
    
    
    NSInteger nGap = 10;
    NSInteger nStartY = [self.m_pMainInfoView frame].origin.y + [self.m_pMainInfoView frame].size.height + nGap;
    NSInteger nScrollHeigt = nStartY;
    
    
    for ( NSInteger i = 0; i < [m_pCommentArray count]; ++i )
    {
        NSDictionary *pDic = [m_pCommentArray objectAtIndex:i];
        UIView *pView = [[UIView alloc] initWithFrame:CGRectMake(10, nStartY, self.m_pMainScrollView.frame.size.width - 20, 70)];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            pView.frame = CGRectMake(10, nStartY, self.m_pMainScrollView.frame.size.width - 20, 90);
        }

        [pView setAutoresizingMask:self.m_pMainScrollView.autoresizingMask];
        
        [pView setTag:1001];
        [pView setBackgroundColor:UIColorFromRGB(0xF6F4E7)];
        UIImageView *pImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [pImgView setBackgroundColor:[UIColor clearColor]];
        [pView addSubview:pImgView];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            pImgView.frame = CGRectMake(10, 10, 70, 70);
        }
        
        NSString *pstrIconUrl = [[pDic objectForKey:@"creator"] objectForKey:@"photoUrl"];
        if ( [pstrIconUrl compare:@""] != NSOrderedSame )
        {
            AsyncImageView *pAsynImage = [[AsyncImageView alloc] initWithFrame:pImgView.bounds];
            [pAsynImage setBackgroundColor:[UIColor clearColor]];
            [pAsynImage setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [pImgView addSubview:pAsynImage];
            [pAsynImage loadImageFromURL:[NSURL URLWithString:pstrIconUrl]];
        }
        
        //name
        NSString *pstrName = [[pDic objectForKey:@"creator"] objectForKey:@"nickname"];
        RHTextView *pLblName = [[RHTextView alloc] initWithFrame:CGRectMake(70, 5, pView.frame.size.width - 80, 21)];
        [pLblName setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin];
        [pLblName setFont:[UIFont systemFontOfSize:12]];
        [pLblName setBackgroundColor:[UIColor clearColor]];
        [pLblName setTextColor:[UIColor blackColor]];
        [pLblName setText:pstrName];
        [pView addSubview:pLblName];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            pLblName.frame = CGRectMake(90, 5, pView.frame.size.width - 120, 33);
            [pLblName setFont:[UIFont systemFontOfSize:18]];
        }
        
        
        //Image
        NSString *pstrUrl = [pDic objectForKey:@"imageUrl"];
        
        NSInteger nstartLabel = 10 + pLblName.frame.size.height;

        if ( pstrUrl && [pstrUrl compare:@""] != NSOrderedSame )
        {
            UIView *pImgBgView = [[UIView alloc] initWithFrame:CGRectMake(70, nstartLabel, pView.frame.size.width - 80, 150)];
            [pImgBgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [pImgBgView setBackgroundColor:[UIColor clearColor]];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                pImgBgView.frame = CGRectMake(90, nstartLabel, pView.frame.size.width - 120, 225);
            }
            
            AsyncImageView *pAsynImage = [[AsyncImageView alloc] initWithFrame:pImgBgView.bounds];
            [pAsynImage setContentMode:UIViewContentModeScaleAspectFill];
            [pAsynImage setAutoresizingMask:pImgBgView.autoresizingMask];
            [pAsynImage setBackgroundColor:[UIColor clearColor]];
            [pAsynImage setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [pImgBgView addSubview:pAsynImage];
            [pAsynImage loadImageFromURL:[NSURL URLWithString:pstrUrl]];
            [pView addSubview:pImgBgView];
            
            //add image
            nstartLabel += pImgBgView.frame.size.height;
        }
        
        
        //Content
        NSString *pstrCnt = [pDic objectForKey:@"content"];
        RHTextView *pLblCnt = [[RHTextView alloc] initWithFrame:CGRectMake(70, nstartLabel, pView.frame.size.width - 80, 21)];
        [pLblCnt setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin];
        [pLblCnt setFont:[UIFont systemFontOfSize:12]];
        //[pLblCnt setNumberOfLines:0];
        [pLblCnt setBackgroundColor:[UIColor clearColor]];
        [pLblCnt setTextColor:[UIColor blackColor]];
        [pLblCnt setText:pstrCnt];
        [pView addSubview:pLblCnt];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            pLblCnt.frame = CGRectMake(90, nstartLabel, pView.frame.size.width - 120, 33);
            [pLblCnt setFont:[UIFont systemFontOfSize:18]];
        }
        
        NSInteger nOldTextHeight = pLblCnt.frame.size.height;
        
        [pLblCnt sizeToFit];
        
        NSInteger nDiff = pLblCnt.frame.size.height - nOldTextHeight;
        
        if ( pstrUrl && [pstrUrl compare:@""] != NSOrderedSame )
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                nDiff += 225;
            }
            else {
                nDiff += 150;
            }
        }
        
        if ( nDiff > 0 )
        {
            CGRect kViewRect = pView.frame;
            kViewRect.size.height += nDiff;
            [pView setFrame:kViewRect];
        }
        
        UIView *pLineView = [[UIView alloc] initWithFrame:CGRectMake(0, pView.frame.size.height-1, pView.frame.size.width, 1)];
        [pLineView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin];
        [pLineView setBackgroundColor:UIColorFromRGB(0xcccccc)];
        [pView addSubview:pLineView];
        
        UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pBtn setFrame:pView.bounds];
        [pBtn setTag:i];
        //[pView addSubview:pBtn];
        [pView insertSubview:pBtn belowSubview:pLblCnt];
        [pBtn addTarget:self action:@selector(pressCommentCnt:) forControlEvents:UIControlEventTouchUpInside];
    
        
        [self.m_pMainScrollView addSubview:pView];
        nScrollHeigt += pView.frame.size.height;
        
        nStartY+= pView.frame.size.height;
    }
    
    [self.m_pMainScrollView setContentSize:CGSizeMake(self.m_pMainScrollView.frame.size.width, nScrollHeigt)];
    
}

- ( IBAction )pressCommentCnt:(id)sender
{
    UIButton *pBtn = ( UIButton * )sender;
    NSLog(@"Tag = %d", pBtn.tag);
    
    
    RHProfileObj *pObj = [RHProfileObj getProfile];
    //檢查是不是自已發的，若是，詢問刪除
    NSDictionary *pDic = [m_pCommentArray objectAtIndex:pBtn.tag];
    NSLog(@"pDic = %@", pDic);
    m_nDelTag = pBtn.tag;
    NSString *pstrCraator = [[pDic objectForKey:@"creator"] objectForKey:@"matchId"];
    NSString *pstrCommentID = [pDic objectForKey:@"id"];
    
    BOOL bCanDelete = NO;
    
     if ( [pstrCraator compare:pObj.m_pstrMatchID] == NSOrderedSame || m_bCanEdit  )
     {
         bCanDelete = YES;
     }
    
    
    if ( bCanDelete ) 
    {
        RHAlertView *alert = [[RHAlertView alloc]initWithTitle:@""
                                                message:NSLocalizedString(@"LE_COMMON_DELETEHINT", nil)
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"LE_COMMON_CANCEL", nil)
                                             otherButtonTitles:NSLocalizedString(@"LE_COMMON_DELETE", nil),nil];
        [alert showWithCallback:^(UIAlertView *alertView, NSInteger buttonIndex)
         {
             if ( buttonIndex == 1 )
             {
                 NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
                 [pParameter setObject:m_pstrAssoID forKey:kAssoID];
                 [pParameter setObject:[m_pMainDic objectForKey:@"id"] forKey:kAssoPostID];
                 [pParameter setObject:pstrCommentID forKey:kAssoCommentID];
                 //[RHAppDelegate showLoadingHUD];
                 [RHLesEnphantsAPI deleteAssociationComment:pParameter Source:self];
                 
             }
             else
             {
                 
             }
             
         }];

    }
    
}

#pragma mark - Public
-( void )setupDataDic:( NSDictionary * )pDic
{
    if ( pDic )
    {
        self.m_pMainDic = pDic;
        
        NSArray *pArray = [pDic objectForKey:@"comment"];
        
        if ( pArray )
        {
            for ( id obj in pArray )
            {
                [self.m_pCommentArray insertObject:obj atIndex:0];
            }
        }
        
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //    NSUInteger nRow = [indexPath row];
    //
    //    NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nRow];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nHeight = 50;
    
    return nHeight;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_pCommentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    // Configure the cell...
    
    NSUInteger nRow = [indexPath row];

    return cell;
}



#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressAddImageBtn:(id)sender
{
    //選圖
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- ( IBAction )pressPostBtn:(id)sender
{
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:m_pstrAssoID forKey:kAssoID];
    [pParameter setObject:[m_pMainDic objectForKey:@"id"] forKey:kAssoPostID];
    [pParameter setObject:[self.m_pTFCntText text] forKey:kAssoComment];
    self.m_pTFCntText.text = nil;
    
    if ( m_pUploadImg )
    {
        NSData *pData = UIImageJPEGRepresentation(m_pUploadImg, 0.85f);
        [pParameter setObject:pData forKey:kAssoImage];
        self.m_pUploadImg = nil;
    }
    
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI commentAssociationPost:pParameter Source:self];

}

- ( IBAction )pressLikeBtn:(id)sender
{
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:m_pstrAssoID forKey:kAssoID];
    [pParameter setObject:[m_pMainDic objectForKey:@"id"] forKey:kAssoPostID];
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI likeAssociationPost:pParameter Source:self];
}

- ( IBAction )pressCommentBtn:(id)sender
{
    
    
}
- ( IBAction )pressManageBtn:(id)sender
{
    if ( m_bCanEdit )
    {
        
        RHAlertView *alert = [[RHAlertView alloc]initWithTitle:@""
                                                       message:@"刪除此文章？"
                                                      delegate:nil
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"刪除",nil];
        [alert showWithCallback:^(UIAlertView *alertView, NSInteger buttonIndex)
         {
             if ( buttonIndex == 1 )
             {
                 NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
                 [pParameter setObject:m_pstrAssoID forKey:kAssoID];
                 [pParameter setObject:[m_pMainDic objectForKey:@"id"] forKey:kAssoPostID];
                 [RHAppDelegate showLoadingHUD];
                 [RHLesEnphantsAPI deleteAssociationPost:pParameter Source:self];
             }
             else
             {
                 
             }
             
         }];
    }
    else
    {
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:m_pstrAssoID forKey:kAssoID];
        [pParameter setObject:[m_pMainDic objectForKey:@"id"] forKey:kAssoPostID];
        [RHAppDelegate showLoadingHUD];
        [RHLesEnphantsAPI reportAssociation:pParameter Source:self];
    }
}

#pragma mark - API
- ( void )callBackGetAssociationPostStatus:( NSDictionary * )pStatusDic
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

- ( void )callBackDeleteAssociationPostStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:m_pstrAssoID forKey:kAssoID];
        [RHLesEnphantsAPI getAssociationPost:pParameter Source:self];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
    
}

- ( void )callBackLikeAssociationPostStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [self.m_pBtnLike setSelected:YES];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackReportAssociationPostStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:m_pstrAssoID forKey:kAssoID];
        [RHLesEnphantsAPI getAssociationPost:pParameter Source:self];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackCommentPostStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
       //Get Post Comment
        NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
        [pParameter setObject:m_pstrAssoID forKey:kAssoID];
        [pParameter setObject:[m_pMainDic objectForKey:@"id"] forKey:kAssoPostID];
        [RHAppDelegate showLoadingHUD];
        [RHLesEnphantsAPI getAssociationComment:pParameter Source:self];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];

}

- ( void )callBackGetAssociationCommentStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        //Get Post Comment
        NSArray *pData = [pStatusDic objectForKey:@"data"];
        
        [self.m_pCommentArray removeAllObjects];
        
        for ( NSInteger i = 0; i < [pData count]; ++i )
        {
            [self.m_pCommentArray insertObject:[pData objectAtIndex:i] atIndex:0];
        }
        
        [self updateCommentUI];
        
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackDeleteAssociationCommentStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        if ( m_nDelTag < [m_pCommentArray count])
        {
            [m_pCommentArray removeObjectAtIndex:m_nDelTag];
        }
        
        [self updateCommentUI];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    //[RHAppDelegate hideLoadingHUD];

}

#pragma mark - Keyboard Related
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textField -> %d", textField.tag);
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-( void )unRegisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    // get a rect for the textView frame
    CGRect containerFrame = self.m_pContainerView.frame;
    containerFrame.size.height = (self.view.frame.size.height-64) - keyboardBounds.size.height;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.m_pContainerView.frame = containerFrame;
    
    
    NSLog(@"m_pContainerView = %@", NSStringFromCGRect(self.m_pContainerView.frame));
    
    [UIView commitAnimations];
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    // get a rect for the textView frame
    CGRect containerFrame = self.m_pContainerView.frame;
    containerFrame.size.height = self.view.frame.size.height - 64;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set views with new info
    self.m_pContainerView.frame = containerFrame;
    // commit animations
    [UIView commitAnimations];
}


@end
