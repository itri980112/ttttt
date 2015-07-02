//
//  ECChatTableCell.m
//  ECChatBubbleView
//
//  Created by Soul on 2014/5/25.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import "ECChatTableCell.h"
#import "NSDate-Helper.h"

#import "RegexKitLite.h"
#import "SCGIFImageView.h"
#import "CustomLongPressGestureRecognizer.h"
#import "SBJson.h"

@implementation ECChatTableCell

- (void)awakeFromNib
{
    _m_pMSGData = [[NSMutableDictionary alloc] init];
    
    /* 日期 */
    self.m_plblDate = [[UILabel alloc] init];
//    self.m_plblDate.autoresizingMask = self.autoresizingMask;
    [self.m_plblDate setTextColor:[UIColor blackColor]];
    [self.m_plblDate setBackgroundColor:[UIColor clearColor]];
    [self.m_plblDate setFont:[UIFont systemFontOfSize:12]];
    [self.m_plblDate setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.m_plblDate];
    
    /* 裝載內容的View */
    self.m_pContentView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.m_pContentView.autoresizingMask = self.autoresizingMask;
    [self.m_pContentView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.m_pContentView];
    
    /* 讀取狀態 */
    self.m_plblRead = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.m_plblRead.autoresizingMask = self.autoresizingMask;
    [self.m_plblRead setBackgroundColor:[UIColor clearColor]];
    [self.m_plblRead setFont:[UIFont systemFontOfSize:8]];
    [self.m_plblRead setText:@"未讀取"];
    [self.m_plblRead sizeToFit];
    [self.m_pContentView addSubview:self.m_plblRead];
    
    /* 訊息時間 */
    self.m_plblTime = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.m_plblTime.autoresizingMask = self.autoresizingMask;
    [self.m_plblTime setBackgroundColor:[UIColor clearColor]];
    [self.m_plblTime setFont:[UIFont systemFontOfSize:8]];
    [self.m_plblTime setText:@"12:00"];
    [self.m_plblTime sizeToFit];
    [self.m_pContentView addSubview:self.m_plblTime];
    
    /* 顯示訊息的框架 */
    self.m_plblMSG = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
//    self.m_plblMSG.autoresizingMask = self.autoresizingMask;
    [self.m_plblMSG setDelegate:self];
    [self.m_plblMSG setHidden:YES];
    [self.m_pContentView addSubview:self.m_plblMSG];
    
    /* 顯示圖片的框架 */
    self.m_pimgPIC = [[UIImageView alloc] initWithFrame:CGRectZero];
//    self.m_pimgPIC.autoresizingMask = self.autoresizingMask;
    [self.m_pimgPIC setHidden:YES];
    [self.m_pContentView addSubview:self.m_pimgPIC];
    
    
    /* 汽泡框 */
    self.m_pimgBubble = [[UIImageView alloc] initWithFrame:CGRectZero];
//    self.m_pimgBubble.autoresizingMask = self.autoresizingMask;
    [self.m_pimgBubble setBackgroundColor:[UIColor clearColor]];
    [self.m_pContentView insertSubview:self.m_pimgBubble atIndex:0];
    
    /* 長壓手勢 */
    self.recognizer = [[CustomLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.recognizer setMinimumPressDuration:1];
    [self.m_pContentView addGestureRecognizer:self.recognizer]; /* 長壓對象目標 */
    [self.recognizer setLabel:self.m_plblMSG];

    
    
    //self.contentView.backgroundColor = [UIColor colorWithRed:0.3 green:arc4random()%1000/1000.00 blue:arc4random()%1000/1000.00 alpha:0.5];

}

#pragma mark - 初始化

- (void) setInitial
{
//    self.m_eECSourceType = [_m_pMSGData[@"TYPE"] intValue];
//    
    self.m_eECAvatarType = [_m_pMSGData[@"Send"] integerValue];
    
    NSString *pstrJSON = _m_pMSGData[@"Msg"];
    
    NSDictionary *pDic = [pstrJSON JSONValue];
    
    NSInteger nType = [[pDic objectForKey:@"type"] integerValue];
    NSString *pstrBody = [pDic objectForKey:@"body"];
    
    
//    NSMutableDictionary *pdicTemp = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FaceList" ofType:@"plist"]];
//    
//    for (NSString *string in [pdicTemp allKeys])
//    {
//        self.m_pstrMSG = [self.m_pstrMSG stringByReplacingOccurrencesOfString:pdicTemp[string] withString:string];
//    }
    
//    self.m_pstrDate = _m_pMSGData[@"Timestamp"];
    
    NSString *pstrTimeStamp = _m_pMSGData[@"Timestamp"];
    
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"HH:mm"];
    self.m_pstrTime = [pFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[pstrTimeStamp floatValue]]];
    
    
    
