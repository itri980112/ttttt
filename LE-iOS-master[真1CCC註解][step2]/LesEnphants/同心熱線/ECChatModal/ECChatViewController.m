//
//  ECChatViewController.m
//  ECChatBubbleView
//
//  Created by Soul on 2014/5/25.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import "ECChatViewController.h"

#import "NSDate-Helper.h"

#import "KeyboardStateListener.h"

@interface ECChatViewController ()

@end

@implementation ECChatViewController

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
    
    _m_pMessages = [[NSMutableArray alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    for (NSInteger index = 0; index < 8; index++)
//    {
//        NSMutableDictionary *pdicTemp = [[NSMutableDictionary alloc] init];
//        
//
//        NSInteger rand = index;
//        NSString *pstrMSG = @"";
//        
//        if (rand == 0)
//        {
//            pstrMSG = @"(laugh)(question)(what)(boy hi)(question)(laugh)(question)(what)(boy hi)(question)(laugh)(question)(what)(boy hi)(question)(laugh)(question)(what)(boy hi)(question)(laugh)(question)(what)(boy hi)(question)(laugh)(question)(what)(boy hi)(question)(laugh)(question)(what)(boy hi)(question)(laugh)(question)(what)(boy hi)(question)(laugh)(question)(what)(boy hi)(question)";
//            [pdicTemp setValue:@"20140717160000" forKeyPath:@"READDATE"];
//            [pdicTemp setValue:@"0" forKey:@"TYPE"];
//            [pdicTemp setValue:[NSString stringWithFormat:@"%d",arc4random()%2] forKey:@"Avatar"];
//        }
//        else if (rand == 1)
//        {
//            pstrMSG = @"http://tw.yahoo.com 02-87876969 0287876969 02 87876969";
//            [pdicTemp setValue:@"20140717160000" forKeyPath:@"READDATE"];
//            [pdicTemp setValue:@"0" forKey:@"TYPE"];
//            [pdicTemp setValue:[NSString stringWithFormat:@"%d",arc4random()%2] forKey:@"AVATAR"];
//        }
//        else if (rand == 2)
//        {
//            pstrMSG = @"http://tw.yahoo.com https://tw.news.yahoo.com/%E6%B0%A3%E7%88%86%E5%BE%8C%E9%82%84%E8%BE%A6%E5%93%A1%E5%B7%A5%E6%97%85%E9%81%8A-%E6%9D%8E%E9%95%B7%E6%A6%AE%E6%8C%A8%E6%89%B9-%E7%9C%9F%E6%98%AF%E7%99%BD%E7%9B%AE-012555626.html";
//            [pdicTemp setValue:@"20140717160000" forKeyPath:@"READDATE"];
//            [pdicTemp setValue:@"0" forKey:@"TYPE"];
//            [pdicTemp setValue:[NSString stringWithFormat:@"%d",arc4random()%2] forKey:@"AVATAR"];
//        }
//        else if (rand == 3)
//        {
//            pstrMSG = @"a";
//            [pdicTemp setValue:@"20140717160000" forKeyPath:@"READDATE"];
//            [pdicTemp setValue:@"0" forKey:@"TYPE"];
//            [pdicTemp setValue:[NSString stringWithFormat:@"%d",arc4random()%2] forKey:@"AVATAR"];
//        }
//        else if (rand == 4)
//        {
//            pstrMSG = @"我";
//            [pdicTemp setValue:@"20140717160000" forKeyPath:@"READDATE"];
//            [pdicTemp setValue:@"0" forKey:@"TYPE"];
//            [pdicTemp setValue:[NSString stringWithFormat:@"%d",arc4random()%2] forKey:@"AVATAR"];
//        }
//        else if (rand == 5)
//        {
//            pstrMSG = @"A32-260.png";
//            [pdicTemp setValue:@"20140717160000" forKeyPath:@"READDATE"];
//            [pdicTemp setValue:@"1" forKey:@"TYPE"];
//            [pdicTemp setValue:@"0" forKey:@"AVATAR"];
//        }
//        else if (rand == 6)
//        {
//            pstrMSG = @"A32-260.png";
//            [pdicTemp setValue:@"20140717160000" forKeyPath:@"READDATE"];
//            [pdicTemp setValue:@"1" forKey:@"TYPE"];
//            [pdicTemp setValue:@"1" forKey:@"AVATAR"];
//        }
//        else
//        {
//            pstrMSG = @"小語哥英雄聯盟小法整場不知道帶眼，顆顆。aklsjdklajsdkljasl(laugh)[难过](question)[尴尬](what)(boy hi)(question)http://tw.yahoo.com 小語哥英雄聯盟小法整場不知道帶眼，顆顆。電話02-87876969 aklsjdklajsdkljaslkdjalksjdlkasdasd";
//            [pdicTemp setValue:@"" forKeyPath:@"READDATE"];
//            [pdicTemp setValue:@"0" forKey:@"TYPE"];
//            [pdicTemp setValue:[NSString stringWithFormat:@"%d",arc4random()%2] forKey:@"Avatar"];
//        }
//        
//        [pdicTemp setValue:pstrMSG forKey:@"MSG"];
//        
//        [pdicTemp setValue:[NSDate stringFromDate:[NSDate date] withFormat:@"HH:mm"] forKeyPath:@"SENDDATE"];
//        
//        if (arc4random()%2 == 0)
//        {
//            [pdicTemp setValue:[NSDate stringFromDate:[NSDate date] withFormat:@"yyyy/MM/dd"] forKeyPath:@"DATE"];
//        }
//        
//        [_m_pMessages addObject:pdicTemp];
//    }
    
    if (![self.view.subviews containsObject:self.m_pECChatInputView])
    {
        self.m_pECChatInputView = [[[NSBundle mainBundle] loadNibNamed:@"ECChatInputView" owner:self options:nil] objectAtIndex:0];
        self.m_pECChatInputView.delegate = self;
        self.m_pECChatInputView.m_eECModeType = ECModeTypeOfNone;
        self.m_pECChatInputView.frame = CGRectMake( 0, SCREEN_HEIGHT - self.m_pECChatInputView.frame.size.height, self.m_pECChatInputView.frame.size.width, self.m_pECChatInputView.frame.size.height);
        [self.view addSubview:self.m_pECChatInputView];
    }
    
    if (![self.view.subviews containsObject:self.m_pECChatEAP])
    {
        self.m_pECChatEAP = [[[NSBundle mainBundle] loadNibNamed:@"ECChatEmojiAndPictureView" owner:self options:nil] objectAtIndex:0];
        self.m_pECChatEAP.frame = CGRectMake( 0, self.view.frame.size.height, self.m_pECChatEAP.frame.size.width, self.m_pECChatEAP.frame.size.height);
        self.m_pECChatEAP.delegate = self;
        self.m_pECChatEAP.m_eECEmoAndPicType = ECEmoAndPicTypeOfPicture;
        [self.view addSubview:self.m_pECChatEAP];
    }
    
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, self.m_pECChatInputView.frame.origin.y);

    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInputBarView)];
    
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInputBarView)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}



