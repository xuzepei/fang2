//
//  RCSearchViewController.m
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCSearchViewController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"
#import "RCFangListViewController.h"
#import "RCErShouFangListViewController.h"
#import "RCZuFangListViewController.h"

#define LITTLE_TAB_BAR_HEIGHT 40.0

@interface RCSearchViewController ()

@end

@implementation RCSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"朋友圈"
														   image:[UIImage imageNamed:@"pyq"]
															 tag:TT_GROUP];
        
		self.tabBarItem = item;

        self.navigationItem.title = @"朋友圈";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickedRightBarButtonItem:)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:@selector(clickedLeftBarButtonItem:)];
        
        _itemArray = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    self.itemArray = nil;
    self.tabBar = nil;
    self.searchBar = nil;
    self.searchButton = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self initTabBar];
    
    [self initSearchBar];
    
    [self initTableView];
    
    [self initButtons];
    
    [self initPickerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.tableView = nil;
    self.tabBar = nil;
    self.searchBar = nil;
    self.searchButton = nil;
}

- (void)clickedLeftBarButtonItem:(id)sender
{
    [[RCTool getTabBarController] setSelectedIndex:0];
}

- (void)clickedRightBarButtonItem:(id)sender
{
    [self clickedSearchButton:nil];
}

#pragma mark - Little Tab Bar

- (void)initTabBar
{
    if(nil == _tabBar)
    {
        _tabBar = [[RCTabBar alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, LITTLE_TAB_BAR_HEIGHT)];
        _tabBar.delegate = self;
        
        NSArray* titleArray = [NSArray arrayWithObjects:@"新房",@"二手房",@"租房", nil];
        [_tabBar updateContent:titleArray];
    }
    
    [self.view addSubview:_tabBar];
}

- (void)clickedTabItem:(int)index token:(id)token
{
    NSLog(@"clickedTabItem:%d",index);
    
    self.selectedIndex = index;
    
    [self updateSearchCondition:index];
}

#pragma mark - Search Bar

- (void)initSearchBar
{
    if(nil == _searchBar)
    {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, LITTLE_TAB_BAR_HEIGHT, [RCTool getScreenSize].width, LITTLE_TAB_BAR_HEIGHT)];
        _searchBar.placeholder = @"请输入楼盘名或地段名搜索";
        _searchBar.showsCancelButton = NO;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.showsCancelButton = NO;
        _searchBar.delegate = self;
        [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
    }
    
    [self.view addSubview:_searchBar];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if(NO == _searchBar.showsCancelButton)
        [_searchBar setShowsCancelButton:YES animated:NO];
        
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked");
    
    [self clickedSearchButton:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    NSLog(@"searchBarCancelButtonClicked");
    
    [searchBar resignFirstResponder];
}

#pragma mark - UITableView

- (void)updateSearchCondition:(int)type
{
    NSArray* conditionArray = [RCTool getSearchConditionByType:type];
    if([conditionArray count])
    {
        [self.itemArray removeAllObjects];
        [self.itemArray addObjectsFromArray:conditionArray];
    }
    
    [_tableView reloadData];
}

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,LITTLE_TAB_BAR_HEIGHT*2,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - LITTLE_TAB_BAR_HEIGHT*2 - TAB_BAR_HEIGHT)
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
    }
	
	[self.view addSubview:_tableView];
    
    
    [self updateSearchCondition:STT_0];
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
	return 40.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
	{
		cell = [[RCSearchCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: cellId];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
	if(item)
	{
        RCSearchCell* temp = (RCSearchCell*)cell;
        [temp updateContent:item];
	}
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
	if(item)
	{
        [_pickerView updateContent:item];
        [_pickerView show];
	}
}

#pragma mark Buttons

- (void)initButtons
{
    if(nil == _searchButton)
    {
        self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(70, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - 80, 180, 33);
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_searchButton addTarget:self action:@selector(clickedSearchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: _searchButton];
    }

}

- (void)clickedSearchButton:(id)sender
{
    NSLog(@"clickedSearchButton");
    
    [_searchBar resignFirstResponder];
    
//    if(0 == [_searchBar.text length])
//        return;
    
    NSString* quyuSearchId = [[_itemArray objectAtIndex:0] objectForKey:@"selected_value_index"];
    NSString* leixingSearchId = [[_itemArray objectAtIndex:1] objectForKey:@"selected_value_index"];
    NSString* jiageIndex = [[_itemArray objectAtIndex:2] objectForKey:@"selected_value_index"];
    NSString* keyword = @"";
    if([_searchBar.text length])
        keyword = _searchBar.text;
    NSString* token = [NSString stringWithFormat:@"keyword=%@",keyword];
    
    if(0 == self.selectedIndex)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/xinfang_list.php?apiid=%@&apikey=%@&page=%d&area=%d&type=%d&price=%d&sort=%d",BASE_URL,APIID,PWD,1,[quyuSearchId intValue],[leixingSearchId intValue],[jiageIndex intValue],0];
        
        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
        BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedPostXinFangRequest:) token:token];
        if(b)
        {
            [RCTool showIndicator:@"请稍候..."];
        }
    }
    else if(1 == self.selectedIndex)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/2hand_list.php?apiid=%@&apikey=%@&page=%d&area=%d&unit_type=%d&price=%d&sort=%d",BASE_URL,APIID,PWD,1,[quyuSearchId intValue],[leixingSearchId intValue],[jiageIndex intValue],0];
        
        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
        BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedPostErShouFangRequest:) token:token];
        if(b)
        {
            [RCTool showIndicator:@"请稍候..."];
        }
    }
    else if(2 == self.selectedIndex)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/rent_list.php?apiid=%@&apikey=%@&page=%d&area=%d&source=%d&price=%d&sort=%d",BASE_URL,APIID,PWD,1,[quyuSearchId intValue],[leixingSearchId intValue],[jiageIndex intValue],0];
        
        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
        BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedPostZuFangRequest:) token:token];
        if(b)
        {
            [RCTool showIndicator:@"请稍候..."];
        }
    }
}

