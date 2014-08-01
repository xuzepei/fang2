//
//  RCDDViewController.m
//  RCFang
//
//  Created by xuzepei on 6/18/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDViewController.h"
#import "RCPublicCell.h"

#define SEGMENTED_BAR_HEIGHT 50.0f

@interface RCDDViewController ()

@end

@implementation RCDDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"订单";
        self.view.backgroundColor = BG_COLOR;
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

#pragma mark - SegmentedControl

- (void)initSegmentedControl
{
    if(nil == _segmentedControl)
    {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"有效订单 10",@"自由订单 1",@"组团订单 1",nil]];
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
}

#pragma mark - Table View

- (void)initTableView
{
    if(nil == _itemArray)
        _itemArray = [[NSMutableArray alloc] init];
    
    if(nil == _itemArray0)
        _itemArray0 = [[NSMutableArray alloc] init];
    
    if(nil == _itemArray1)
        _itemArray1 = [[NSMutableArray alloc] init];
    
    if(nil == _itemArray2)
        _itemArray2 = [[NSMutableArray alloc] init];
    
    if(nil == _tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,SEGMENTED_BAR_HEIGHT,[RCTool getScreenSize].width,[RCTool getScreenSize].height - NAVIGATION_BAR_HEIGHT - SEGMENTED_BAR_HEIGHT)
                                                  style:UITableViewStyleGrouped];
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
    }
    
    NSDictionary* dict = @{@"ddbh":@"2568855666",
                           @"fwxq":@"搬家",
                           @"bx":@"赠送",
                           @"yq":@"无电梯上楼，双倍积分",
                           @"zt":@"已发布",
                           @"yz":@"3"};
    [_itemArray addObject:dict];
    [_itemArray addObject:dict];
    [_itemArray addObject:dict];
    [_itemArray addObject:dict];
    
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
//    static NSString *cellId2 = @"cellId2";
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
    if(cell == nil)
    {
        cell = [[RCPublicCell alloc] initWithStyle: UITableViewCellStyleDefault
                                   reuseIdentifier: cellId1 contentViewClass:NSClassFromString(@"RCDDCellContentView")];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
    RCPublicCell* temp = (RCPublicCell*)cell;
    if(temp)
    {
        [temp updateContent:item cellHeight:[self getCellHeight:indexPath] delegate:self token:nil];
    }

//    else
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:cellId0];
//        if(nil == cell)
//        {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId0];
//            
//            //cell.backgroundColor = BG_COLOR;
//            cell.textLabel.text = @"更多...";
//            cell.textLabel.textAlignment = NSTextAlignmentCenter;
//        }
//    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
//    if(2 == indexPath.section)
//    {
//        [self updateContent:self.item];
//    }
}

- (void)clickedButton:(id)token
{
    NSLog(@"clickedButton");
}

@end
