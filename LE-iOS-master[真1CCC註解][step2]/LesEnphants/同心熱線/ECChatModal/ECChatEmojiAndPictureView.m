//
//  ECChatEmojiAndPictureView.m
//  ECChatBubbleView
//
//  Created by Soul on 2014/8/8.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import "ECChatEmojiAndPictureView.h"

#import "User.h"
#import "APIClient.h"

@implementation ECChatEmojiAndPictureView

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
    /* 表情列表 */
    
    self.isHistory = NO;
    
    self.m_parrSymbol = [[NSMutableArray alloc] init];
    
    self.m_parrPhoto = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *pdicEmoji = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FaceList" ofType:@"plist"]];
    
    NSInteger numOfEmoji = [[pdicEmoji allKeys] count];
    
    for (NSInteger index = 0; index < numOfEmoji; index++)
    {
        NSInteger indexPage = index / 20;
        NSInteger indexRow = index % 20 % 7;
        NSInteger indexColumn = index % 20 / 7;
        
        ECChatEmojiTypeView *pECChatEmojiTypeView = [[[NSBundle mainBundle] loadNibNamed:@"ECChatEmojiTypeView" owner:self options:nil] objectAtIndex:0];
        [pECChatEmojiTypeView setDelegate:self];
        [pECChatEmojiTypeView.m_pbtnEmoji setTag:index + 1];
        [pECChatEmojiTypeView.m_pbtnEmoji setImage:[UIImage imageNamed:[NSString stringWithFormat:@"emoji_%03d.png", index + 1]] forState:UIControlStateNormal];
        [pECChatEmojiTypeView.m_pbtnEmoji setImage:[UIImage imageNamed:[NSString stringWithFormat:@"emoji_%03d.png", index + 1]] forState:UIControlStateSelected];
        
        [pECChatEmojiTypeView setFrame:CGRectMake(indexPage * 315 + indexRow * 45, indexColumn * 50 + 10, 45, 45)];
        [self.m_psclEmoji addSubview:pECChatEmojiTypeView];
    }
    
    for (NSInteger index = 0; index < (numOfEmoji / 20 + 1); index++ )
    {
        UIButton *pbtnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [pbtnDelete setFrame:CGRectMake(index * 315 + 6 * 45, 2 * 50 + 10, 45, 45)];
        [pbtnDelete setBackgroundImage:[UIImage imageNamed:@"chatroom_expression_delete.png"] forState:UIControlStateNormal];
        [pbtnDelete addTarget:self action:@selector(setDeleteButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.m_psclEmoji addSubview:pbtnDelete];
    }
    
    self.m_ppvEmoji.numberOfPages = numOfEmoji / 21 + 1;
    self.m_ppvEmoji.currentPage = 0;
    
    [self.m_psclEmoji setContentSize:CGSizeMake( self.m_psclEmoji.frame.size.width * self.m_ppvEmoji.numberOfPages, self.m_psclEmoji.frame.size.height)];
    
    [self setupInitial];
}

- (void) setupInitial
{
    [self setupUI];
    [self setupParam];
}

- (void) setupUI
{
    
}

- (void) setupParam
{
    [self setModeButtonDidTapped:nil];
}

