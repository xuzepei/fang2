//
//  RCFJViewController.m
//  RCFang
//
//  Created by xuzepei on 6/17/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCFJViewController.h"
#import "RCHttpRequest.h"
#import "RCPublicCell.h"
#import "RCSHViewController.h"

#define HEADER_VIEW_HEIGHT 40.0f
#define HEADER_BUTTON0_TAG 100
#define HEADER_BUTTON1_TAG 101
#define AD_CELL_HEIGHT 50.0f
#define LOCATION_BAR 30.0f

@interface RCFJViewController ()

@end

@implementation RCFJViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"查看附近的搬家公司";
        
        _itemArray = [[NSMutableArray alloc] init];
        
        self.page = 1;
        
        self.condition0 = @"3000米";
        self.condition1 = @"默认排序";
        
        self.view.backgroundColor = BG_COLOR;
        
        UIImage *image = [UIImage imageNamed:@"dib"];
        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickedMapButtonItem:)];
        
        self.navigationItem.rightBarButtonItem = rightItem;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedLocation:) name:UPDATED_LOCATION_NOTIFICATION object:nil];
        
        //获取当前位置
        BMKMapView* mapView = [[BMKMapView alloc] init];
        mapView.delegate  = self;
        [mapView setShowsUserLocation:YES];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    [self initPickerView];
    
    [self initHeaderView];
    
    [self initTableView];
    
    [self updateContent:nil];
    
}

- (void)clickedBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.pickerView = nil;
    self.condition0Selection = nil;
    self.condition1Selection = nil;
    self.condition0 = nil;
    self.condition1 = nil;
    self.headerButton0 = nil;
    self.headerButton1 = nil;
    self.tableView = nil;
    self.itemArray = nil;
    self.item = nil;
    self.refreshButton = nil;
    self.locationLabel = nil;
}

- (void)clickedMapButtonItem:(id)sender
{
    NSLog(@"clickedMapButtonItem");
    
    if(0 == [self.itemArray count])
        return;
    
//    RCBaiDuMapViewController* temp = [[RCBaiDuMapViewController alloc] initWithNibName:nil bundle:nil];
//    temp.title = @"附近的搬家公司";
//    [temp updateContent:@{@"list":self.itemArray} zoom:17];
//    [self.navigationController pushViewController:temp animated:YES];
}

- (void)updateContent:(NSDictionary*)item
{
    NSString* coordination = [RCTool getUserLocation];
    NSString* params = [NSString stringWithFormat:@"type=list&page=%d&point=%@",self.page,coordination];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/mover_nearby.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedContentRequest:) token:params];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedContentRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            NSArray* array = [result objectForKey:@"list"];
            if(array && [array isKindOfClass:[NSArray class]])
            {
                [self.itemArray addObjectsFromArray:array];
                
                self.page++;
            }
        }
        else
        {
            [RCTool showAlert:@"提示" message:error];
            return;
        }
    }
    
    if(self.tableView)
        [self.tableView reloadData];
}

#pragma mark - Header View

- (void)initHeaderView
{
    //条件0
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"范围" forKey:@"name"];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObject:@"1000米"];
    [array addObject:@"3000米"];
    [array addObject:@"5000米"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON0_TAG] forKey:@"tag"];
    self.condition0Selection = dict;
    
    //条件1
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"排序" forKey:@"name"];
    array = [[NSMutableArray alloc] init];
    [array addObject:@"默认排序"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:HEADER_BUTTON1_TAG] forKey:@"tag"];
    self.condition1Selection = dict;
    
    if(nil == _headerButton0)
    {
        _headerButton0 = [[RCButtonView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width/2.0, HEADER_VIEW_HEIGHT)];
        _headerButton0.delegate = self;
        _headerButton0.tag = HEADER_BUTTON0_TAG;
        [_headerButton0 updateContent:@"范围"];
        [self.view addSubview: _headerButton0];
    }
    
    if(nil == _headerButton1)
    {
        _headerButton1 = [[RCButtonView alloc] initWithFrame:CGRectMake([RCTool getScreenSize].width/2.0, 0, [RCTool getScreenSize].width/2.0, HEADER_VIEW_HEIGHT)];
        _headerButton1.delegate = self;
        _headerButton1.tag = HEADER_BUTTON1_TAG;
        [_headerButton1 updateContent:@"排序"];
        [self.view addSubview: _headerButton1];
    }
    
    
    //当前位置
    if(nil == _locationLabel)
    {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, HEADER_VIEW_HEIGHT, 250, LOCATION_BAR)];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.font = [UIFont systemFontOfSize:16];
        _locationLabel.text = [NSString stringWithFormat:@"当前：%@",[RCTool getUserLocationName]];
    }
    
    [self.view addSubview:_locationLabel];
    
    if(nil == _refreshButton)
    {
        self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.refreshButton setImage:[UIImage imageNamed:@"shuaxin"] forState:UIControlStateNormal];
        self.refreshButton.frame = CGRectMake(0, 0, LOCATION_BAR, LOCATION_BAR);
        self.refreshButton.center = CGPointMake([RCTool getScreenSize].width - 26.0f, HEADER_VIEW_HEIGHT + LOCATION_BAR/2.0);
        [self.refreshButton addTarget:self action:@selector(clickedRefreshButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:self.refreshButton];
}

- (void)clickedHeaderButton:(int)tag token:(id)token
{
    NSLog(@"clickedHeaderButton");
    
    if(HEADER_BUTTON0_TAG == tag)
    {
        [_pickerView updateContent:self.condition0Selection];
    }
    else if(HEADER_BUTTON1_TAG == tag)
    {
        [_pickerView updateContent:self.condition1Selection];
    }
    
    [_pickerView show];
}

