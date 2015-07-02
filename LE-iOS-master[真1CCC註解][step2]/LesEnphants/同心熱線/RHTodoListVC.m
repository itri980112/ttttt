//
//  RHTodoListVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/10/1.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHTodoListVC.h"
#import "RHAppDelegate.h"
#import "RHLesEnphantsAPI.h"
#import "LesEnphantsApiDefinition.h"
#import "GoldCoinAnimationVC.h"
#import "RHProfileObj.h"

@interface RHTodoListVC ()

@end

@implementation RHTodoListVC
@synthesize m_pDataArray;
@synthesize m_pMainTableView;
@synthesize m_pTFInputTodo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_pDataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_LINE_MAIN_ADDTODO", nil)];
    [self.m_pTFInputTodo setPlaceholder:NSLocalizedString(@"LE_LINE_MAIN_INPUTHINT", nil)];
    //Data
    [self.m_pDataArray addObject:NSLocalizedString(@"LE_LINE_TODO_S1", nil)];
    [self.m_pDataArray addObject:NSLocalizedString(@"LE_LINE_TODO_S2", nil)];
    [self.m_pDataArray addObject:NSLocalizedString(@"LE_LINE_TODO_S3", nil)];
    [self.m_pDataArray addObject:NSLocalizedString(@"LE_LINE_TODO_S4", nil)];
    [self.m_pDataArray addObject:NSLocalizedString(@"LE_LINE_TODO_S5", nil)];
    [self.m_pDataArray addObject:NSLocalizedString(@"LE_LINE_TODO_S6", nil)];
    [self.m_pDataArray addObject:NSLocalizedString(@"LE_LINE_TODO_S7", nil)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 -( void )dealloc
{
    [m_pDataArray release];
    [m_pMainTableView release];
    [m_pTFInputTodo release];
    [super dealloc];
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ShowAnimation
- (void)showAnimation:(NSInteger)point
{
    RHProfileObj *pObj = [RHProfileObj getProfile];
    if ( pObj.m_nType != 1 ) return;

    // 得到金幣,顯示動畫
    if (point >= kShowAnimationMinimumPoint) {
        GoldCoinAnimationVC *vc = nil;
        if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad) {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC~ipad" bundle:nil];
        }
        else {
            vc = [[GoldCoinAnimationVC alloc] initWithNibName:@"GoldCoinAnimationVC" bundle:nil];
        }
        
        vc.m_getPoint = point;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:^{
            [vc startAnimation];
        }];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *pstr = [m_pDataArray objectAtIndex:[indexPath row]];
    [self.m_pTFInputTodo setText:pstr];
    [self.m_pTFInputTodo becomeFirstResponder];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_pDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    // Configure the cell...
    
    NSUInteger nRow = [indexPath row];
    
    
    NSString *pstrTitle = [m_pDataArray objectAtIndex:nRow];
    [[cell textLabel] setText:pstrTitle];

    
    return cell;
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textField -> %ld", (long)textField.tag);
    
    
    [textField resignFirstResponder];
    
    //Send Match ID to get QrCode
    NSString *pstrText = [textField text];
    
    if ( ![pstrText compare:@"" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        //Call API
        
        NSDictionary *pParameter = [NSDictionary dictionaryWithObjectsAndKeys:pstrText,kToDo, nil];
        
            [RHAppDelegate showLoadingHUD];
            [RHLesEnphantsAPI AddNewTodo:pParameter Source:self];
    }

    
    return YES;
    
}


#pragma mark - Gateway
- ( void )callBackAddNewTotoStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSInteger point = [[pStatusDic objectForKey:@"Point"] integerValue];
        
        if (point >= kShowAnimationMinimumPoint) {
            [self showAnimation:point];
        }
        else {
            [RHAppDelegate MessageBox:@"新增待辦事項成功"];
        }
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }

    
    [RHAppDelegate hideLoadingHUD];
}

@end
