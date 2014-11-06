//
//  RCGongGaoViewController.m
//  RCFang
//
//  Created by xuzepei on 11/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCGongGaoViewController.h"
#import "RCHttpRequest.h"
#import "RCGongGaoCell.h"
#import "RCWebViewController.h"

@interface RCGongGaoViewController ()

@end

@implementation RCGongGaoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"大管家公告";
    self.page = 1;
    
    [self initRefreshControl];
    
    if(nil == _itemArray)
    {
        _itemArray = [[NSMutableArray alloc] init];
    }
    
    [self updateContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refresh Control

- (void)initRefreshControl
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //[self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    //    self.tableView.headerPullToRefreshText = [RCTool getTextById:@"ti_6"];
    //    self.tableView.headerReleaseToRefreshText = [RCTool getTextById:@"ti_7"];
    //    self.tableView.headerRefreshingText = [RCTool getTextById:@"ti_8"];
    //
    self.tableView.footerPullToRefreshText = @"";
    self.tableView.footerReleaseToRefreshText = @"";
    self.tableView.footerRefreshingText = @"";
}

- (void)footerRereshing
{
    NSLog(@"footerRereshing");
    
    [self updateContent];
}

- (void)updateContent
{
    NSString* urlString = [NSString stringWithFormat:@"%@/announcement_list.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"page=%d",self.page];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedPostRequest:) token:token];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedPostRequest:(NSString*)jsonString
{
    [self.tableView footerEndRefreshing];
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            NSArray* array = [result objectForKey:@"list"];
            if(array && [array isKindOfClass:[NSArray class]])
            {
                if([array count])
                {
                    self.page++;
                    [_itemArray addObjectsFromArray:array];
                    [self.tableView reloadData];
                }
            }
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

#pragma mark - Table view data source

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath
{
	if(indexPath.section >= [_itemArray count])
		return nil;
	
	return [_itemArray objectAtIndex: indexPath.section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_itemArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
    RCGongGaoCell* cell = [self getReusableCell:tableView];
    if(cell)
    {
        [cell updateContent:item];
    }
    
//    NSString* intro = [item objectForKey:@"intro"];
//    if([intro length])
    {
//        CGSize size = [intro sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([RCTool getScreenSize].width - 10, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//        cell.constraint.constant = 100.0;//size.height;
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    
    return cell.frame.size.height;
}

- (RCGongGaoCell*)getReusableCell:(UITableView*)tableView
{
    static NSString* cellId = @"cellId";
    RCGongGaoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RCGongGaoCell" owner:self options:nil];
        for(id object in objects)
        {
            if([object isKindOfClass:[RCGongGaoCell class]])
            {
                cell = (RCGongGaoCell*)object;
                [cell setValue:cellId forKey:@"reuseIdentifier"];
                break;
            }
        }

        cell.accessoryType = UITableViewCellAccessoryNone;
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
    RCGongGaoCell* cell = [self getReusableCell:tableView];
    if(cell)
    {
        [cell updateContent:item];
    }
    
    return (UITableViewCell*)cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
    if(item)
    {
        NSString* id = [item objectForKey:@"id"];
        if([id length])
        {
            NSString* urlString = [NSString stringWithFormat:@"%@/web/show_news.php?apiid=%@&apikey=%@&id=%@",BASE_URL,APIID,PWD,id];
            
            RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:urlString title:[item objectForKey:@"title"]];
            [self.navigationController pushViewController:temp animated:YES];
        }
    }
}


@end
