//
//  RCFeedbackViewController.m
//  RCFang
//
//  Created by xuzepei on 5/10/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCFeedbackViewController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"

@interface RCFeedbackViewController ()

@end

@implementation RCFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"用户反馈";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(clickedRightBarButtonItem:)];
    }
    return self;
}

- (void)dealloc
{
    self.textView = nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.textView = nil;
}

- (void)clickedRightBarButtonItem:(id)sender
{
    if(0 == [_textView.text length])
        return;
    
    NSString* urlString = [NSString stringWithFormat:@"%@/feedback.php?apiid=%@&apikey=%@&action=add",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"content=%@&username=%@",_textView.text,[RCTool getUsername]];
    
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
            _textView.text = @"";
            error = @"成功发送反馈意见！";

            //return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)initTextView
{
    if(nil == _textView)
    {
        _textView = [[RCPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - 216)];
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.placeholder = @"请留下您的宝贵意见或建议";
    }
    
    [self.view addSubview:_textView];
    
    [self.textView becomeFirstResponder];
}

@end