//    
//    NSString *pstrRead = _m_pMSGData[@"READDATE"];
//    
//    if (pstrRead.length)
//    {
//        self.m_pstrRead = @"已讀取";
//    }
//    else
//    {
//        self.m_pstrRead = @"未讀取";
//    }
//
    
    if ( nType == 0 )
    {
        self.m_pstrMSG = pstrBody;
        [self setContentWhenSourceMessageData];
    }
    else if ( nType == 1 )
    {
        self.m_pstrMSG = pstrBody;
        [self setContentWhenSourceImageData];
    }
    
    if (self.m_eECSourceType == ECSourceTypeOfMessage)
    {
        
    }
    else
    {
    
    }
}



#pragma mark - 轉換

- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label
{
    /* 取得表情符號的對照清單 */
    NSDictionary *pdicTemp = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Face" ofType:@"plist"]];
    self.m_pdicEmoji = [[NSDictionary alloc] initWithObjects:pdicTemp[@"Values@2x"] forKeys:pdicTemp[@"Keys"]];
    
    [label setNeedsDisplay];
    
    NSMutableArray *httpArr = [CustomMethod addHttpArr:o_text];
    NSMutableArray *phoneNumArr = [CustomMethod addPhoneNumArr:o_text];
//    NSMutableArray *emailArr = [CustomMethod addEmailArr:o_text];
    
    NSString *text = [CustomMethod transformString:o_text emojiDic:self.m_pdicEmoji];
    text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
    
    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup:text];
    [attString setFont:[UIFont systemFontOfSize:14]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setAttString:attString withImages:wk_markupParser.images];
    
    NSString *string = attString.string;
    
//    if ([emailArr count]) {
//        for (NSString *emailStr in emailArr) {
//            [label addCustomLink:[NSURL URLWithString:emailStr] inRange:[string rangeOfString:emailStr]];
//        }
//    }
    
    if ([phoneNumArr count])
    {
        for (NSString *phoneNum in phoneNumArr)
        {
            [label addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
        }
    }
    
    if ([httpArr count])
    {
        for (NSString *httpStr in httpArr) {
            [label addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
        }
    }
    
    label.delegate = self;
    CGRect labelRect = label.frame;
    labelRect.size.width = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    label.frame = labelRect;
    label.underlineLinks = YES;//链接是否带下划线
    [label.layer display];
}

- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    _requestURL = linkInfo.URL;
    
    if ([[UIApplication sharedApplication] canOpenURL:_requestURL])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系統訊息" message:[NSString stringWithFormat:@"開啟連結？\n%@", linkInfo.URL] delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"開啟", nil];
        
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系統訊息" message:[NSString stringWithFormat:@"無法開啟連結\n%@", linkInfo.URL] delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        
        [alert show];
    }
    
    return NO;
}

-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowPhone:(NSTextCheckingResult*)linkInfo
{
    
    _requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",linkInfo.phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:_requestURL])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系統訊息" message:[NSString stringWithFormat:@"是否撥打?\n%@", linkInfo.phoneNumber] delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"撥打", nil];
        
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系統訊息" message:[NSString stringWithFormat:@"無法撥打\n%@", linkInfo.phoneNumber] delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        
        [alert show];
    }
    
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:_requestURL];
    }
    else
    {
        
    }
}

#pragma mark - 訊息來源為文字

