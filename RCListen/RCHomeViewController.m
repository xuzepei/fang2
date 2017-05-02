//
//  RCHomeViewController.m
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCHomeViewController.h"
#import "RCTool.h"
#import "RCXinFangViewController.h"
#import "RCFangDaiViewController.h"
#import "RCSecondHandHouseViewController.h"
#import "RCZuFangViewController.h"
#import "RCLocationController.h"
#import "RCWebViewController.h"
#import "RCHttpRequest.h"
#import "RCNewsViewController.h"
#import "RCBJViewController.h"
#import "RCCreateDDViewController.h"
#import "RCStartBJViewController.h"
#import "RCCityTableViewController.h"
#import "RCFuctionButton.h"
#import "RCLoginViewController.h"
#import "TYAlertController.h"
#import "UIView+TYAlertView.h"
#import "OpenAppView.h"

#define AD_FRAME_HEIGHT 170.0
#define SCROLL_LABEL_HEIGHT 60.0

@interface RCHomeViewController ()

@end

@implementation RCHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
//        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"首页"
//														   image:[UIImage imageNamed:@"lb"]
//															 tag:TT_HOMEPAGE];
//        
//		self.tabBarItem = item;
		
		self.navigationItem.title = @"工地之家";
        self.view.backgroundColor = BG_COLOR;

//        UIButton *titleImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage* titleImage = [UIImage imageNamed:@"home_title"];
//        titleImageButton.frame = CGRectMake(0, 0, titleImage.size.width, titleImage.size.height);
//        [titleImageButton setImage:titleImage forState:UIControlStateNormal];
//        [titleImageButton setImage:titleImage forState:UIControlStateHighlighted];
//        [titleImageButton addTarget:self action:@selector(clickedTitleImageButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
//        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, 200, 30)];
//        titleLabel.font = [UIFont boldSystemFontOfSize:21];
//        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.shadowColor = [UIColor grayColor];
//        titleLabel.shadowOffset = CGSizeMake(1, 1);
//        titleLabel.backgroundColor = [UIColor clearColor];
//        titleLabel.text = @"欢迎进入大管家";
//        
//        self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, 40)];
//        
//        [self.navigationItem.titleView addSubview:titleLabel];
        
//        _selectAreaButton = [[RCSelectAreaButton alloc] initWithFrame:CGRectMake([RCTool getScreenSize].width - 76, -4, 60, 40)];
//        _selectAreaButton.delegate = self;
//        
//        [self.navigationItem.titleView addSubview:_selectAreaButton];
        
        
        
    }
    return self;
}

- (void)dealloc
{
    self.adScrollView = nil;
    self.tableView = nil;
    self.itemArray = nil;
    self.banjiaButton = nil;
    self.jiazhengButton = nil;
    self.kuaidiButton = nil;
    self.bjTitleLabel = nil;
    self.jzTitleLabel = nil;
    self.kdTitleLabel = nil;
    self.bjLabel = nil;
    self.jzLabel = nil;
    self.kdLabel = nil;
    self.selectAreaButton = nil;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self goToLoginViewController];
    
//    NSString* city = @"成都";
//    NSDictionary* cityInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_city"];
//    if(cityInfo)
//    {
//        city = [cityInfo objectForKey:@"city"];
//        if(0 == [city length])
//            city = [cityInfo objectForKey:@"now_city"];
//    }
//    
//    if(_selectAreaButton)
//        [_selectAreaButton updateContent:city];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self updateAd];
//    [self updateInfo];
    
    [self initScrollLabel];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.adScrollView = nil;
    self.tableView = nil;
}

- (void)clickedRightBarButtonItem:(id)sender
{
    NSLog(@"clickedRightBarButtonItem");
}

- (void)clickedTitleImageButton:(id)sender
{
    NSLog(@"clickedTitleImageButton");
    
    //[[RCTool getTabBarController] setSelectedIndex:1];
}

- (void)updateContent
{
    if(nil == _itemArray)
    {
        _itemArray = [[NSMutableArray alloc] init];
        [_itemArray addObjectsFromArray:@[@{@"text":@"上WiFi"},@{@"text":@"看电影"},@{@"text":@"玩游戏"},@{@"text":@"充话费"},@{@"text":@"想家了"},@{@"text":@"买相因"},@{@"text":@"安全须知"}]];
        
        [self initFunctionButtons];
    }
}

- (void)updateAd
{
    if(nil == _adItems)
    {
        self.adItems = [[NSMutableArray alloc] init];
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@?m=%@&c=%@&a=%@",BASE_URL,@"api",@"index",@"getbanner"];
    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
    [temp request:urlString delegate:self resultSelector:@selector(finishedAdRequest:) token:nil];
}

- (void)finishedAdRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSNumber* code = [result objectForKey:@"code"];
        if(code.intValue == 200)
        {
            [_adItems removeAllObjects];
            
            NSArray* dataArray = [result objectForKey:@"data"];
            if(dataArray && [dataArray isKindOfClass:[NSArray class]])
            {
                [_adItems addObjectsFromArray:dataArray];
            }
            
        }
        
        [self initAdScrollView];
    }
    
    [self updateContent];
}

