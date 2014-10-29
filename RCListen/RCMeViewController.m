//
//  RCMeViewController.m
//  RCFang
//
//  Created by xuzepei on 6/6/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMeViewController.h"
#import "RCLoginViewController.h"
#import "RCPublicCell.h"
#import "RCMeModifyViewController.h"
#import "RCHttpRequest.h"
#import "RCDDViewController.h"
#import "RCJFViewController.h"
#import "RCYHJViewController.h"

#define TOP_VIEW_HEIGHT 80.0f
#define ME_TAB_BAR_HEIGHT 53.0f
#define CELL_HEIGHT 48.0f

@interface RCMeViewController ()

@end

@implementation RCMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"个人中心"
														   image:[UIImage imageNamed:@"me"]
															 tag:TT_ME];
		self.tabBarItem = item;
		
		self.navigationItem.title = @"个人中心";
        
        self.view.backgroundColor = [RCTool colorWithHex:0xf0f0f0];
    }
    return self;
}

- (void)dealloc
{
    self.topView = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self initTopView];
//    
//    [self initTabBar];
//    
//    [self initTableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initTopView];
    
    //[self initTabBar];
    
    [self initTableView];
    
    [self updateContent];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent
{
    if(NO == [RCTool isLogined])
        return;
    
    NSString* username = [RCTool getUsername];
    NSString* password = [RCTool getPassword];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user_center.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedRequest:) token:token];
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
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            self.item = result;
            [self.tableView reloadData];
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

#pragma mark - Top View

- (void)initTopView
{
    if(nil == _topView)
    {
        _topView = [[RCMeTopView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, TOP_VIEW_HEIGHT)];
    }
    
    for(UIView* subView in [_topView subviews])
        [subView removeFromSuperview];
    
    [_topView setNeedsDisplay];
    [self.view addSubview:_topView];
    
    if([RCTool isLogined])//已登录
    {
        UIButton* modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //modifyButton.backgroundColor = [UIColor redColor];
        modifyButton.frame = CGRectMake([RCTool getScreenSize].width - 60, 20, 40, 40);
        [modifyButton setImage:[UIImage imageNamed:@"djt"] forState:UIControlStateNormal];
        [modifyButton addTarget:self action:@selector(clickedModifyButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:modifyButton];
    }
    else
    {
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //loginButton.backgroundColor = [UIColor redColor];
        loginButton.frame = CGRectMake(0, 0, 71, 25);
        loginButton.center = CGPointMake([RCTool getScreenSize].width/2.0, 58);
        [loginButton setTitle:@"点击登录" forState:UIControlStateNormal];
        [loginButton setTitleColor:[RCTool colorWithHex:0x3e3c3d] forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(clickedLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:loginButton];
    }
}

- (void)clickedLoginButton:(id)sender
{
    NSLog(@"clickedLoginButton");
    
    RCLoginViewController* temp = [[RCLoginViewController alloc] initWithNibName:nil bundle:nil];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp
                                         animated:YES];
 
}

- (void)clickedModifyButton:(id)sender
{
    NSLog(@"clickedModifyButton");
    
    RCMeModifyViewController* temp = [[RCMeModifyViewController alloc] initWithNibName:nil bundle:nil];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];

}


#pragma mark - Tab Bar

- (void)initTabBar
{
    if(NO == [RCTool isLogined])
    {
        if(_tabBar)
            [_tabBar removeFromSuperview];
        
        return;
    }
    
    if(nil == _tabBar)
    {
        _tabBar = [[RCMeTabBar alloc] initWithFrame:CGRectMake(0,TOP_VIEW_HEIGHT, [RCTool getScreenSize].width, ME_TAB_BAR_HEIGHT)];
        _tabBar.delegate = self;
        
        NSArray* titleArray = [NSArray arrayWithObjects:@"朋友圈",@"积分兑换",@"积分赠予",nil];
        [_tabBar updateContent:titleArray];
        
        [self clickedTabItem:0 token:nil];
    }
    
    [self.view addSubview:_tabBar];
}

- (void)clickedTabItem:(int)index token:(id)token
{
    NSLog(@"clickedTabItem:%d",index);
}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _itemArray)
        _itemArray = [[NSMutableArray alloc] init];
    
    CGFloat height = TOP_VIEW_HEIGHT;
//    if([RCTool isLogined])
//        height += ME_TAB_BAR_HEIGHT;
    
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,height,[RCTool getScreenSize].width,[RCTool getScreenSize].height - height -TAB_BAR_HEIGHT)
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
    }
    
    _tableView.frame = CGRectMake(0,height,[RCTool getScreenSize].width,[RCTool getScreenSize].height - height - TAB_BAR_HEIGHT);
	
	[self.view addSubview:_tableView];
    
    if(0 == [_itemArray count])
    {
        //        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        //        [dict setObject:@"浏览历史" forKey:@"name"];
        //        [dict setObject:@"lishi" forKey:@"image_path"];
        //        [_itemArray addObject:dict];
        //        [dict release];
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"我的订单" forKey:@"name"];
        [dict setObject:@"me_dd" forKey:@"image_path"];
        [_itemArray addObject:dict];

        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"我的优惠卷" forKey:@"name"];
        [dict setObject:@"me_bx" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"我的积分" forKey:@"name"];
        [dict setObject:@"me_jf" forKey:@"image_path"];
        [_itemArray addObject:dict];

    }
    
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(0 == section)
        return 8;
    
    return 30.0;
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
	return CELL_HEIGHT;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell = [[RCPublicCell alloc] initWithStyle: UITableViewCellStyleDefault
                                    reuseIdentifier: cellId contentViewClass:NSClassFromString(@"RCMeNumberCellContentView")];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [RCTool colorWithHex:0x757575];
  
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xjt"]];
        imageView.center = CGPointMake(280, CELL_HEIGHT/2.0);
        [cell.contentView addSubview:imageView];

    }
	
    
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
	if(item)
	{
        cell.textLabel.text = [item objectForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed:[item objectForKey:@"image_path"]];
        
        if(self.item)
        {
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
            [tempDict addEntriesFromDictionary:item];
            
            NSString* count = @"";
            if(0 == indexPath.row)
            {
                count = [self.item objectForKey:@"order_count"];
            }
            else if(1 == indexPath.row)
            {
                count = [self.item objectForKey:@"coupon_count"];
            }
            else if(2 == indexPath.row)
            {
                count = [self.item objectForKey:@"credit"];
            }
            
            [tempDict setObject:count forKey:@"count"];
            
            RCPublicCell* temp = (RCPublicCell*)cell;
            
            [temp updateContent:tempDict cellHeight:CELL_HEIGHT delegate:self token:nil];
        }
	}
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    

    if(0 == indexPath.row)
    {
        if(NO == [RCTool isLogined])
        {
            [RCTool showAlert:@"提示" message:@"请先登录！"];
            return;
        }
        
        RCDDViewController* temp = [[RCDDViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
    else if(1 == indexPath.row)
    {
        if(NO == [RCTool isLogined])
        {
            [RCTool showAlert:@"提示" message:@"请先登录！"];
            return;
        }
        
        RCYHJViewController* temp = [[RCYHJViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
    else if(2 == indexPath.row)
    {
        if(NO == [RCTool isLogined])
        {
            [RCTool showAlert:@"提示" message:@"请先登录！"];
            return;
        }
        
        RCJFViewController* temp = [[RCJFViewController alloc] initWithNibName:nil bundle:nil];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
}


@end