- (void) setContentWhenSourceMessageData
{
    CGFloat screenWidth;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        screenWidth = 768;
    }
    else {
        screenWidth = 320;
    }
    
    
    if (self.m_pstrDate.length)
    {
        [self.m_plblDate setFrame:CGRectMake( 0, 0, screenWidth, 30)];
        [self.m_plblDate setText:self.m_pstrDate];
    }
    else
    {
        [self.m_plblDate setFrame:CGRectMake( 0, 0, screenWidth, 10)];
        [self.m_plblDate setText:@""];
    }
    
    float originX = floorf(self.m_eECAvatarType == ECAvatarTypeOfMine ? 60 : 20 );
    float originY = CGRectGetMaxY(self.m_plblDate.frame) + 5;

    /* OHAttributedLabel */
    
    [self creatAttributedLabel:self.m_pstrMSG Label:self.m_plblMSG];
    [CustomMethod drawImage:self.m_plblMSG];
    
    [self.m_plblMSG setHidden:NO];
    [self.m_plblMSG setFrame:CGRectMake( 0, 0, self.m_plblMSG.frame.size.width, self.m_plblMSG.frame.size.height)];
    
    self.m_pContentView.frame = CGRectMake( originX, originY, self.m_plblMSG.frame.size.width, self.m_plblMSG.frame.size.height);
    
    if (self.m_eECAvatarType == ECAvatarTypeOfMine)
    {
        self.m_pContentView.frame = CGRectMake( screenWidth - 20 - self.m_pContentView.frame.size.width, self.m_pContentView.frame.origin.y, self.m_pContentView.frame.size.width, self.m_pContentView.frame.size.height);
    }
    else
    {
        
    }
    
    [self setBubbleForTargetView:self.m_pContentView SourceFrom:self.m_eECAvatarType];
    
    [self setReadForTargetView:self.m_pContentView SourceFrom:self.m_eECAvatarType];
    
    [self setTimeForTargetView:self.m_pContentView SourceFrom:self.m_eECAvatarType];
    
}

#pragma mark - 訊息來源為圖片

- (void) setContentWhenSourceImageData
{
    CGFloat screenWidth;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        screenWidth = 768;
    }
    else {
        screenWidth = 320;
    }

    if (self.m_pstrDate.length)
    {
        [self.m_plblDate setFrame:CGRectMake( 0, 0, screenWidth, 30)];
        [self.m_plblDate setText:self.m_pstrDate];
    }
    else
    {
        [self.m_plblDate setFrame:CGRectMake( 0, 0, screenWidth, 10)];
        [self.m_plblDate setText:@""];
    }
    
    float originX = floorf(self.m_eECAvatarType == ECAvatarTypeOfMine ? 60 : 20 );
    float originY = CGRectGetMaxY(self.m_plblDate.frame) + 5;
    float imgEdge = 140;
    
    self.m_pContentView.frame = CGRectMake( originX, originY, imgEdge, imgEdge);
    
    [self.m_pimgPIC setHidden:NO];
    [self.m_pimgPIC setFrame:CGRectMake( 0, 0, self.m_pContentView.frame.size.width, self.m_pContentView.frame.size.height)];
    
    if (![self.subviews containsObject:self.m_pImgSync])
    {
        /* Cache */
        self.m_pImgSync = [[AsyncImageView alloc] initWithFrame:self.m_pimgPIC.bounds];
        self.m_pImgSync.imageCache = [RHAppDelegate sharedDelegate].m_pImageCache;
        [self.m_pImgSync setBackgroundColor:[UIColor clearColor]];
        [self.m_pimgPIC addSubview:_m_pImgSync];
    }
    
    [self.m_pImgSync loadImageFromURL:[NSURL URLWithString:self.m_pstrMSG]];

    
    if (self.m_eECAvatarType == ECAvatarTypeOfMine)
    {
        self.m_pContentView.frame = CGRectMake( screenWidth - 20 - self.m_pContentView.frame.size.width, self.m_pContentView.frame.origin.y, imgEdge, imgEdge);
    }
    else
    {
        //無需變動
    }
    
    /* 圖片不需要汽泡框 */
    //[self setBubbleForTargetView:self.m_pContentView SourceFrom:self.m_eECAvatarType];
    
    [self setReadForTargetView:self.m_pContentView SourceFrom:self.m_eECAvatarType];
    [self setTimeForTargetView:self.m_pContentView SourceFrom:self.m_eECAvatarType];
}

#pragma mark - 替Cell建立泡泡框

- (void) setBubbleForTargetView:(UIView *)view SourceFrom:(ECAvatarType)eECAvatarType
{
    if (self.m_eECAvatarType == ECAvatarTypeOfMine)
    {
        
        [self.m_plblMSG setTextColor:UIColorFromRGB(0XFFFFFF)];
        
        self.m_pimgBubble.image = [[UIImage imageNamed:@"outgoing.png"] stretchableImageWithLeftCapWidth:22 topCapHeight:16];
        self.m_pimgBubble.frame = CGRectMake(0 - 9, 0 - 7, view.frame.size.width + 25, view.frame.size.height + 15);
    }
    else
    {
        [self.m_plblMSG setTextColor:UIColorFromRGB(0X6E6E6E)];
        self.m_pimgBubble.image = [[UIImage imageNamed:@"incoming.png"] stretchableImageWithLeftCapWidth:22 topCapHeight:16];
        self.m_pimgBubble.frame = CGRectMake(0 - 15, 0 - 7, view.frame.size.width + 25, view.frame.size.height + 15);
    }
}

