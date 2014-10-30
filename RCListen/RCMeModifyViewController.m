//
//  RCMeModifyViewController.m
//  RCFang
//
//  Created by xuzepei on 6/6/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMeModifyViewController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"
#import "RCPasswordViewController.h"

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
    
    [self updateContent];

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

#pragma mark - 获取用户资料
// 获取用户资料
- (void)updateContent
{
    NSString* username = [RCTool getUsername];
    NSString* password = [RCTool getPassword];
    if(0 == [username length] || 0 == [password length])
        return;
    
    NSString* params = [NSString stringWithFormat:@"type=info&username=%@&password=%@",username,password];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user_profile.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedInfoRequest:) token:params];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedInfoRequest:(NSString*)jsonString
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
            NSString* nickname = [result objectForKey:@"niname"];
            if([nickname length])
            {
                [RCTool setNickname:nickname];
                
                [self.tableView reloadData];
            }
            
            NSString* username = [result objectForKey:@"username"];
            if([username length])
                [RCTool setUsername:username];
            
            NSString* password = [result objectForKey:@"password"];
            if([password length])
                [RCTool setPassword:password];
            
            
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

#pragma mark - 修改昵称

- (void)updateNickname
{
    if(0 == [_nicknameTF.text length])
        return;
    
    [_nicknameTF resignFirstResponder];
    
    NSString* username = [RCTool getUsername];
    NSString* password = [RCTool getPassword];
    if(0 == [username length] || 0 == [password length])
        return;
    
    NSString* params = [NSString stringWithFormat:@"type=niname&username=%@&password=%@&niname=%@",username,password,_nicknameTF.text];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user_profile.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedUpdateNicknameRequest:) token:params];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedUpdateNicknameRequest:(NSString*)jsonString
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
            NSString* nickname = [result objectForKey:@"niname"];
            if([nickname length])
            {
                [RCTool setNickname:nickname];
                
                [self.tableView reloadData];
            }
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
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
//        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:@"修改昵称" forKey:@"name"];
//        [dict setObject:@"me_nc" forKey:@"image_path"];
//        [_itemArray addObject:dict];

        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"修改密码" forKey:@"name"];
        [dict setObject:@"me_mm" forKey:@"image_path"];
        [_itemArray addObject:dict];

        
//        dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:@"绑定手机" forKey:@"name"];
//        [dict setObject:@"me_sj" forKey:@"image_path"];
//        [_itemArray addObject:dict];

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
    static NSString *cellId1 = @"cellId1";
    static NSString *cellId2 = @"cellId2";
    
    UITableViewCell *cell = nil;
    
//    if(0 == indexPath.row)
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if (cell == nil)
//        {
//            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
//                                          reuseIdentifier: cellId];
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            cell.textLabel.textColor = [RCTool colorWithHex:0x757575];
//            
//            UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
//            button.frame = CGRectMake(240, 10, 60, 30);
//            [button setTitle:@"修改" forState:UIControlStateNormal];
//            [button setTitleColor:NAVIGATION_BAR_COLOR forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//            [button addTarget:self action:@selector(clickedModifyNicknameButton:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:button];
//            
//            if(nil == _nicknameTF)
//            {
//                _nicknameTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 180, 50)];
//                _nicknameTF.delegate = self;
//                //_nicknameTF.borderStyle = UITextBorderStyleLine;
//                _nicknameTF.returnKeyType = UIReturnKeyDone;
//                _nicknameTF.textColor = [RCTool colorWithHex:0x757575];
//            }
//            
//            [cell.contentView addSubview:_nicknameTF];
//        }
//        
//        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
//        if(item)
//        {
//            NSString* nickname = [RCTool getNickname];
//            if(0 == [nickname length])
//                _nicknameTF.placeholder = @"修改昵称";
//            else
//                _nicknameTF.text = nickname;
//            
//            cell.imageView.image = [UIImage imageNamed:[item objectForKey:@"image_path"]];
//        }
//    }
    if(0 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                          reuseIdentifier: cellId1];
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
        }
    }
//    else if(2 == indexPath.row)
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
//        if (cell == nil)
//        {
//            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
//                                          reuseIdentifier: cellId2];
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            cell.textLabel.textColor = [RCTool colorWithHex:0x757575];
//            
//            UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xjt"]];
//            imageView.center = CGPointMake(280, CELL_HEIGHT/2.0);
//            [cell.contentView addSubview:imageView];
//        }
//        
//        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
//        if(item)
//        {
//            cell.textLabel.text = [item objectForKey:@"name"];
//            cell.imageView.image = [UIImage imageNamed:[item objectForKey:@"image_path"]];
//        }
//    }
	
    

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(0 == indexPath.row)
    {
        RCPasswordViewController* temp = [[RCPasswordViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:temp animated:YES];
    }
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
//    NSString* numbers = @"0123456789.";
//    NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    BOOL b = [string isEqualToString:filtered];
//    if(!b)
//    {
//        return NO;
//    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    
    if([_nicknameTF.text length])
    {
        NSString* current = [RCTool getNickname];
        if([current isEqualToString:_nicknameTF.text])
        {
            [_nicknameTF resignFirstResponder];
            return YES;
        }
            
        [self updateNickname];
    }
    
    return YES;
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


- (void)clickedModifyNicknameButton:(id)sender
{
    NSLog(@"clickedModifyNicknameButton");
    
    [_nicknameTF becomeFirstResponder];
}

@end