- (void)finishedPostXinFangRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSArray* array = [result objectForKey:@"list"];
        NSString* count = [result objectForKey:@"count"];
        if(array && [array isKindOfClass:[NSArray class]])
        {
            NSString* quyuSearchId = [[_itemArray objectAtIndex:0] objectForKey:@"selected_value_index"];
            NSString* leixingSearchId = [[_itemArray objectAtIndex:1] objectForKey:@"selected_value_index"];
            NSString* jiageIndex = [[_itemArray objectAtIndex:2] objectForKey:@"selected_value_index"];
            NSString* keyword = _searchBar.text;
            if(0 == [keyword length])
                keyword = @"";
            
            _searchBar.text = nil;
            
            RCFangListViewController* temp = [[RCFangListViewController alloc] initWithNibName:nil bundle:nil];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:array
                          count:count
                           area:[quyuSearchId intValue]
                           type:[leixingSearchId intValue]
                          price:[jiageIndex intValue]
             keyword:keyword];
            [self.navigationController pushViewController:temp animated:YES];
        }

    }

}

- (void)finishedPostErShouFangRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSArray* array = [result objectForKey:@"list"];
        NSString* count = [result objectForKey:@"count"];
        if(array && [array isKindOfClass:[NSArray class]])
        {
            NSString* quyuSearchId = [[_itemArray objectAtIndex:0] objectForKey:@"selected_value_index"];
            NSString* leixingSearchId = [[_itemArray objectAtIndex:1] objectForKey:@"selected_value_index"];
            NSString* jiageIndex = [[_itemArray objectAtIndex:2] objectForKey:@"selected_value_index"];
            NSString* keyword = _searchBar.text;
            if(0 == [keyword length])
                keyword = @"";
            
            _searchBar.text = nil;
            
            RCErShouFangListViewController* temp = [[RCErShouFangListViewController alloc] initWithNibName:nil bundle:nil];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:array
                          count:count
                           area:[quyuSearchId intValue]
                           type:[leixingSearchId intValue]
                          price:[jiageIndex intValue]
                        keyword:keyword];
            [self.navigationController pushViewController:temp animated:YES];
        }
        
    }
    
}

- (void)finishedPostZuFangRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSArray* array = [result objectForKey:@"list"];
        NSString* count = [result objectForKey:@"count"];
        if(array && [array isKindOfClass:[NSArray class]])
        {
            NSString* quyuSearchId = [[_itemArray objectAtIndex:0] objectForKey:@"selected_value_index"];
            NSString* leixingSearchId = [[_itemArray objectAtIndex:1] objectForKey:@"selected_value_index"];
            NSString* jiageIndex = [[_itemArray objectAtIndex:2] objectForKey:@"selected_value_index"];
            NSString* keyword = _searchBar.text;
            if(0 == [keyword length])
                keyword = @"";
            
            _searchBar.text = nil;
            
            RCZuFangListViewController* temp = [[RCZuFangListViewController alloc] initWithNibName:nil bundle:nil];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:array
                          count:count
                           area:[quyuSearchId intValue]
                           type:[leixingSearchId intValue]
                          price:[jiageIndex intValue]
                        keyword:keyword];
            [self.navigationController pushViewController:temp animated:YES];
        }
        
    }
    
}

#pragma mark - Picker View

- (void)initPickerView
{
    if(nil == _pickerView)
    {
        _pickerView = [[RCPickerView alloc] initWithFrame:CGRectMake(0, [RCTool getScreenSize].height, [RCTool getScreenSize].width, PICKER_VIEW_HEIGHT)];
        _pickerView.delegate = self;
    }
}

- (void)clickedSureValueButton:(int)index token:(id)token
{
    if(nil == token)
        return;
    
    NSDictionary* item = (NSDictionary*)token;
    int stt = [[item objectForKey:@"stt"] intValue];
    int subtype = [[item objectForKey:@"subtype"] intValue];
    
    NSMutableDictionary* temp = [[NSMutableDictionary alloc] init];
    [temp addEntriesFromDictionary:item];
    [temp setObject:[NSNumber numberWithInt:index] forKey:@"selected_value_index"];
    
    NSArray* conditionArray = [RCTool getSearchConditionByType:stt];
    if([conditionArray count])
    {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        [array addObjectsFromArray:conditionArray];
        [array replaceObjectAtIndex:subtype withObject:temp];
        [RCTool setSearchCondition:array type:stt];
        
        [self updateSearchCondition:stt];
    }

    
}

@end
