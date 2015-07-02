    //
//  RHMyNicknameEditVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/16.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHMyNicknameEditVC.h"
#import "Utilities.h"
#import "AsyncImageView.h"
#import "RHProfileObj.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface RHMyNicknameEditVC () < UITextFieldDelegate > {
    int m_KeyboardHeight;
}

- ( void )modifyMatchIdToServer;
@end

@implementation RHMyNicknameEditVC

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
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_MYNICKNAME_TITLE", nil)];
    
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
        [self.m_pTFEdit setText:pObj.m_pstrNickName];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    m_KeyboardHeight = kOFFSET_FOR_KEYBOARD;
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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

- ( IBAction )pressSendBtn:(id)sender
{
    [self modifyMatchIdToServer];
}

#pragma mark - Private 
- ( void )modifyMatchIdToServer
{
    [RHAppDelegate showLoadingHUD];
    
    
    NSMutableDictionary *pParameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [pParameter setObject:[self.m_pTFEdit text] forKey:kNickname];
    
    [RHLesEnphantsAPI setUserProfile:pParameter Source:self];
    
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //[self modifyMatchIdToServer];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
        //return YES;
    }
    else
    {
        //return NO;
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.m_pTFEdit])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            //[self setViewMovedUp:YES];
        }
    }
}

-(void)onKeyboardWillShow:(NSNotification*)notification {
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            m_KeyboardHeight = keyboardFrame.size.height / 2;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            m_KeyboardHeight = keyboardFrame.size.width / 2;
            break;
            
        default:
            break;
    }

    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)onKeyboardWillHide:(NSNotification*)notification {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= m_KeyboardHeight;
        rect.size.height += m_KeyboardHeight;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += m_KeyboardHeight;
        rect.size.height -= m_KeyboardHeight;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


#pragma mark - API Delegate
- ( void )callBackSetUserProfileStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        [RHAppDelegate MessageBox:@"設定成功"];
        
        //TODO: 重新取得使用者資料
        RHProfileObj *pObj = [RHProfileObj getProfile];
        pObj.m_pstrNickName = [self.m_pTFEdit text];
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
