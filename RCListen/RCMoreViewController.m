//
//  RCMoreViewController.m
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCMoreViewController.h"
#import "RCTool.h"
#import "RCFangDaiViewController.h"
#import "RCShuiFeiViewController.h"
#import "RCWebViewController.h"
#import "RCFeedbackViewController.h"
#import "RCHttpRequest.h"
#import "UMSocial.h"

#define UPDATE_TAG 122

@interface RCMoreViewController ()

@end

@implementation RCMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        UITabBarItem* item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:TT_MORE];
//        
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"更多"
														   image:[UIImage imageNamed:@"gd"]
															 tag:TT_MORE];
        
		self.tabBarItem = item;
		
		self.navigationItem.title = @"更多";
        
        _itemArray = [[NSMutableArray alloc] init];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([RCTool getScreenSize].width - 200)/2.0, 0, 200, 80)];
        imageView.image = [UIImage imageNamed:@"logo"];
        [self.view addSubview:imageView];
        
        self.versionLabel = [[UILabel alloc] initWithFrame:CGRectMake([RCTool getScreenSize].width - 60, 52, 50, 18)];
        self.versionLabel.text = @"v1.0";
        self.versionLabel.font = [UIFont systemFontOfSize:15];
        self.versionLabel.backgroundColor = [UIColor blueColor];
        self.versionLabel.textColor = [UIColor whiteColor];
        self.versionLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.versionLabel];
        
        [self updateContent];
    }
    return self;
}

- (void)updateContent
{

    NSString* urlString = [NSString stringWithFormat:@"%@/app_version.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];

    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedRequest:) token:nil];
    if(b)
    {
        //[RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedRequest:(NSString*)jsonString
{
    //[RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            self.versionLabel.text = [result objectForKey:@"version"];
            
            return;
        }
        
        //[RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)dealloc
{
    self.tableView = nil;
    self.itemArray = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.tableView = nil;
}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,80,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - 80)
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
    }
	
	[self.view addSubview:_tableView];
    
    if(0 == [_itemArray count])
    {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"关于大管家" forKey:@"name"];
    [dict setObject:@"f8" forKey:@"image_path"];
    [_itemArray addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"大管家公告" forKey:@"name"];
    [dict setObject:@"f1" forKey:@"image_path"];
    [_itemArray addObject:dict];
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"版本升级" forKey:@"name"];
        [dict setObject:@"f6" forKey:@"image_path"];
        [_itemArray addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"常见问题" forKey:@"name"];
    [dict setObject:@"f3" forKey:@"image_path"];
    [_itemArray addObject:dict];
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"意见反馈" forKey:@"name"];
        [dict setObject:@"me_mm" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"新功能介绍" forKey:@"name"];
        [dict setObject:@"f9" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"扫一扫" forKey:@"name"];
        [dict setObject:@"f11" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"清除缓存" forKey:@"name"];
        [dict setObject:@"f10" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"价格标准" forKey:@"name"];
        [dict setObject:@"f4" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"分享给好友" forKey:@"name"];
        [dict setObject:@"f5" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"软件使用许可协议" forKey:@"name"];
        [dict setObject:@"f2" forKey:@"image_path"];
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
    if(indexPath.row != 2)
        return 44.0;
    
    return 0.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: cellId];
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
    
    if(0 == indexPath.row)
    {
//        RCFangDaiViewController* temp =[[RCFangDaiViewController alloc] initWithNibName:nil bundle:nil];
//        temp.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:temp animated:YES];
        
        NSString* urlString = [NSString stringWithFormat:@"%@/web/about.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
        
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:@"关于大管家"];
        [self.navigationController pushViewController:temp animated:YES];

    }
    else if(1 == indexPath.row)
    {
//        RCShuiFeiViewController* temp = [[RCShuiFeiViewController alloc] initWithNibName:nil bundle:nil];
//        temp.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:temp animated:YES];
        
        NSString* urlString = [NSString stringWithFormat:@"%@/web/announcement.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
        
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:@"大管家公告"];
        [self.navigationController pushViewController:temp animated:YES];
    }
    else if(2 == indexPath.row)
    {
//        //检查最新版本
//        NSString* urlString = [NSString stringWithFormat:@"%@/check_update.php?apiid=%@&pwd=%@&ios=1",BASE_URL,APIID,PWD];
//        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
//        [temp request:urlString delegate:self resultSelector:@selector(finishedCheckRequest:) token:nil];
    }
    else if(3 == indexPath.row)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/web/faq.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
        
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:@"常见问题"];
        [self.navigationController pushViewController:temp animated:YES];

    }
    else if(4 == indexPath.row)
    {
        NSString* username = [RCTool getUsername];
        if(0 == [username length])
        {
            [RCTool showAlert:@"提示" message:@"登录用户才能发送用户反馈！"];
            return;
        }
        
        RCFeedbackViewController* temp = [[RCFeedbackViewController alloc] initWithNibName:nil bundle:nil];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];

    }
    else if(5 == indexPath.row)
    {

        NSString* urlString = [NSString stringWithFormat:@"%@/web/whatsnew.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
        
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:@"新功能介绍"];
        [self.navigationController pushViewController:temp animated:YES];
    }
    else if(6 == indexPath.row)
    {
        [self clickedScanButton:nil];
    }
    else if(7 == indexPath.row)
    {
        NSString* imageDirectoryPath = [NSString stringWithFormat:@"%@/images",[RCTool getUserDocumentDirectoryPath]];
        [RCTool removeFile:imageDirectoryPath];

        [RCTool showAlert:@"提示" message:@"成功清理缓存!"];
    }
    else if(8 == indexPath.row)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/web/price_list.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
        
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:@"价格标准"];
        [self.navigationController pushViewController:temp animated:YES];
    }
    else if(9 == indexPath.row)
    {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMENG_APPKEY
                                          shareText:@""
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,
                                UMShareToWechatTimeline,
                                    UMShareToWechatSession,UMShareToEmail,UMShareToSms,nil]
                                           delegate:nil];
    }
    else if(10 == indexPath.row)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/web/license.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
        
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:@"软件使用许可协议"];
        [self.navigationController pushViewController:temp animated:YES];
    }
}

