//
//  RHChatVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/10/23.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHChatVC.h"
#import "AsyncImageView.h"
#import "RHAppDelegate.h"
#import "Utilities.h"
#import "RHSQLManager.h"
#import "ECChatTableCell.h"
#import "SBJson.h"
#import "LesEnphantsApiDefinition.h"

@interface RHChatVC () < UIScrollViewDelegate >
{
    NSMutableArray      *m_pChatLogArray;
    BOOL                m_bIsEmotionViewShown;
    BOOL                m_bIsKeyBoardShown;
}

@property ( nonatomic, retain ) NSMutableArray      *m_pChatLogArray;

- ( void )showEmotionView:( BOOL )bAnimated;
- ( void )hideEmotionView:( BOOL )bAnimated;
- ( void )updateEmotionImage;
@end

@implementation RHChatVC
@synthesize m_pDataDic;
@synthesize m_pChatLogArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_pDataDic = nil;
        self.m_pChatLogArray = [NSMutableArray arrayWithCapacity:1];
        m_bIsEmotionViewShown = NO;
        m_bIsKeyBoardShown = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:UIColorFromRGB(0XF2EADC)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processRecieveNewMsg:) name:kReceiveRemoteMsg object:nil];
    
    [self registerForKeyboardNotifications];
    //Load Data
    if ( m_pDataDic )
    {
        [self.m_pLblName setText:[m_pDataDic objectForKey:@"nickname"]];
        
        
        NSString *pstrIconURL = [m_pDataDic objectForKey:@"photoUrl"];
        
        if ( [pstrIconURL compare:@""] != NSOrderedSame )
        {
            AsyncImageView *pView = [[AsyncImageView alloc] initWithFrame:self.m_pIconImageView.bounds];
            [pView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [self.m_pIconImageView addSubview:pView];
            [pView loadImageFromURL:[NSURL URLWithString:pstrIconURL]];
            [Utilities setRoundCornor3:self.m_pIconImageView];
        }
        
        
    }
    
    NSArray *pArray = [[RHSQLManager instance] getChatLogWithJID:[m_pDataDic objectForKey:@"jid"]];
    self.m_pChatLogArray = [NSMutableArray arrayWithArray:pArray];
    [self.m_pMainTableView reloadData];
    
    if ( [m_pChatLogArray count] > 0 )
    {
        NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:[pArray count]-1 inSection:0];
        [self.m_pMainTableView selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
    
    [self updateEmotionImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- ( void )showEmotionView:( BOOL )bAnimated
{
    //先放至定位
    CGRect kRect = self.m_pEmotionBgView.frame;
    kRect.origin.y = self.view.frame.size.height;
    [self.m_pEmotionBgView setFrame:kRect];
    
    CGRect containerFrame = self.m_pContainerView.frame;
    containerFrame.size.height -= self.m_pEmotionBgView.frame.size.height;
    
    if ( bAnimated )
    {
        [UIView beginAnimations:@"Move" context:nil];
    }
    
    kRect = self.m_pEmotionBgView.frame;
    kRect.origin.y = self.view.frame.size.height - kRect.size.height;
    [self.m_pEmotionBgView setFrame:kRect];
    [self.m_pContainerView setFrame:containerFrame];
    
    
    if ( bAnimated )
    {
        [UIView commitAnimations];
    }
    
}

- ( void )hideEmotionView:( BOOL )bAnimated
{
    //先放至定位
    CGRect kRect = self.m_pEmotionBgView.frame;
    kRect.origin.y = self.view.frame.size.height;

    
    CGRect containerFrame = self.m_pContainerView.frame;
    containerFrame.size.height += self.m_pEmotionBgView.frame.size.height;
    
    if ( bAnimated )
    {
        [UIView beginAnimations:@"Move" context:nil];
    }
    
    [self.m_pEmotionBgView setFrame:kRect];
    [self.m_pContainerView setFrame:containerFrame];

    
    if ( bAnimated )
    {
        [UIView commitAnimations];
    }
}

- ( void )updateEmotionImage
{
    if ( [[RHAppDelegate sharedDelegate].m_pEmotionArray count] > 0 )
    {
        NSArray *pEmotionArray = [[[RHAppDelegate sharedDelegate].m_pEmotionArray objectAtIndex:0] objectForKey:@"images"];
        
        NSInteger nCount = [pEmotionArray count];
        NSLog(@"nCount = %d", nCount);
        NSInteger nControlPage = ceilf(nCount / 6.0f );
        
        [self.m_pEmotionScrollView setContentSize:CGSizeMake(280*nControlPage, 120)];

        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            nControlPage = ceilf(nCount / 14.0f );
            [self.m_pEmotionScrollView setContentSize:CGSizeMake(728*nControlPage, 120)];
        }

        [self.m_pEmotionPageCtrl setNumberOfPages:nControlPage];
        [self.m_pEmotionPageCtrl setCurrentPage:0];
        
        
        NSInteger nPageSize = 280;
        NSInteger nXGap = 25;
        NSInteger nWidth = 60;
        NSInteger nHeight = 60;
        NSInteger nYGap = 0;
        NSInteger nStartX = 25;
        NSInteger nStartY = 0;
        
        for ( NSInteger i = 0; i < nCount; ++i )
        {
            UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [pBtn setTag:i];
            [pBtn addTarget:self action:@selector(postImage:) forControlEvents:UIControlEventTouchUpInside];
            [self.m_pEmotionScrollView addSubview:pBtn];
            CGRect kRect = CGRectMake(nStartX, nStartY, nWidth, nHeight);
            [pBtn setFrame:kRect];
            
            
            //Load Iamge
            NSString *pstrURL = [pEmotionArray objectAtIndex:i];
            
            AsyncImageView *pAsyncImg = [[AsyncImageView alloc] initWithFrame:pBtn.bounds];
            [pAsyncImg setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
            [pBtn addSubview:pAsyncImg];
            [pAsyncImg setUserInteractionEnabled:NO];
            [pAsyncImg loadImageFromURL:[NSURL URLWithString:pstrURL]];
            [pAsyncImg setBackgroundColor:[UIColor clearColor]];
            
            
            nStartX = nStartX + nWidth + nXGap;
            
            if ( i % 3 == 2 )
            {
                //換行
                NSInteger nPage = i / 6 ;
                nStartX = 25 + nPage * nPageSize;
                nStartY = nStartY + nYGap + nHeight;
            }
            
            if ( i % 6 == 5 )
            {
                //換頁
                NSInteger nPage = i / 6 + 1;
                nStartX = 25 + nPage * nPageSize;
                nStartY = 0;
            }
        }
        
    }
    
    
}

- ( IBAction )postImage:(id)sender
{
    NSInteger nTag = [( UIButton* )sender tag];
    if ( [[RHAppDelegate sharedDelegate].m_pEmotionArray count] > 0 )
    {
        NSArray *pEmotionArray = [[[RHAppDelegate sharedDelegate].m_pEmotionArray objectAtIndex:0] objectForKey:@"images"];
        
        NSString *pstrURL = [pEmotionArray objectAtIndex:nTag];
        
        
        NSString *pstrJID = [NSString stringWithFormat:@"%@@%@", [m_pDataDic objectForKey:@"jid"], kChatServer];
        
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        
        NSString *pstrBody = kChatMsg;
        pstrBody = [pstrBody stringByReplacingOccurrencesOfString:@"AAA" withString:@"1"];
        pstrBody = [pstrBody stringByReplacingOccurrencesOfString:@"BBB" withString:pstrURL];
        
        [body setStringValue:pstrBody];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:pstrJID];
        [message addChild:body];
        
        [[[RHAppDelegate sharedDelegate] xmppStream] sendElement:message];
        
        NSString *pstrTimeStamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
        
        //Insert to DB,對方的JID
        [[RHSQLManager instance] insetChatLog:[m_pDataDic objectForKey:@"jid"] Msg:pstrBody Timestamp:pstrTimeStamp MsgType:@"chat" Send:@"1"];
        
        [self processRecieveNewMsg:nil];
        
        [[RHSQLManager instance] insetChatJID:[m_pDataDic objectForKey:@"jid"] Timestamp:pstrTimeStamp LastMsg:pstrBody DisplayName:@""];

        
        
    }
}

#pragma mark - Notificatio
- ( void )processRecieveNewMsg:( NSNotification * )pNotification
{
    NSArray *pArray = [[RHSQLManager instance] getChatLogWithJID:[m_pDataDic objectForKey:@"jid"]];
    self.m_pChatLogArray = [NSMutableArray arrayWithArray:pArray];
    [self.m_pMainTableView reloadData];
    NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:[pArray count]-1 inSection:0];
    [self.m_pMainTableView selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}


#pragma mark - Customized Methods
- ( void )setupDataDic:( NSDictionary *)pDic
{
    self.m_pDataDic = pDic;
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self unRegisterForKeyboardNotifications];
    [self.navigationController popViewControllerAnimated:YES];
}

- ( IBAction )pressAddStickerBtn:(id)sender
{
    m_bIsEmotionViewShown = !m_bIsEmotionViewShown;
    
    if ( m_bIsKeyBoardShown )
    {
        [self.m_pTFChat resignFirstResponder];
    }
    
    
    if ( m_bIsEmotionViewShown )
    {
        [self showEmotionView:YES];
    }
    else
    {
        [self hideEmotionView:YES];
    }
}

- ( IBAction )pressSendBtn:(id)sender
{
    NSString *pstrInput = [self.m_pTFChat text];
    pstrInput = [pstrInput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( [pstrInput compare:@""] == NSOrderedSame )
    {
        return;
    }

    
    
    
    NSString *pstrJID = [NSString stringWithFormat:@"%@@%@", [m_pDataDic objectForKey:@"jid"], kChatServer];
    
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    
    NSString *pstrBody = kChatMsg;
    pstrBody = [pstrBody stringByReplacingOccurrencesOfString:@"AAA" withString:@"0"];
    pstrBody = [pstrBody stringByReplacingOccurrencesOfString:@"BBB" withString:[self.m_pTFChat text]];
    
    [body setStringValue:pstrBody];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:pstrJID];
    [message addChild:body];
    
    [[[RHAppDelegate sharedDelegate] xmppStream] sendElement:message];
    
    NSString *pstrTimeStamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    
    //Insert to DB,對方的JID
    [[RHSQLManager instance] insetChatLog:[m_pDataDic objectForKey:@"jid"] Msg:pstrBody Timestamp:pstrTimeStamp MsgType:@"chat" Send:@"1"];
    
    [self processRecieveNewMsg:nil];
    
    [[RHSQLManager instance] insetChatJID:[m_pDataDic objectForKey:@"jid"] Timestamp:pstrTimeStamp LastMsg:pstrBody DisplayName:@""];
    
    
    [self.m_pTFChat setText:@""];
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
    if ( m_bIsEmotionViewShown )
    {
        [self hideEmotionView:NO];
        m_bIsEmotionViewShown = NO;
    }
    
    m_bIsKeyBoardShown = YES;
    NSLog(@"m_pContainerView = %@", NSStringFromCGRect(self.m_pContainerView.frame));
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
    m_bIsKeyBoardShown = NO;
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


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_pChatLogArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *pDic = [m_pChatLogArray objectAtIndex:[indexPath row]];
    NSLog(@"pDic = %@", pDic);
    
    NSString *pstrMsg = [pDic objectForKey:@"Msg"];
    NSDictionary *pMsgDic = [pstrMsg JSONValue];
    NSInteger nType = [[pMsgDic objectForKey:@"type"] integerValue];
    
    CGFloat fHeight = 0;
    
    if ( nType == 0 )
    {
        fHeight = [ECChatTableCell neededHeightForMessageData:[m_pChatLogArray objectAtIndex:[indexPath row]]];
    }
    else
    {
        fHeight = [ECChatTableCell neededHeightForImageData:[m_pChatLogArray objectAtIndex:[indexPath row]]];
        NSLog(@"fHeight = %f", fHeight);
    }
    
    

    return fHeight;
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
    

    
    cell.m_pMSGData = [m_pChatLogArray objectAtIndex:[indexPath row]];
    
    
    [cell setInitial];
    [cell setBackgroundColor:UIColorFromRGB(0XF2EADC)];
    return cell;
    
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    NSUInteger nRow = [indexPath row];
    
    NSDictionary *pDic = [m_pChatLogArray objectAtIndex:nRow];
    
    
    [cell.textLabel setText:[pDic objectForKey:@"Msg"]];
    
    NSInteger nSend = [[pDic objectForKey:@"Send"] integerValue];
    
    if ( nSend == 0 )
    {
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    }
    else
    {
        [cell.textLabel setTextAlignment:NSTextAlignmentRight];
    }
    
    
    return cell;
    */
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger nPage = scrollView.contentOffset.x / 280.0f;
    [self.m_pEmotionPageCtrl setCurrentPage:nPage];
}

@end
