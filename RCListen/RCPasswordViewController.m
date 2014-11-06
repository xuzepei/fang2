//
//  RCPasswordViewController.m
//  RCFang
//
//  Created by xuzepei on 8/21/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCPasswordViewController.h"
#import "RCTool.h"
#import "RCHttpRequest.h"
#import "iToast.h"


#define ACCOUNT_TF_TAG 100
#define PASSWORD_TF_TAG 101
#define ATTRIBUTED_LABEL_TAG 102

@interface RCPasswordViewController ()

@end

@implementation RCPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
		self.title = @"修改密码";
        
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
    
    RCPasswordView* passwordView = (RCPasswordView*)self.view;
    passwordView.delegate = self;
    [passwordView updateContent:1 token:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)clickedRightBarButtonItem:(id)sender
{
    
}

- (void)clickedNextButton:(int)type token:(NSDictionary*)token
{
    if(1 == type)
    {
        NSString* phone = [token objectForKey:@"phone"];
        if(0 == [phone length])
            return;
        
        NSString* password = [token objectForKey:@"password"];
        if(0 == [password length])
            return;
        
        NSString* params = [NSString stringWithFormat:@"step=1&username=%@&ypass=%@",phone,password];
        
        NSString* urlString = [NSString stringWithFormat:@"%@/user_passport.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
        
        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
        BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedStep1Request:) token:params];
        if(b)
        {
            [RCTool showIndicator:@"请稍候..."];
        }
        
    }
    else if(2 == type)
    {
        NSString* phone = [token objectForKey:@"username"];
        if(0 == [phone length])
            return;
        
        NSString* verify_list = [token objectForKey:@"verify_list"];
        if(0 == [verify_list length])
            return;
        
        NSString* verify_code = [token objectForKey:@"verify_code"];
        if(0 == [verify_code length])
            return;
        
        NSString* params = [NSString stringWithFormat:@"step=2&username=%@&verify_list=%@&verify_code=%@",phone,verify_list,verify_code];
        
        NSString* urlString = [NSString stringWithFormat:@"%@/user_passport.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
        
        RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
        BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedStep2Request:) token:params];
        if(b)
        {
            [RCTool showIndicator:@"请稍候..."];
        }
    }
    else if(3 == type)
    {
        NSString* phone = [token objectForKey:@"username"];
        if(0 == [phone length])
            return;
        
        NSString* pass = [token objectForKey:@"pass"];
        if(0 == [pass length])
            return;
        
        NSString* repass = [token objectForKey:@"repass"];
        if(0 == [repass length])
            return;
        
        NSString* verify_code = [token objectForKey:@"verify_code"];
        if(0 == [verify_code length])
            return;
        
        NSString* params = [NSString stringWithFormat:@"step=3&username=%@&pass=%@&repass=%@&treaty=1&verify_code=%@",phone,pass,repass,verify_code];
        
        NSString* urlString = [NSString stringWithFormat:@"%@/user_passport.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
        
        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
        BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedStep3Request:) token:params];
        if(b)
        {
            [RCTool showIndicator:@"请稍候..."];
        }
    }
}

- (void)finishedStep1Request:(NSString*)jsonString
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
            RCPasswordView* passwordView = (RCPasswordView*)self.view;
            [passwordView updateContent:2 token:result];
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)finishedStep2Request:(NSString*)jsonString
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
            RCPasswordView* passwordView = (RCPasswordView*)self.view;
            [passwordView updateContent:3 token:result];
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)finishedStep3Request:(NSString*)jsonString
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
            }
            
            NSString* password = [result objectForKey:@"password"];
            if([password length])
            {
                [RCTool setPassword:password];
            }
            
            [[iToast makeText:[NSString stringWithFormat:@"修改密码成功！%@",username]] show];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
    }
}

@end
