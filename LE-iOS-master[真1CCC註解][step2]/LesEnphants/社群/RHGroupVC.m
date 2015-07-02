//
//  RHGroupVC.m
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/20.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import "RHGroupVC.h"
#import "RevealController.h"
#import "RHLesEnphantsAPI.h"
#import "RHAppDelegate.h"
#import "LesEnphantsApiDefinition.h"
#import "RHAssociationListVC.h"
#import "RHMyAssociationVC.h"
#import "RHAssociationDefinition.h"
#import "RHAssociationListCell.h"
#import "RHAssociationPostListVC.h"
#import "RHProfileObj.h"
#import "RHActionSheet.h"
#import "AsyncImageView.h"
#import "RHCreateAssociationVC.h"
#import "RHAssociationWebVC.h"

#define kStartTag       1000
#define kAreaTag        2000

@interface RHGroupVC () < RHActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource >
{
    NSMutableArray         *m_pAssociationListArray;
    NSMutableArray         *m_pAssociationTopListArray;
    NSInteger              m_nCurSelIdx;
}

@property ( nonatomic, retain ) NSMutableArray         *m_pAssociationListArray;
@property ( nonatomic, retain ) NSMutableArray         *m_pAssociationTopListArray;

@property ( nonatomic, retain ) NSMutableArray          *m_pCreatedArray;
@property ( nonatomic, retain ) NSMutableArray          *m_pJoinedArray;

- ( void )switchToTab1;
- ( void )switchToTab2;
- ( void )switchToTab3;
- ( void )switchToTab4;
- ( void )updateUI;
@end

@implementation RHGroupVC
@synthesize m_pAssociationListArray;
@synthesize m_pAssociationTopListArray;
@synthesize m_pRHMyAssociationVC;
@synthesize m_pRHCreateAssociationVC;
@synthesize m_pRHAssociationPostListVC;
@synthesize m_pMainPicker;
@synthesize m_pMainPicker2;
@synthesize m_pCreatedArray;
@synthesize m_pJoinedArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.m_pAssociationListArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pAssociationTopListArray = [NSMutableArray arrayWithCapacity:1];
        m_nCurSelIdx = 0;
        self.m_pRHMyAssociationVC = nil;
        self.m_pRHCreateAssociationVC = nil;
        self.m_pRHAssociationPostListVC = nil;
        self.m_pMainPicker = nil;
        self.m_pMainPicker2 = nil;
        
        self.m_pCreatedArray = [NSMutableArray arrayWithCapacity:1];
        self.m_pJoinedArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.m_pLblTitle setText:NSLocalizedString(@"LE_GROUP_MAIN_TITLE", nil)];
    [self.m_pLblBtn1 setText:NSLocalizedString(@"LE_GROUP_MAIN_ALL", nil)];
    [self.m_pLblBtn2 setText:NSLocalizedString(@"LE_GROUP_MAIN_HOT", nil)];
    [self.m_pLblBtn3 setText:NSLocalizedString(@"LE_GROUP_MAIN_SEARCH", nil)];
    [self.m_pLblBtn4 setText:NSLocalizedString(@"LE_GROUP_MYASSO_TITLE", nil)];
    [self.m_pLblKeywordTItle setText:NSLocalizedString(@"LE_GROUP_MAIN_KEYWORD", nil)];
    [self.m_pLblStarTitle setText:NSLocalizedString(@"LE_GROUP_MAIN_STAR", nil)];
    [self.m_pLblAreaTitle setText:NSLocalizedString(@"LE_GROUP_MAIN_AREA", nil)];
    
    
    UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
    [self.m_pNaviBar addGestureRecognizer:navigationBarPanGestureRecognizer];
    NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
	[navigationBarPanGestureRecognizer release];////CCC try
	NSLog(@"G count %ld",(long)[navigationBarPanGestureRecognizer retainCount]);
    [self.m_pBtnMenu addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self switchToTab1];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"isFirstRunAuthority"] == NO) {
        [defaults setObject:[NSDate date] forKey:@"isFirstRunAuthority"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self pressMyAuthorityBtn:nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - Private Methods
- ( void )switchToTab1
{
    if ( self.m_pSearchView.superview )
    {
        [self.m_pSearchView removeFromSuperview];
    }
    else if ( self.m_pGMainScrollView.superview )
    {
        [self.m_pGMainScrollView removeFromSuperview];
    }
    
    [self.m_pBtnTab1 setSelected:YES];
    [self.m_pBtnTab2 setSelected:NO];
    [self.m_pBtnTab3 setSelected:NO];
    [self.m_pBtnTab4 setSelected:NO];
    
    //Load List
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI getAssociationList:self];
    
}
- ( void )switchToTab2
{
    if ( self.m_pSearchView.superview )
    {
        [self.m_pSearchView removeFromSuperview];
    }
    else if ( self.m_pGMainScrollView.superview )
    {
        [self.m_pGMainScrollView removeFromSuperview];
    }
    
    [self.m_pBtnTab1 setSelected:NO];
    [self.m_pBtnTab2 setSelected:YES];
    [self.m_pBtnTab3 setSelected:NO];
    [self.m_pBtnTab4 setSelected:NO];
    
    //Load List
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI getAssociationTopList:self];
    
}
- ( void )switchToTab3
{
    if ( self.m_pGMainScrollView.superview )
    {
        [self.m_pGMainScrollView removeFromSuperview];
    }

    if ( self.m_pSearchView.superview == nil )
    {
        [self.m_pCntView addSubview:self.m_pSearchView];
        [self.m_pSearchView setFrame:self.m_pCntView.bounds];
    }
    
    [self.m_pBtnTab1 setSelected:NO];
    [self.m_pBtnTab2 setSelected:NO];
    [self.m_pBtnTab3 setSelected:YES];
    [self.m_pBtnTab4 setSelected:NO];
}
- ( void )switchToTab4
{
    [RHAppDelegate showLoadingHUD];
    [RHLesEnphantsAPI getMyAssociation:self];

    if ( self.m_pSearchView.superview )
    {
        [self.m_pSearchView removeFromSuperview];
    }
    
    if ( self.m_pGMainScrollView.superview == nil )
    {
        [self.m_pCntView addSubview:self.m_pGMainScrollView];
        [self.m_pGMainScrollView setFrame:self.m_pCntView.bounds];
    }
    
    [self.m_pBtnTab1 setSelected:NO];
    [self.m_pBtnTab2 setSelected:NO];
    [self.m_pBtnTab3 setSelected:NO];
    [self.m_pBtnTab4 setSelected:YES];
}

