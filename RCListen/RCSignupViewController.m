//
//  RCSignupViewController.m
//  RCFang
//
//  Created by xuzepei on 3/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCSignupViewController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"

#define ACCOUNT_TF_TAG 100
#define PASSWORD_TF_TAG 101
#define ATTRIBUTED_LABEL_TAG 102

@interface RCSignupViewController ()

@end

@implementation RCSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
		self.title = @"注册";
        
        _itemArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)dealloc
{}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self initTableView];
    
    [self initButtons];
    
    [self initTextFields];
    
    //[self initAttributedLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.tableView = nil;
    self.loginButton = nil;
    self.accountTF = nil;
    self.passwordTF = nil;
    self.attributedLabel = nil;
}

- (void)clickedRightBarButtonItem:(id)sender
{
    
}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)
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
    [dict setObject:@"帐号：" forKey:@"name"];
    [_itemArray addObject:dict];

    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"密码：" forKey:@"name"];
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
    static NSString *cellId1 = @"cellId1";
    
    UITableViewCell *cell = nil;
    
    if(0 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            [cell addSubview:_accountTF];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell addSubview:_passwordTF];
        }
    }
	
    
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
	if(item)
	{
        cell.textLabel.text = [item objectForKey:@"name"];
	}
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark Buttons

- (void)initButtons
{
    if(nil == _loginButton)
    {
        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(70, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - 220, 180, 33);
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginButton setTitle:@"注册" forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_loginButton addTarget:self action:@selector(clickedSignupButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview: _loginButton];
    }
    
}

- (void)clickedSignupButton:(id)sender
{
    NSLog(@"clickedSignupButton");
    
    if(0 == [_accountTF.text length])
    {
        [RCTool showAlert:@"提示" message:@"请输入手机号！"];
        return;
    }
    
    if(0 == [_passwordTF.text length])
    {
        [RCTool showAlert:@"提示" message:@"请输入密码！"];
        return;
    }
    
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user_register.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"tel=%@&pass=%@&area=%@",_accountTF.text,_passwordTF.text,@"乐山"];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedPostRequest:) token:token];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedPostRequest:(NSString*)jsonString
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
            NSString* username = [result objectForKey:@"username"];
            if([username length])
            {
                [RCTool setUsername:username];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                [RCTool showAlert:@"提示" message:@"注册成功!"];
                
                return;
            }

        }
        else
            [RCTool showAlert:@"提示" message:error];
        
        return;
    }
    
    [RCTool showAlert:@"提示" message:@"注册失败，请检查网络，稍后尝试！"];
}


#pragma mark - TextField

- (void)initTextFields
{
    if(nil == _accountTF)
    {
        _accountTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 11, 200, 30)];
        _accountTF.delegate = self;
        _accountTF.tag = ACCOUNT_TF_TAG;
        _accountTF.placeholder = @"手机号";
        _accountTF.returnKeyType = UIReturnKeyDone;
        _accountTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    
    if(nil == _passwordTF)
    {
        _passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 11, 200, 30)];
        _passwordTF.delegate = self;
        _passwordTF.tag = PASSWORD_TF_TAG;
        _passwordTF.placeholder = @"密码";
        _passwordTF.secureTextEntry = YES;
        _passwordTF.returnKeyType = UIReturnKeyDone;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(ACCOUNT_TF_TAG == textField.tag)
    {
        [_passwordTF becomeFirstResponder];
        
        return NO;
    }
    else if(PASSWORD_TF_TAG == textField.tag)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if(ACCOUNT_TF_TAG == textField.tag)
    {
        NSString* numbers = @"0123456789+-";
        NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL b = [string isEqualToString:filtered];
        if(!b)
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - OHAttributedLabel

- (void)initAttributedLabel
{
    if(nil == _attributedLabel)
    {
        _attributedLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        _attributedLabel.tag = ATTRIBUTED_LABEL_TAG;
        _attributedLabel.frame = CGRectMake([RCTool getScreenSize].width - 70, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - 260, 200, 20);
        _attributedLabel.underlineLinks = YES;
        _attributedLabel.lineBreakMode =
        UILineBreakModeWordWrap;
        _attributedLabel.backgroundColor = [UIColor clearColor];
        _attributedLabel.delegate = self;
        NSString* text = @"忘记密码?";
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:text];
        [_attributedLabel setFont:[UIFont systemFontOfSize:16]];
        _attributedLabel.attributedText = attrStr;
        [_attributedLabel addCustomLink:[NSURL URLWithString:text] inRange:NSMakeRange(0, [text length])];
    }
    
    [self.tableView addSubview: _attributedLabel];
}

- (void)clickLinkText:(NSString*)linkText token:(id)token
{
    NSLog(@"clickLinkText:%@",linkText);
    
    if(ATTRIBUTED_LABEL_TAG == _attributedLabel.tag)
    {
        
    }
}

- (UIColor*)colorForLink:(NSTextCheckingResult*)linkInfo underlineStyle:(int32_t*)underlineStyle
{
    return [UIColor blueColor];
}

- (UIFont*)fontForLink:(id)token
{
	return [UIFont systemFontOfSize:12];
}

@end
