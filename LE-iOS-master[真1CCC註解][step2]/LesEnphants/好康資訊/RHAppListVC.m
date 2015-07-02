//
//  RHAppListVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/9/17.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHAppListVC.h"
#import "RHAppListCell.h"
#import "RHAppDelegate.h"

@interface RHAppListVC () < RHAppListCellDelegate >
{
    NSArray     *m_pDataArray;
}

@property ( nonatomic, retain ) NSArray        *m_pDataArray;

@end


@implementation RHAppListVC
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


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = [m_pDataArray count];
    
    
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RHAppListCellIdentifier = @"RHAppListCellIdentifier";
    
    RHAppListCell *cell = [tableView dequeueReusableCellWithIdentifier:RHAppListCellIdentifier];
    if (cell == nil)
    {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *pArray =  [[NSBundle mainBundle] loadNibNamed:@"RHAppListCell" owner:self options:nil];
        
        for ( id oneView in pArray )
        {
            if ( [oneView isKindOfClass:[RHAppListCell class]] )
            {
                cell = oneView;
                cell.tag = indexPath.row;
            }
        }
    }
    
    // Configure the cell...
    
    NSUInteger nRow = [indexPath row];
    
    
    NSDictionary *pDic = [m_pDataArray objectAtIndex:nRow];
    [cell setupDataDic:pDic];
    [cell setDelegate:self];
    [cell updateUI];
    
    return cell;
    
}


#pragma mark - RHAppListCell Delegate
- ( void )callBackSelectedTag:( NSInteger )nIdx
{
    NSDictionary *pDic = [m_pDataArray objectAtIndex:nIdx];
    
    NSString *pstrURL = [pDic objectForKey:@"ios_url"];
    NSURL *pURL = [NSURL URLWithString:pstrURL];
    
    if ( [[UIApplication sharedApplication] canOpenURL:pURL] )
    {
        [[UIApplication sharedApplication] openURL:pURL];
    }
    else
    {
        [RHAppDelegate MessageBox:@"下載連結錯誤"];
    }
    
}

@end
