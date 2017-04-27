//
//  RCSecondHandHouseViewController.m
//  RCFang
//
//  Created by xuzepei on 3/26/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCSecondHandHouseViewController.h"
#import "RCTool.h"
#import "RCSecondHandHouseInfoViewController.h"
#import "RCHttpRequest.h"

#define AD_FRAME_HEIGHT 120.0
#define HEADER_VIEW_HEIGHT 35.0

#define HEADER_BUTTON0_TAG 100
#define HEADER_BUTTON1_TAG 101
#define HEADER_BUTTON2_TAG 102
#define HEADER_BUTTON3_TAG 103

#define HEADER_TITLE0 @"区域"
#define HEADER_TITLE1 @"户型"
#define HEADER_TITLE2 @"总价"
#define HEADER_TITLE3 @"排序"

@interface RCSecondHandHouseViewController ()

@end

@implementation RCSecondHandHouseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"二手房－乐山";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(clickedRightBarButtonItem:)];
        
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

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    //[self updateAd];
    
    [self initHeaderView];
    
    [self initTableView];
    
    [self initPickerView];
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

- (void)updateContent
{
    NSString* urlString = [NSString stringWithFormat:@"%@/2hand_list.php?apiid=%@&apikey=%@&page=%d&area=%d&unit_type=%d&price=%d&sort=%d",BASE_URL,APIID,PWD,self.page,self.quyuSearchId,self.selectionIndex1,self.selectionIndex2,self.selectionIndex3];

    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
    BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedRequest:) token:nil];
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
    CGRect lastItemRect = [_tableView rectForFooterInSection:0];
    
    if(contentoffset.y >= lastItemRect.origin.y - 290)
    {
        [self updateContent];
    }
}

#pragma mark - AdScrollView

- (void)initAdScrollView
{
    self.adHeight = 0;
    
    NSDictionary* ad = [RCTool getAdByType:@"2hand"];
    if(ad)
    {
        NSString* show = [ad objectForKey:@"show"];
        if([show isEqualToString:@"1"])
        {
            NSArray* urlArray = [ad objectForKey:@"urllist"];
            if(urlArray && [urlArray isKindOfClass:[NSArray class]])
            {
                if([urlArray count])
                {
                    if(nil == _adScrollView)
                    {
                        self.adHeight = AD_FRAME_HEIGHT;
                        _adScrollView = [[RCAdScrollView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, AD_FRAME_HEIGHT)];
                    }
                    
                    [_adScrollView updateContent:urlArray];
                    
                    [self.view addSubview: _adScrollView];
                }
            }
        }
    }
}

- (void)updateAd
{
    NSString* urlString = [NSString stringWithFormat:@"%@/ad.php?apiid=%@&apikey=%@&type=2hand",BASE_URL,APIID,PWD];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    [temp request:urlString delegate:self resultSelector:@selector(finishedAdRequest:) token:nil];
}

- (void)finishedAdRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        [RCTool setAd:@"2hand" ad:result];
        
        [self initAdScrollView];
        
        if(_tableView)
        {
            _tableView.frame = CGRectMake(0,self.adHeight,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT -TAB_BAR_HEIGHT - self.adHeight);
        }
    }
    
}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.adHeight,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT -TAB_BAR_HEIGHT - self.adHeight)
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
	
	[self.view addSubview:_tableView];
    
