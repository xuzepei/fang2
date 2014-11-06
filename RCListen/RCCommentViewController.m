//
//  RCCommentViewController.m
//  RCFang
//
//  Created by xuzepei on 4/7/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCCommentViewController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"
#import "RCCommentCell.h"

#define INPUT_BAR_HEIGHT 40.0

@interface RCCommentViewController ()

@end

@implementation RCCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"评论";
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        _itemArray = [[NSMutableArray alloc] init];
        self.page = 1;
    }
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    self.itemArray = nil;
    self.item = nil;
    self.inputBar = nil;
    self.inputTF = nil;
    self.sendButton = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initTableView];
    
    [self initInputBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.tableView = nil;
    self.inputBar = nil;
    self.inputTF = nil;
    self.sendButton = nil;
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    NSString* id = [self.item objectForKey:@"id"];
    if(0 == [id length])
        return;
    
    NSString* type = [self.item objectForKey:@"type"];
    if(0 == [type length])
        return;
    
    if(1 == [type intValue])
    {
        self.title = @"新房－评论";
    }
    else if(2 == [type intValue])
    {
         self.title = @"二手房－评论";
    }
    else if(3 == [type intValue])
    {
        self.title = @"租房－评论";
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/comment.php?apiid=%@&apikey=%@&action=read&id=%@&type=%@&page=%d",BASE_URL,APIID,PWD,id,type,self.page];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedRequest:) token:nil];
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
        NSArray* array = [result objectForKey:@"comment_list"];
        if(array && [array isKindOfClass:[NSArray class]])
        {
            self.page++;
            [_itemArray addObjectsFromArray:array];
        }
    }
    
    if(_tableView)
        [_tableView reloadData];
}

#pragma mark - Input Bar

- (void)initInputBar
{
    if(nil == _inputBar)
    {
        _inputBar = [[UIView alloc] initWithFrame:CGRectMake(0, [RCTool getScreenSize].height- STATUS_BAR_HEIGHT - INPUT_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT,[RCTool getScreenSize].width,INPUT_BAR_HEIGHT)];
        _inputBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_box_bg"]];
    }
    
    [self.view addSubview: _inputBar];
    
    if(nil == _inputTF)
    {
        _inputTF = [[UITextField alloc] initWithFrame:CGRectMake(26, 9, 210, 36)];
        _inputTF.placeholder = @"填写评论";
        _inputTF.font = [UIFont systemFontOfSize:16];
        [_inputTF setBorderStyle:UITextBorderStyleNone];
        _inputTF.returnKeyType = UIReturnKeyDone;
        _inputTF.delegate = self;
    }
    
    [_inputBar addSubview: _inputTF];
    
    if(nil == _sendButton)
    {
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(320 - 64,0,56,40);
        [_sendButton setImage:[UIImage imageNamed:@"send_button"] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(clickedSendButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_inputBar addSubview: _sendButton];
}

- (void)clickedSendButton:(id)sender
{
    NSString* username = [RCTool getUsername];
    if(0 == [username length])
    {
        [RCTool showAlert:@"提示" message:@"登录用户才能发表评论！"];
        return;
    }
    
    NSString* id = [self.item objectForKey:@"id"];
    if(0 == [id length])
    {
        [self cancelInput];
        return;
    }
    
    NSString* type = [self.item objectForKey:@"type"];
    if(0 == [type length])
    {
        [self cancelInput];
        return;
    }
    
    NSString* content = _inputTF.text;
    if(0 == [content length])
    {
        [self cancelInput];
        return;
    }
    
    if([content length] > 100)
    {
        [RCTool showAlert:@"提示" message:@"用户评论字数不能超过100个字！"];
        return;
    }

    
    NSString* urlString = [NSString stringWithFormat:@"%@/comment.php?apiid=%@&apikey=%@&action=add&id=%@&type=%@",BASE_URL,APIID,PWD,id,type];
    
    NSString* token = [NSString stringWithFormat:@"content=%@&user=%@",content,[RCTool getUsername]];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedPostRequest:) token:token];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
    
    [self cancelInput];
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
            _inputTF.text = @"";
            error = @"评论发送成功！";
            
            [_itemArray removeAllObjects];
            self.page = 1;
            [self updateContent:self.item];
            
            //return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self clickedSendButton:nil];

    return YES;
}

- (void)cancelInput
{
    if(_inputTF)
        [_inputTF resignFirstResponder];
}

#pragma mark - Keyboard notification

- (void)keyboardWillShow: (NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
	NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [aValue CGRectValue];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         _tableView.frame = CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - INPUT_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - keyboardRect.size.height);
                         
                         _inputBar.frame = CGRectMake(0, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - keyboardRect.size.height - INPUT_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT, [RCTool getScreenSize].width, INPUT_BAR_HEIGHT);
                         
                     }completion:^(BOOL finished) {

                     }];
}

- (void)keyboardWillHide: (NSNotification*)notification
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         

                         _tableView.frame = CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - INPUT_BAR_HEIGHT);
                         
                         _inputBar.frame = CGRectMake(0, [RCTool getScreenSize].height- STATUS_BAR_HEIGHT - INPUT_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT,[RCTool getScreenSize].width,INPUT_BAR_HEIGHT);
                     }];
}


#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - INPUT_BAR_HEIGHT)
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
	
	[self.view addSubview:_tableView];
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
	NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath:indexPath];
    if(item)
    {
        CGSize textSize = CGSizeZero;
        
        NSString* content = [item objectForKey:@"content"];
        if([content isKindOfClass:[NSString class]] && [content length])
        {
            textSize = [content sizeWithFont:[UIFont systemFontOfSize:14]
                           constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
        }
        
        return 24.0 + MAX(24,textSize.height);
    }
    
    return 44.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
	{
		cell = [[RCCommentCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier: cellId];
		cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
    RCCommentCell* temp = (RCCommentCell*)cell;
    NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath: indexPath];
	if(item)
	{
        [temp updateContent:item];
	}
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
				  willDecelerate:(BOOL)decelerate{
    
    if(nil == _tableView)
        return;
    
    CGPoint contentoffset = scrollView.contentOffset;
    CGRect lastItemRect = [_tableView rectForFooterInSection:0];
    
    if(contentoffset.y >= lastItemRect.origin.y - 290)
    {
        [self updateContent:self.item];
    }
}

@end