- ( void )updateUI
{
    if ( m_nStarIdx >= 0 && m_nChinaIdx >= 0 )
    {
        NSString *pstrClassify = [NSString stringWithFormat:@"%@, %@",g_pstrStart[m_nStarIdx], g_pstrChina[m_nChinaIdx]];
        [self.m_pBtnType setTitle:pstrClassify forState:UIControlStateNormal];
    }
    
    if ( m_nCityIdx >= 0 )
    {
        [self.m_pBtnCity setTitle:g_pstrCity[m_nCityIdx] forState:UIControlStateNormal];
    }
}

- ( void )updateMyGroup
{
    /*
    CGRect kRectCreated = self.m_pGCreatedView.frame;
    CGRect kRectJoined = self.m_pGJoinedView.frame;
    
    kRectCreated.origin.y = 0;
    NSInteger nTableViewHeightCreate = [m_pCreatedArray count] * 50;
    nTableViewHeightCreate = MAX(nTableViewHeightCreate, 200);
    kRectCreated.size.height = 8 + 44 + nTableViewHeightCreate;
    
    
    [self.m_pGCreatedView setFrame:kRectCreated];
    
    kRectJoined.origin.y = kRectCreated.origin.y + kRectCreated.size.height;
    NSInteger nTableViewHeightJoin = [m_pJoinedArray count] * 50;
    nTableViewHeightJoin = MAX(nTableViewHeightJoin, 200);
    kRectJoined.size.height = 8 + 44 + nTableViewHeightJoin;
    
    [self.m_pGJoinedView setFrame:kRectJoined];
    
    NSInteger nTotalHeight = kRectCreated.size.height + kRectJoined.size.height;
    
    [self.m_pGMainScrollView setContentSize:CGSizeMake(300, nTotalHeight)];
    */
    
    [self.m_pGCreatedTable reloadData];
    [self.m_pGJoinedTable reloadData];
}

