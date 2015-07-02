//
//  ECChatInputView.m
//  ECChatBubbleView
//
//  Created by Soul on 2014/8/8.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import "ECChatInputView.h"
#import "KeyboardStateListener.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation ECChatInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - LifeCircle

- (void) awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self setupInitial];
}

- (void) setupInitial
{
    [self setupUI];
    [self setupParam];
}

- (void) setupUI
{
    [_m_ptxtvInput.layer setBorderColor:[UIColor blackColor].CGColor];
    [_m_ptxtvInput.layer setBorderWidth:1.0f];
    [_m_ptxtvInput.layer setCornerRadius:3.0f];
}

- (void) setupParam
{
    self.m_ptxtvInput.text = @"";
    
    [self callBackInputbarHeightAndCalculateTxtvHeight:self.m_ptxtvInput ShowKeyBoard:NO];
}

#pragma mark - Button Action Did Tapped

- (IBAction) setModeButtonDidTapped:(UIButton *)sender
{
    /* 先改變狀態 */
    if (self.m_eECModeType == ECModeTypeOfNone)
    {
        self.m_eECModeType = ECModeTypeOfPicture;
        self.m_pbtnMode.selected = YES;
    }
    else if (self.m_eECModeType == ECModeTypeOfPicture)
    {
        self.m_eECModeType = ECModeTypeOfWrite;
        self.m_pbtnMode.selected = NO;
    }
    else if (self.m_eECModeType == ECModeTypeOfWrite)
    {
        self.m_eECModeType = ECModeTypeOfPicture;
        self.m_pbtnMode.selected = YES;
    }
    else
    {
        
    }
    
    if (self.m_eECModeType == ECModeTypeOfWrite)
    {
        [self.m_ptxtvInput becomeFirstResponder];
        
        if (_delegate && [_delegate respondsToSelector:@selector(callBackShowPicture:)])
        {
            [_delegate callBackShowPicture:self.m_eECModeType];
        }
    }
    else if (self.m_eECModeType == ECModeTypeOfPicture)
    {
        [self.m_ptxtvInput resignFirstResponder];
        
        if (_delegate && [_delegate respondsToSelector:@selector(callBackShowPicture:)])
        {
            [_delegate callBackShowPicture:self.m_eECModeType];
        }
    }
}


- (IBAction) setSendButtonDidTapped:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(callBackMessageData:MessageSendType:)])
    {
        [_delegate callBackMessageData:self.m_ptxtvInput.text MessageSendType:ECMessageSendTypeOfMessage];
    }
    
    [self setupParam];
    
    [self setDismissInputBarButtonDidTapped:nil];
}

- (void) setDismissInputBarButtonDidTapped:(UIButton *)sender
{
    
    if (self.m_eECModeType == ECModeTypeOfWrite)
    {
        [self.m_ptxtvInput resignFirstResponder];
    }
    else if (self.m_eECModeType == ECModeTypeOfPicture)
    {
        [self.m_ptxtvInput resignFirstResponder];
    }
    else
    {
        
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackReturnInitial)])
    {
        [_delegate callBackReturnInitial];
    }
    
    self.m_eECModeType = ECModeTypeOfNone;
    self.m_pbtnMode.selected = NO;
}

#pragma mark - 計算UITextView高度 以及 call back TextView Height
//對話欄高度
- (void) callBackInputbarHeightAndCalculateTxtvHeight:(UITextView *)ptxtvTemp ShowKeyBoard:(BOOL)isShow
{
    float width = ptxtvTemp.frame.size.width;
    float height = 0.0;
    
    float keyboard = floorf( isShow == YES ? 216 : 0);
    
    CGSize sizeTxtv = [ptxtvTemp sizeThatFits:CGSizeMake( width, 3000)];
    
    if (!ptxtvTemp.text.length)
    {
        height = 70;
        
        
    }
    else if (sizeTxtv.height < 70)
    {
        height = 90;
    }
    else if (sizeTxtv.height > 70)
    {
        
        height = 140;
        
    }
    else if (sizeTxtv.height < 140)
    {
        height = 180;
    }
    else
    {
        height = sizeTxtv.height;
    }
    
    ptxtvTemp.frame = CGRectMake( ptxtvTemp.frame.origin.x, ptxtvTemp.frame.origin.y, ptxtvTemp.frame.size.width, height);
    
    if ( _delegate && [_delegate respondsToSelector:@selector(callBackInputBarFrame:)])
    {
        [_delegate callBackInputBarFrame:CGRectMake( self.frame.origin.x, SCREEN_HEIGHT - (height + 11) - keyboard, self.frame.size.width, (height + 11))];
    }
}


