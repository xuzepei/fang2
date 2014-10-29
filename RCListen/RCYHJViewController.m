//
//  RCYHJViewController.m
//  RCFang
//
//  Created by xuzepei on 10/29/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCYHJViewController.h"
#import "RCHttpRequest.h"
#import "RCYHJCell0.h"
#import "RCYHJCell1.h"

#define SEGMENTED_BAR_HEIGHT 50.0f

@interface RCYHJViewController ()

@end

@implementation RCYHJViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"我的优惠卷";
        self.view.backgroundColor = BG_COLOR;
        
        if(nil == _itemArray)
            _itemArray = [[NSMutableArray alloc] init];
        
        if(nil == _itemArray0)
            _itemArray0 = [[NSMutableArray alloc] init];
        
        if(nil == _itemArray1)
            _itemArray1 = [[NSMutableArray alloc] init];
        
        self.page0 = 1;
        self.page1 = 1;
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
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user_coupon.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    NSString* type = @"nuse";
    int page = 0;
    if(0 == self.segmentedControl.selectedSegmentIndex)
    {
        type = @"nuse";
        page = self.page0;
    }
    else if(1 == self.segmentedControl.selectedSegmentIndex)
    {
        type = @"used";
        page = self.page1;
    }
    
    NSString* token = [NSString stringWithFormat:@"username=%@&password=%@&type=%@&page=%d",username,password,type,page];
    
    SEL selector = nil;
    if(0 == self.segmentedControl.selectedSegmentIndex)
        selector = @selector(finishedRequest0:);
    else if(1 == self.segmentedControl.selectedSegmentIndex)
        selector = @selector(finishedRequest1:);

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
            NSArray* array = [result objectForKey:@"coupon_list"];
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
            NSArray* array = [result objectForKey:@"coupon_list"];
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
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"   未使用的优惠卷",@"已使用的优惠卷",nil]];
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
    
    [self.tableView reloadData];
    
    if(0 == [self.itemArray count])
        [self updateContent];
}

#pragma mark - Table View

- (void)initTableView
{
    if(nil == _tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,SEGMENTED_BAR_HEIGHT,[RCTool getScreenSize].width,[RCTool getScreenSize].height - NAVIGATION_BAR_HEIGHT - SEGMENTED_BAR_HEIGHT - STATUS_BAR_HEIGHT)
                                                  style:UITableViewStylePlain];
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
    }
    
    [_tableView reloadData];
	[self.view addSubview:_tableView];
    
}

- (CGFloat)getCellHeight:(NSIndexPath*)indexPath
{
    if(0 == self.segmentedControl.selectedSegmentIndex)
        return 70.0f;
    
    return 125.0f;
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
    if(0 == self.segmentedControl.selectedSegmentIndex)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RCYHJCell0" owner:self options:nil];
        cell = [objects objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
        RCYHJCell0* temp = (RCYHJCell0*)cell;
        if(temp)
        {
            [temp updateContent:item];
        }
    }
    else if(1 == self.segmentedControl.selectedSegmentIndex)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RCYHJCell1" owner:self options:nil];
        cell = [objects objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
        RCYHJCell1* temp = (RCYHJCell1*)cell;
        if(temp)
        {
            [temp updateContent:item];
        }
    }
    

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

@end
