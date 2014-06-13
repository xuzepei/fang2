//
//  RCFangDaiViewController.m
//  RCFang
//
//  Created by xuzepei on 3/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCFangDaiViewController.h"
#import "RCTool.h"
#import "RCDaiKuanTypeViewController.h"
#import "RCAnJieYearViewController.h"
#import "RCRateTypeViewController.h"
#import "RCFangDaiCell.h"
#import "RCFangDaiRateCell.h"
#import "RCFangDaiResultViewController.h"

#define SANGDAI_SUM_TAG 100
#define GONGJIJIN_SUM_TAG 101

@interface RCFangDaiViewController ()

@end

@implementation RCFangDaiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
		self.title = @"房贷计算器";
        
        _itemArray = [[NSMutableArray alloc] init];
        
        self.daikuanTypeArray = [NSArray arrayWithObjects:@"商业贷款",@"公积金贷款",@"组合贷款",nil];
        
        self.anjieYearArray = [NSArray arrayWithObjects:@"1 年 (12期)",@"2 年 (24期)",@"3 年 (36期)",@"4 年 (48期)",@"5 年 (60期)",@"6 年 (72期)",@"7 年 (84期)",@"8 年 (96期)",@"9 年 (108期)",@"10 年 (120期)",@"11 年 (132期)",@"12 年 (144期)",@"13 年 (156期)",@"14 年 (168期)",@"15 年 (180期)",@"16 年 (192期)",@"17 年 (204期)",@"18 年 (216期)",@"19 年 (228期)",@"20 年 (240期)",@"21 年 (252期)",@"22 年 (264期)",@"23 年 (276期)",@"24 年 (288期)",@"25 年 (300期)",@"26 年 (312期)",@"27 年 (324期)",@"28 年 (336期)",@"29 年 (348期)",@"30 年 (360期)",nil];
        
        self.rateTypeArray = [NSArray arrayWithObjects:@"12年7月6日利率上限 (1.1倍)",@"12年7月6日利率下限 (85折)",@"12年7月6日利率下限 (7折)",@"12年7月6日基准利率",@"12年6月8日利率上限 (1.1倍)",@"12年6月8日利率下限 (85折)",@"12年6月8日利率下限 (7折)",@"12年6月8日基准利率",@"11年7月7日利率上限 (1.1倍)",@"11年7月7日利率下限 (85折)",@"11年7月7日利率下限 (7折)",@"11年7月7日基准利率",@"11年4月6日利率上限 (1.1倍)",@"11年4月6日利率下限 (85折)",@"11年4月6日利率下限 (7折)",@"11年4月6日基准利率",@"11年2月9日利率上限 (1.1倍)",@"11年2月9日利率下限 (85折)",@"11年2月9日利率下限 (7折)",@"11年2月9日基准利率",@"10年12月26日利率上限 (1.1倍)",@"10年12月26日利率下限 (85折)",@"10年12月26日利率下限 (7折)",@"10年12月26日基准利率",@"10年10月20日利率上限 (1.1倍)",@"10年10月20日利率下限 (85折)",@"10年10月20日利率下限 (7折)",@"10年10月20日基准利率",@"08年12月23日利率上限 (1.1倍)",@"08年12月23日利率下限 (85折)",@"08年12月23日利率下限 (7折)",@"08年12月23日基准利率",nil];
        
        self.anjieYear = 19;
        self.rateType = 3;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
        
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    [self initTextFields];
    
    [self initTableView];
    
    [self initButtons];
    
    [self initSegmentedControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.tableView = nil;
    self.calculateButton = nil;
    self.sangdaiSum = nil;
    self.gongjijinSum = nil;
}

#pragma mark - SegmentedControl

- (void)initSegmentedControl
{
    if(nil == _segmentedControl)
    {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"  等额本金  ",@"  等额本息  ",nil]];
        
        _segmentedControl.center = CGPointMake(160, 30);
        
        [_segmentedControl addTarget:self
                              action:@selector(clickedSegmentedControl:)
                    forControlEvents:UIControlEventValueChanged];
        
        [_segmentedControl setSelectedSegmentIndex:0];
    }
    
    [self.tableView addSubview: _segmentedControl];
}

