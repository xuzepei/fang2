//
//  RCFangDaiResultViewController.m
//  RCFang
//
//  Created by xuzepei on 3/15/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCFangDaiResultViewController.h"
#import "RCTool.h"
#import "RCFangDaiRateCell.h"
#import "RCFangDaiCell.h"
#import "RCYueJunHuanKuanViewController.h"

@interface RCFangDaiResultViewController ()

@end

@implementation RCFangDaiResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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

- (void)updateContent:(NSDictionary*)item daikuanType:(int)daikuanType
{
    self.item = item;
    self.daikuanType = daikuanType;
    
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
        [_itemArray addObject:@"还款总额："];
        [_itemArray addObject:@"支付利息："];
        [_itemArray addObject:@"贷款月数："];
        [_itemArray addObject:@"月均还款："];
        [_itemArray addObject:@"贷款总额："];
        [_itemArray addObject:@"利率："];
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
    if(2 == self.daikuanType)
    {
        if(5 == indexPath.row)
            return 60.0;
    }
    
    return 40.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    static NSString *cellId1 = @"cellId1";
    static NSString *cellId2 = @"cellId2";
    static NSString *cellId3 = @"cellId3";
    static NSString *cellId4 = @"cellId4";
    static NSString *cellId5 = @"cellId5";
    
    UITableViewCell *cell = nil;

    if(0 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[RCFangDaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                         reuseIdentifier: cellId];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(_item)
        {
            RCFangDaiCell* temp = (RCFangDaiCell*)cell;
            NSString* tempStr = [NSString stringWithFormat:@"%@元",[_item objectForKey:@"huankuan_sum"]];
            [temp updateContent:tempStr];
        }
    }
    else if(1 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if(cell == nil)
        {
            cell = [[RCFangDaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                         reuseIdentifier: cellId1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(_item)
        {
            RCFangDaiCell* temp = (RCFangDaiCell*)cell;
            NSString* tempStr = [NSString stringWithFormat:@"%@元",[_item objectForKey:@"lixi_sum"]];
            [temp updateContent:tempStr];
        }
    }
    else if(2 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if(cell == nil)
        {
            cell = [[RCFangDaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                         reuseIdentifier: cellId2];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(_item)
        {
            RCFangDaiCell* temp = (RCFangDaiCell*)cell;
            [temp updateContent:[_item objectForKey:@"month_sum"]];
        }
    }
    else if(3 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId3];
        if(cell == nil)
        {
            cell = [[RCFangDaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                         reuseIdentifier: cellId3];
        }
        
        if(_item)
        {
            NSArray* array = [_item objectForKey:@"yue_huankuan"];
            
            if([array count] > 1)
            {
                RCFangDaiCell* temp = (RCFangDaiCell*)cell;
                NSString* tempStr = [NSString stringWithFormat:@"1月: %@元",[array objectAtIndex:0]];
                [temp updateContent:tempStr];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            else
            {
                RCFangDaiCell* temp = (RCFangDaiCell*)cell;
                NSString* tempStr = [NSString stringWithFormat:@"%@元",[array objectAtIndex:0]];
                [temp updateContent:tempStr];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        
    }
    else if(4 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId4];
        if(cell == nil)
        {
            cell = [[RCFangDaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                         reuseIdentifier: cellId4];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(_item)
        {
            RCFangDaiCell* temp = (RCFangDaiCell*)cell;
            NSString* tempStr = [NSString stringWithFormat:@"%@元",[_item objectForKey:@"daikuan_sum"]];
            [temp updateContent:tempStr];
        }
    }
    else if(5 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId5];
        if(cell == nil)
        {
            cell = [[RCFangDaiRateCell alloc] initWithStyle: UITableViewCellStyleDefault
                                             reuseIdentifier: cellId5];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        if(_item)
        {
            RCFangDaiRateCell* temp = (RCFangDaiRateCell*)cell;
            [temp updateContent:[_item objectForKey:@"rate"] value1:[_item objectForKey:@"rate1"]];
        }
    }

    
    cell.textLabel.text = [self getCellDataAtIndexPath:indexPath];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(3 == indexPath.row)
    {
        if(_item)
        {
            NSArray* array = [_item objectForKey:@"yue_huankuan"];
            if([array count] > 1)
            {
                RCYueJunHuanKuanViewController* temp = [[RCYueJunHuanKuanViewController alloc] initWithNibName:nil bundle:nil];
                [temp updateContent:array];
                 [self.navigationController pushViewController:temp animated:YES];

            }
        }
    }
}

@end
