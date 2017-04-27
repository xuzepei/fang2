//
//  RCFavoriteViewController.m
//  RCFang
//
//  Created by xuzepei on 5/3/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCFavoriteViewController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"
#import "RCXinFangCell.h"
#import "RCSecondHandHouseCell.h"
#import "RCZuFangCell.h"
#import "RCFangInfoViewController.h"
#import "RCSecondHandHouseInfoViewController.h"
#import "RCZuFangInfoViewController.h"

#define AD_FRAME_HEIGHT 120.0
#define LITTLE_TAB_BAR_HEIGHT 40.0

@interface RCFavoriteViewController ()

@end

@implementation RCFavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _itemArray = [[NSMutableArray alloc] init];
        _itemArray0 = [[NSMutableArray alloc] init];
        _itemArray1 = [[NSMutableArray alloc] init];
        _itemArray2 = [[NSMutableArray alloc] init];
        _itemArray3 = [[NSMutableArray alloc] init];
        
        self.page0 = 1;
        self.page1 = 1;
        self.page2 = 1;
        self.page3 = 1;
        
        self.title = @"我的收藏";
    }
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    self.tabBar = nil;
    self.adScrollView = nil;
    
    self.itemArray = nil;
    self.itemArray0 = nil;
    self.itemArray1 = nil;
    self.itemArray2 = nil;
    self.itemArray3 = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //[self updateAd];
    
    [self initTableView];
    
    [self initTabBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.tableView = nil;
    self.tabBar = nil;
    self.adScrollView = nil;
}

- (void)updateContent:(HOUSE_TYPE)type page:(int)page index:(int)index
{
    
    NSString* urlString = [NSString stringWithFormat:@"%@/favorite_list.php?apiid=%@&apikey=%@&page=%d&class=%d&username=%@",BASE_URL,APIID,PWD,page,type,[RCTool getUsername]];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:index] forKey:@"index"];
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp request:urlString delegate:self resultSelector:nil token:dict];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedRequest:(NSString*)jsonString token:(id)token;
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* dict = (NSDictionary*)token;
    int index = [[dict objectForKey:@"index"] intValue];
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        //NSLog(@"result:%@",result);
        
        NSArray* listArray = [result objectForKey:@"list"];
        if(listArray && [listArray isKindOfClass:[NSArray class]])
        {
            if(0 == index)
            {
                _page0++;
                [_itemArray0 addObjectsFromArray:listArray];
            }
            else if(1 == index)
            {
                _page1++;
                [_itemArray1 addObjectsFromArray:listArray];
            }
            else if(2 == index)
            {
                _page2++;
                [_itemArray2 addObjectsFromArray:listArray];
            }
            else if(3 == index)
            {
                _page3++;
                [_itemArray3 addObjectsFromArray:listArray];
            }
        }
        
    }
    
    [_itemArray removeAllObjects];
    if(0 == self.selectedIndex)
    {
        [_itemArray addObjectsFromArray:_itemArray0];
    }
    else if(1 ==  self.selectedIndex)
    {
        [_itemArray addObjectsFromArray:_itemArray1];
    }
    else if(2 ==  self.selectedIndex)
    {
        [_itemArray addObjectsFromArray:_itemArray2];
    }
    else if(3 ==  self.selectedIndex)
    {
        [_itemArray addObjectsFromArray:_itemArray3];
    }
    
    [_tableView reloadData];
}


#pragma mark - AdScrollView

- (void)initAdScrollView
{
    self.adHeight = 0;
    
    NSDictionary* ad = [RCTool getAdByType:@"news"];
    if(ad)
    {
        NSString* show = [ad objectForKey:@"show"];
        if([show isEqualToString:@"1"])
        {
            NSArray* urlArray = [ad objectForKey:@"urllist"];
            if(urlArray && [urlArray isKindOfClass:[NSArray class]])
            {
                if([urlArray count])
                {
                    if(nil == _adScrollView)
                    {
                        self.adHeight = AD_FRAME_HEIGHT;
                        _adScrollView = [[RCAdScrollView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, AD_FRAME_HEIGHT)];
                    }
                    
                    [_adScrollView updateContent:urlArray];
                    
                    [self.view addSubview: _adScrollView];
                }
            }
        }
    }
    
    
    
}

- (void)updateAd
{
    NSString* urlString = [NSString stringWithFormat:@"%@/ad.php?apiid=%@&apikey=%@&type=news",BASE_URL,APIID,PWD];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    [temp request:urlString delegate:self resultSelector:@selector(finishedAdRequest:) token:nil];
}

- (void)finishedAdRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        [RCTool setAd:@"news" ad:result];
        
        [self initAdScrollView];
        
        if(_tabBar)
        {
            _tabBar.frame = CGRectMake(0, self.adHeight, [RCTool getScreenSize].width, LITTLE_TAB_BAR_HEIGHT);
        }
        
        if(_tableView)
        {
            _tableView.frame = CGRectMake(0,self.adHeight+LITTLE_TAB_BAR_HEIGHT,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - self.adHeight - LITTLE_TAB_BAR_HEIGHT - TAB_BAR_HEIGHT);
        }
    }
    
}