//    if(0 == [_itemArray count])
//    {
//        NSMutableDictionary* dict = nil;
//        
//        dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:@"首创爱这城 精装套二 户型方正大气 房子好" forKey:@"name"];
//        [dict setObject:@"imageurl" forKey:@"image_url"];
//        [dict setObject:@"2室2厅" forKey:@"huxing"];
//        [dict setObject:@"72万" forKey:@"jiage"];
//        [dict setObject:@"高新区" forKey:@"quyu"];
//        [dict setObject:@"" forKey:@"dingwei"];
//        [dict setObject:@"84平米" forKey:@"mianji"];
//        [dict setObject:@"领馆国际城" forKey:@"loupan"];
//        [dict setObject:@"［高新区］高新区红星路南延线与领馆大道交汇处" forKey:@"dizhi"];
//        [dict setObject:@"“意见征询稿”中较重要的条款包括：执行20%个税征收比率时，会针对持有房屋的时间(如，五年以内以及五年以上)和其他条件设置不同标准；尊重人民可以获得财产性收入的历史因素。对北京户口单身含离异人士进一步限购，过去京籍家庭可拥有两套住房，有购房者采取“假离婚”应对，未来则可能仅鼓励单身或离异人士持有一套房。" forKey:@"dongtai"];
//        [dict setObject:@"20多条公交线路： “二环路东一段中站”—2路、51路、52路、76路、108路 " forKey:@"jiaotong"];
//        [dict setObject:@"30.67,104.06" forKey:@"latelng"];
//        [dict setObject:@"蓝光COCO时代是蓝光继COCO金沙之后的又一力作，作为城市公寓系超越之作，COCO时代无论从区域、配套还是产品都进行了全新升级。COCO时代领踞成都二环，东中心，地面交通二环路、府青路、建设路四通八达，更有地铁6号线、3号线锦上添花。同时，COCO时代占据成都最集中的商业综合体的覆盖区域，建设路、红星路、猛追湾等5大成熟黄金商圈环伺左右。定位缤纷都市生活体的COCO时代在住宅产品打造上以50—89m2幻变城市公馆为主，7栋高层以围合式布局与两万平的商业部分融为一体，直面大型商业区。项目还打造了面积约20000平米的城市级商业街区，商业形态丰富，包括潮流主题店+风情餐饮街+时尚娱乐场+社区街铺。2—3层商业环绕整个建筑群落。" forKey:@"jieshao"];
//        [_itemArray addObject:dict];
//        [dict release];
//    }
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if(0 == section)
        return _headerView;
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if(0 == section)
        return HEADER_VIEW_HEIGHT;
    
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
            RCSecondHandHouseInfoViewController* temp = [[RCSecondHandHouseInfoViewController alloc] initWithNibName:nil bundle:nil];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:item];
            [self.navigationController pushViewController:temp animated:YES];
        }
    }
}

#pragma mark - Header View

- (void)initHeaderView
{
    //区域
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:HEADER_TITLE0 forKey:@"name"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON0_TAG] forKey:@"tag"];
    self.selection0 = dict;
    
    //类型
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:HEADER_TITLE1 forKey:@"name"];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObject:@"不限"];
    [array addObject:@"一居"];
    [array addObject:@"二居"];
    [array addObject:@"三居"];
    [array addObject:@"四居"];
    [array addObject:@"五居"];
    [array addObject:@"五居以上"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON1_TAG] forKey:@"tag"];
    self.selection1 = dict;
    
    //价格
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:HEADER_TITLE2 forKey:@"name"];
    array = [[NSMutableArray alloc] init];
    [array addObject:@"不限"];
    [array addObject:@"15万以下"];
    [array addObject:@"15万~35万"];
    [array addObject:@"35万~55万"];
    [array addObject:@"55万~75万"];
    [array addObject:@"75万~100万"];
    [array addObject:@"100万~150万"];
    [array addObject:@"150万~200万"];
    [array addObject:@"200万~300万"];
    [array addObject:@"300万以上"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON2_TAG] forKey:@"tag"];
    self.selection2 = dict;
    
    //排序
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:HEADER_TITLE3 forKey:@"name"];
    array = [[NSMutableArray alloc] init];
    [array addObject:@"默认排序"];
    [array addObject:@"发布时间排序"];
    [array addObject:@"总价由高到低"];
    [array addObject:@"总价由低到高"];
    [array addObject:@"面积由小到大"];
    [array addObject:@"面积由大到小"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON3_TAG] forKey:@"tag"];
    self.selection3 = dict;
    
    if(nil == _headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, HEADER_VIEW_HEIGHT)];
    }
    
    if(nil == _headerButton0)
    {
        _headerButton0 = [[RCButtonView alloc] initWithFrame:CGRectMake(0, 0, 80, HEADER_VIEW_HEIGHT)];
        _headerButton0.delegate = self;
        _headerButton0.tag = HEADER_BUTTON0_TAG;
        _headerButton0.text = HEADER_TITLE0;
        [_headerView addSubview: _headerButton0];
    }
    
    if(nil == _headerButton1)
    {
        _headerButton1 = [[RCButtonView alloc] initWithFrame:CGRectMake(80, 0, 80, HEADER_VIEW_HEIGHT)];
        _headerButton1.delegate = self;
        _headerButton1.tag = HEADER_BUTTON1_TAG;
        _headerButton1.text = HEADER_TITLE1;
        [_headerView addSubview: _headerButton1];
    }
    
    
    if(nil == _headerButton2)
    {
        _headerButton2 = [[RCButtonView alloc] initWithFrame:CGRectMake(80*2, 0, 80, HEADER_VIEW_HEIGHT)];
        _headerButton2.delegate = self;
        _headerButton2.tag = HEADER_BUTTON2_TAG;
        _headerButton2.text = HEADER_TITLE2;
        [_headerView addSubview: _headerButton2];
    }
    
    if(nil == _headerButton3)
    {
        _headerButton3 = [[RCButtonView alloc] initWithFrame:CGRectMake(80*3, 0, 80, HEADER_VIEW_HEIGHT)];
        _headerButton3.delegate = self;
        _headerButton3.tag = HEADER_BUTTON3_TAG;
        _headerButton3.text = HEADER_TITLE3;
        [_headerView addSubview: _headerButton3];
    }
}

