//
//  RCDDViewController.m
//  RCFang
//
//  Created by xuzepei on 6/18/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDViewController.h"
#import "RCPublicCell.h"
#import "RCHttpRequest.h"
#import "RCDDCell.h"
#import "RCDDStep4ViewController.h"
#import "RCDDStep5ViewController.h"
#import "RCDDStep6ViewController.h"
#import "RCPJDDViewController.h"
#import "RCDDDetailViewController.h"

#define SEGMENTED_BAR_HEIGHT 50.0f

@interface RCDDViewController ()

@end

@implementation RCDDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"我的订单";
        self.view.backgroundColor = BG_COLOR;
        
        if(nil == _itemArray)
            _itemArray = [[NSMutableArray alloc] init];
        
        if(nil == _itemArray0)
            _itemArray0 = [[NSMutableArray alloc] init];
        
        if(nil == _itemArray1)
            _itemArray1 = [[NSMutableArray alloc] init];
        
        if(nil == _itemArray2)
            _itemArray2 = [[NSMutableArray alloc] init];
        
        self.page0 = 1;
        self.page1 = 1;
        self.page2 = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    [self initSegmentedControl];
    
    [self initTableView];
    
    [self initRefreshControl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.tableView = nil;
    self.segmentedControl = nil;
    
}

- (void)clickedBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateContent
{
    if(NO == [RCTool isLogined])
        return;
    
    NSString* username = [RCTool getUsername];
    NSString* password = [RCTool getPassword];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user_order.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    NSString* type = @"nocharge_list";
    int page = 0;
    if(0 == self.segmentedControl.selectedSegmentIndex)
    {
        type = @"nocharge_list";
        page = self.page0;
    }
    else if(1 == self.segmentedControl.selectedSegmentIndex)
    {
        type = @"charged_list";
        page = self.page1;
    }
    else if(2 == self.segmentedControl.selectedSegmentIndex)
    {
        type = @"finish_list";
        page = self.page2;
    }
    
    NSString* token = [NSString stringWithFormat:@"username=%@&password=%@&type=%@&page=%d",username,password,type,page];
    
    SEL selector = nil;
    if(0 == self.segmentedControl.selectedSegmentIndex)
        selector = @selector(finishedRequest0:);
    else if(1 == self.segmentedControl.selectedSegmentIndex)
        selector = @selector(finishedRequest1:);
    else if(2 == self.segmentedControl.selectedSegmentIndex)
        selector = @selector(finishedRequest2:);
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:selector token:token];
    if(b)
    {
        //[RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedRequest0:(NSString*)jsonString
{
    //[RCTool hideIndicator];
    
    [self.tableView footerEndRefreshing];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            NSArray* array = [result objectForKey:@"order_list"];
            if(array && [array isKindOfClass:[NSArray class]])
            {
                self.page0++;
                //[self.itemArray0 removeAllObjects];
                [self.itemArray0 addObjectsFromArray:array];
                
                if(0 == self.segmentedControl.selectedSegmentIndex)
                {
                    [self.itemArray removeAllObjects];
                    [self.itemArray addObjectsFromArray:self.itemArray0];
                    [self.tableView reloadData];
                }
                
                
            }
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)finishedRequest1:(NSString*)jsonString
{
    //[RCTool hideIndicator];
    
    [self.tableView footerEndRefreshing];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            NSArray* array = [result objectForKey:@"order_list"];
            if(array && [array isKindOfClass:[NSArray class]])
            {
                self.page1++;
                //[self.itemArray1 removeAllObjects];
                [self.itemArray1 addObjectsFromArray:array];
                if(1 == self.segmentedControl.selectedSegmentIndex)
                {
                    [self.itemArray removeAllObjects];
                    [self.itemArray addObjectsFromArray:self.itemArray1];
                    [self.tableView reloadData];
                }
            }
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)finishedRequest2:(NSString*)jsonString
{
    //[RCTool hideIndicator];
    
    [self.tableView footerEndRefreshing];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            NSArray* array = [result objectForKey:@"order_list"];
            if(array && [array isKindOfClass:[NSArray class]])
            {
                self.page2++;
                //[self.itemArray2 removeAllObjects];
                [self.itemArray2 addObjectsFromArray:array];
                if(2 == self.segmentedControl.selectedSegmentIndex)
                {
                    [self.itemArray removeAllObjects];
                    [self.itemArray addObjectsFromArray:self.itemArray2];
                    [self.tableView reloadData];
                }
            }
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
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

#pragma mark - SegmentedControl

- (void)initSegmentedControl
{
    if(nil == _segmentedControl)
    {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"   未付款   ",@"   已付款   ",@"   已完成   ",nil]];
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.tintColor = NAVIGATION_BAR_COLOR;
        
        _segmentedControl.center = CGPointMake([RCTool getScreenSize].width/2.0, SEGMENTED_BAR_HEIGHT/2.0);
        
        [_segmentedControl addTarget:self
                              action:@selector(clickedSegmentedControl:)
                    forControlEvents:UIControlEventValueChanged];
        
        [_segmentedControl setSelectedSegmentIndex:0];
    }
    
    [self.view addSubview: _segmentedControl];
}

- (void)clickedSegmentedControl:(id)sender
{
    NSLog(@"clickedSegmentedControl");
    
    
    if(0 == self.segmentedControl.selectedSegmentIndex)
    {
        [self.itemArray removeAllObjects];
        [self.itemArray addObjectsFromArray:self.itemArray0];
    }
    else if(1 == self.segmentedControl.selectedSegmentIndex)
    {
        [self.itemArray removeAllObjects];
        [self.itemArray addObjectsFromArray:self.itemArray1];
    }
    else if(2 == self.segmentedControl.selectedSegmentIndex)
    {
        [self.itemArray removeAllObjects];
        [self.itemArray addObjectsFromArray:self.itemArray2];
    }
    
    [self.tableView reloadData];
    
    if(0 == [self.itemArray count])
        [self updateContent];
}

