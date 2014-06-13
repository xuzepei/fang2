//
//  RCTuanGouViewController.m
//  RCFang
//
//  Created by xuzepei on 5/27/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCTuanGouViewController.h"
#import "RCTool.h"
#import "RCXinFangCell.h"
#import "RCFangInfoViewController.h"
#import "RCZiXunViewController.h"
#import "RCHttpRequest.h"
#import "RCTuanGouInfoViewController.h"
#import "RCTuanGouCell.h"

#define HEADER_VIEW_HEIGHT 35.0

#define HEADER_BUTTON0_TAG 100
#define HEADER_BUTTON1_TAG 101
#define HEADER_BUTTON2_TAG 102
#define HEADER_BUTTON3_TAG 103

#define AD_FRAME_HEIGHT 120.0

@interface RCTuanGouViewController ()

@end

@implementation RCTuanGouViewController

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
    
    self.quyuSelection = nil;
    self.leixingSelection = nil;
    self.jiageSelection = nil;
    self.paixuSelection = nil;
    
    self.adScrollView = nil;
    self.count = nil;
    
    self.type = nil;
    self.detailInfo = nil;
    self.keyword = nil;
    self.username = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"热门团购";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];

    [self initTableView];
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

- (void)updateContent:(NSString*)username
{
    self.username = username;
    
    NSString* urlString = nil;
    if([self.username length])
    {
        urlString = [NSString stringWithFormat:@"%@/tuangou_list.php?apiid=%@&pwd=%@&page=%d&username=%@",BASE_URL,APIID,PWD,self.page,self.username];
    }
    else{
        urlString = [NSString stringWithFormat:@"%@/tuangou_list.php?apiid=%@&pwd=%@&page=%d",BASE_URL,APIID,PWD,self.page];
    }
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedRequest:) token:nil];
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
    CGRect lastItemRect = [_tableView rectForFooterInSection:1];
    
    if(contentoffset.y >= lastItemRect.origin.y - 290)
    {
        [self updateContent:self.username];
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
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    //    if(1 == section)
    //        return _headerView;
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    //    if(1 == section)
    //        return HEADER_VIEW_HEIGHT;
    
    return 0;
}

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath
{
    if(1 == indexPath.section)
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
    if(1 == section)
        return [_itemArray count] + 1;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(1 == indexPath.section)
    {
        if(0 == indexPath.row)
            return 20.0;
        else
            return 80.0;
    }
    
    return 0.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    static NSString *cellId1 = @"cellId1";
    static NSString *cellId2 = @"cellId2";
    UITableViewCell *cell = nil;
    
    if(1 == indexPath.section)
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
            
            cell.textLabel.text = [NSString stringWithFormat:@"共%@个楼盘",self.count];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
            if (cell == nil)
            {
                cell = [[RCTuanGouCell alloc] initWithStyle: UITableViewCellStyleDefault
                                             reuseIdentifier: cellId1];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
            
            NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
            if(item)
            {
                RCXinFangCell* temp = (RCXinFangCell*)cell;
                [temp updateContent:item];
            }
        }
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId2];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
            cell.textLabel.textColor = [UIColor grayColor];
            
            UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fangchandaogou_bg"]];
            cell.backgroundView = imageView;
        }
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(1 == indexPath.section)
    {
        if(0 != indexPath.row)
        {
            NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
            if(item)
            {
                RCTuanGouInfoViewController* temp = [[RCTuanGouInfoViewController alloc] initWithNibName:nil bundle:nil];
                temp.hidesBottomBarWhenPushed = YES;
                [temp updateContent:item];
                [self.navigationController pushViewController:temp animated:YES];

            }
        }
    }
}

#pragma mark - Header View

- (void)initHeaderView
{
    //区域
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"区域" forKey:@"name"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON0_TAG] forKey:@"tag"];
    self.quyuSelection = dict;
    
    //类型
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"类型" forKey:@"name"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON1_TAG] forKey:@"tag"];
    self.leixingSelection = dict;
    
    //价格
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"价格" forKey:@"name"];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObject:@"不限"];
    [array addObject:@"3000元每平米以下"];
    [array addObject:@"3000~5000元每平米"];
    [array addObject:@"5000~7000元每平米"];
    [array addObject:@"7000~90000元每平米"];
    [array addObject:@"9000~110000元每平米"];
    [array addObject:@"110000元每平米以上"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON2_TAG] forKey:@"tag"];
    self.jiageSelection = dict;
    
    //排序
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"排序" forKey:@"name"];
    array = [[NSMutableArray alloc] init];
    [array addObject:@"默认排序"];
    [array addObject:@"价格由高到低"];
    [array addObject:@"价格由低到高"];
    [array addObject:@"开盘时间倒序"];
    [array addObject:@"开盘时间顺序"];
    [array addObject:@"入住时间倒序"];
    [array addObject:@"入住时间顺序"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON3_TAG] forKey:@"tag"];
    self.paixuSelection = dict;
    
    if(nil == _headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, HEADER_VIEW_HEIGHT)];
    }
    
    if(nil == _headerButton0)
    {
        _headerButton0 = [[RCButtonView alloc] initWithFrame:CGRectMake(0, 0, 80, HEADER_VIEW_HEIGHT)];
        _headerButton0.delegate = self;
        _headerButton0.tag = HEADER_BUTTON0_TAG;
        _headerButton0.text = @"区域";
        [_headerView addSubview: _headerButton0];
    }
    
    if(nil == _headerButton1)
    {
        _headerButton1 = [[RCButtonView alloc] initWithFrame:CGRectMake(80, 0, 80, HEADER_VIEW_HEIGHT)];
        _headerButton1.delegate = self;
        _headerButton1.tag = HEADER_BUTTON1_TAG;
        _headerButton1.text = @"类型";
        [_headerView addSubview: _headerButton1];
    }
    
    
    if(nil == _headerButton2)
    {
        _headerButton2 = [[RCButtonView alloc] initWithFrame:CGRectMake(80*2, 0, 80, HEADER_VIEW_HEIGHT)];
        _headerButton2.delegate = self;
        _headerButton2.tag = HEADER_BUTTON2_TAG;
        _headerButton2.text = @"价格";
        [_headerView addSubview: _headerButton2];
    }
    
    if(nil == _headerButton3)
    {
        _headerButton3 = [[RCButtonView alloc] initWithFrame:CGRectMake(80*3, 0, 80, HEADER_VIEW_HEIGHT)];
        _headerButton3.delegate = self;
        _headerButton3.tag = HEADER_BUTTON3_TAG;
        _headerButton3.text = @"排序";
        [_headerView addSubview: _headerButton3];
    }
}

