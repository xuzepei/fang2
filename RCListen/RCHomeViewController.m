//
//  RCHomeViewController.m
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCHomeViewController.h"
#import "RCTool.h"
#import "RCWebViewController.h"
#import "RCHttpRequest.h"
#import "RCNewsViewController.h"
#import "RCLoginViewController.h"
#import "TYAlertController.h"
#import "UIView+TYAlertView.h"
#import "OpenAppView.h"
#import "RCSettingsViewController.h"


#define AD_FRAME_HEIGHT 250.0
#define SCROLL_LABEL_HEIGHT 60.0

@interface RCHomeViewController ()<NSURLConnectionDelegate>

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
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_button"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedLeftBarButtonItem:)];
   
        
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

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(nil == [RCTool getUserInfo])
        [self goToLoginViewController];
    
    [self checkWifiConnection];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.adScrollViewHeight = ([RCTool getScreenSize].height <= 480)? 140.0f :([RCTool getScreenSize].height * AD_FRAME_HEIGHT)/736.0 ;
    
    [self updateAd];
    [self updateFunctions];
    [self updateHotNews];
    
    if([RCTool isReachableViaWiFi])
    {
        self.isWifiConnected = YES;
        [self updateWifiConnectionStatus];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    self.internetReachable = [Reachability reachabilityForInternetConnection];
    [self.internetReachable startNotifier];
}

- (void)checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.isWifiConnected = YES;
            break;
        }
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.isWifiConnected = NO;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.isWifiConnected = NO;
            break;
        }
    }
    
    [self updateWifiConnectionStatus];
}

- (void)updateWifiConnectionStatus
{
    if(self.firstButton)
    {
        if(self.isWifiConnected)
        {
            [self.firstButton updateContent:@{@"text":@"上WiFi",@"color":@"36cd9d",@"image":@"yilianjie"}];
        }
        else
        {
            [self.firstButton updateContent:@{@"text":@"上WiFi",@"color":@"36cd9d",@"image":@"weilianjie"}];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.adScrollView = nil;
    self.tableView = nil;
}

- (void)clickedLeftBarButtonItem:(id)sender
{
    NSLog(@"clickedLeftBarButtonItem");
    
    RCSettingsViewController* temp = [[RCSettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)clickedTitleImageButton:(id)sender
{
    NSLog(@"clickedTitleImageButton");
    
    //[[RCTool getTabBarController] setSelectedIndex:1];
}

#pragma mark - AdScrollView

- (void)updateAd
{
    [self initAdScrollView];
    
    if(nil == _adItems)
    {
        self.adItems = [[NSMutableArray alloc] init];
    }

    NSString* urlString = [NSString stringWithFormat:@"%@?m=%@&c=%@&a=%@&t=%f",BASE_URL,@"api",@"index",@"getbanner",[NSDate date].timeIntervalSince1970];
    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
    [temp request:urlString delegate:self resultSelector:@selector(finishedAdRequest:) token:nil];
}

- (void)finishedAdRequest:(NSString*)jsonString
{
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
            
            if([_adItems count] && _adScrollView)
                [_adScrollView updateContent:_adItems];
            
            return;
        }
    }
    
    [self performSelector:@selector(updateAd) withObject:nil afterDelay:5];
}

- (void)initAdScrollView
{
    if(nil == _adScrollView)
    {
        _adScrollView = [[RCAdScrollView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, self.self.adScrollViewHeight)];
    }
    
    [self.view addSubview: _adScrollView];
}

#pragma mark - Hot News

- (void)updateHotNews
{
    [self initScrollLabel];
    
    NSString* urlString = [NSString stringWithFormat:@"%@?m=%@&c=%@&a=%@&t=%f",BASE_URL,@"api",@"index",@"gethotnews",[NSDate date].timeIntervalSince1970];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    [temp request:urlString delegate:self resultSelector:@selector(finishedInfoRequest:) token:nil];
}

- (void)finishedInfoRequest:(NSString*)jsonString
{
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSNumber* code = [result objectForKey:@"code"];
        if(code.intValue == 200)
        {
            NSArray* dataArray = [result objectForKey:@"data"];
            if(dataArray && [dataArray isKindOfClass:[NSArray class]])
            {
                self.hotNews = dataArray;
            }
            
            if([self.hotNews count] && self.scrollLabel)
                [self.scrollLabel updateContent:self.hotNews];
            
            return;
        }
    }
    
    [self performSelector:@selector(updateHotNews) withObject:nil afterDelay:5];
}

#pragma mark - RCScrollLabelDelegate

- (void)initScrollLabel
{
    if(nil == _scrollLabel)
    {
        CGFloat height = ([RCTool getScreenSize].height <= 480)? 50 : SCROLL_LABEL_HEIGHT;
        self.scrollLabel = [[RCScrollLabel alloc] initWithFrame:CGRectMake(0, [RCTool getScreenSize].height - height -STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT, [RCTool getScreenSize].width, height)];
        self.scrollLabel.backgroundColor = [UIColor whiteColor];
    }
    
    [self.view addSubview:self.scrollLabel];
}

#pragma mark - Buttons

- (void)updateFunctions
{
    if(nil == _itemArray)
    {
        _itemArray = [[NSMutableArray alloc] init];
        [_itemArray addObjectsFromArray:@[@{@"text":@"上WiFi",@"color":@"36cd9d",@"image":@"weilianjie"},@{@"text":@"看电影",@"color":@"36bfe1",@"image":@"kandianying"},@{@"text":@"玩游戏",@"color":@"e3c623",@"image":@"wanyouxi"},@{@"text":@"充话费",@"color":@"ff4545",@"image":@"chonghuafei"},@{@"text":@"想家了",@"color":@"b089ff",@"image":@"xiangjiale"},@{@"text":@"买相因",@"color":@"ff7800",@"image":@"maixiangyin"},@{@"text":@"安全须知",@"color":@"6dcf1d",@"image":@"anquanxuzhi"}]];
        
        [self initFunctionButtons];
    }
}

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
        
        if(button.tag == 500)
        {
            self.firstButton = button;
        }

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
            [self checkWifiConnection];
            break;
        }
        case 501:
        {
            OpenAppView* temp = [OpenAppView createViewFromNib];
            temp.titleLabel.text = [item objectForKey:@"text"];
            [temp updateContent:@[@{@"name":@"天翼视讯",@"image":@"tianyishixun.png",@"url":@"",@"apple_id":@"1128325956",@"urlscheme":@"yzf1000"}]];
            
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
            [temp updateContent:@[@{@"name":@"想家了",@"image":@"xiangjiale.jpg",@"url":@"",@"apple_id":@"1021510983",@"urlscheme":@"keshidianhua"}]];
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
            
            NSString* urlString = @"http://downapp.tfeyes.com:8081/aqxz.html";
            RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:urlString title:@"安全须知"];
            [self.navigationController pushViewController:temp animated:YES];
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

