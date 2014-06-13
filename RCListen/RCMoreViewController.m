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
    }
    return self;
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
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"房贷计算器" forKey:@"name"];
    [dict setObject:@"fangdai" forKey:@"image_path"];
    [_itemArray addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"税费计算器" forKey:@"name"];
    [dict setObject:@"suifei" forKey:@"image_path"];
    [_itemArray addObject:dict];
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"清理缓存" forKey:@"name"];
    [dict setObject:@"qingli" forKey:@"image_path"];
    [_itemArray addObject:dict];
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"关于我们" forKey:@"name"];
        [dict setObject:@"guanyu" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"使用帮助" forKey:@"name"];
        [dict setObject:@"bangzhu" forKey:@"image_path"];
        [_itemArray addObject:dict];
        
        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"用户反馈" forKey:@"name"];
        [dict setObject:@"fankui" forKey:@"image_path"];
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
        RCFangDaiViewController* temp =[[RCFangDaiViewController alloc] initWithNibName:nil bundle:nil];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];

    }
    else if(1 == indexPath.row)
    {
        RCShuiFeiViewController* temp = [[RCShuiFeiViewController alloc] initWithNibName:nil bundle:nil];
        temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
    else if(2 == indexPath.row)
    {
        NSString* imageDirectoryPath = [NSString stringWithFormat:@"%@/images",[RCTool getUserDocumentDirectoryPath]];
        [RCTool removeFile:imageDirectoryPath];
        
        [RCTool showAlert:@"提示" message:@"成功清理缓存!"];
    }
    else if(3 == indexPath.row)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/aboutus.php",BASE_URL];
        
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:@"关于我们"];
        [self.navigationController pushViewController:temp animated:YES];

    }
    else if(4 == indexPath.row)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/help.php",BASE_URL];
        
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        [temp updateContent:urlString title:@"使用帮助"];
        [self.navigationController pushViewController:temp animated:YES];

    }
    else if(5 == indexPath.row)
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
}


@end