#pragma mark - 讀取狀態

- (void) setReadForTargetView:(UIView *)view SourceFrom:(ECAvatarType)eECAvatarType
{
    [self.m_plblRead setText:self.m_pstrRead];
    
    if (self.m_eECAvatarType == ECAvatarTypeOfMine)
    {
        self.m_plblRead.frame = CGRectMake(0 - (self.m_plblRead.frame.size.width + 15), view.frame.size.height - self.m_plblRead.frame.size.height - 5, self.m_plblRead.frame.size.width, self.m_plblRead.frame.size.height);
        
        self.m_plblRead.hidden = YES;
    }
    else
    {
        self.m_plblRead.frame = CGRectMake( view.frame.size.width + 15, view.frame.size.height - self.m_plblRead.frame.size.height - 5, self.m_plblRead.frame.size.width, self.m_plblRead.frame.size.height);
        
        self.m_plblRead.hidden = YES;
    }
    
}

#pragma mark - 訊息時間

- (void) setTimeForTargetView:(UIView *)view SourceFrom:(ECAvatarType)eECAvatarType
{
    [self.m_plblTime setText:self.m_pstrTime];
    
    if (self.m_eECAvatarType == ECAvatarTypeOfMine)
    {
        self.m_plblTime.frame = CGRectMake(0 - (self.m_plblTime.frame.size.width + 15), view.frame.size.height - 5, self.m_plblTime.frame.size.width, self.m_plblTime.frame.size.height);
    }
    else
    {
        self.m_plblTime.frame = CGRectMake( view.frame.size.width + 15, view.frame.size.height - 5, self.m_plblTime.frame.size.width, self.m_plblTime.frame.size.height);
    }
}

#pragma mark - 長壓手勢的Action

- (void)longPress:(CustomLongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (self.m_eECSourceType == ECSourceTypeOfMessage)
        {
            [self becomeFirstResponder];
            
            if ([self canBecomeFirstResponder])
            {
                UIMenuController *menu = [UIMenuController sharedMenuController];
                
                //UIMenuItem *saveItem = [[UIMenuItem alloc] initWithTitle:@"儲存" action:@selector(copy:)];
                
                //[menu setMenuItems:[NSArray arrayWithObjects:saveItem, nil]];
                
                //CGRect targetRect = [self convertRect:gestureRecognizer.view.frame fromView:gestureRecognizer.view.superview];
                
                [menu setTargetRect:gestureRecognizer.view.frame inView:gestureRecognizer.view.superview];
                [menu setMenuVisible:YES animated:YES];
                [menu update];
                
            }
            else
            {
                UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:nil message:@"無法呼叫選單" delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
                [alert2 show];
                
            }
        }
        else
        {
            
        }
    }
    else
    {
        
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    BOOL result = NO;
    if(@selector(copy:) == action) {
        result = YES;
    }
    return result;
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.m_pstrMSG];
    [self resignFirstResponder];
}

#pragma mark - 回傳訊息高度

+ (CGFloat) neededHeightForImageData:(NSMutableDictionary *)messageData
{
    NSString *date = messageData[@"TimeStamp"];

    if (date.length)
    {
        return 150 + 30;         //假設含有時間的圖片高度
    }
    else
    {
        return 150 + 10;         //假設未含有時間的圖片高度
    }
}

#pragma mark - 回傳圖片高度

+ (CGFloat) neededHeightForMessageData:(NSMutableDictionary *)messageData
{
    NSString *pstrMsg = messageData[@"Msg"];
    
    NSMutableDictionary *pdicTemp = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FaceList" ofType:@"plist"]];
    
    for (NSString *string in [pdicTemp allKeys])
    {
        pstrMsg = [pstrMsg stringByReplacingOccurrencesOfString:pdicTemp[string] withString:string];
    }
    
    NSString *date = messageData[@"TimeStamp"];
    
    OHAttributedLabel *plabel = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
    
    [[ECChatTableCell alloc] creatAttributedLabel:pstrMsg Label:plabel];
    [CustomMethod drawImage:plabel];
    [plabel setFrame:CGRectMake( 0, 0, plabel.frame.size.width, plabel.frame.size.height)];
    
    if (date.length)
    {
        return plabel.frame.size.height + 30 + 20;
    }
    else
    {
        return plabel.frame.size.height + 10 + 20;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