- (void) viewDidAppear:(BOOL)animated
{
    if (_tableView.contentSize.height > _tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLog(@"m_pMessages:%d", [self.m_pMessages count]);
    
    return [_m_pMessages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECSourceType eECSourceType = [[[_m_pMessages objectAtIndex:indexPath.row] objectForKey:@"TYPE"] intValue];
    
    if (eECSourceType == ECSourceTypeOfMessage)
    {
        return [ECChatTableCell neededHeightForMessageData:[_m_pMessages objectAtIndex:indexPath.row]];
    }
    else
    {
        return [ECChatTableCell neededHeightForImageData:[_m_pMessages objectAtIndex:indexPath.row]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"ECChatTableCell";
    
    ECChatTableCell *cell = (ECChatTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"ECChatTableCell" owner:self options:nil];
		for(id currentObject in nibObjects)
        {
			if([currentObject isKindOfClass:[ECChatTableCell class]])
            {
				cell = currentObject;
				break;
			}
		}
	}
    
    DLog(@"%@", [_m_pMessages objectAtIndex:indexPath.row]);
    
    cell.m_pMSGData = [_m_pMessages objectAtIndex:indexPath.row];
    
    [cell setInitial];
    
    return cell;
}


#pragma mark - Tableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}


#pragma mark - ECChat InputView Delegate

- (void) callBackInputBarFrame:(CGRect)frame
{
    [UIView animateWithDuration:0.2 animations:^{
        self.m_pECChatInputView.frame = frame;
        
        self.tableView.frame = CGRectMake( self.tableView.frame.origin.x, self.tableView.frame.origin.y,  self.tableView.frame.size.width, self.m_pECChatInputView.frame.origin.y);
    }];
    
    if (_tableView.contentOffset.y == (_tableView.contentSize.height - _tableView.frame.size.height) && _tableView.contentSize.height > _tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

- (void) callBackShowPicture:(ECModeType)eECModeType
{
    [UIView animateWithDuration:0.2 animations:^{
        self.m_pECChatInputView.frame = CGRectMake( self.m_pECChatInputView.frame.origin.x, SCREEN_HEIGHT - 216 - self.m_pECChatInputView.frame.size.height,  self.m_pECChatInputView.frame.size.width, self.m_pECChatInputView.frame.size.height);
        
        if (eECModeType == ECModeTypeOfPicture)
        {
            self.m_pECChatEAP.frame = CGRectMake( self.m_pECChatEAP.frame.origin.x, CGRectGetMaxY(self.m_pECChatInputView.frame), self.m_pECChatEAP.frame.size.width, self.m_pECChatEAP.frame.size.height);
        }
        else
        {
            self.m_pECChatEAP.frame = CGRectMake( 0, self.view.frame.size.height, self.m_pECChatEAP.frame.size.width, self.m_pECChatEAP.frame.size.height);
        }
        
        self.tableView.frame = CGRectMake( self.tableView.frame.origin.x, self.tableView.frame.origin.y,  self.tableView.frame.size.width, self.m_pECChatInputView.frame.origin.y);
    }];
    
    if (_tableView.contentOffset.y == (_tableView.contentSize.height - _tableView.frame.size.height) && _tableView.contentSize.height > _tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
    
}

- (void) callBackReturnInitial
{
    [UIView animateWithDuration:0.2 animations:^{
        self.m_pECChatInputView.frame = CGRectMake( self.m_pECChatInputView.frame.origin.x, SCREEN_HEIGHT - self.m_pECChatInputView.frame.size.height,  self.m_pECChatInputView.frame.size.width, self.m_pECChatInputView.frame.size.height);
        
        self.m_pECChatEAP.frame = CGRectMake( 0, self.view.frame.size.height, self.m_pECChatEAP.frame.size.width, self.m_pECChatEAP.frame.size.height);
        
        self.tableView.frame = CGRectMake( self.tableView.frame.origin.x, self.tableView.frame.origin.y,  self.tableView.frame.size.width, self.m_pECChatInputView.frame.origin.y);
    }];
    
    
    if (_tableView.contentOffset.y == (_tableView.contentSize.height - _tableView.frame.size.height) && _tableView.contentSize.height > _tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

- (void) callBackMessageData:(NSString *)pstrMSG MessageSendType:(ECMessageSourceType)eECMessageSourceType
{
    NSMutableDictionary *pdicData = [[NSMutableDictionary alloc] init];
    
    [pdicData setValue:pstrMSG forKeyPath:@"MSG"];
    [pdicData setValue:@"20140717160000" forKeyPath:@"READDATE"];
    [pdicData setValue:@"0" forKey:@"TYPE"];
    [pdicData setValue:@"1" forKey:@"Avatar"];
    [pdicData setValue:[NSDate stringFromDate:[NSDate date] withFormat:@"HH:mm"] forKeyPath:@"SDATE"];
    
    if (arc4random()%2 == 0)
    {
        [pdicData setValue:[NSDate stringFromDate:[NSDate date] withFormat:@"yyyy/MM/dd"] forKeyPath:@"Date"];
    }
    
    [_m_pMessages addObject:pdicData];
    
    [_tableView reloadData];
    [_tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    
    [ECChatInputView playMessageReceivedSound];
}

#pragma mark - ECChatEmojiAndPictureView Delegate

- (void) callBackReturnEmojiMessage:(NSString *)pstrEmoji
{
    NSMutableDictionary *pdicTemp = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FaceList" ofType:@"plist"]];
    
    NSString *pstrMSG = [[pdicTemp allKeysForObject:pstrEmoji] objectAtIndex:0];
    
    self.m_pECChatInputView.m_ptxtvInput.text = [self.m_pECChatInputView.m_ptxtvInput.text stringByAppendingString:pstrMSG];
    
    [self.m_pECChatInputView callBackInputbarHeightAndCalculateTxtvHeight:self.m_pECChatInputView.m_ptxtvInput ShowKeyBoard:YES];
    
    CGRect frame = self.m_pECChatInputView.m_ptxtvInput.frame;
    
    [self.m_pECChatInputView.m_ptxtvInput scrollRectToVisible:CGRectMake( frame.origin.x, self.m_pECChatInputView.m_ptxtvInput.contentSize.height - frame.size.height, frame.size.width, frame.size.height) animated:YES];
}

- (void) callBackDeleteButtonDidTapped
{
    NSString *nowMessage = self.m_pECChatInputView.m_ptxtvInput.text;
    
    if (nowMessage.length)
    {
        BOOL isPass = NO;
        
        NSMutableDictionary *pdicTemp = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FaceList" ofType:@"plist"]];
        
        for (NSInteger index = 0; index < [[pdicTemp allKeys] count]; index++) {
            
            
            NSString *string = [[pdicTemp allKeys] objectAtIndex:index];
            
            
            if (nowMessage.length >= string.length)
            {
                if ([[nowMessage substringWithRange:NSMakeRange(nowMessage.length - string.length, string.length)] isEqualToString:string]) {
                    
                    nowMessage = [nowMessage substringToIndex:nowMessage.length - string.length];
                    isPass = YES;
                    break;
                    
                }
                else if (!isPass && index == ([[pdicTemp allKeys] count] - 1) )
                {
                    
                    nowMessage = [nowMessage substringToIndex:nowMessage.length - 1];
                    break;
                    
                }
            }
        }
    }
    
    self.m_pECChatInputView.m_ptxtvInput.text = nowMessage;
}

#pragma mark - UISwipeGestureRecognizer

- (void) dismissInputBarView
{
    [self.m_pECChatInputView setDismissInputBarButtonDidTapped:nil];
}

@end
