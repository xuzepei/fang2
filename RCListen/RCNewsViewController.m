//
//  RCNewsViewController.m
//  RCFang
//
//  Created by xuzepei on 4/8/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCNewsViewController.h"
#import "RCTool.h"
#import "RCZiXunCell.h"
#import "RCHttpRequest.h"
#import "RCWebViewController.h"

#define AD_FRAME_HEIGHT 120.0
#define LITTLE_TAB_BAR_HEIGHT 40.0

@interface RCNewsViewController ()

@end

@implementation RCNewsViewController

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
        
        self.title = @"新闻";
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

- (void)updateContent:(int)type page:(int)page index:(int)index
{
    NSString* urlString = [NSString stringWithFormat:@"%@/news_list.php?apiid=%@&pwd=%@&page=%d&type=%d&ios=1",BASE_URL,APIID,PWD,page,type];
    
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
        NSLog(@"result:%@",result);
        
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
    NSString* urlString = [NSString stringWithFormat:@"%@/ad.php?apiid=%@&pwd=%@&type=news",BASE_URL,APIID,PWD];
    
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
        _tabBar = [[RCZiXunTabBar alloc] initWithFrame:CGRectMake(0, self.adHeight, [RCTool getScreenSize].width, LITTLE_TAB_BAR_HEIGHT)];
        _tabBar.delegate = self;
        
        NSArray* titleArray = [NSArray arrayWithObjects:@"头条",@"导购",@"市场",@"排行榜",nil];
        [_tabBar updateContent:titleArray];
        
        [_tabBar clickedTabItem:0];
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
            [self updateContent:1 page:_page0 index:index];
            return;
        }
        
        [_itemArray removeAllObjects];
        [_itemArray addObjectsFromArray:_itemArray0];
    }
    else if(1 == index)
    {
        if(0 == [_itemArray1 count])
        {
            [self updateContent:2 page:_page1 index:index];
            return;
        }
        
        [_itemArray removeAllObjects];
        [_itemArray addObjectsFromArray:_itemArray1];
    }
    else if(2 == index)
    {
        if(0 == [_itemArray2 count])
        {
            [self updateContent:3 page:_page2 index:index];
            return;
        }
        
        [_itemArray removeAllObjects];
        [_itemArray addObjectsFromArray:_itemArray2];
    }
    else if(3 == index)
    {
        if(0 == [_itemArray3 count])
        {
            [self updateContent:99 page:_page3 index:index];
            return;
        }
        
        [_itemArray removeAllObjects];
        [_itemArray addObjectsFromArray:_itemArray3];
    }
    
    [_tableView reloadData];
}


- (void)loadMore:(int)index
{
    NSLog(@"loadMore:%d",index);
    
    if(0 == index)
    {
        [self updateContent:1 page:_page0 index:index];
        return;
    }
    else if(1 == index)
    {
        [self updateContent:2 page:_page1 index:index];
        return;
    }
    else if(2 == index)
    {
        [self updateContent:3 page:_page2 index:index];
        return;
    }
    else if(3 == index)
    {
        [self updateContent:99 page:_page3 index:index];
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
	return 70.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
	{
		cell = [[RCZiXunCell alloc] initWithStyle: UITableViewCellStyleDefault
                                   reuseIdentifier: cellId];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	

    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
	if(item)
	{
        RCZiXunCell* temp = (RCZiXunCell*)cell;
        [temp updateContent:item];
	}
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
	if(item)
    {
        NSString* id = [item objectForKey:@"id"];
        if(0 == [id length])
            return;
        
        NSString* title = [item objectForKey:@"title"];
        NSString* urlString = [NSString stringWithFormat:@"%@/show_news.php?id=%@",BASE_URL,id];
        RCWebViewController* temp = [[RCWebViewController alloc] init:NO];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:title];
        [self.navigationController pushViewController:temp animated:YES];

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
