//
//  RHChooseFriendsVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/10/13.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHChooseFriendsVC.h"
#import "RHChooseFriendCell.h"
#import "RHAppDelegate.h"
#import "RHProfileObj.h"

@interface RHChooseFriendsVC ()
{
    NSMutableArray      *m_pDataArray;
}

@property (nonatomic, retain ) NSMutableArray      *m_pDataArray;

@end



@implementation RHChooseFriendsVC
@synthesize m_pDataArray;

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
    

    
    NSArray *pArray = [RHAppDelegate sharedDelegate].m_pRHProfileObj.m_pFriendsArray;
    
    
    for ( NSInteger i = 0; i < [pArray count]; ++i )
    {
        NSDictionary *pDic = [pArray objectAtIndex:i];
        NSInteger nTYpe = [[pDic objectForKey:@"type"] integerValue];
        //爸爸不能加進去
        if ( nTYpe != 2 )
        {
            [m_pDataArray addObject:pDic];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [m_pDataArray release];
    [_m_pMainrTableView release];
    [super dealloc];
}


#pragma mark - IBAction
- ( IBAction )pressBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = [m_pDataArray count];
    
    NSLog(@"nCount = %d", nCount);
    
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RHChooseFriendCellIdentifier = @"RHChooseFriendCellIdentifier";
    
    RHChooseFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:RHChooseFriendCellIdentifier];
    if (cell == nil)
    {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *pArray =  [[NSBundle mainBundle] loadNibNamed:@"RHChooseFriendCell" owner:self options:nil];
        
        for ( id oneView in pArray )
        {
            if ( [oneView isKindOfClass:[RHChooseFriendCell class]] )
            {
                cell = oneView;
            }
        }
    }
    
    // Configure the cell...
    
    NSUInteger nRow = [indexPath row];
    
    NSDictionary *pDic = [m_pDataArray objectAtIndex:nRow];
    
    [cell setM_pMainDic:pDic];
    [cell updateUI];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RHChooseFriendCell *cell = (RHChooseFriendCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    BOOL bIsHighlight = cell.m_bIsHighlight;
    NSDictionary *pDic = [m_pDataArray objectAtIndex:[indexPath row]];
    if ( bIsHighlight )
    {
        //從list 移掉
        [RHAppDelegate removefromHightLight:pDic];
    }
    else
    {
        // add to liset
        [RHAppDelegate addToHightLight:pDic];
    }
    
    [self.m_pMainrTableView reloadData];
}

@end
