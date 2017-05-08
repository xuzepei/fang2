//
//  RCChangePasswordViewController.m
//  RCFang
//
//  Created by xuzepei on 17/5/5.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import "RCChangePasswordViewController.h"
#import "RCHttpRequest.h"

@interface RCChangePasswordViewController ()

@end

@implementation RCChangePasswordViewController

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
    
    self.title = @"修改密码";
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)clickedChangeButton:(id)sender {
    
    if(0 == [self.phoneNumber.text length])
    {
        [RCTool showAlert:@"提示" message:@"请输入电话号码。"];
        return;
    }
    
    if(0 == [self.oldPassword.text length])
    {
        [RCTool showAlert:@"提示" message:@"请输入旧的密码。"];
        return;
    }
    
    if(0 == [self.anotherPassword.text length])
    {
        [RCTool showAlert:@"提示" message:@"请输入新的密码。"];
        return;
    }
    
    [self requestToChange];
}

- (void)requestToChange
{
    NSString* urlString = [NSString stringWithFormat:@"%@?m=%@&c=%@&a=%@&t=%f&mobile=%@&oldpassword=%@&newpassword=%@",BASE_URL,@"api",@"user",@"changepwd",[NSDate date].timeIntervalSince1970,self.phoneNumber.text,self.oldPassword.text,self.anotherPassword.text];
    
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
            NSString* msg = [result objectForKey:@"msg"];
            //NSString* message = [NSString stringWithFormat:@"请使用新密码重新登录。"];
            [RCTool showAlert:@"提示" message:msg];
            
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
    
    [RCTool showAlert:@"提示" message:@"修改密码失败，请检查网络，稍后尝试！"];
}

@end
