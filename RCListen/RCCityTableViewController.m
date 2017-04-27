//
//  RCCityTableViewController.m
//  RCFang
//
//  Created by xuzepei on 10/29/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCCityTableViewController.h"
#import "RCHttpRequest.h"

@interface RCCityTableViewController ()

@end

@implementation RCCityTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"服务城市";
    
    if(nil == _itemArray)
        _itemArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;

    NSString* urlString = [NSString stringWithFormat:@"%@/city_list.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    
    NSString* city = @"成都";
    NSDictionary* cityInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_city"];
    if(cityInfo)
    {
        city = [cityInfo objectForKey:@"city"];
        if(0 == [city length])
            city = [cityInfo objectForKey:@"now_city"];
    }

    NSString* token = [NSString stringWithFormat:@"city=%@",city];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedRequest:) token:token];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            self.result = result;
            
            NSArray* array = [self.result objectForKey:@"city_list"];
            if(array && [array isKindOfClass:[NSArray class]])
            {
                [self.itemArray removeAllObjects];
                [self.itemArray addObjectsFromArray:array];
                [self.tableView reloadData];
            }
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

#pragma mark - Table view data source

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath
{
	if(indexPath.row >= [_itemArray count])
		return nil;
	
	return [_itemArray objectAtIndex: indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(0 == section)
        return 1;
    else if(1 == section)
        return [_itemArray count];
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(0 == section)
        return @"定位城市";
    
    return @"其他可服务城市";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                      reuseIdentifier: cellId];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if(0 == indexPath.section)
    {
        NSString* temp = @"";
        if(self.result)
            temp = [self.result objectForKey:@"now_city"];
        cell.textLabel.text = temp;
    }
    else if(1 == indexPath.section)
    {
        NSDictionary* dict = [self getCellDataAtIndexPath:indexPath];
        if(dict)
            cell.textLabel.text = [dict objectForKey:@"city"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(0 == indexPath.section)
    {
        NSString* temp = @"";
        if(self.result && [self.result isKindOfClass:[NSDictionary class]])
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:self.result forKey:@"current_city"];
            [defaults synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if(1 == indexPath.section)
    {
        NSDictionary* dict = [self getCellDataAtIndexPath:indexPath];
        if(dict)
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:dict forKey:@"current_city"];
            [defaults synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


@end