#pragma mark - IBAction
- ( IBAction )pressTab1:(id)sender
{
    if ( [self.m_pBtnTab1 isSelected ] )
    {
        return;
    }
    
    [self switchToTab1];
    
}
- ( IBAction )pressTab2:(id)sender
{
    if ( [self.m_pBtnTab2 isSelected ] )
    {
        return;
    }
    
    [self switchToTab2];
}
- ( IBAction )pressTab3:(id)sender
{
    if ( [self.m_pBtnTab3 isSelected ] )
    {
        return;
    }
    
    [self switchToTab3];
}
- ( IBAction )pressTab4:(id)sender
{
    if ( [self.m_pBtnTab4 isSelected ] )
    {
        return;
    }
    
    [self switchToTab4];
}

- ( IBAction )pressMyAssociationBtn:(id)sender
{
    self.m_pRHMyAssociationVC = [[RHMyAssociationVC alloc] initWithNibName:@"RHMyAssociationVC" bundle:nil];
    [self.navigationController pushViewController:m_pRHMyAssociationVC animated:YES];
}

- ( IBAction )pressMyAuthorityBtn:(id)sender
{
    RHAssociationWebVC *webVC = [[RHAssociationWebVC alloc] initWithNibName:@"RHAssociationWebVC" bundle:nil];
    [self.navigationController pushViewController:webVC animated:YES];
}

- ( IBAction )pressCityBtn:(id)sender
{
    [self.view endEditing:YES];
    
    //City
    
    NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
    
    
    RHActionSheet *sheet = [[RHActionSheet alloc] initWithTitle: title
                                                       delegate: self
                                              cancelButtonTitle: @"確定"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet showInView: [[RHAppDelegate sharedDelegate] window]];
    sheet.tag = kAreaTag;
    
    if ( m_pMainPicker2 == nil )
    {
        self.m_pMainPicker2 = [[UIPickerView alloc] initWithFrame: CGRectMake(0,0, self.view.frame.size.width, 216)];
        m_pMainPicker2.tag = kAreaTag;
        m_pMainPicker2.delegate = self;
        m_pMainPicker2.dataSource = self;
    }
    
    [sheet addSubview: self.m_pMainPicker2];
}

- ( IBAction )pressTypeBtn:(id)sender
{
    [self.view endEditing:YES];

    //picker, 星座和生肖
    
    NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
    
    
    RHActionSheet *sheet = [[RHActionSheet alloc] initWithTitle: title
                                                       delegate: self
                                              cancelButtonTitle: @"確定"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet showInView: [[RHAppDelegate sharedDelegate] window]];
    sheet.tag = kStartTag;
    
    if ( m_pMainPicker == nil )
    {
        self.m_pMainPicker = [[UIPickerView alloc] initWithFrame: CGRectMake(0,0, self.view.frame.size.width, 216)];
        m_pMainPicker.tag = kStartTag;
        m_pMainPicker.delegate = self;
        m_pMainPicker.dataSource = self;
    }
    
    [sheet addSubview: self.m_pMainPicker];

}

- ( IBAction )pressSearchBtn:(id)sender
{
    //Load List
    [RHAppDelegate showLoadingHUD];
    
    NSMutableDictionary *pPamrameter = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSString *pstrCity = @"";
    NSString *pstrStar = @"";
    NSString *pstrChina = @"";
    
    if (m_nCityIdx > 0) {
        pstrCity = g_pstrCity[m_nCityIdx];
        [pPamrameter setObject:pstrCity forKey:kAssoCity];
    }
    
    if (m_nStarIdx > 0) {
        pstrStar = g_pstrStart[m_nStarIdx];
         [pPamrameter setObject:pstrStar forKey:kAssoSignStar];
    }
    
    if (m_nChinaIdx > 0) {
        pstrChina = g_pstrChina[m_nChinaIdx];
        [pPamrameter setObject:pstrChina forKey:kAssoSignChina];
    }
    
    NSString *pstrKeyword = [self.m_pTFKeyword text];
    
    if ( [pstrKeyword compare:@"" options:NSCaseInsensitiveSearch] != NSOrderedSame )
    {
        [pPamrameter setObject:[self.m_pTFKeyword text] forKey:kAssoKeyword];
    }
    

    [RHLesEnphantsAPI searchAssociation:pPamrameter Source:self];
}

