//
//  RCJFDHViewController.m
//  RCFang
//
//  Created by xuzepei on 10/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCJFDHViewController.h"
#import "RCHttpRequest.h"

@interface RCJFDHViewController ()

@end

@implementation RCJFDHViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"积分兑换";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self updateContent:self.item];
    
    self.label0.text = [self.item objectForKey:@"credit"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString* numbers = @"0123456789.";
    NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL b = [string isEqualToString:filtered];
    if(!b)
    {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    if(NO == [RCTool isLogined])
        return;
    
    NSString* username = [RCTool getUsername];
    NSString* password = [RCTool getPassword];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user_credit.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"username=%@&password=%@&type=convert_info",username,password];
    
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
            
            self.label0.text = [self.item objectForKey:@"credit"];
            self.tf.text = [self.item objectForKey:@"credit_convert"];
            self.label1.text = [self.item objectForKey:@"intro1"];
            self.label2.text = [self.item objectForKey:@"intro2"];
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (IBAction)clickedButton:(id)sender
{
    NSLog(@"clickedButton");
    
    NSString* username = [RCTool getUsername];
    NSString* password = [RCTool getPassword];
    
    NSString* credit_convert = self.tf.text;
    if(0 == [credit_convert length])
        return;
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user_credit.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"username=%@&password=%@&type=convert&credit_convert=%@",username,password,credit_convert];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedConvertRequest:) token:token];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedConvertRequest:(NSString*)jsonString
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
            [RCTool showAlert:@"提示" message:@"积分兑换成功！"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

@end
