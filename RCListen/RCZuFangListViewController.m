//
//  RCZuFangListViewController.m
//  RCFang
//
//  Created by xuzepei on 5/8/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCZuFangListViewController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"
#import "RCZuFangInfoViewController.h"


#define AD_FRAME_HEIGHT 120.0
#define HEADER_VIEW_HEIGHT 35.0

#define HEADER_BUTTON0_TAG 100
#define HEADER_BUTTON1_TAG 101
#define HEADER_BUTTON2_TAG 102
#define HEADER_BUTTON3_TAG 103

@interface RCZuFangListViewController ()

@end

@implementation RCZuFangListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _itemArray = [[NSMutableArray alloc] init];
        
        self.page = 1;
        self.count = @"0";
    }
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    self.itemArray = nil;
    self.headerView = nil;
    self.headerButton0 = nil;
    self.headerButton1 = nil;
    self.headerButton2 = nil;
    self.headerButton3 = nil;
    self.pickerView = nil;
    
    self.selection0 = nil;
    self.selection1 = nil;
    self.selection2 = nil;
    self.selection3 = nil;
    
    self.adScrollView = nil;
    self.count = nil;
    
    self.type = nil;
    self.detailInfo = nil;
    
    self.keyword = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    //[self updateAd];
    
    //[self initHeaderView];
    
    [self initTableView];
    
    //[self initPickerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.tableView = nil;
    self.headerView = nil;
    self.headerButton0 = nil;
    self.headerButton1 = nil;
    self.headerButton2 = nil;
    self.headerButton3 = nil;
    self.pickerView = nil;
    self.adScrollView = nil;
}

- (void)clickedRightBarButtonItem:(id)sender
{
    [[RCTool getTabBarController] setSelectedIndex:1];
}

- (void)updateContent:(NSString*)type info:(NSDictionary*)info
{
    NSString* urlString = nil;
    self.type = type;
    self.detailInfo = info;
    
    if(0 == [type length] && nil == info)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/rent_list.php?apiid=%@&apikey=%@&page=%d&area=%d&source=%d&price=%d&sort=%d",BASE_URL,APIID,PWD,self.page,self.area,self.typeIndex,self.price,0];
        
        NSString* token = [NSString stringWithFormat:@"keyword=%@",self.keyword];
        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
        BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedRequest:) token:token];
        if(b)
        {
            [RCTool showIndicator:@"请稍候..."];
        }
    }
    else{
        
        if([self.type isEqualToString:@"same"])
        {
            self.title = @"同小区房源";
            NSString* num = [self.detailInfo objectForKey:@"r_num"];
            urlString = [NSString stringWithFormat:@"%@/rent_more.php?apiid=%@&apikey=%@&page=%d&type=%@&num=%@",BASE_URL,APIID,PWD,self.page,self.type,num];
        }
        else if([self.type isEqualToString:@"price"])
        {
            self.title = @"同价位房源";
            NSString* price = [self.detailInfo objectForKey:@"h_pricenum"];
            urlString = [NSString stringWithFormat:@"%@/rent_more.php?apiid=%@&apikey=%@&page=%d&type=%@&price=%@",BASE_URL,APIID,PWD,self.page,self.type,price];
        }
        
        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
        BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedRequest:) token:nil];
        if(b)
        {
            [RCTool showIndicator:@"请稍候..."];
        }
    }
    

}

- (void)updateContent:(NSArray*)array count:(NSString*)count area:(int)area type:(int)type price:(int)price keyword:(NSString*)keyword
{
    self.title = @"租房房源";
    
    if([array count])
    {
        [_itemArray removeAllObjects];
        [_itemArray addObjectsFromArray:array];
    }
    
    if([count length])
        self.count = count;
    
    self.area = area;
    self.typeIndex = type;
    self.price = price;
    self.page = 2;
    self.keyword = keyword;
    
    [_tableView reloadData];
}

- (void)finishedRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        self.page++;
        
        NSString* count = [result objectForKey:@"count"];
        if([count length])
            self.count = count;
        
        NSArray* array = [result objectForKey:@"list"];
        if(array && [array isKindOfClass:[NSArray class]])
        {
            //[_itemArray removeAllObjects];
            [_itemArray addObjectsFromArray:array];
        }
    }
    
    [_tableView reloadData];
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
        [self updateContent:self.type info:self.detailInfo];
    }
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
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{

    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{

    
    return 0;
}

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath
{
    if(0 == indexPath.section)
    {
        if(0 == indexPath.row)
            return nil;
        
        if(indexPath.row - 1 >= [_itemArray count])
            return nil;
        
        return [_itemArray objectAtIndex: indexPath.row - 1];
    }
    
    return nil;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(0 == section)
        return [_itemArray count] + 1;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)
    {
        if(0 == indexPath.row)
            return 20.0;
        else
            return 80.0;
    }
    
    return 40.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    static NSString *cellId1 = @"cellId1";
    
    UITableViewCell *cell = nil;
    
    if(0 == indexPath.section)
    {
        if(0 == indexPath.row)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                               reuseIdentifier: cellId];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.textLabel.textColor = [UIColor grayColor];
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"共%@个房源",self.count];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
            if (cell == nil)
            {
                cell = [[RCSecondHandHouseCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                     reuseIdentifier: cellId1];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
            
            NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
            if(item)
            {
                RCSecondHandHouseCell* temp = (RCSecondHandHouseCell*)cell;
                [temp updateContent:item];
            }
        }
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(0 == indexPath.section)
    {
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
        if(item)
        {
            RCZuFangInfoViewController* temp = [[RCZuFangInfoViewController alloc] initWithNibName:nil bundle:nil];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:item];
            [self.navigationController pushViewController:temp animated:YES];

        }
    }
}

@end