- ( IBAction )pressAddBtn:(id)sender
{
    self.m_pRHCreateAssociationVC = [[RHCreateAssociationVC alloc] initWithNibName:@"RHCreateAssociationVC" bundle:nil];
    [self.navigationController pushViewController:self.m_pRHCreateAssociationVC animated:YES];
}

#pragma mark - Public
- ( void )setupData:( NSArray * )pCreatedArray Join:( NSArray * )pJoinedArray
{
    if ( pCreatedArray )
    {
        self.m_pCreatedArray = [NSMutableArray arrayWithArray:pCreatedArray];
    }
    else
    {
        self.m_pCreatedArray = [NSMutableArray arrayWithCapacity:1];
    }
    
    if ( pJoinedArray )
    {
        self.m_pJoinedArray = [NSMutableArray arrayWithArray:pJoinedArray];
    }
    else
    {
        self.m_pJoinedArray = [NSMutableArray arrayWithCapacity:1];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat fHeight = 0;
    
    if ( [self.m_pBtnTab1 isSelected] )
    {
        //Tab 1
        fHeight = 44.0f;
    }
    else if ( [self.m_pBtnTab2 isSelected] )
    {
        fHeight = 80.0f;
    }
    else if ( [self.m_pBtnTab4 isSelected] )
    {
        fHeight = [tableView rowHeight];
    }
    
    
    return fHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger nRow = [indexPath row];
    NSDictionary *pDic = nil;
    
    if ( [self.m_pBtnTab1 isSelected] )
    {
        
        m_nCurSelIdx = nRow;
        
        NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nRow];
        
        
        RHAssociationListVC *pVC = [[RHAssociationListVC alloc] initWithNibName:@"RHAssociationListVC" bundle:nil];
        if ( m_nCurSelIdx < [m_pAssociationListArray count] )
        {
            [pVC setM_pstrTitle:[pDic objectForKey:@"name"]];
            [pVC setM_nIdx:[[pDic objectForKey:@"id"] integerValue]];
        }
        
        [self.navigationController pushViewController:pVC animated:YES];
    }
    else if ( [self.m_pBtnTab2 isSelected] )
    {
        
        NSDictionary *pDic = [m_pAssociationTopListArray objectAtIndex:nRow];
        
        //        id pclassIconUrl = [pDic objectForKey:@"classIconUrl"];
        //
        //        if ( [pclassIconUrl isKindOfClass:[NSString class]] )
        //        {
        //            [RHAppDelegate MessageBox:@"後台資料有誤"];
        //            return;
        //        }
        
        
        
        self.m_pRHAssociationPostListVC = [[RHAssociationPostListVC alloc] initWithNibName:@"RHAssociationPostListVC" bundle:nil];
        [m_pRHAssociationPostListVC setM_pConfigDic:pDic];
        
        
        //判斷Creator
        NSDictionary *pCreatorDic = [pDic objectForKey:@"creator"];
        NSString *pstrmatchId = [pCreatorDic objectForKey:@"matchId"];
        BOOL bIsManager = NO;
        
        RHProfileObj *pObj = [RHProfileObj getProfile];
        
        if ( [pstrmatchId compare:pObj.m_pstrMatchID options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            bIsManager = YES;
        }
        
        [m_pRHAssociationPostListVC setM_bIsManager:bIsManager];
        [self.navigationController pushViewController:m_pRHAssociationPostListVC animated:YES];
    }
    else if ( [self.m_pBtnTab4 isSelected] )
    {
        if ( [tableView tag] == 2 )
        {
            //社長身份
            pDic = [m_pCreatedArray objectAtIndex:nRow];
            //bIsManager = YES;
        }
        else if ( [tableView tag] == 1 )
        {
            //社員身份
            pDic = [m_pJoinedArray objectAtIndex:nRow];
            //bIsManager = NO;
        }
        
        self.m_pRHAssociationPostListVC = [[RHAssociationPostListVC alloc] initWithNibName:@"RHAssociationPostListVC" bundle:nil];
        [m_pRHAssociationPostListVC setM_pConfigDic:pDic];
        //[m_pRHAssociationPostListVC setM_bIsManager:bIsManager];
        
        //判斷Creator
        NSDictionary *pCreatorDic = [pDic objectForKey:@"creator"];
        NSString *pstrmatchId = [pCreatorDic objectForKey:@"matchId"];
        BOOL bIsCreator = NO;
        
        RHProfileObj *pObj = [RHProfileObj getProfile];
        
        if ( [pstrmatchId compare:pObj.m_pstrMatchID options:NSCaseInsensitiveSearch] == NSOrderedSame )
        {
            bIsCreator = YES;
        }
        
        NSArray *pManagerArray = [pDic objectForKey:@"manager"];
        
        BOOL bIsManager = NO;
        for ( NSInteger i = 0 ; i < [pManagerArray count]; ++i )
        {
            NSDictionary *pDic = [pManagerArray objectAtIndex:i];
            NSString *pstrManagermatchId = [pDic objectForKey:@"matchId"];
            
            if ( [pstrManagermatchId compare:pObj.m_pstrMatchID options:NSCaseInsensitiveSearch] == NSOrderedSame )
            {
                bIsManager = YES;
            }
        }
        
        
        
        [m_pRHAssociationPostListVC setM_bIsManager:(bIsManager|bIsCreator)];
        
        
        [self.navigationController pushViewController:m_pRHAssociationPostListVC animated:YES];
        
    }
    
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nCount = 0;
    
    if ( [tableView tag] == 2 )
    {
        nCount = [m_pCreatedArray count];
    }
    else if ( [tableView tag] == 1 )
    {
        nCount = [m_pJoinedArray count];
    }
    else
    {
        if ( [self.m_pBtnTab1 isSelected] )
        {
            //Tab 1
            nCount = [m_pAssociationListArray count];
        }
        else if ( [self.m_pBtnTab2 isSelected] )
        {
            nCount = [m_pAssociationTopListArray count];
        }
    }

    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self.m_pBtnTab1 isSelected] )
    {
        static NSString *CellIdentifier = @"CellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        
        // Configure the cell...
        
        NSUInteger nRow = [indexPath row];
        
        NSDictionary *pDic = [m_pAssociationListArray objectAtIndex:nRow];;
        NSInteger nImgIdx = [[pDic objectForKey:@"id"] integerValue];
        
        NSString *pstrImageName = g_pstrCellImage[nImgIdx-1];
        
        [cell.imageView setImage:[UIImage imageNamed:pstrImageName]];
        AsyncImageView *pImgView = [[AsyncImageView alloc] initWithFrame:cell.imageView.bounds];
        [pImgView setImageCache:[RHAppDelegate sharedDelegate].m_pImageCache];
        
        NSString *pstrURl = [pDic objectForKey:@"icon"];
        pstrURl = [pstrURl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell.imageView addSubview:pImgView];
        [pImgView loadImageFromURL:[NSURL URLWithString:pstrURl]];
        [pImgView setBackgroundColor:[UIColor clearColor]];
        
        [cell.textLabel setText:[pDic objectForKey:@"name"]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
        
    }
    else if ( [self.m_pBtnTab2 isSelected] )
    {
        
        NSString *CellIdentifier = @"RHAssociationListCell";
        
        RHAssociationListCell *cell = (RHAssociationListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"RHAssociationListCell" owner:self options:nil];
            for(id currentObject in nibObjects)
            {
                if([currentObject isKindOfClass:[RHAssociationListCell class]])
                {
                    cell = currentObject;
                    break;
                }
            }
        }
        
        // Configure the cell...
        
        NSUInteger nRow = [indexPath row];
        
        NSDictionary *pDic = [m_pAssociationTopListArray objectAtIndex:nRow];
        
        NSDictionary *pclassIconUrl = [pDic objectForKey:@"classIconUrl"];
        
        NSInteger nImgIdx = 1;
        
        if ( pclassIconUrl && [ pclassIconUrl isKindOfClass:[NSDictionary class]] )
        {
            nImgIdx = [[pclassIconUrl objectForKey:@"id"] integerValue];
        }

        
        
        [cell setM_pMainDic:pDic];
        [cell setM_nID:nImgIdx];
        [cell updateUI];
        
        return cell;
    }
    else if ( [self.m_pBtnTab4 isSelected] )
    {
        static NSString *CellIdentifier = @"CellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        
        // Configure the cell...
        NSUInteger nRow = [indexPath row];
        NSDictionary *pDic = nil;
        
        if ( [tableView tag] == 2 )
        {
            pDic = [m_pCreatedArray objectAtIndex:nRow];
        }
        else if ( [tableView tag] == 1 )
        {
            pDic = [m_pJoinedArray objectAtIndex:nRow];
        }

        [cell.textLabel setText:[pDic objectForKey:@"name"]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        return cell;
    }

    
    
    return nil;
}


