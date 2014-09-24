//
//  RCSearchAddressTableViewController.m
//  RCFang
//
//  Created by xuzepei on 9/10/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCSearchAddressTableViewController.h"
#import "RCGuiHuaViewController.h"

@interface RCSearchAddressTableViewController ()

@end

@implementation RCSearchAddressTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(nil == _itemArray)
        _itemArray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    if(nil == _searchBar)
    {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
    }
    
    self.navigationItem.titleView = _searchBar;
    
    [self updateContent:self.item];
    
    if(nil == _search)
    {
        _search = [[BMKPoiSearch alloc] init];
        _search.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_search)
        _search.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_search)
        _search.delegate = nil;
}

- (void)clickedBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked");
    
    NSString* text = _searchBar.text;
    if(0 == [text length])
        return;
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc ] init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"成都";
    citySearchOption.keyword = text;
    BOOL flag = [_search poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    if(_searchBar)
    {
        _searchBar.placeholder = [self.item objectForKey:@"placeholder"];
    }
}

#pragma mark - BMKPoiSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    NSLog(@"onGetPoiResult");
    if(BMK_SEARCH_NO_ERROR == errorCode)
    {
        [_itemArray removeAllObjects];
        [_itemArray addObjectsFromArray:poiResult.poiInfoList];
        
        [self.tableView reloadData];
    }
    else
    {
        [RCTool showAlert:@"提示" message:@"对不起，不能找到该地点信息"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_itemArray count];
}

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath
{
	if(indexPath.row >= [_itemArray count])
		return nil;
	
	return [_itemArray objectAtIndex: indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    BMKPoiInfo* info = [self getCellDataAtIndexPath:indexPath];
    if(info)
    {
        cell.textLabel.text = info.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BMKPoiInfo* info = [self getCellDataAtIndexPath:indexPath];
    if(info)
    {
        int type = [[self.item objectForKey:@"type"] intValue];
        if(0 == type)
        {
            RCGuiHuaViewController* temp = (RCGuiHuaViewController*)self.delegate;
            temp.qdInfo = info;
        }
        else
        {
            RCGuiHuaViewController* temp = (RCGuiHuaViewController*)self.delegate;
            temp.zdInfo = info;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
