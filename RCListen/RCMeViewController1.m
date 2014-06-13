//
//  RCMeViewController.m
//  RCFang
//
//  Created by xuzepei on 3/9/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCMeViewController1.h"
#import "RCTool.h"
#import "RCLoginViewController.h"
#import "RCWebViewController.h"
#import "CUShareCenter.h"
#import "RCFavoriteViewController.h"
#import "RCWebViewController.h"
#import "RCShareTextViewController.h"
#import "RCTuanGouViewController.h"

#define SHARE_TAG 111

@interface RCMeViewController1 ()

@end

@implementation RCMeViewController1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"个人中心"
														   image:[UIImage imageNamed:@"me"]
															 tag:TT_ME];
		self.tabBarItem = item;
		
		self.navigationItem.title = @"个人中心";
        
        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布信息" style:UIBarButtonItemStyleDone target:self action:@selector(clickedRightBarButtonItem:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
        _itemArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    self.itemArray = nil;
    self.loginButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUserName];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self initTableView];
    
    [self initButtons];
    
    [self updateUserName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.tableView = nil;
    self.loginButton = nil;
}

- (void)clickedRightBarButtonItem:(id)sender
{
    NSString* username = [RCTool getUsername];
    if(0 == [username length])
    {
        [RCTool showAlert:@"提示" message:@"登录用户才能发布信息！"];
        return;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user/rent_release.php?username=%@&password=%@",@"http://app.lsfxgg.com",username,[RCTool getPassword]];
    
    RCWebViewController* temp = [[RCWebViewController alloc] initWithNibName:nil bundle:nil];
    temp.hidesBottomBarWhenPushed = YES;
    [temp updateContent:urlString title:@"租房信息"];
    [self.navigationController pushViewController:temp animated:YES];
}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT -TAB_BAR_HEIGHT)
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
//        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:@"浏览历史" forKey:@"name"];
//        [dict setObject:@"lishi" forKey:@"image_path"];
//        [_itemArray addObject:dict];
//        [dict release];
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"我的收藏" forKey:@"name"];
        [dict setObject:@"favorites" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"扫一扫" forKey:@"name"];
        [dict setObject:@"saomiao" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"分享" forKey:@"name"];
        [dict setObject:@"fenxiang" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"我的资料" forKey:@"name"];
        [dict setObject:@"gerenziliao" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"我的团购" forKey:@"name"];
        [dict setObject:@"wodetuangou" forKey:@"image_path"];
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
	return 44.0;
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
        [self clickedFavoriteButton:nil];
    }
    else if(1 == indexPath.row)
    {
        [self clickedScanButton:nil];
    }
    else if(2 == indexPath.row)
    {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择操作"
                                                                  delegate:self
                                                         cancelButtonTitle:@"取消"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"通过短信分享",@"通过腾讯微博分享",@"通过新浪微博分享",nil];
        actionSheet.tag = SHARE_TAG;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    else if(3 == indexPath.row)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/user/user_info.php?username=%@&password=%@",@"http://app.lsfxgg.com",[RCTool getUsername],[RCTool getPassword]];
        
        RCWebViewController* temp = [[RCWebViewController alloc] initWithNibName:nil bundle:nil];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:@"我的资料"];
        [self.navigationController pushViewController:temp animated:YES];

    }
    else if(4 == indexPath.row)
    {
        NSString* username = [RCTool getUsername];
        if(0 == [username length])
        {
            [RCTool showAlert:@"提示" message:@"登录后才能查看我的团购！"];
            return;
        }
        
        RCTuanGouViewController* temp = [[RCTuanGouViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:username];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];

    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(SHARE_TAG == actionSheet.tag)
    {
        if(0 == buttonIndex)
        {
            [self sendMessage:[RCTool getShareText] number:nil];
        }
        else if(1 == buttonIndex)
        {
            [self shareText:[RCTool getShareText] type:SHT_QQ];
        }
        else if(2 == buttonIndex)
        {
            [self shareText:[RCTool getShareText] type:SHT_SINA];
        }
    }
}


- (void)sendMessage:(NSString*)text number:(NSString*)number
{

    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if(messageClass)
    {
        if(NO == [MFMessageComposeViewController canSendText])
        {
            [RCTool showAlert:@"提示" message:@"设备没有短信功能"];
            return;
        }
    }
    else
    {
        [RCTool showAlert:@"提示" message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
        return;
    }
    
    MFMessageComposeViewController* compose = [[MFMessageComposeViewController alloc] init];
    
    compose.messageComposeDelegate = self;
    if([number length])
    compose.recipients = [NSArray arrayWithObject:number];
    compose.body = text;
    [self presentViewController:compose animated:YES completion:^{
        
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:NO completion:^{
        
    }];//关键的一句   不能为YES
    
    switch ( result ) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
        {
            [RCTool showAlert:@"提示" message:@"短信发送成功!"];
            break;
        }
        default:
            break;
    }
    
}

- (void)shareText:(NSString*)text type:(SHARE_TYPE)type
{
    if(SHT_QQ == type)
    {
        CUShareCenter* qqShare = [CUShareCenter sharedInstanceWithType:CUSHARE_QQ];
        
        if([qqShare isBind])
        {
            RCShareTextViewController* temp = [[RCShareTextViewController alloc] initWithNibName:nil bundle:nil];
            
            [temp updateContent:type text:text];
            
            UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:temp];

            [self presentViewController:navigationController animated:YES completion:^{
                
            }];

        }
        else
        {
            [qqShare Bind:self];
        }
    }
    else if(SHT_SINA == type)
    {
        CUShareCenter* sinaShare = [CUShareCenter sharedInstanceWithType:CUSHARE_SINA];
        
        if ([sinaShare isBind])
        {
            RCShareTextViewController* temp = [[RCShareTextViewController alloc] initWithNibName:nil bundle:nil];
            
            [temp updateContent:type text:text];
            
            UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:temp];
            
            [self presentModalViewController:navigationController animated:YES];

        }
        else
        {
            [sinaShare Bind:self];
        }
    }
}

#pragma mark Buttons

- (void)initButtons
{
    if(nil == _loginButton)
    {
        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(70, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - 100, 180, 33);
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                //[_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_loginButton addTarget:self action:@selector(clickedLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: _loginButton];
    }
    
}

- (void)clickedLoginButton:(id)sender
{
    NSLog(@"clickedLoginButton");
    
    RCLoginViewController* temp = [[RCLoginViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:temp
                                         animated:YES];

    
}

- (void)clickedLogoutButton:(id)sender
{
    NSLog(@"clickedLogoutButton");
    
    [RCTool setUsername:@""];
    
    [self updateUserName];
    
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
    [self presentModalViewController: reader
                            animated: YES];
}

- (void)clickedFavoriteButton:(id)sender
{
    RCFavoriteViewController* temp = [[RCFavoriteViewController alloc] initWithNibName:nil bundle:nil];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
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
    [reader dismissModalViewControllerAnimated: YES];
    
    if([urlString hasPrefix:@"http:"] || [urlString hasPrefix:@"https:"])
    {
        RCWebViewController* temp = [[RCWebViewController alloc] init:NO];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:nil];
        [self.navigationController pushViewController:temp animated:YES];

    }
}

- (void)updateUserName
{
    if(_loginButton)
    {
        NSString* username = [RCTool getUsername];
        if([username length])
        {
            NSString* temp = [NSString stringWithFormat:@"退出(%@)",username];
            [_loginButton setTitle:temp forState:UIControlStateNormal];
            [_loginButton addTarget:self action:@selector(clickedLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
            [_loginButton addTarget:self action:@selector(clickedLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

@end