#pragma mark - API
- ( void )callBackGetAssociationListStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSArray *pArray = [pStatusDic objectForKey:@"data"];
        [[RHAppDelegate sharedDelegate] keepAssociationList:pArray];
        self.m_pAssociationListArray = [NSMutableArray arrayWithArray:pArray];
        [self.m_pAssociationListTable reloadData];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackGerAssociationTopListStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSArray *pArray = [pStatusDic objectForKey:@"data"];
        self.m_pAssociationTopListArray = [NSMutableArray arrayWithArray:pArray];
        [self.m_pAssociationListTable reloadData];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}



- ( void )callBackGetMyAssociationListStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSArray *pCreatedArray = [pStatusDic objectForKey:@"created"];
        NSArray *pJoinedArray = [pStatusDic objectForKey:@"joined"];

        //self.m_pRHMyAssociationVC = [[RHMyAssociationVC alloc] initWithNibName:@"RHMyAssociationVC" bundle:nil];
        //[m_pRHMyAssociationVC setupData:pCreatedArray Join:pJoinedArray];
        //[self.navigationController pushViewController:m_pRHMyAssociationVC animated:YES];
        
        [self setupData:pCreatedArray Join:pJoinedArray];
        [self updateMyGroup];
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

- ( void )callBackSearchAssociationStatus:( NSDictionary * )pStatusDic
{
    NSInteger nError = [[pStatusDic objectForKey:@"error"] integerValue];
    
    if ( nError == 0 )
    {
        NSArray *pArray = [pStatusDic objectForKey:@"data"];
        
        if ( [pArray count] > 0 )
        {
            RHAssociationListVC *pVC = [[RHAssociationListVC alloc] initWithNibName:@"RHAssociationListVC" bundle:nil];
            [pVC setM_pstrTitle:@"搜尋結果"];
            [pVC setupData:pArray];
            
            [self.navigationController pushViewController:pVC animated:YES];

        }
        else
        {
            [RHAppDelegate MessageBox:@"此條件下無相闗的社團"];
        }
        
    }
    else
    {
        NSString *pstrErrorMsg = [RHAppDelegate getErrorMsgWithCode:[NSString stringWithFormat:@"%d",nError]];
        [RHAppDelegate MessageBox:pstrErrorMsg];
    }
    
    [RHAppDelegate hideLoadingHUD];
}

