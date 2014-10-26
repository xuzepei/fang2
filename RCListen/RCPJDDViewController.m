//
//  RCPJDDViewController.m
//  RCFang
//
//  Created by xuzepei on 10/26/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCPJDDViewController.h"
#import "RCHttpRequest.h"

@interface RCPJDDViewController ()

@end

@implementation RCPJDDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"评价订单";
        
        self.selected_index0  = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initPickerView];
    
    self.tv.placeholder = @"请填写评价内容";
    
    NSString* urlString = [NSString stringWithFormat:@"%@/order_appraise_info.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];

    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedPFRequest:) token:nil];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedPFRequest:(NSString*)jsonString
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
            
            NSArray* array = [result objectForKey:@"list"];
            if(array && [array isKindOfClass:[NSArray class]])
            {
                self.pfList = array;
                
                if([self.pfList count])
                {
                    NSMutableArray* array = [[NSMutableArray alloc] init];
                    for(NSDictionary* item in self.pfList)
                    {
                        [array addObject:[item objectForKey:@"text"]];
                    }

                    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:@"请选择评分" forKey:@"name"];
                    [dict setObject:array forKey:@"values"];
                    [dict setObject:[NSNumber numberWithInt:111] forKey:@"tag"];
                    self.selection0 = dict;
                }
            }
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == 111)
    {
        [_pickerView updateContent:self.selection0];
        [_pickerView show];
    }
    
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary *)item
{
    self.item = item;
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Picker View

- (void)initPickerView
{
    if(nil == _pickerView)
    {
        _pickerView = [[RCPickerView alloc] initWithFrame:CGRectMake(0, [RCTool getScreenSize].height, [RCTool getScreenSize].width, PICKER_VIEW_HEIGHT)];
        _pickerView.delegate = self;
    }
}

- (void)clickedSureValueButton:(int)index token:(id)token
{
    if(nil == token || -1 == index)
        return;
    
    NSDictionary* dict = (NSDictionary*)token;
    int tag = [[dict objectForKey:@"tag"] intValue];
    if(111 == tag)
    {
        self.selected_index0 = index;

        if(self.selected_index0 >= 0 && self.selected_index0 < [self.pfList count])
        {
            NSDictionary* item = [self.pfList objectAtIndex:self.selected_index0];
            self.tf.text = [item objectForKey:@"text"];
        }
        else
        {
            self.tf.text = @"";
        }
    }
}

- (IBAction)clickedButton:(id)sender
{
    NSString* username = [RCTool getUsername];
    NSString* password = [RCTool getPassword];
    if(0 == [username length] || 0 == [password length])
    {
        [RCTool showAlert:@"提示" message:@"请先登录！"];
        return ;
    }
    
    NSString* order_num = [self.item objectForKey:@"order_num"];
    if(0 == [order_num length])
        return;

    NSString* appraise_text = self.tv.text;
    if(0 == [appraise_text length])
    {
        [RCTool showAlert:@"提示" message:@"请填写评价文字。"];
        return;
    }
    
    NSString* appraise = @"";
    if(self.selected_index0 >=0 && self.selected_index0 < [self.pfList count])
    {
        NSDictionary* item = [self.pfList objectAtIndex:self.selected_index0];
        appraise = [item objectForKey:@"value"];
    }
    
    
    NSString* urlString = [NSString stringWithFormat:@"%@/user_order.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"type=appraise&username=%@&password=%@&order_num=%@&appraise_text=%@&appraise=%@",username,password,order_num,appraise_text,appraise];
    
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
            [RCTool showAlert:@"提示" message:@"订单评价成功！"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

@end
