//
//  RHActionSheet.m
//  iPolice
//
//  Created by Rusty Huang on 2014/9/26.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHActionSheet.h"

@interface RHActionSheet()
{
    id< RHActionSheetDelegate >     m_delegate;
    NSMutableArray                  *m_pOtherSelection;
    UIButton                        *m_pCancelButton;
    UIButton                        *m_pDistructiveButton;
    CGFloat                         m_fAlpha;
}

@property   id< RHActionSheetDelegate >     m_delegate;
@property ( nonatomic, retain )  NSMutableArray                  *m_pOtherSelection;
@property ( nonatomic, retain )  UIButton                        *m_pCancelButton;
@property ( nonatomic, retain )  UIButton                        *m_pDistructiveButton;

- ( void )setRoundConor:( id )oneView;
- ( void )closeView;
@end

@implementation RHActionSheet
@synthesize m_delegate;
@synthesize m_pOtherSelection;
@synthesize m_pCancelButton;
@synthesize m_pDistructiveButton;

#pragma mark - Inheritance

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_fAlpha = 0.0f;
    }
    return self;
}


- (id)initWithTitle:(NSString *)title delegate:(id<RHActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    self = [super init];
    
    if ( self )
    {
        
        m_delegate = delegate;
        //parse 參數
        va_list args;
        va_start(args, otherButtonTitles); // scan for arguments after firstObject.
        
        // get rest of the objects until nil is found
        NSMutableArray  *pParameterArray = [NSMutableArray arrayWithCapacity:1];
        
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*) )
        {
            [pParameterArray addObject:str];
        }
        
        NSLog(@"pParameterArray = %@", pParameterArray);
        
        
        //處理UI
        
        //整個ActionSheet的UI
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        //ActionSheet的背景色
        [self setBackgroundColor:[UIColor clearColor]];
        
        //AddButtons
        //1. CancelButton
        self.m_pCancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [m_pCancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [m_pCancelButton setBackgroundColor:[UIColor whiteColor]];
        [m_pCancelButton setFrame:CGRectMake(20, self.frame.size.height - 40 - 10, self.frame.size.width - 40, 40)];
        [self insertSubview:m_pCancelButton atIndex:0];
        [m_pCancelButton addTarget:self action:@selector(pressOKBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self setRoundConor:m_pCancelButton];
    
    }
    
    return self;
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.50f
                     animations:^{
                            [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                     }
                     completion:^(BOOL finished)
    {
        m_fAlpha = 0.30f;
        [self setNeedsDisplay];
                     }];
}

- ( void )closeView
{
    m_fAlpha = 0.0f;
    [self setNeedsDisplay];
    [UIView animateWithDuration:0.50f
                     animations:^{
                         [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                     }
                     completion:^(BOOL finished)
     {
         NSArray *pSubViews = [self subviews];
         
         for ( id oneView in pSubViews )
         {
             if ( [oneView isKindOfClass:[UIView class]] )
             {
                 UIView *pView = ( UIView * )oneView;
                 [pView removeFromSuperview];
             }
         }
         
     }];
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect bounds = self.bounds;
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:bounds];
    
    UIColor* fillColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: m_fAlpha];
    
    //// Rectangle Drawing
    [fillColor2 setFill];
    [rectanglePath fill];
    rectanglePath.lineWidth = 0;
    [rectanglePath stroke];
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    
    CGRect kRect = [view frame];
    
    kRect.origin.y = self.bounds.size.height - kRect.size.height - 60;
    kRect.origin.x = 5;
    kRect.size.width = self.frame.size.width - 10;
    [view setFrame:kRect];
    [view setBackgroundColor:[UIColor whiteColor]];
    NSLog(@"view -> %@", NSStringFromCGRect(kRect));
    
    [self setRoundConor:view];
    
    NSLog(@"addSubview");
}

#pragma mark - Event
- ( void )touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( m_delegate && [m_delegate respondsToSelector:@selector(actionSheetCancel:)])
    {
        [m_delegate actionSheetCancel:self];
    }
    
    [self closeView];
}

#pragma mark - Func
- ( void )setRoundConor:( id )oneView
{
    //設定圓角
    //設定邊框粗細
    [[oneView layer] setBorderWidth:0];
    
    //邊框顏色
    [[oneView layer] setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0].CGColor];
    
    //將超出邊框的部份做遮罩
    [[oneView layer] setMasksToBounds:YES];
    
    //設定被景顏色
    [[oneView layer] setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor];
    
    //設定圓角程度
    [[oneView layer] setCornerRadius:10];// 10是圓倒角、30是圓形
}


#pragma mark - IBAction
- ( IBAction )pressOKBtn:(id)sender
{
    UIButton *pBtn = ( UIButton * )sender;
    if ( m_delegate && [m_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)] )
    {
        [m_delegate actionSheet:self clickedButtonAtIndex:[pBtn tag]];
        [self closeView];
    }
}

@end