#pragma mark - UITextVField Delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITextView Delegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if (self.m_eECModeType != ECModeTypeOfWrite)
    {
        self.m_eECModeType = ECModeTypeOfWrite;
        self.m_pbtnMode.selected = NO;
    }
    
    [self callBackInputbarHeightAndCalculateTxtvHeight:self.m_ptxtvInput ShowKeyBoard:YES];
    
    self.frame = CGRectMake( self.frame.origin.x, SCREEN_HEIGHT - (self.m_ptxtvInput.frame.size.height + 11) - 216 - floorf(IOS_VERSION >= 7.0 ? 0 : 64.f), self.frame.size.width, (self.m_ptxtvInput.frame.size.height + 11));
}

- (void) textViewDidChange:(UITextView *)textView
{
    [self callBackInputbarHeightAndCalculateTxtvHeight:self.m_ptxtvInput ShowKeyBoard:YES];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    [self callBackInputbarHeightAndCalculateTxtvHeight:self.m_ptxtvInput ShowKeyBoard:NO];
}

#pragma mark - Keyboard Notification
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //DLog(@"%@", NSStringFromCGRect(keyboardRect));
    
//    [UIView animateWithDuration:duration
//                          delay:0.0f
//                        options:[self animationOptionsForCurve:curve]
//                     animations:^{
//                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
//                         CGRect inputViewFrame = _inputView.frame;
//                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
//                         // for ipad modal form presentations
//                         CGFloat messageViewFrameBottom = _bkiew.frame.size.height - INPUT_HEIGHT;
//                         if(inputViewFrameY > messageViewFrameBottom) {
//                             inputViewFrameY = [UIScreen mainScreen].bounds.size.height - _inputView.frame.size.height;
//                         }
//                         
//                         
//                         _inputView.frame = CGRectMake(inputViewFrame.origin.x,
//                                                       inputViewFrameY,
//                                                       inputViewFrame.size.width,
//                                                       inputViewFrame.size.height);
//                         
//                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
//                                                                0.0f,
//                                                                self.view.frame.size.height - _inputView.frame.origin.y - INPUT_HEIGHT,
//                                                                0.0f);
//                         _tableView.contentInset = insets;
//                         _tableView.scrollIndicatorInsets = insets;
//                         [self scrollToBottomAnimated:YES];
//                     }
//                     completion:^(BOOL finished) {
//                     }];
}

- (void)callBackReturnEmojiMessage:(NSString *)pstrEmoji
{
    self.m_ptxtvInput.text = [self.m_ptxtvInput.text stringByAppendingString:pstrEmoji];
    
    float width = self.m_ptxtvInput.frame.size.width;
    float height = 0.0;
    
    CGSize sizeTxtv = [self.m_ptxtvInput sizeThatFits:CGSizeMake( width, 3000)];
    
    if (!self.m_ptxtvInput.text.length)
    {
        height = TXTVINPUT_HEIGHT_MIN;
    }
    else if (sizeTxtv.height < TXTVINPUT_HEIGHT_MIN)
    {
        height = TXTVINPUT_HEIGHT_MIN;
    }
    else if (sizeTxtv.height > TXTVINPUT_HEIGHT_MAX)
    {
        height = TXTVINPUT_HEIGHT_MAX;
    }
    else
    {
        height = sizeTxtv.height;
    }
    
    self.m_ptxtvInput.frame = CGRectMake( self.m_ptxtvInput.frame.origin.x, self.m_ptxtvInput.frame.origin.y, self.m_ptxtvInput.frame.size.width, height);
    
    if ( _delegate && [_delegate respondsToSelector:@selector(callBackInputBarFrame:)])
    {
//        [_delegate callBackInputBarFrame:CGRectMake( self.frame.origin.x, SCREEN_HEIGHT - (height + 11) - 216, self.frame.size.width, (height + 11))];
//        self.m_pECChatEmojiAndPictureView.frame = CGRectMake( 0, (height + 11), self.m_pECChatEmojiAndPictureView.frame.size.width, self.m_pECChatEmojiAndPictureView.frame.size.height);
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 播放接收音
+ (void)playMessageReceivedSound
{
    [ECChatInputView playSoundWithName:@"sound" type:@"m4r"];
}

#pragma mark - 播放音效
+ (void)playSoundWithName:(NSString *)name type:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *url = [NSURL fileURLWithPath:path];
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        AudioServicesPlaySystemSound(sound);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    else {
        NSLog(@"**** Sound Error: file not found: %@", path);
    }
}

@end
