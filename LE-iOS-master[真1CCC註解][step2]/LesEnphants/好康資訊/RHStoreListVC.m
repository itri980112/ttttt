//
//  RHStoreListVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/17.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHStoreListVC.h"
#import "RHCntWebView.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "RHStoreSubCell.h"

@interface RHStoreListVC ()
{
    NSArray     *m_pDataArray;
}

@property ( nonatomic, retain ) NSArray        *m_pDataArray;

@end

@implementation RHStoreListVC
@synthesize m_pDataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pDataArray = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.m_pMainTable.SKSTableViewDelegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void )dealloc
{
    [m_pDataArray release];
    [_m_pMainTable release];
    [super dealloc];
}

- ( void )setupData:( NSArray * )pArray
{
    self.m_pDataArray = pArray;
}

#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = [self.m_pDataArray count];
    NSLog(@"numberOfRowsInSection = %d", nCount);
    
    return nCount;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *pDic = [m_pDataArray objectAtIndex:indexPath.row];
    NSLog(@"numberOfSubRowsAtIndexPath = %@", pDic);
    NSArray *pArray = [pDic objectForKey:@"SubNews"];
    
    NSInteger nCount = [pArray count];
    
    return nCount;
    
    //return [self.m_pDataArray[indexPath.section][indexPath.row] count] - 1;
    //return [[[self.m_pDataArray objectAtIndex:indexPath.row] objectForKey:@"store"] count] ;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        return YES;
    }
    
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSDictionary *pDic = [m_pDataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [pDic objectForKey:@"subject"];
    [cell setBackgroundColor:[UIColor clearColor]];
//    if ((indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 0)) || (indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 2)))
//        cell.expandable = YES;
//    else
//        cell.expandable = NO;
    
    cell.expandable = YES;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RHStoreSubCellIdentifier = @"RHStoreSubCellIdentifier";
    
    RHStoreSubCell *cell = [tableView dequeueReusableCellWithIdentifier:RHStoreSubCellIdentifier];
    if (cell == nil)
    {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *pArray =  [[NSBundle mainBundle] loadNibNamed:@"RHStoreSubCell" owner:self options:nil];
        
        for ( id oneView in pArray )
        {
            if ( [oneView isKindOfClass:[RHStoreSubCell class]] )
            {
                cell = oneView;
            }
        }
    }
    
    
    NSDictionary *pDic = [m_pDataArray objectAtIndex:indexPath.row];
    NSArray *pArray = [pDic objectForKey:@"SubNews"];

    NSInteger nSubRow = [indexPath subRow]-1;

    
    NSDictionary *pSubDic = [[pArray objectAtIndex:nSubRow] objectForKey:@"meta"];
    
    
    BOOL bGovCard = [[pSubDic objectForKey:@"govCard"] boolValue];
    BOOL bBabyRoom = [[pSubDic objectForKey:@"babyRoom"] boolValue];
    BOOL bOutlet = [[pSubDic objectForKey:@"outlet"] boolValue];
    
    cell.m_bOutlet = bOutlet;
    cell.m_bGovCard = bGovCard;
    cell.m_bBabyRoom = bBabyRoom;
    
    cell.m_pLblContent.text = [[pArray objectAtIndex:nSubRow] objectForKey:@"subject"];
    
    NSDictionary *pMetaDic = [[pArray objectAtIndex:nSubRow] objectForKey:@"meta"];
    cell.m_pLblAddress.text = [pMetaDic objectForKey:@"address"];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell updateUI];
    
    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
    
    NSDictionary *pDic = [m_pDataArray objectAtIndex:indexPath.row];
    NSArray *pArray = [pDic objectForKey:@"SubNews"];
    
    NSInteger nSubRow = [indexPath subRow]-1;
    
    
    NSDictionary *pSubDic = [pArray objectAtIndex:nSubRow];
    
    //NSString *pstrURL = [pSubDic objectForKey:@"url"];
    
    RHCntWebView *pVC = [[RHCntWebView alloc] initWithNibName:@"RHCntWebView" bundle:nil];
    //[pVC setM_pstrURL:pstrURL];
    [pVC setM_pstrHtml:[pSubDic objectForKey:@"content"]];
    [pVC setM_pstrTitle:[pSubDic objectForKey:@"subject"]];
    [self.navigationController pushViewController:[pVC autorelease] animated:YES];
    
}


/*

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger nRow = [indexPath row];
    NSUInteger nSection = [indexPath section];
    
    NSDictionary *pDataDic = [m_pDataArray objectAtIndex:nSection];
    NSArray *pArray = [pDataDic objectForKey:@"store"];
    NSDictionary *pDic = [pArray objectAtIndex:nRow];

    NSString *pstrURL = [pDic objectForKey:@"url"];
    
    RHCntWebView *pVC = [[RHCntWebView alloc] initWithNibName:@"RHCntWebView" bundle:nil];
    [pVC setM_pstrURL:pstrURL];
    [pVC setM_pstrTitle:[pDic objectForKey:@"name"]];
    [self.navigationController pushViewController:[pVC autorelease] animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *pDic = [m_pDataArray objectAtIndex:section];
    
    return [pDic objectForKey:@"city"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger nCount = [m_pDataArray count];
    
    return nCount;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *pDic = [m_pDataArray objectAtIndex:section];
    
    NSArray *parray = [pDic objectForKey:@"store"];
    
    NSInteger nCount = [parray count];
    
    
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
    
    // Configure the cell...
    
    NSUInteger nRow = [indexPath row];
    NSUInteger nSection = [indexPath section];
    
    NSDictionary *pDataDic = [m_pDataArray objectAtIndex:nSection];
    NSArray *pArray = [pDataDic objectForKey:@"store"];
    NSDictionary *pDic = [pArray objectAtIndex:nRow];
    
    [[cell textLabel] setText:[pDic objectForKey:@"name"]];

    return cell;
    
}
*/

@end