- (void) createSymbolScroll
{
    for (UIView *view in self.m_psclBottom.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSInteger count = [self.m_parrSymbol count] + 1;
    
    for (NSInteger index = 0; index < count; index++)
    {
        ECChatSymbolTypeView *pECChatSymbolTypeView = [[[NSBundle mainBundle] loadNibNamed:@"ECChatSymbolTypeView" owner:self options:nil] objectAtIndex:0];
        [pECChatSymbolTypeView setDelegate:self];
        
        if (index != 0)
        {
            [pECChatSymbolTypeView setM_pdicData:[self.m_parrSymbol objectAtIndex:index - 1]];
        }
        
        [pECChatSymbolTypeView setTag:index];
        [pECChatSymbolTypeView setFrame:CGRectMake(index * 46, 0, 46, 44)];
        [pECChatSymbolTypeView setupInitial];
        
        if (index == 1)
        {
            [pECChatSymbolTypeView setSymbolButtonDidTapped:nil];
        }
        
        [self.m_psclBottom addSubview:pECChatSymbolTypeView];
    }
    
    [self.m_psclBottom setContentSize:CGSizeMake( count * 46, _m_psclBottom.frame.size.height)];
}

- (void) createPhotoScroll
{
    for (UIView *view in self.m_psclPicture.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSInteger count = [self.m_parrPhoto count];
    
    for (NSInteger index = 0; index < count; index++)
    {
        NSInteger iRow = (index / 4) % 2;
        NSInteger iColum = index % 4;
        NSInteger iPage = index / 8;
        
        ECChatPhotoTypeView *pECChatPhotoTypeView = [[[NSBundle mainBundle] loadNibNamed:@"ECChatPhotoTypeView" owner:self options:nil] objectAtIndex:0];
        [pECChatPhotoTypeView setDelegate:self];
        
        [pECChatPhotoTypeView setM_pdicData:[self.m_parrPhoto objectAtIndex:index]];
        
        [pECChatPhotoTypeView setTag:index];
        [pECChatPhotoTypeView setFrame:CGRectMake(iColum * 80 + iPage * 320, iRow * 80 + 6, 80, 80)];
        [pECChatPhotoTypeView setupInitial];
        
        [self.m_psclPicture addSubview:pECChatPhotoTypeView];
    }
    
    _m_ppvPicture.numberOfPages = ([self.m_parrPhoto count] / 8 + 1);
    
    _m_ppvPicture.currentPage = 0;
    
    [self.m_psclPicture setContentSize:CGSizeMake( ([self.m_parrPhoto count] / 8 + 1) * _m_psclPicture.frame.size.width, _m_psclPicture.frame.size.height)];
}

- (void) createPhotoScrollByHistory
{
    for (UIView *view in self.m_psclPicture.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSInteger count = [self.m_parrHistory count];
    
    if (count > 32)
    {
        count = 32;
    }
    
    for (NSInteger index = 0; index < count; index++)
    {
        NSInteger iRow = (index / 4) % 2;
        NSInteger iColum = index % 4;
        NSInteger iPage = index / 8;
        
        ECChatPhotoTypeView *pECChatPhotoTypeView = [[[NSBundle mainBundle] loadNibNamed:@"ECChatPhotoTypeView" owner:self options:nil] objectAtIndex:0];
        [pECChatPhotoTypeView setDelegate:self];
        
        [pECChatPhotoTypeView setM_pdicData:[self.m_parrHistory objectAtIndex:index]];
        
        [pECChatPhotoTypeView setTag:index];
        [pECChatPhotoTypeView setFrame:CGRectMake(iColum * 80 + iPage * 320, iRow * 80 + 6, 80, 80)];
        [pECChatPhotoTypeView setupInitial];
        
        [self.m_psclPicture addSubview:pECChatPhotoTypeView];
    }
    
    _m_ppvPicture.numberOfPages = ([self.m_parrHistory count] / 8 + 1);
    
    _m_ppvPicture.currentPage = 0;
    
    [self.m_psclPicture setContentSize:CGSizeMake( ([self.m_parrHistory count] / 8 + 1) * _m_psclPicture.frame.size.width, _m_psclPicture.frame.size.height)];
}


#pragma mark - Button Action Did Tapped

- (IBAction) setModeButtonDidTapped:(UIButton *)sender
{
    if (self.m_eECEmoAndPicType == ECEmoAndPicTypeOfEmoji)
    {
        self.m_eECEmoAndPicType = ECEmoAndPicTypeOfPicture;
    }
    else
    {
        self.m_eECEmoAndPicType = ECEmoAndPicTypeOfEmoji;
    }
    [self initialLayoutView:self.m_eECEmoAndPicType];
}

- (void) initialLayoutView:(ECEmoAndPicType)eECEmoAndPicType
{
    if (eECEmoAndPicType == ECEmoAndPicTypeOfEmoji)
    {
        self.m_pviewEmoji.hidden = NO;
        self.m_pviewPicture.hidden = YES;
    }
    else
    {
        self.m_pviewEmoji.hidden = YES;
        self.m_pviewPicture.hidden = NO;
    }
}

- (void) setDeleteButtonDidTapped:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(callBackDeleteButtonDidTapped)])
    {
        [_delegate callBackDeleteButtonDidTapped];
    }
}