#pragma mark - AdScrollView

- (void)initAdScrollView
{
    self.adScrollViewHeight = 0;
    
    NSArray* urlArray = self.adItems;
    if(urlArray && [urlArray isKindOfClass:[NSArray class]])
    {
        if([urlArray count])
        {
            if(nil == _adScrollView)
            {
                self.adScrollViewHeight = AD_FRAME_HEIGHT;
                _adScrollView = [[RCAdScrollView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, AD_FRAME_HEIGHT)];
            }
            
            [_adScrollView updateContent:urlArray];
            
            [self.view addSubview: _adScrollView];
        }
    }
}

- (void)updateInfo
{
    NSString* urlString = [NSString stringWithFormat:@"%@/index_project.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];

    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
    [temp request:urlString delegate:self resultSelector:@selector(finishedInfoRequest:) token:nil];
}

- (void)finishedInfoRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSArray* list = [result objectForKey:@"list"];
        if(list && [list isKindOfClass:[NSArray class]])
        {
            for(NSDictionary* item in list)
            {
                NSString* id = [item objectForKey:@"id"];
                if([id isEqualToString:@"1"])
                {
                    self.bjTitleLabel.text = [item objectForKey:@"title"];
                    self.bjLabel.text = [item objectForKey:@"num"];
                }
                else if([id isEqualToString:@"2"])
                {
                    self.jzTitleLabel.text = [item objectForKey:@"title"];
                    self.jzLabel.text = [item objectForKey:@"num"];
                }
                else if([id isEqualToString:@"3"])
                {
                    self.kdTitleLabel.text = [item objectForKey:@"title"];
                    self.kdLabel.text = [item objectForKey:@"num"];
                }
            }
        }
    }
}

#pragma mark - RCScrollLabelDelegate

