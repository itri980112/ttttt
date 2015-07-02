//
//  ECChatViewController.h
//  ECChatBubbleView
//
//  Created by Soul on 2014/5/25.
//  Copyright (c) 2014年 Soul. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ECChatTableCell.h"

#import "ECChatInputView.h"

#import "ECChatEmojiAndPictureView.h"

@interface ECChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ECChatEmojiTypeViewDelegate>

@property (nonatomic, retain) NSMutableArray *m_pMessages;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) ECChatInputView *m_pECChatInputView;

@property (nonatomic, retain) ECChatEmojiAndPictureView *m_pECChatEAP;

@end