- (void)clickedHeaderButton:(int)tag token:(id)token
{
    NSLog(@"clickedHeaderButton");
    
    if(HEADER_BUTTON0_TAG == tag)
    {
        NSArray* array = [self.quyuSelection objectForKey:@"values"];
        if(nil == array || [array count] < 1)
        {
            
            NSMutableArray* values = [[NSMutableArray alloc] init];
            NSArray* areas = [RCTool getArea];
            if(areas && [areas count])
                [values addObjectsFromArray:areas];
            
            NSMutableDictionary* quyuSelection = [[NSMutableDictionary alloc] init];
            if(self.quyuSelection)
                [quyuSelection addEntriesFromDictionary:self.quyuSelection];
            [quyuSelection setObject:values forKey:@"values"];
            
            self.quyuSelection = quyuSelection;
        }
        
        [_pickerView updateContent:self.quyuSelection];
        [_pickerView show];
    }
    else if(HEADER_BUTTON1_TAG == tag)
    {
        NSArray* array = [self.leixingSelection objectForKey:@"values"];
        if(nil == array || [array count] < 1)
        {
            NSMutableArray* values = [[NSMutableArray alloc] init];
            NSArray* types = [RCTool getHouseType];
            if(types && [types count])
                [values addObjectsFromArray:types];
            
            NSMutableDictionary* leixingSelection = [[NSMutableDictionary alloc] init];
            if(self.leixingSelection)
                [leixingSelection addEntriesFromDictionary:self.leixingSelection];
            [leixingSelection setObject:values forKey:@"values"];
            
            self.leixingSelection = leixingSelection;
        }
        
        [_pickerView updateContent:self.leixingSelection];
        [_pickerView show];
    }
    else if(HEADER_BUTTON2_TAG == tag)
    {
        [_pickerView updateContent:self.jiageSelection];
        [_pickerView show];
    }
    else if(HEADER_BUTTON3_TAG == tag)
    {
        [_pickerView updateContent:self.paixuSelection];
        [_pickerView show];
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
    
    NSDictionary* dict = (NSDictionary*)token;
    int tag = [[dict objectForKey:@"tag"] intValue];
    if(HEADER_BUTTON0_TAG == tag)
    {
        _quyuIndex = index;
        
        NSString* temp = @"区域";
        NSArray* array = [_quyuSelection objectForKey:@"values"];
        NSDictionary* value = [array objectAtIndex: _quyuIndex];
        if(_quyuIndex)
            temp = [value objectForKey:@"name"];
        self.quyuSearchId = [[value objectForKey:@"id"] intValue];
        
        [_headerButton0 updateContent:temp];
    }
    else if(HEADER_BUTTON1_TAG == tag)
    {
        _leixingIndex = index;
        
        NSString* temp = @"类型";
        NSArray* array = [_leixingSelection objectForKey:@"values"];
        NSDictionary* value = [array objectAtIndex: _leixingIndex];
        if(_leixingIndex)
            temp = [value objectForKey:@"name"];
        self.leixingSearchId = [[value objectForKey:@"id"] intValue];
        
        [_headerButton1 updateContent:temp];
    }
    else if(HEADER_BUTTON2_TAG == tag)
    {
        _jiageIndex = index;
        
        NSString* temp = @"价格";
        if(_jiageIndex)
        {
            NSArray* array = [_jiageSelection objectForKey:@"values"];
            temp = [array objectAtIndex: _jiageIndex];
        }
        [_headerButton2 updateContent:temp];
    }
    else if(HEADER_BUTTON3_TAG == tag)
    {
        _paixuIndex = index;
        
        NSString* temp = @"排序";
        if(_paixuIndex)
        {
            NSArray* array = [_paixuSelection objectForKey:@"values"];
            temp = [array objectAtIndex: _paixuIndex];
        }
        
        [_headerButton3 updateContent:temp];
    }
    
    self.page = 1;
    [_itemArray removeAllObjects];
    [self updateContent:self.username];
}


@end
