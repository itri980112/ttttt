//
//  ECChatSymbolTypeView.h
//  SingleBank
//
//  Created by Soul on 2014/8/12.
//  Copyright (c) 2014年 Shinren Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ECChatSymbolTypeViewDelegate <NSObject>

@required

- (void) callBackHistoryinView:(UIView *)view;

- (void) callBackSymbolwithCategoryID:(NSInteger)cID inView:(UIView *)view;

@end

@interface ECChatSymbolTypeView : UIView

@property (nonatomic, assign) id<ECChatSymbolTypeViewDelegate> delegate;

@property (nonatomic, retain) NSMutableDictionary *m_pdicData;

@property (nonatomic, retain) IBOutlet UIImageView *m_pimgSymbol;

@property (nonatomic, retain) IBOutlet UIButton *m_pbtnSymbol;

- (void) setupInitial;

- (IBAction) setSymbolButtonDidTapped:(UIButton *)sender;

@end
