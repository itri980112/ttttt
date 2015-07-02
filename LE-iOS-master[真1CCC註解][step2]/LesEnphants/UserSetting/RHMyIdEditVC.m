//
//  RHMyIdEditVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/16.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHMyIdEditVC.h"
#import "Utilities.h"
#import "AsyncImageView.h"
#import "RHProfileObj.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
@interface RHMyIdEditVC () < UITextFieldDelegate >
- ( void )modifyMatchIdToServer;
@end

@implementation RHMyIdEditVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_MYID_TITLE", nil)];
    
    [Utilities setRoundCornor:self.m_pIconImgView];
    
    //Load User Profile
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
        
        //set MatchID
        [self.m_pTFEdit setText:pObj.m_pstrMatchID];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_m_pIconImgView release];
    [_m_pTFEdit release];
    [super dealloc];
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private 
- ( void )modifyMatchIdToServer
{
    [RHAppDelegate showLoadingHUD];
    
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:[self.m_pTFEdit text] forKey:kPostMatchID];
    
    [RHLesEnphantsAPI setMatchID:pParameter Source:self];
    
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//CCC:在文字區輸入好文字後，按下enter之後，將會呼叫本函數
    [textField resignFirstResponder];
    [self modifyMatchIdToServer];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{//CCC:每當在文字區輸入一個文字，都會呼叫一次本函數，string參數是本次輸入的字母
    NSLog(@"textField.tag = %d", textField.tag);
	
	NSLog(@"input = %@", string);
	
	const char *inputChar = [string UTF8String];
	int nASCII = *inputChar;
	int nLength = [textField.text length];
	NSLog(@"char = %c = %d", *inputChar, nASCII );
	
	if([string compare:@"" options:NSCaseInsensitiveSearch] == 0)
	{
		NSLog(@"delete");
		return YES;
	}

    
    //長度限制，最長12個字元
    if ( nLength > 11 )
    {
        return NO;
    }
    
    //字元限制 0(48) ~ 9(57)
    if ( (( nASCII >= 48 ) && ( nASCII <= 57 )) || ( (nASCII >= 97 ) && (nASCII <= 122)) )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - API Delegate
- ( void )callBackSetmatchIdStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [RHAppDelegate MessageBox:@"設定成功"];
        
        //TODO: 重新取得使用者資料
        RHProfileObj *pObj = [RHProfileObj getProfile];
        pObj.m_pstrMatchID = [self.m_pTFEdit text];
        [pObj saveProfile];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

@end