- (IBAction)clickedRefreshButton:(id)sender
{
    NSLog(@"clickedRefreshButton");
    
    RCAppDelegate* appDelegate = (RCAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate updateUserLocation];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100;
    
    [self.refreshButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
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
        NSArray* array = [_condition0Selection objectForKey:@"values"];
        NSString* value = [array objectAtIndex:index];
        self.condition0 = value;
        
        [_headerButton0 updateContent:value];
    }
    else if(HEADER_BUTTON1_TAG == tag)
    {
        NSArray* array = [_condition1Selection objectForKey:@"values"];
        NSString* value = [array objectAtIndex:index];
        self.condition1 = value;
        
        [_headerButton1 updateContent:value];
    }
    
    self.pageno = 0;
    
    [self.itemArray removeAllObjects];
    if(self.tableView)
        [self.tableView reloadData];
    
    [self updateContent:self.item];
    
}

#pragma mark - Table View

- (void)initTableView
{
    if(nil == _tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,LOCATION_BAR+HEADER_VIEW_HEIGHT,[RCTool getScreenSize].width,[RCTool getScreenSize].height - (LOCATION_BAR+HEADER_VIEW_HEIGHT))
                                                  style:UITableViewStyleGrouped];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
//    NSDictionary* dict = @{@"name":@"成都双流－老兵搬家",
//                           @"address":@"双流－东升（1.15km）",
//                           @"times":@"12"};
//    [_itemArray addObject:dict];
//    [_itemArray addObject:dict];
    
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
    return 0.1;
}

- (CGFloat)getCellHeight:(NSIndexPath*)indexPath
{
    return 64.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    if(1 == section)
        return [_itemArray count];
    else if(2 == section)
        return 1;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)
    {
            return 0;
    }
    else if(1 == indexPath.section)
    {
        return [self getCellHeight:indexPath];
    }
    else if(2 == indexPath.section)
        return 44.0f;
    
    return 0.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId0 = @"cellId0";
    static NSString *cellId1 = @"cellId1";
    static NSString *cellId2 = @"cellId2";
    
    UITableViewCell *cell = nil;
    
    if(0 == indexPath.section)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if(cell == nil)
        {
            cell = [[RCPublicCell alloc] initWithStyle: UITableViewCellStyleDefault
                                        reuseIdentifier: cellId2 contentViewClass:NSClassFromString(@"RCAdCellContentView")];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //cell.backgroundColor = BG_COLOR;
        }
    }
    else if(1 == indexPath.section)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if(cell == nil)
        {
            cell = [[RCPublicCell alloc] initWithStyle: UITableViewCellStyleDefault
                                        reuseIdentifier: cellId1 contentViewClass:NSClassFromString(@"RCFJCellContentView")];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //cell.backgroundColor = BG_COLOR;
            //        cell.backgroundView = [[UIView new] autorelease];
            //        cell.selectedBackgroundView = [[UIView new] autorelease];
        }
        
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
        RCPublicCell* temp = (RCPublicCell*)cell;
        if(temp)
        {
            [temp updateContent:item cellHeight:[self getCellHeight:indexPath] delegate:self token:nil];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId0];
        if(nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId0];
            
            //cell.backgroundColor = BG_COLOR;
            cell.textLabel.text = @"更多...";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(2 == indexPath.section)
    {
        [self updateContent:self.item];
    }
}

- (void)clickedCell:(NSDictionary*)token
{
    NSLog(@"clickedCell");
    
    RCSHViewController* temp = [[RCSHViewController alloc] initWithNibName:nil bundle:nil];
    [temp updateContent:token];
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)clickedCallRect:(NSDictionary*)token
{
    NSLog(@"clickedCallRect");
    
    NSDictionary* item = (NSDictionary*)token;
    
    if(nil == item)
        return;
    
    NSString* phoneNum = [item objectForKey:@"tel"];
    if([phoneNum isKindOfClass:[NSString class]] && [phoneNum length])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
    }
}

#pragma mark -

- (void)clickedLeftButton:(id)token
{
    NSLog(@"clickedLeftButton");
    NSDictionary* item = (NSDictionary*)token;
    
    if(nil == item)
        return;
    
//    NSArray* array = [NSArray arrayWithObject:item];
//    RCRouteMapViewController* temp = [[RCRouteMapViewController alloc] initWithNibName:nil bundle:nil];
//    [temp updateContent:array title:@"路径规划"];
//    [self.navigationController pushViewController:temp animated:YES];
//    [temp release];
}

- (void)clickedRightButton:(id)token
{
    NSLog(@"clickedRightButton");
    NSDictionary* item = (NSDictionary*)token;
    
    if(nil == item)
        return;
    
    NSString* phoneNum = [item objectForKey:@"tel"];
    if([phoneNum isKindOfClass:[NSString class]] && [phoneNum length])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
    }
}

- (void)updatedLocation:(NSNotification*)noti
{
    _locationLabel.text = [NSString stringWithFormat:@"当前：%@",[RCTool getUserLocationName]];
    
    [_refreshButton.layer removeAllAnimations];
}

#pragma mark - 获取当前位置

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    
    //NSLog(@"didUpdateUserLocation");
    
    //self.userLocation = mapView.userLocation.coordinate;
    [mapView setShowsUserLocation:NO];
    
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"didFailToLocateUserWithError");
}

@end
