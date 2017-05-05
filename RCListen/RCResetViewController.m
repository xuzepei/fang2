//
//  RCResetViewController.m
//  RCFang
//
//  Created by xuzepei on 17/5/5.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import "RCResetViewController.h"
#import "RCHttpRequest.h"

#define RESET_ALERT_TAG 115

@interface RCResetViewController ()

@end

@implementation RCResetViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary* userInfo = [RCTool getUserInfo];
    if(userInfo)
    {
        self.phoneNumber.text = [userInfo objectForKey:@"mobile"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"重置密码";
    self.view.backgroundColor = BG_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if(RESET_ALERT_TAG == alertView.tag)
//    {
//        NSLog(@"clickedButtonAtIndex:%d",buttonIndex);
//        
//        if(0 == buttonIndex)
//        {
//            [self requestToReset];
//        }
//        else if(1 == buttonIndex)
//        {
//
//        }
//    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(RESET_ALERT_TAG == alertView.tag)
    {
        NSLog(@"clickedButtonAtIndex:%d",buttonIndex);
        
        if(0 == buttonIndex)
        {
            [self requestToReset];
        }
        else if(1 == buttonIndex)
        {
            
        }
    }
}

- (IBAction)clickedResetButton:(id)sender {
    
    if(0 == [self.phoneNumber.text length])
    {
        [RCTool showAlert:@"提示" message:@"请输入电话号码。"];
        return;
    }
    
    if(0 == [self.identity.text length])
    {
        [RCTool showAlert:@"提示" message:@"请输入业务办理时的身份证号码。"];
        return;
    }
    
    NSString* message = [NSString stringWithFormat:@"是否确认需要对“%@”重置密码？",self.phoneNumber.text];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:nil otherButtonTitles:@"确认",@"取消",nil];
    alertView.tag = RESET_ALERT_TAG;
    [alertView show];
    
}

- (void)requestToReset
{
    NSString* urlString = [NSString stringWithFormat:@"%@?m=%@&c=%@&a=%@&t=%f&mobile=%@&cardnumber=%@",BASE_URL,@"api",@"user",@"resetpwd",[NSDate date].timeIntervalSince1970,self.phoneNumber.text,self.identity.text];
    
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedPostRequest:) token:nil];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedPostRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSNumber* code = [result objectForKey:@"code"];
        if(code.intValue == 200)
        {
            NSString* message = [NSString stringWithFormat:@"新密码已经发送至手机号“%@”上，请使用新密码重新登录。",self.phoneNumber.text];
            [RCTool showAlert:@"提示" message:message];
            
            [RCTool removeUserInfo];
            [self.navigationController popViewControllerAnimated:NO];
            
            return;
        }
        else
        {
            NSString* msg = [result objectForKey:@"msg"];
            if([msg length])
            {
                [RCTool showAlert:@"提示" message:msg];
                
                return;
            }
        }
        
    }
    
    [RCTool showAlert:@"提示" message:@"重置密码失败，请检查网络，稍后尝试！"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


@end
