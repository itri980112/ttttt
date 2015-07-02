//
//  RHKnowledgeListVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/1.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHKnowledgeListVC.h"
#import "RHAppDelegate.h"
#import "RHKnowledgeContentVC.h"

@interface RHKnowledgeListVC ()

@end

@implementation RHKnowledgeListVC
@synthesize m_pDataArray;
@synthesize m_pstrTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pDataArray = nil;
        self.m_pstrTitle = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:m_pstrTitle];
    
    
    [RHAppDelegate hideLoadingHUD];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_m_pLblTitle release];
    [_m_pMainTable release];
    [m_pDataArray release];
    [super dealloc];
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger nRow = [indexPath row];
    
    NSDictionary *pDic = [m_pDataArray objectAtIndex:nRow];
    
    RHKnowledgeContentVC *pVC = [[[RHKnowledgeContentVC alloc] initWithNibName:@"RHKnowledgeContentVC" bundle:nil] autorelease];
    
    [pVC setM_pContentData:pDic];
    
    [self.navigationController pushViewController:pVC animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = [m_pDataArray count];
    NSLog(@"nCount = %d", nCount);
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    
    NSUInteger nRow = [indexPath row];
    
    NSDictionary *pDic = [m_pDataArray objectAtIndex:nRow];
    
    [cell.textLabel setText:[pDic objectForKey:@"subject"]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
    
}



@end