- (void)clickedSegmentedControl:(id)sender
{
    self.huankuanType = _segmentedControl.selectedSegmentIndex;
}

- (float)getSangDaiRate
{
    if(_anjieYear + 1 <= 5)
    {
        return g_rate_sangdai_5[_rateType];
    }
    else
    {
        return g_rate_sangdai_30[_rateType];
    }
    
    return 0.0;
}

- (float)getGongJiJinRate
{
    if(_anjieYear + 1 <= 5)
    {
        return g_rate_gojijin_5[_rateType];
    }
    else
    {
        return g_rate_gojijin_30[_rateType];
    }
    
    return 0.0;
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
        [_itemArray addObject:@"贷款类别"];
        [_itemArray addObject:@"按揭年数"];
        [_itemArray addObject:@"利率类型"];
        [_itemArray addObject:@"利率"];
        [_itemArray addObject:@"贷款总额"];
    }
    
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.0;
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
        if(3 == indexPath.row || 4 == indexPath.row)
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
    
    UITableViewCell *cell = nil;
    NSString* item = (NSString*)[self getCellDataAtIndexPath: indexPath];
    
    if(0 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[RCFangDaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                         reuseIdentifier: cellId];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        RCFangDaiCell* temp = (RCFangDaiCell*)cell;
        [temp updateContent:[self.daikuanTypeArray objectAtIndex:self.daikuanType]];
    }
    else if(1 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if(cell == nil)
        {
            cell = [[RCFangDaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                         reuseIdentifier: cellId1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        RCFangDaiCell* temp = (RCFangDaiCell*)cell;
        [temp updateContent:[self.anjieYearArray objectAtIndex:self.anjieYear]];
    }
    else if(2 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if(cell == nil)
        {
            cell = [[RCFangDaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                         reuseIdentifier: cellId2];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        RCFangDaiCell* temp = (RCFangDaiCell*)cell;
        [temp updateContent:[self.rateTypeArray objectAtIndex:self.rateType]];
    }
    else if(3 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId3];
        if(cell == nil)
        {
            cell = [[RCFangDaiRateCell alloc] initWithStyle: UITableViewCellStyleDefault
                                             reuseIdentifier: cellId3];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString* rate0 = nil;
        NSString* rate1 = nil;
        
        if(0 == _daikuanType)
        {
            rate0 = [NSString stringWithFormat:@"%.2f%%",[self getSangDaiRate]*100];
        }
        else if(1 == _daikuanType)
        {
            rate0 = [NSString stringWithFormat:@"%.2f%%",[self getGongJiJinRate]*100];
        }
        else if(2 == _daikuanType)
        {
            rate0 = [NSString stringWithFormat:@"%.2f%%",[self getSangDaiRate]*100];
            
            rate1 = [NSString stringWithFormat:@"%.2f%%",[self getGongJiJinRate]*100];
        }
        
        RCFangDaiRateCell* temp = (RCFangDaiRateCell*)cell;
        [temp updateContent:rate0 value1:rate1];
    }
    else if(4 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId4];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId4];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell addSubview:_sangdaiSum];
        
        if(2 == _daikuanType)
        {
            _sangdaiSum.placeholder = @"请输入商业贷款总额（单位:万元）";
            [cell addSubview:_gongjijinSum];
        }
        else
        {
            _sangdaiSum.placeholder = @"请输入贷款总额（单位:万元）";
            _gongjijinSum.text = @"";
            [_gongjijinSum removeFromSuperview];
        }
    }
    
    cell.textLabel.text = item;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(0 == indexPath.row)
    {
        RCDaiKuanTypeViewController* temp = [[RCDaiKuanTypeViewController alloc] initWithNibName:nil bundle:nil];
        temp.delegate = self;
        [temp updateContent:self.daikuanTypeArray selectedIndex:_daikuanType];
        [self.navigationController pushViewController:temp animated:YES];
  }
    else if(1 == indexPath.row)
    {
        RCAnJieYearViewController* temp = [[RCAnJieYearViewController alloc] initWithNibName:nil bundle:nil];
        temp.delegate = self;
        [temp updateContent:self.anjieYearArray selectedIndex:_anjieYear];
        [self.navigationController pushViewController:temp animated:YES];

    }
    else if(2 == indexPath.row)
    {
        RCRateTypeViewController* temp = [[RCRateTypeViewController alloc] initWithNibName:nil bundle:nil];
        temp.delegate = self;
        [temp updateContent:self.rateTypeArray selectedIndex:_rateType];
        [self.navigationController pushViewController:temp animated:YES];

    }
}

#pragma mark Buttons

- (void)initButtons
{
    if(nil == _calculateButton)
    {
        self.calculateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _calculateButton.frame = CGRectMake(40, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - 50, 240, 40);
        //        [_loginButton setImage:[UIImage imageNamed:@"location_button"] forState:UIControlStateNormal];
        [_calculateButton setTitle:@"开始计算" forState:UIControlStateNormal];
        [_calculateButton addTarget:self action:@selector(clickedCalculateButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview: _calculateButton];
    }
    
}

//本息还款的月还款额(参数: 年利率/贷款总额/贷款总月份)
- (float)getMonthMoney1:(float)lilv total:(float)total month:(float)month
{
	float lilv_month = lilv / 12;//月利率
	return total * lilv_month * pow(1 + lilv_month, month) / (pow(1 + lilv_month, month) -1 );
}

//本金还款的月还款额(参数: 年利率 / 贷款总额 / 贷款总月份 / 贷款当前月0～length-1)
- (float)getMonthMoney2:(float)lilv total:(float)total month:(float)month cur_month:(float)cur_month;
{
	float lilv_month = lilv / 12;//月利率

	float benjin_money = total / month;
    
	return (total - benjin_money * cur_month) * lilv_month + benjin_money;
}

- (NSDictionary*)getResult
{
    if(2 == _daikuanType)
    {
        if(0 == [_sangdaiSum.text length] || [_sangdaiSum.text hasPrefix:@"."] || [_sangdaiSum.text hasSuffix:@"."])
        {
            [RCTool showAlert:@"提示" message:@"请输入正确的商业贷款总额（单位:万元）"];
            return nil;
        }
        
        if(0 == [_gongjijinSum.text length] || [_gongjijinSum.text hasPrefix:@"."] || [_gongjijinSum.text hasSuffix:@"."])
        {
            [RCTool showAlert:@"提示" message:@"请输入正确的公积金贷款总额（单位:万元）"];
            return nil;
        }
        
    }
    else
    {
        if(0 == [_sangdaiSum.text length] || [_sangdaiSum.text hasPrefix:@"."] || [_sangdaiSum.text hasSuffix:@"."])
        {
            [RCTool showAlert:@"提示" message:@"请输入正确的贷款总额（单位:万元）"];
            return nil;
        }
    }
    
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    float sangdaiRate = [self getSangDaiRate];
    float gongjijinRate = [self getGongJiJinRate];
    int years = self.anjieYear+1;
    int month = years*12;
    
    NSString* huankuan_sum = @"";
    NSString* lixi_sum = @"";
    NSString* daikuan_sum = @"";
    NSString* month_sum = [NSString stringWithFormat:@"%d(月)",month];
    NSString* rate = @"";

    if(0 == _daikuanType)
    {
        float daikuan_total = [_sangdaiSum.text floatValue]*10000;
        float all_total = 0.0;
        
        if(0 == _huankuanType)//等额本金
        {
            NSMutableArray* yuejunhuankuanArray = [[NSMutableArray alloc] init];

            for(int i = 0; i < month; i++)
            {
				float huankuan = [self getMonthMoney2:sangdaiRate total:daikuan_total month:month cur_month:i];
				all_total += huankuan;
                
                huankuan = round(huankuan * 100) / 100;
                
                [yuejunhuankuanArray addObject:[NSString stringWithFormat:@"%.2f",huankuan]];
			}
            
            //NSLog(@"yuejunhuankuanArray:%@",yuejunhuankuanArray);
            
            [result setObject:yuejunhuankuanArray forKey:@"yue_huankuan"];
            
            all_total = round(all_total * 100) / 100;
            daikuan_total = round(daikuan_total * 100) / 100;
            
            huankuan_sum = [NSString stringWithFormat:@"%.2f",all_total];
            [result setObject:huankuan_sum forKey:@"huankuan_sum"];
            
            lixi_sum = [NSString stringWithFormat:@"%.2f",all_total - daikuan_total];
            [result setObject:lixi_sum forKey:@"lixi_sum"];
            
            daikuan_sum = [NSString stringWithFormat:@"%.2f",daikuan_total];
            [result setObject:daikuan_sum forKey:@"daikuan_sum"];
            
            [result setObject:month_sum forKey:@"month_sum"];
            
            rate = [NSString stringWithFormat:@"%.2f%%",sangdaiRate*100];
            [result setObject:rate forKey:@"rate"];
            
        }
        else if(1 == _huankuanType)//等额本息
        {
            NSMutableArray* yuejunhuankuanArray = [[NSMutableArray alloc] init];
            
			float month_huankuan = [self getMonthMoney1:sangdaiRate total:daikuan_total month:month];
            
            month_huankuan = round(month_huankuan * 100) / 100;
            
            [yuejunhuankuanArray addObject:[NSString stringWithFormat:@"%.2f",month_huankuan]];
            
            [result setObject:yuejunhuankuanArray forKey:@"yue_huankuan"];
            
            all_total = month_huankuan * month;
            all_total = round(all_total * 100) / 100;
            daikuan_total = round(daikuan_total * 100) / 100;
            
            huankuan_sum = [NSString stringWithFormat:@"%.2f",all_total];
            [result setObject:huankuan_sum forKey:@"huankuan_sum"];
            
            lixi_sum = [NSString stringWithFormat:@"%.2f",all_total - daikuan_total];
            [result setObject:lixi_sum forKey:@"lixi_sum"];
            
            daikuan_sum = [NSString stringWithFormat:@"%.2f",daikuan_total];
            [result setObject:daikuan_sum forKey:@"daikuan_sum"];
            
            [result setObject:month_sum forKey:@"month_sum"];
            
            rate = [NSString stringWithFormat:@"%.2f%%",sangdaiRate*100];
            [result setObject:rate forKey:@"rate"];
        }
    }
    else if(1 == _daikuanType)
    {
        float daikuan_total = [_sangdaiSum.text floatValue]*10000;
        float all_total = 0.0;
        
        if(0 == _huankuanType)//等额本金
        {
            NSMutableArray* yuejunhuankuanArray = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < month; i++)
            {
				float huankuan = [self getMonthMoney2:gongjijinRate total:daikuan_total month:month cur_month:i];
				all_total += huankuan;
                
                huankuan = round(huankuan * 100)/100;
                
                [yuejunhuankuanArray addObject:[NSString stringWithFormat:@"%.2f",huankuan]];
			}
            
            //NSLog(@"yuejunhuankuanArray:%@",yuejunhuankuanArray);
            
            [result setObject:yuejunhuankuanArray forKey:@"yue_huankuan"];
            
            all_total = round(all_total * 100) / 100;
            daikuan_total = round(daikuan_total * 100) / 100;
            
            huankuan_sum = [NSString stringWithFormat:@"%.2f",all_total];
            [result setObject:huankuan_sum forKey:@"huankuan_sum"];
            
            lixi_sum = [NSString stringWithFormat:@"%.2f",all_total - daikuan_total];
            [result setObject:lixi_sum forKey:@"lixi_sum"];
            
            daikuan_sum = [NSString stringWithFormat:@"%.2f",daikuan_total];
            [result setObject:daikuan_sum forKey:@"daikuan_sum"];
            
            [result setObject:month_sum forKey:@"month_sum"];
            
            rate = [NSString stringWithFormat:@"%.2f%%",gongjijinRate*100];
            [result setObject:rate forKey:@"rate"];
            
        }
        else if(1 == _huankuanType)//等额本息
        {
            NSMutableArray* yuejunhuankuanArray = [[NSMutableArray alloc] init];
            
			float month_huankuan = [self getMonthMoney1:gongjijinRate total:daikuan_total month:month];
            
            month_huankuan = round(month_huankuan * 100)/100;
            
            [yuejunhuankuanArray addObject:[NSString stringWithFormat:@"%.2f",month_huankuan]];
            
            [result setObject:yuejunhuankuanArray forKey:@"yue_huankuan"];
            
            all_total = month_huankuan * month;
            all_total = round(all_total * 100) / 100;
            daikuan_total = round(daikuan_total * 100) / 100;
            
            huankuan_sum = [NSString stringWithFormat:@"%.2f",all_total];
            [result setObject:huankuan_sum forKey:@"huankuan_sum"];
            
            lixi_sum = [NSString stringWithFormat:@"%.2f",all_total - daikuan_total];
            [result setObject:lixi_sum forKey:@"lixi_sum"];
            
            daikuan_sum = [NSString stringWithFormat:@"%.2f",daikuan_total];
            [result setObject:daikuan_sum forKey:@"daikuan_sum"];
            
            [result setObject:month_sum forKey:@"month_sum"];
            
            rate = [NSString stringWithFormat:@"%.2f%%",gongjijinRate*100];
            [result setObject:rate forKey:@"rate"];
        }
    }
    else if(2 == _daikuanType)
    {
        float sangdai_total = [_sangdaiSum.text floatValue]*10000;
        float gongjijin_total = [_gongjijinSum.text floatValue]*10000;
        
        float daikuan_total = sangdai_total + gongjijin_total;
        float all_total = 0.0;
        
        if(0 == _huankuanType)//等额本金
        {
            NSMutableArray* yuejunhuankuanArray = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < month; i++)
            {
				float huankuan = [self getMonthMoney2:sangdaiRate total:sangdai_total month:month cur_month:i] +[self getMonthMoney2:gongjijinRate total:gongjijin_total month:month cur_month:i];
                
				all_total += huankuan;
                
                huankuan = round(huankuan * 100)/100;
                
                [yuejunhuankuanArray addObject:[NSString stringWithFormat:@"%.2f",huankuan]];
			}
            
            //NSLog(@"yuejunhuankuanArray:%@",yuejunhuankuanArray);
            
            [result setObject:yuejunhuankuanArray forKey:@"yue_huankuan"];
            
            all_total = round(all_total * 100) / 100;
            daikuan_total = round(daikuan_total * 100) / 100;
            
            huankuan_sum = [NSString stringWithFormat:@"%.2f",all_total];
            [result setObject:huankuan_sum forKey:@"huankuan_sum"];
            
            lixi_sum = [NSString stringWithFormat:@"%.2f",all_total - daikuan_total];
            [result setObject:lixi_sum forKey:@"lixi_sum"];
            
            daikuan_sum = [NSString stringWithFormat:@"%.2f",daikuan_total];
            [result setObject:daikuan_sum forKey:@"daikuan_sum"];
            
            [result setObject:month_sum forKey:@"month_sum"];
            
            rate = [NSString stringWithFormat:@"%.2f%%",sangdaiRate*100];
            [result setObject:rate forKey:@"rate"];
            
            rate = [NSString stringWithFormat:@"%.2f%%",gongjijinRate*100];
            [result setObject:rate forKey:@"rate1"];
        }
        else if(1 == _huankuanType)//等额本息
        {
            NSMutableArray* yuejunhuankuanArray = [[NSMutableArray alloc] init];
            
			float month_huankuan = [self getMonthMoney1:sangdaiRate total:sangdai_total month:month] + [self getMonthMoney1:gongjijinRate total:gongjijin_total month:month];
            
            month_huankuan = round(month_huankuan * 100)/100;
            
            [yuejunhuankuanArray addObject:[NSString stringWithFormat:@"%.2f",month_huankuan]];
            
            [result setObject:yuejunhuankuanArray forKey:@"yue_huankuan"];
            
            all_total = month_huankuan * month;
            all_total = round(all_total * 100) / 100;
            daikuan_total = round(daikuan_total * 100) / 100;
            
            huankuan_sum = [NSString stringWithFormat:@"%.2f",all_total];
            [result setObject:huankuan_sum forKey:@"huankuan_sum"];
            
            lixi_sum = [NSString stringWithFormat:@"%.2f",all_total - daikuan_total];
            [result setObject:lixi_sum forKey:@"lixi_sum"];
            
            daikuan_sum = [NSString stringWithFormat:@"%.2f",daikuan_total];
            [result setObject:daikuan_sum forKey:@"daikuan_sum"];
            
            [result setObject:month_sum forKey:@"month_sum"];
            
            rate = [NSString stringWithFormat:@"%.2f%%",sangdaiRate*100];
            [result setObject:rate forKey:@"rate"];
            
            rate = [NSString stringWithFormat:@"%.2f%%",gongjijinRate*100];
            [result setObject:rate forKey:@"rate1"];
        }
    }

    return result;
}