#pragma mark - Table View

- (void)initTableView
{
    if(nil == _tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,SEGMENTED_BAR_HEIGHT,[RCTool getScreenSize].width,[RCTool getScreenSize].height - NAVIGATION_BAR_HEIGHT - SEGMENTED_BAR_HEIGHT)
                                                  style:UITableViewStyleGrouped];
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    [_tableView reloadData];
	[self.view addSubview:_tableView];
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)getCellHeight:(NSIndexPath*)indexPath
{
    return 280.0;
    
    CGFloat height = 0.0f;
    NSDictionary* item = [self getCellDataAtIndexPath:indexPath];
    if(item)
    {
        NSString* ddbh = [item objectForKey:@"ddbh"];
        if([ddbh length])
        {
            CGSize size = [ddbh sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(220,CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            
            height += MAX(size.height, 16) + 6;
        }
        
        NSString* fwxq = [item objectForKey:@"fwxq"];
        if([fwxq length])
        {
            CGSize size = [fwxq sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(80,CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            
            height += MAX(size.height, 16) + 6;
        }
        
        
        NSString* yq = [item objectForKey:@"yq"];
        if([yq length])
        {
            CGSize size = [yq sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(240,CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            
            height += MAX(size.height, 16) + 6;
        }
        
        height += 44;
    }
    
    
    return MAX(height,110);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_itemArray count];
}

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath
{
	if(indexPath.section >= [_itemArray count])
		return nil;
	
	return [_itemArray objectAtIndex: indexPath.section];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeight:indexPath];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId1 = @"cellId1";
    
    UITableViewCell *cell = nil;
    if (cell == nil)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RCDDCell" owner:self options:nil];
        cell = [objects objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
    RCDDCell* temp = (RCDDCell*)cell;
    if(temp)
    {
        temp.delegate = self;
        [temp updateContent:item];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(2 == indexPath.section)
    {
        //[self updateContent:self.item];
    }
}

- (void)clickedButton:(int)type token:(NSDictionary *)token
{
    if(0 == type)//确认并支付
    {
        NSString* username = [RCTool getUsername];
        NSString* password = [RCTool getPassword];
        
        NSString* urlString = [NSString stringWithFormat:@"%@/user_order.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
        
        NSString* order_num = [token objectForKey:@"order_num"];
        NSString* type = @"confirm";
        
        NSString* token1 = [NSString stringWithFormat:@"username=%@&password=%@&type=%@&order_num=%@&user_order=1",username,password,type,order_num];
        
        SEL selector = @selector(finishedConfirmRequest:);
        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
        BOOL b = [temp post:urlString delegate:self resultSelector:selector token:token1];
        if(b)
        {
            //[RCTool showIndicator:@"请稍候..."];
        }
    
    }
    else if(1 == type)//取消
    {
        NSString* username = [RCTool getUsername];
        NSString* password = [RCTool getPassword];
        
        NSString* urlString = [NSString stringWithFormat:@"%@/user_order.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
        
        NSString* order_num = [token objectForKey:@"order_num"];
        
        NSString* token1 = [NSString stringWithFormat:@"username=%@&password=%@&type=%@&order_num=%@&user_name=%@",username,password,@"del",order_num,username];
        
        SEL selector = @selector(finishedDeleteRequest:);
        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
        BOOL b = [temp post:urlString delegate:self resultSelector:selector token:token1];
        if(b)
        {
            //[RCTool showIndicator:@"请稍候..."];
        }
        
        
        int index = [[token objectForKey:@"index"] intValue];
        if(index < [self.itemArray count])
        {
            [self.itemArray removeObjectAtIndex:index];
            [self.tableView reloadData];
        }
    }
    else if(2 == type)//支付
    {
        RCDDStep6ViewController* temp = [[RCDDStep6ViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:token];
        [self.navigationController pushViewController:temp animated:YES];
    }
    else if(3 == type)//跟踪流程
    {
        RCDDDetailViewController* temp = [[RCDDDetailViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:token];
        [self.navigationController pushViewController:temp animated:YES];
    }
    else if(4 == type)//完成订单
    {
        NSString* username = [RCTool getUsername];
        NSString* password = [RCTool getPassword];
        
        NSString* urlString = [NSString stringWithFormat:@"%@/user_order.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
        
        NSString* order_num = [token objectForKey:@"order_num"];
        NSString* type = @"finish";
        
        NSString* token1 = [NSString stringWithFormat:@"username=%@&password=%@&type=%@&order_num=%@",username,password,type,order_num];
        
        SEL selector = @selector(finishedFinishRequest:);
        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
        BOOL b = [temp post:urlString delegate:self resultSelector:selector token:token1];
        if(b)
        {
            //[RCTool showIndicator:@"请稍候..."];
        }
    }
    else if(5 == type)//评价
    {
        RCPJDDViewController* temp = [[RCPJDDViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:token];
        [self.navigationController pushViewController:temp animated:YES];
    }
}

- (void)finishedConfirmRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            RCDDStep5ViewController* temp = [[RCDDStep5ViewController alloc] initWithNibName:nil bundle:nil];
            [temp updateContent:result];
            [self.navigationController pushViewController:temp animated:YES];
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)finishedDeleteRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)finishedFinishRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

@end