- (void)clickedFirstButton
{
    if([RCTool isReachableViaWiFi])
    {
        if(self.isWifiConnected)
        {
            
        }
    }
    else
    {
        
    }
}

- (void)checkWifiConnection
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString* urlString = [@"http://www.baidu.com" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 5];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];

    BOOL isSuccess = YES;
    
    NSURLConnection * urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (urlConnection)
    {
        self.isChecking = YES;
        [RCTool showIndicator:@"检测中..."];
    }
    else
    {
        isSuccess = NO;
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.httpStatusCode = [(NSHTTPURLResponse*)response statusCode];
    NSDictionary* header = [(NSHTTPURLResponse*)response allHeaderFields];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.isChecking = NO;
    [RCTool hideIndicator];
    
    NSLog(@"checkWifiConnection, finish:%d",self.httpStatusCode);
    
    if(200 == self.httpStatusCode)
    {
        NSString* wifiName = @"";
        NSDictionary* wifiInfo = [RCTool getWifiInfo];
        if(wifiInfo && [wifiInfo isKindOfClass:[wifiInfo class]])
        {
            wifiName = [wifiInfo objectForKey:@"SSID"];
        }
        
        if(0 == [wifiName length])
            wifiName = @"";
        
        NSString* phoneNumber = @"";
        NSDictionary* userInfo = [RCTool getUserInfo];
        if(userInfo)
        {
            phoneNumber = [userInfo objectForKey:@"mobile"];
        }
        
        if(0 == [phoneNumber length])
            phoneNumber = @"";
        
        NSString* urlString = [NSString stringWithFormat:@"http://downapp.tfeyes.com:8081/home/index/onlinestatus.html?macaddress=%@&wifiname=%@&gdmobile=%@",@"",wifiName,phoneNumber];
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:nil];
        [self.navigationController pushViewController:temp animated:YES];
    }
    else
    {

    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    self.isChecking = NO;
    [RCTool hideIndicator];
    
    NSLog(@"checkWifiConnection, fail:%d",self.httpStatusCode);
    
    if(302 == self.httpStatusCode)
    {
    }
    else
    {
        
    }

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
