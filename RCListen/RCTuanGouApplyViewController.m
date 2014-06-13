//
//  RCTuanGouApplyViewController.m
//  RCFang
//
//  Created by xuzepei on 6/7/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCTuanGouApplyViewController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"
#import <QuartzCore/QuartzCore.h>

@interface RCTuanGouApplyViewController ()

@end

@implementation RCTuanGouApplyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"申请团购";
        
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"申请" style:UIBarButtonItemStyleDone target:self action:@selector(clickedRightBarButtonItem:)];
        self.navigationItem.rightBarButtonItem = item;
        
        item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickedLeftBarButtonItem:)];
        self.navigationItem.leftBarButtonItem = item;
        
        UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 50, 100, 30)];
        tipLabel.text = @"申请人姓名:";
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.view addSubview:tipLabel];
        
        
        [self initTextField];
    }
    return self;
}

- (void)dealloc
{
    self.tg_id = nil;
    self.textField = nil;

}

- (void)clickedLeftBarButtonItem:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)clickedRightBarButtonItem:(id)sender
{
    if(0 == [_textField.text length])
    {
        [RCTool showAlert:@"提示" message:@"请先填写申请人的姓名！"];
        return;
    }
    
    if(0 == [self.tg_id length])
        return;
    
    NSString* urlString = [NSString stringWithFormat:@"%@/tuangou_apply.php?apiid=%@&pwd=%@&action=sub",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"tg_id=%@&user=%@&name=%@",self.tg_id,[RCTool getUsername],_textField.text];
    
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
            [RCTool showAlert:@"提示" message:@"团购申请成功！"];
            
            [self clickedLeftBarButtonItem:nil];
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSString*)tg_id
{
    self.tg_id = tg_id;
    
    NSString* nickname = [RCTool getNickname];
    if([nickname length])
    {
        _textField.text = nickname;
    }
}

- (void)initTextField
{
    if(nil == _textField)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 80, 200, 28)];
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.placeholder = @"请填写您的姓名";
        
        _textField.layer.cornerRadius = 2.0f;
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderColor = [[UIColor grayColor]CGColor];
        _textField.layer.borderWidth = 1.0f;
    }
    
    [_textField becomeFirstResponder];
    [self.view addSubview:_textField];
}

@end