#pragma mark - ECChatEmojiTypeView Delegate

- (void) callBackEmojiButton:(NSString *)pstrEmoji withTypeButtonTag:(NSInteger)iTag
{
    if (_delegate && [_delegate respondsToSelector:@selector(callBackReturnEmojiMessage:)])
    {
        [_delegate callBackReturnEmojiMessage:pstrEmoji];
    }
}

#pragma mark - ECChatSymbolTypeView Delegate

- (void) callBackSymbolwithCategoryID:(NSInteger)cID inView:(UIView *)view
{
    self.isHistory = NO;
    
    for (UIView *subview in _m_psclBottom.subviews)
    {
        if (subview == view)
        {
            ((ECChatSymbolTypeView *)subview).m_pbtnSymbol.selected = YES;
        }
        else
        {
            ((ECChatSymbolTypeView *)subview).m_pbtnSymbol.selected = NO;
        }
    }
    
    [self callAPIPic:cID];
    
}

- (void) callBackHistoryinView:(UIView *)view
{
    self.isHistory = YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/CommonPIC.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: filePath]) //檢查檔案是否存在
    {
        _m_parrHistory = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    else
    {
        _m_parrHistory = [[NSMutableArray alloc] init];
    }
    
    for (UIView *subview in _m_psclBottom.subviews)
    {
        if (subview == view)
        {
            ((ECChatSymbolTypeView *)subview).m_pbtnSymbol.selected = YES;
        }
        else
        {
            ((ECChatSymbolTypeView *)subview).m_pbtnSymbol.selected = NO;
        }
    }
    
    [self createPhotoScrollByHistory];
}

#pragma mark - ECChatPhotoTypeView Delegate

- (void) callBackPhotoWithData:(NSMutableDictionary *)pdicPIC inView:(UIView *)view
{
    for (UIView *subview in _m_psclPicture.subviews)
    {
        if (subview == view)
        {
            ((ECChatPhotoTypeView *)subview).m_pbtnPhoto.selected = YES;
        }
        else
        {
            ((ECChatPhotoTypeView *)subview).m_pbtnPhoto.selected = NO;
        }
    }
    
    NSString *pstrBPIC = pdicPIC[@"BPIC"];
    
    if (_delegate && [_delegate respondsToSelector:@selector(callBackReturnPhotoMessage:)])
    {
        [_delegate callBackReturnPhotoMessage:pstrBPIC];
    }
    
    if ([_m_parrHistory containsObject:pdicPIC])
    {
        NSInteger index = [_m_parrHistory indexOfObject:pdicPIC];
        [_m_parrHistory moveObjectAtIndex:index toIndex:0];
    }
    else
    {
        [_m_parrHistory insertObject:pdicPIC atIndex:0];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/CommonPIC.plist"];
    
    [_m_parrHistory writeToFile:filePath atomically:YES];
    
    if (self.isHistory == YES)
    {
        [self createPhotoScrollByHistory];
    }
}


#pragma mark - Call 貼圖 API

/**
 呼叫 pic.asp
 */
- (void)callAPIPic:(NSInteger)iCategoryID
{
    __weak User *user = [User sharedUser];
    
    //mypwdsave.asp 參數
    NSDictionary *params = @{@"UDID"        :   [user UDID],
                             @"APPID"       :   [user APPID],
                             @"CATEGORY_ID" :   @(iCategoryID),
                             };
    
    APIClient *api = [APIClient sharedClient];
    [api callAPIPic:params callback:^(APIClientResponseStatus status, NSDictionary *JSON)
    {
        
        if(status == APIClientResponseStatusSuccess)
        {
            _m_parrPhoto = JSON[@"DATA"];
            
            [self createPhotoScroll];
        }
        else
        {
            _m_parrPhoto = [[NSMutableArray alloc] init];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"貼圖取得失敗"
                                                          delegate:nil
                                                 cancelButtonTitle:@"確定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _m_psclEmoji)
    {
        _m_ppvEmoji.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
    else if (scrollView == _m_psclPicture)
    {
        _m_ppvPicture.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