- (void)initScrollLabel
{
    if(nil == _scrollLabel)
    {
        self.scrollLabel = [[RCScrollLabel alloc] initWithFrame:CGRectMake(0, [RCTool getScreenSize].height - SCROLL_LABEL_HEIGHT -STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT, [RCTool getScreenSize].width, SCROLL_LABEL_HEIGHT)];
        self.scrollLabel.backgroundColor = [UIColor blackColor];
        [self.scrollLabel updateContent:nil];
    }
    
    [self.view addSubview:self.scrollLabel];
}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.adScrollViewHeight,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - self.adScrollViewHeight - TAB_BAR_HEIGHT - 40)
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
	
	[self.view addSubview:_tableView];
    
    
    if(0 == [_itemArray count])
    {
    //temp
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"新房" forKey:@"name"];
    [dict setObject:@"xinfang" forKey:@"image_path"];
    [_itemArray addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"二手房" forKey:@"name"];
    [dict setObject:@"ershoufang" forKey:@"image_path"];
    [_itemArray addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"租房" forKey:@"name"];
    [dict setObject:@"zufang" forKey:@"image_path"];
    [_itemArray addObject:dict];
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"新闻" forKey:@"name"];
    [dict setObject:@"xinwen" forKey:@"image_path"];
    [_itemArray addObject:dict];
        
    }
    
    [_tableView reloadData];
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
	return 50.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                  reuseIdentifier: cellId] ;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	

    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
	if(item)
	{
        cell.textLabel.text = [item objectForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed:[item objectForKey:@"image_path"]];
	}
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	//NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
    
    if(0 == indexPath.row)
    {
        RCXinFangViewController* temp = [[RCXinFangViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent];
        [self.navigationController pushViewController:temp animated:YES];

    
    }
    else if(1 == indexPath.row)
    {
        RCSecondHandHouseViewController* temp = [[RCSecondHandHouseViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent];
        [self.navigationController pushViewController:temp animated:YES];

    }
    else if(2 ==  indexPath.row)
    {
        RCZuFangViewController* temp = [[RCZuFangViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent];
        [self.navigationController pushViewController:temp animated:YES];

    }
    else if(3 ==  indexPath.row)
    {
        RCNewsViewController* temp = [[RCNewsViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:temp animated:YES];

    }
}

#pragma mark - Buttons

- (void)initFunctionButtons
{
    CGSize screenSize = [RCTool getScreenSize];
    CGFloat offset_x = 10.0f;
    CGFloat offset_y = self.adScrollViewHeight + 20;
    CGFloat buttonWidth = (screenSize.width - offset_x*2 - 10*2)/3.0;
    CGFloat buttonHeight = 60;
    
    for(int i = 0; i < 7; i++)
    {
        int column = i % 3;
        if(i > 0 && column == 0)
        {
            offset_y += buttonHeight + 10;
            offset_x = 10;
        }
        
        RCFuctionButton* button = [[RCFuctionButton alloc] initWithFrame:CGRectMake(offset_x + (buttonWidth + 10)*column, offset_y, buttonWidth, buttonHeight)];
        button.delegate = self;
        button.tag = i + 500;
        [button updateContent: [self.itemArray objectAtIndex:i]];
        [self.view addSubview: button];

    }
    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(50+40+50, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - 42, 40, 40);
//    [button setImage:[UIImage imageNamed:@"calculator_button"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clickedCalculatorButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview: button];
//    
//    
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(50+(40+50)*2, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - 42, 40, 40);
//    [button setImage:[UIImage imageNamed:@"scan_button"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clickedScanButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview: button];
    
}

- (void)clickedFuctionButton:(RCFuctionButton*)button token:(id)token
{
    NSLog(@"clickedFuctionButton:%@",token);
    
    int tag = button.tag;
    NSDictionary* item = (NSDictionary*)token;
    
    switch (tag) {
        case 500:
        {
            [self goToLoginViewController];
            break;
        }
        case 501:
        {
            OpenAppView* temp = [OpenAppView createViewFromNib];
            temp.titleLabel.text = [item objectForKey:@"text"];
            [temp updateContent:@[@{@"name":@"天翼视讯",@"image":@"tianyishixun.png",@"url":@""}]];
            
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:temp preferredStyle:TYAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            
            break;
        }
        case 502:
        {
            OpenAppView* temp = [OpenAppView createViewFromNib];
            temp.titleLabel.text = [item objectForKey:@"text"];
            [temp updateContent:@[@{@"name":@"玩游戏",@"image":@"wanyouxi.jpg",@"url":@"http://wap.189store.com/game/game?f=0"}]];
            
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:temp preferredStyle:TYAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            
            break;
        }
        case 503:
        {
            OpenAppView* temp = [OpenAppView createViewFromNib];
            temp.titleLabel.text = [item objectForKey:@"text"];
            [temp updateContent:@[@{@"name":@"充话费",@"image":@"chonghuafei.jpg",@"url":@"http://wapsc.189.cn/pay?intid=wap-sy-menu-cz"}]];
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:temp preferredStyle:TYAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            
            break;
        }
        case 504:
        {
            OpenAppView* temp = [OpenAppView createViewFromNib];
            temp.titleLabel.text = [item objectForKey:@"text"];
            [temp updateContent:@[@{@"name":@"想家了",@"image":@"xiangjiale.jpg",@"url":@""}]];
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:temp preferredStyle:TYAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            
            break;
        }
        case 505:
        {
            OpenAppView* temp = [OpenAppView createViewFromNib];
            temp.titleLabel.text = [item objectForKey:@"text"];
            [temp updateContent:@[@{@"name":@"买相因",@"image":@"maixiangyin.jpg",@"url":@"http://m.tyfo.com/wap/newversion/main.htm?numflag=0"}]];
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:temp preferredStyle:TYAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            
            break;
        }
        case 506:
        {
            break;
        }
        case 507:
        {
            break;
        }
        default:
            break;
    }
    
    
}

- (void)goToLoginViewController
{
    RCLoginViewController* temp = [[RCLoginViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:temp];
    
    [self presentViewController:navController animated:NO completion:^{
        
    }];
}

//- (void)clickedScanButton:(id)sender
//{
//    NSLog(@"clickedScanButton");
//    
//    // ADD: present a barcode reader that scans from the camera feed
//    ZBarReaderViewController *reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
//    
//    ZBarImageScanner *scanner = reader.scanner;
//    // TODO: (optional) additional reader configuration here
//    
//    // EXAMPLE: disable rarely used I2/5 to improve performance
//    [scanner setSymbology: ZBAR_I25
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
//    
//    // present and release the controller
//    [self presentModalViewController: reader
//                            animated: YES];
//
//}

//- (void) imagePickerController: (UIImagePickerController*) reader
// didFinishPickingMediaWithInfo: (NSDictionary*) info
//{
//    [RCTool playSound:@"done.caf"];
//    // ADD: get the decode results
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        // EXAMPLE: just grab the first barcode
//        break;
//    
//    NSLog(@"code:%@",symbol.data);
//
//    NSString* urlString = symbol.data;
//    //    // EXAMPLE: do something useful with the barcode data
//    //    resultText.text = symbol.data;
//    //
//    //    // EXAMPLE: do something useful with the barcode image
//    //    resultImage.image =
//    //    [info objectForKey: UIImagePickerControllerOriginalImage];
//    
//    // ADD: dismiss the controller (NB dismiss from the *reader*!)
//    [reader dismissModalViewControllerAnimated: YES];
//    
//    if([urlString hasPrefix:@"http:"] || [urlString hasPrefix:@"https:"])
//    {
//        RCWebViewController* temp = [[RCWebViewController alloc] init:NO];
//        temp.hidesBottomBarWhenPushed = YES;
//        [temp updateContent:urlString title:nil];
//        [self.navigationController pushViewController:temp animated:YES];
//
//    }
//}


//#pragma mark - Selection Area
//
//- (void)clickedSelectionButton:(id)sender
//{
//    NSLog(@"clickedSelectionButton");
//
//    RCCityTableViewController* temp = [[RCCityTableViewController alloc] initWithNibName:nil bundle:nil];
//    temp.hidesBottomBarWhenPushed = YES;
//    [temp updateContent:nil];
//    [self.navigationController pushViewController:temp animated:YES];
//}


@end