- (void)clickedHeaderButton:(int)tag token:(id)token
{
    NSLog(@"clickedHeaderButton");
    
    if(HEADER_BUTTON0_TAG == tag)
    {
        NSArray* array = [self.selection0 objectForKey:@"values"];
        if(nil == array || [array count] < 1)
        {
            
            NSMutableArray* values = [[NSMutableArray alloc] init];
            NSArray* areas = [RCTool getArea];
            if(areas && [areas count])
                [values addObjectsFromArray:areas];
            
            NSMutableDictionary* selection0 = [[NSMutableDictionary alloc] init];
            if(self.selection0)
                [selection0 addEntriesFromDictionary:self.selection0];
            [selection0 setObject:values forKey:@"values"];
            
            self.selection0 = selection0;
        }
        
        [_pickerView updateContent:self.selection0];
        [_pickerView show];
    }
    else if(HEADER_BUTTON1_TAG == tag)
    {
        [_pickerView updateContent:self.selection1];
        [_pickerView show];
    }
    else if(HEADER_BUTTON2_TAG == tag)
    {
        [_pickerView updateContent:self.selection2];
        [_pickerView show];
    }
    else if(HEADER_BUTTON3_TAG == tag)
    {
        [_pickerView updateContent:self.selection3];
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
        _selectionIndex0 = index;
        
        NSString* temp = HEADER_TITLE0;
        NSArray* array = [_selection0 objectForKey:@"values"];
        NSDictionary* value = [array objectAtIndex: _selectionIndex0];
        if(_selectionIndex0)
            temp = [value objectForKey:@"name"];
        self.quyuSearchId = [[value objectForKey:@"id"] intValue];
        
        [_headerButton0 updateContent:temp];
    }
    else if(HEADER_BUTTON1_TAG == tag)
    {
        _selectionIndex1 = index;
        
        NSString* temp = HEADER_TITLE1;
        if(_selectionIndex1)
        {
            NSArray* array = [_selection1 objectForKey:@"values"];
            temp = [array objectAtIndex: _selectionIndex1];
        }
        
        [_headerButton1 updateContent:temp];
    }
    else if(HEADER_BUTTON2_TAG == tag)
    {
        _selectionIndex2 = index;
        
        NSString* temp = HEADER_TITLE2;
        if(_selectionIndex2)
        {
            NSArray* array = [_selection2 objectForKey:@"values"];
            temp = [array objectAtIndex: _selectionIndex2];
        }
        [_headerButton2 updateContent:temp];
    }
    else if(HEADER_BUTTON3_TAG == tag)
    {
        _selectionIndex3 = index;
        
        NSString* temp = HEADER_TITLE3;
        if(_selectionIndex3)
        {
            NSArray* array = [_selection3 objectForKey:@"values"];
            temp = [array objectAtIndex: _selectionIndex3];
        }
        
        [_headerButton3 updateContent:temp];
    }
    
    
    self.page = 1;
    [_itemArray removeAllObjects];
    [self updateContent];
}

@end
