//
//  RCJFViewController.m
//  RCFang
//
//  Created by xuzepei on 10/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCJFViewController.h"
#import "RCJFCell.h"
#import "RCHttpRequest.h"
#import "RCJFDHViewController.h"


#define TOP_VIEW_HEIGHT 80.0f
#define CELL_HEIGHT 99.0f

@interface RCJFViewController ()

@end

@implementation RCJFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

		self.title = @"我的积分";
        
        self.view.backgroundColor = [RCTool colorWithHexString:@"0xf0f0f0"];
        
        if(nil == _itemArray)
            _itemArray = [[NSMutableArray alloc] init];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"积分兑换" style:UIBarButtonItemStylePlain target:self action:@selector(clickedRightBarButtonItem:)];
    }
    return self;
}

- (void)dealloc
{
    self.topView = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initTopView];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateContent];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedRightBarButtonItem:(id)sender
{
    RCJFDHViewController* temp = [[RCJFDHViewController alloc] initWithNibName:nil bundle:nil];
    [temp updateContent:self.item];
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)updateContent
{
    if(NO == [RCTool isLogined])
        return;
    
    NSString* username = [RCTool getUsername];
    NSString* password = [RCTool getPassword];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user_credit.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"username=%@&password=%@&type=list",username,password];
    
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
        //if(0 == [error length])
        {
            self.item = result;
            
            [self.topView updateContent:self.item];
            
            NSArray* array = [self.item objectForKey:@"credit_list"];
            if(array && [array isKindOfClass:[NSArray class]])
            {
                [_itemArray removeAllObjects];
                [_itemArray addObjectsFromArray:array];
                [self.tableView reloadData];
            }
            
            //return;
        }
        
        if([error length])
            [RCTool showAlert:@"提示" message:error];
        
    }
}

#pragma mark - Top View

- (void)initTopView
{
    if(nil == _topView)
    {
        _topView = [[RCMeTopView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, TOP_VIEW_HEIGHT)];
    }
    
    for(UIView* subView in [_topView subviews])
        [subView removeFromSuperview];
    
    [_topView setNeedsDisplay];
    [self.view addSubview:_topView];
}

#pragma mark - UITableView

- (void)initTableView
{
    CGFloat height = TOP_VIEW_HEIGHT;

    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,height,[RCTool getScreenSize].width,[RCTool getScreenSize].height - height -TAB_BAR_HEIGHT)
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
    }
    
    _tableView.frame = CGRectMake(0,height,[RCTool getScreenSize].width,[RCTool getScreenSize].height - height - TAB_BAR_HEIGHT);
	
	[self.view addSubview:_tableView];
    
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(0 == section)
        return 8;
    
    return 30.0;
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
    if(cell == nil)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RCJFCell" owner:self options:nil];
        cell = [objects objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
    RCJFCell* temp = (RCJFCell*)cell;
    if(temp)
    {
        [temp updateContent:item];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    
    if(0 == indexPath.row)
    {

    }
    else if(1 == indexPath.row)
    {
        
    }
    else if(2 == indexPath.row)
    {
        
    }
}

@end