#pragma mark - Little Tab Bar

- (void)initTabBar
{
    if(nil == _tabBar)
    {
        _tabBar = [[RCTabBar alloc] initWithFrame:CGRectMake(0, self.adHeight, [RCTool getScreenSize].width, LITTLE_TAB_BAR_HEIGHT)];
        _tabBar.delegate = self;
        
        NSArray* titleArray = [NSArray arrayWithObjects:@"新房",@"二手房购",@"租房",nil];
        [_tabBar updateContent:titleArray];
        
        [self clickedTabItem:0 token:nil];
    }
    
    [self.view addSubview:_tabBar];
    
}

- (void)clickedTabItem:(int)index token:(id)token
{
    NSLog(@"clickedTabItem:%d",index);
    
    self.selectedIndex = index;
    
    if(0 == index)
    {
        if(0 == [_itemArray0 count])
        {
            [self updateContent:HT_XINFANG page:_page0 index:index];
            return;
        }
        
        [_itemArray removeAllObjects];
        [_itemArray addObjectsFromArray:_itemArray0];
    }
    else if(1 == index)
    {
        if(0 == [_itemArray1 count])
        {
            [self updateContent:HT_ERSHOU page:_page1 index:index];
            return;
        }
        
        [_itemArray removeAllObjects];
        [_itemArray addObjectsFromArray:_itemArray1];
    }
    else if(2 == index)
    {
        if(0 == [_itemArray2 count])
        {
            [self updateContent:HT_ZUFANG page:_page2 index:index];
            return;
        }
        
        [_itemArray removeAllObjects];
        [_itemArray addObjectsFromArray:_itemArray2];
    }
    
    [_tableView reloadData];
}


- (void)loadMore:(int)index
{
    NSLog(@"loadMore:%d",index);
    
    if(0 == index)
    {
        [self updateContent:HT_XINFANG page:_page0 index:index];
        return;
    }
    else if(1 == index)
    {
        [self updateContent:HT_ERSHOU page:_page1 index:index];
        return;
    }
    else if(2 == index)
    {
        [self updateContent:HT_ZUFANG page:_page2 index:index];
        return;
    }
    
    [_tableView reloadData];
}


#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.adHeight+LITTLE_TAB_BAR_HEIGHT,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - self.adHeight - LITTLE_TAB_BAR_HEIGHT - TAB_BAR_HEIGHT)
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
    }
	
	[self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath
{
	if(indexPath.row >= [_itemArray count])
		return nil;
	
	return [_itemArray objectAtIndex: indexPath.row];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_itemArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    static NSString *cellId1 = @"cellId1";
    static NSString *cellId2 = @"cellId2";
    
    UITableViewCell *cell = nil;
    
    if(0 == self.selectedIndex)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[RCXinFangCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: cellId];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
        if(item)
        {
            RCXinFangCell* temp = (RCXinFangCell*)cell;
            [temp updateContent:item];
        }
    }
    else if(1 == self.selectedIndex)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil)
        {
            cell = [[RCSecondHandHouseCell alloc] initWithStyle: UITableViewCellStyleDefault
                                         reuseIdentifier: cellId1];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
        if(item)
        {
            RCSecondHandHouseCell* temp = (RCSecondHandHouseCell*)cell;
            [temp updateContent:item];
        }
    }
    else if(2 == self.selectedIndex)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell == nil)
        {
            cell = [[RCZuFangCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                 reuseIdentifier: cellId2];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
        if(item)
        {
            RCZuFangCell* temp = (RCZuFangCell*)cell;
            [temp updateContent:item];
        }
    }

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
	if(item)
    {
        if(0 == self.selectedIndex)
        {
            RCFangInfoViewController* temp = [[RCFangInfoViewController alloc] initWithNibName:nil bundle:nil];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:item];
            [self.navigationController pushViewController:temp animated:YES];

        }
        else if(1 == self.selectedIndex)
        {
            RCSecondHandHouseInfoViewController* temp = [[RCSecondHandHouseInfoViewController alloc] initWithNibName:nil bundle:nil];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:item];
            [self.navigationController pushViewController:temp animated:YES];

        }
        else if(2 == self.selectedIndex)
        {
            RCZuFangInfoViewController* temp = [[RCZuFangInfoViewController alloc] initWithNibName:nil bundle:nil];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:item];
            [self.navigationController pushViewController:temp animated:YES];

        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
				  willDecelerate:(BOOL)decelerate{
    
    if(nil == _tableView)
        return;
    
    CGPoint contentoffset = scrollView.contentOffset;
    CGRect lastItemRect = [_tableView rectForFooterInSection:0];
    
    if(contentoffset.y >= lastItemRect.origin.y - 290)
    {
        [self loadMore:self.selectedIndex];
    }
}


@end
