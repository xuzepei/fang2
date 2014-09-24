//
//  RCDDStep4ViewController.m
//  RCFang
//
//  Created by xuzepei on 9/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDStep4ViewController.h"
#import "RCDDStep5ViewController.h"
#import "RCHttpRequest.h"

@interface RCDDStep4ViewController ()

@end

enum {
    TF_TAG_0 = 200,
    TF_TAG_1,
    TF_TAG_2,
    TF_TAG_3,
    TF_TAG_4,
    TF_TAG_5,
    TF_TAG_6,
    TF_TAG_7,
    TF_TAG_8,
    TF_TAG_9,
    TF_TAG_10,
    TF_TAG_11,
    TF_TAG_12,
};

@implementation RCDDStep4ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"填写物品信息";
        
        self.selected_index0 = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView.contentSize = CGSizeMake([RCTool getScreenSize].width, 700);
    
    self.tf0.text = [self.item objectForKey:@"order_num"];
    self.tf1.text = [RCTool getUsername];
    
    [self initPickerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"性别" forKey:@"name"];
    NSArray* array = @[@"先生",@"女士"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_4] forKey:@"tag"];
    self.selection0 = dict;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(TF_TAG_0 == textField.tag || TF_TAG_1 == textField.tag)
    {
        return NO;
    }
    else if(TF_TAG_4 == textField.tag)
    {
        [_tf0 resignFirstResponder];
        [_tf1 resignFirstResponder];
        [_tf2 resignFirstResponder];
        [_tf3 resignFirstResponder];
        
        [_pickerView updateContent:self.selection0];
        [_pickerView show];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if(TF_TAG_3 == textField.tag)
    {
        NSString* numbers = @"0123456789";
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
    if(TF_TAG_4 == tag)
    {
        self.selected_index0 = index;
        NSArray* array = [self.selection0 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [array objectAtIndex:index];
    }
}

#pragma mark -

- (IBAction)clickedNextButton:(id)sender
{
    NSString* username = [RCTool getUsername];
    if(0 == [username length])
    {
        [RCTool showAlert:@"提示" message:@"请先登录！"];
        return ;
    }
    
    NSString* order_num = [self.item objectForKey:@"order_num"];
    if(0 == [order_num length])
        return;

    NSString* user_name = [RCTool getUsername];
    
    if(-1 == self.selected_index0)
    {
        [RCTool showAlert:@"提示" message:@"请选择性别！"];
        return;
    }
    
    NSString* user_sex = [NSString stringWithFormat:@"%d",self.selected_index0 + 1];
    
    NSString* user_tel = self.tf2.text;
    if(0 == [user_name length])
    {
        [RCTool showAlert:@"提示" message:@"请填写用户姓名！"];
        return;
    }
    
    NSString* urgent_tel = self.tf3.text;
    if(0 == [urgent_tel length])
    {
        [RCTool showAlert:@"提示" message:@"请填写紧急联系电话！"];
        return;
    }
//    order_num     -- 订单编号
//    user_name     -- 用户姓名
//    user_sex      -- 用户性别
//    user_tel      -- 用户电话
//    urgent_tel    -- 紧急联系电话

    
    NSString* urlString = [NSString stringWithFormat:@"%@/order_remover.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"type=remover&step=5&username=%@&order_num=%@&user_name=%@&user_sex=%@&user_tel=%@&urgent_tel=%@",username,order_num,user_name,user_sex,user_tel,urgent_tel];
    
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
            RCDDStep5ViewController* temp = [[RCDDStep5ViewController alloc] initWithNibName:nil bundle:nil];
            NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
            [item addEntriesFromDictionary:self.item];
            [item addEntriesFromDictionary:result];
            [temp updateContent:item];
            [self.navigationController pushViewController:temp animated:YES];
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

@end
