//
//  RCShuiFeiResultViewController.m
//  RCFang
//
//  Created by xuzepei on 3/16/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCShuiFeiResultViewController.h"
#import "RCTool.h"
#import "RCShuiFeiResultCell.h"

@interface RCShuiFeiResultViewController ()

@end

@implementation RCShuiFeiResultViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"税费计算";
        _itemArray = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

- (void)dealloc
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    if(_tableView)
        [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self initLabels];
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.tableView = nil;
    self.headerLabel = nil;
    self.footerLabel = nil;
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    [_tableView reloadData];
}

#pragma mark - Labels

- (void)initLabels
{
    if(nil == _headerLabel)
    {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
        _headerLabel.backgroundColor = [UIColor clearColor];
        _headerLabel.textColor = [UIColor blackColor];
        _headerLabel.font = [UIFont boldSystemFontOfSize:16];
        _headerLabel.textAlignment = UITextAlignmentLeft;
        _headerLabel.text = @"  计算结果";
    }
    
    
    if(nil == _footerLabel)
    {
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
        _footerLabel.backgroundColor = [UIColor clearColor];
        _footerLabel.textColor = [UIColor blackColor];
        _footerLabel.font = [UIFont boldSystemFontOfSize:16];
        _footerLabel.textAlignment = UITextAlignmentLeft;
        _footerLabel.text = @"  以上计算结果仅供参考。";
    }
}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
    }
	
	[self.view addSubview:_tableView];
    
    if(0 == [_itemArray count])
    {
        [_itemArray addObject:@"房贷总价："];
        [_itemArray addObject:@"印花税："];
        [_itemArray addObject:@"公证费："];
        [_itemArray addObject:@"契税："];
        [_itemArray addObject:@"委托办理产权手续费："];
        [_itemArray addObject:@"房屋买卖手续费："];
    }
    
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerLabel;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _footerLabel;
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
    return 40.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = nil;

    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[RCShuiFeiResultCell alloc] initWithStyle: UITableViewCellStyleDefault
                                     reuseIdentifier: cellId];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [self getCellDataAtIndexPath:indexPath];
    
    if(_item)
    {
        RCShuiFeiResultCell* temp = (RCShuiFeiResultCell*)cell;
        NSString* tempStr = nil;
        if(0 == indexPath.row)
        {
           tempStr = [NSString stringWithFormat:@"%@元",[_item objectForKey:@"zongjia"]];
        }
        else if(1 == indexPath.row)
        {
            tempStr = [NSString stringWithFormat:@"%@元",[_item objectForKey:@"yinhuashui"]];
        }
        else if(2 == indexPath.row)
        {
            tempStr = [NSString stringWithFormat:@"%@元",[_item objectForKey:@"gongzhengfei"]];
        }
        else if(3 == indexPath.row)
        {
            tempStr = [NSString stringWithFormat:@"%@元",[_item objectForKey:@"qishui"]];
        }
        else if(4 == indexPath.row)
        {
            tempStr = [NSString stringWithFormat:@"%@元",[_item objectForKey:@"weituofei"]];
        }
        else if(5 == indexPath.row)
        {
            tempStr = [NSString stringWithFormat:@"%@元",[_item objectForKey:@"fangwumaimaishouxufei"]];
        }

        [temp updateContent:tempStr];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

@end
