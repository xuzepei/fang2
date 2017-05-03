//
//  RCNewsViewController.m
//  RCFang
//
//  Created by xuzepei on 4/8/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCNewsViewController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"
#import "RCWebViewController.h"
#import "RCNewsTableViewCell.h"

#define CELL_HEIGHT 180.0

@interface RCNewsViewController ()

@end

@implementation RCNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _itemArray = [[NSMutableArray alloc] init];
        
        self.page0 = 1;
        self.view.backgroundColor = BG_COLOR;
        self.title = @"重要通知";
    }
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    self.itemArray = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initTableView];
    
    [self initRefreshControl];
    
    [self updateContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.tableView)
        [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateContent
{
    NSString* urlString = [NSString stringWithFormat:@"%@?m=%@&c=%@&a=%@&page=%d&t=%f",BASE_URL,@"api",@"index",@"getnews",self.page0,[NSDate date].timeIntervalSince1970];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedRequest:) token:nil];
    if(b)
    {
        [RCTool showIndicator:@"加载中..."];
    }
    else if(self.tableView)
        [self.tableView footerEndRefreshing];
}

- (void)finishedRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    if(self.tableView)
        [self.tableView footerEndRefreshing];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"result:%@",result);
        
        NSNumber* code = [result objectForKey:@"code"];
        if(code.intValue == 200)
        {
            NSArray* dataArray = [result objectForKey:@"data"];
            if(dataArray && [dataArray isKindOfClass:[NSArray class]])
            {
                _page0++;
                [_itemArray addObjectsFromArray:dataArray];
            }
        }

    }
    
    [_tableView reloadData];
}


#pragma mark - RefreshControl

- (void)initRefreshControl
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.tableView.footerPullToRefreshText = @"";
    self.tableView.footerReleaseToRefreshText = @"";
    self.tableView.footerRefreshingText = @"";
}


- (void)footerRereshing
{
    NSLog(@"footerRereshing");
    
    [self updateContent];
}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)
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
	return CELL_HEIGHT;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
	{
		cell = [[RCNewsTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                   reuseIdentifier: cellId];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    NSDictionary* item = [self getCellDataAtIndexPath:indexPath];
    if(item)
    {
        RCNewsTableViewCell* temp = (RCNewsTableViewCell*)cell;
        [temp updateContent:item cellHeight:CELL_HEIGHT];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];

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
        [self updateContent];
    }
}

@end