- (void)clickedScanButton:(id)sender
{
    NSLog(@"clickedScanButton");
    
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentViewController:reader animated:YES completion:nil];
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    [RCTool playSound:@"done.caf"];
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    NSLog(@"code:%@",symbol.data);
    
    NSString* urlString = symbol.data;
    //    // EXAMPLE: do something useful with the barcode data
    //    resultText.text = symbol.data;
    //
    //    // EXAMPLE: do something useful with the barcode image
    //    resultImage.image =
    //    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    if([urlString hasPrefix:@"http:"] || [urlString hasPrefix:@"https:"])
    {
        RCWebViewController* temp = [[RCWebViewController alloc] init:NO];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:nil];
        [self.navigationController pushViewController:temp animated:YES];
        
    }
}

- (void)finishedCheckRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* version = [result objectForKey:@"version"];
        self.updateUrlString = [result objectForKey:@"url"];
        if([version floatValue] > [VERSION floatValue])
        {
            if([self.updateUrlString length])
            {
                NSString* message = [result objectForKey:@"update"];
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"版本升级提示", nil)
                                                                     message:message
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消" otherButtonTitles:@"立刻下载",nil];
                alertView.tag = UPDATE_TAG;
                [alertView show];
                
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(UPDATE_TAG == alertView.tag)
    {
        NSLog(@"clickedButtonAtIndex:%d",buttonIndex);
        
        if(1 == buttonIndex)
        {
            if([self.updateUrlString length])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrlString]];
            }
        }
    }
}




@end