#pragma mark - UIPickerView Delegate & DataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pstrTitle = @"";
    
    if ( pickerView.tag == kStartTag )
    {
        if ( component == 0 )
        {
            pstrTitle = g_pstrStart[row];
        }
        else
        {
            pstrTitle = g_pstrChina[row];
        }
    }
    else
    {
        pstrTitle = g_pstrCity[row];
    }
    
    return pstrTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ( pickerView.tag == kStartTag )
    {
        if ( component == 0 )
        {
            m_nStarIdx = row;
        }
        else
        {
            m_nChinaIdx = row;
        }
    }
    else
    {
        m_nCityIdx = row;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger nCount = 0;
    if ( pickerView.tag == kStartTag )
    {
        nCount = 2;
    }
    else
    {
        nCount = 1;
    }
    
    return nCount;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger nCount = 0;
    if ( pickerView.tag == kStartTag )
    {
        nCount = sizeof(g_pstrStart) / sizeof(g_pstrStart[0]);
    }
    else
    {
        nCount = sizeof(g_pstrCity) / sizeof(g_pstrCity[0]);
    }
    
    return nCount;
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if ( actionSheet.tag == kStartTag)
//    {
//        if ( buttonIndex == 1 )
//        {
//            //還原
//            m_nChinaIdx = -1;
//            m_nStarIdx = -1;
//        }
//    }
//    else
//    {
//        if ( buttonIndex == 1 )
//        {
//            //還原
//            m_nCityIdx = -1;
//        }
//    }
    
    [self updateUI];
}
@end
