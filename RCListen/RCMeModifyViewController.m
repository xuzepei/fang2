//
//  RCMeModifyViewController.m
//  RCFang
//
//  Created by xuzepei on 6/6/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMeModifyViewController.h"
#import "RCTool.h"

#define CELL_HEIGHT 50.0f

@interface RCMeModifyViewController ()

@end

@implementation RCMeModifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

		self.title = @"个人中心";
        self.view.backgroundColor = BG_COLOR;
    }
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    self.itemArray = nil;
    self.logoutButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initTableView];
    
    [self initButtons];
    
    
    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.tableView = nil;
    self.logoutButton = nil;
}

- (void)clickedBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _itemArray)
        _itemArray = [[NSMutableArray alloc] init];
    
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
        [dict setObject:@"修改昵称" forKey:@"name"];
        [dict setObject:@"me_nc" forKey:@"image_path"];
        [_itemArray addObject:dict];

        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"修改密码" forKey:@"name"];
        [dict setObject:@"me_mm" forKey:@"image_path"];
        [_itemArray addObject:dict];

        
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"绑定手机" forKey:@"name"];
        [dict setObject:@"me_sj" forKey:@"image_path"];
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
	return CELL_HEIGHT;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                            reuseIdentifier: cellId];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [RCTool colorWithHex:0x757575];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xjt"]];
        imageView.center = CGPointMake(280, CELL_HEIGHT/2.0);
        [cell.contentView addSubview:imageView];
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
}

#pragma mark Buttons

- (void)initButtons
{
    if(nil == _logoutButton)
    {
        self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.frame = CGRectMake(70, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - 100, 226, 35);
        _logoutButton.center = CGPointMake([RCTool getScreenSize].width/2.0, 300);
        _logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_logoutButton setTitle:@"退出账户" forState:UIControlStateNormal];
        [_logoutButton setBackgroundImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_logoutButton addTarget:self action:@selector(clickedLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: _logoutButton];
    }
    
}

- (void)clickedLogoutButton:(id)sender
{
    NSLog(@"clickedLogoutButton");

    [RCTool setUsername:@""];
    
    [self clickedBackButton:nil];
}


@end