- (void)clickedCalculateButton:(id)sender
{
    NSLog(@"clickedCalculateButton");
    
    NSDictionary* result = [self getResult];
    if(result)
    {
        RCFangDaiResultViewController* temp = [[RCFangDaiResultViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:result daikuanType:_daikuanType];
        if(0 == _huankuanType)
        {
            temp.title = @"等额本金计算法";
        }
        else
        {
            temp.title = @"等额本息计算法";
        }
        
        [self.navigationController pushViewController:temp animated:YES];

    }
}

#pragma mark - TextFields

- (void)initTextFields
{
    if(nil == _sangdaiSum)
    {
        _sangdaiSum = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 20)];
        _sangdaiSum.tag = SANGDAI_SUM_TAG;
        _sangdaiSum.backgroundColor = [UIColor clearColor];
        _sangdaiSum.borderStyle = UITextBorderStyleLine;
        _sangdaiSum.font = [UIFont systemFontOfSize:12];
        _sangdaiSum.placeholder = @"请输入贷款总额（单位:万元）";
        _sangdaiSum.returnKeyType = UIReturnKeyDone;
        _sangdaiSum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _sangdaiSum.delegate = self;
    }
    
    if(nil == _gongjijinSum)
    {
        _gongjijinSum = [[UITextField alloc] initWithFrame:CGRectMake(100, 14 + 20, 200, 20)];
        _gongjijinSum.tag = GONGJIJIN_SUM_TAG;
        _gongjijinSum.backgroundColor = [UIColor clearColor];
        _gongjijinSum.borderStyle = UITextBorderStyleLine;
        _gongjijinSum.font = [UIFont systemFontOfSize:12];
        _gongjijinSum.placeholder = @"请输入公积金贷款总额（单位:万元）";
        _gongjijinSum.returnKeyType = UIReturnKeyDone;
        _gongjijinSum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _gongjijinSum.delegate = self;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString* numbers = @"0123456789.";
    NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL b = [string isEqualToString:filtered];
    if(!b)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    
    if(SANGDAI_SUM_TAG == textField.tag)
    {
        if([textField.text hasPrefix:@"."] || [textField.text hasSuffix:@"."])
        {
            [RCTool showAlert:@"提示" message:@"请输入正确的贷款总额(单位：万元)"];
            return NO;
        }
        
        if(2 == _daikuanType)
            [_gongjijinSum becomeFirstResponder];
        else
            [_sangdaiSum resignFirstResponder];
    }
    else
    {
        [_gongjijinSum resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - KeyBoard

- (void)keyboardWillShow: (NSNotification*)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [aValue CGRectValue];
    
    if(_tableView)
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = _tableView.frame;
            rect.size.height = [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - keyboardRect.size.height;
            _tableView.frame = rect;
        }completion:^(BOOL finished) {
            
            if (_tableView.contentSize.height > _tableView.frame.size.height)
            {
                CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
                [_tableView setContentOffset:offset animated:YES];
            }

        }];
    }
 
}

- (void)keyboardWillHide: (NSNotification*)notification
{
    //    NSDictionary *userInfo = [notification userInfo];
    //	NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //	CGRect keyboardRect = [aValue CGRectValue];
    
    if(_tableView)
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = _tableView.frame;
            rect.size.height = [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT;
            _tableView.frame = rect;
        }];
        
    }
    
}

@end
