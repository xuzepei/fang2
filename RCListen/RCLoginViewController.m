//
//  RCLoginViewController.m
//  RCFang
//
//  Created by xuzepei on 3/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCLoginViewController.h"
#import "RCTool.h"
#import "RCSignupViewController.h"
#import "RCHttpRequest.h"
//#import "iToast.h"
#import "RCResetViewController.h"

#define ACCOUNT_TF_TAG 100
#define PASSWORD_TF_TAG 101
#define ATTRIBUTED_LABEL_TAG 102

@interface RCLoginViewController ()

@end

@implementation RCLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
		self.title = @"登录";
        
//        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(clickedRightBarButtonItem:)];
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
     self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = NAVIGATION_BAR_COLOR;
    
    if([RCTool getScreenSize].height <= 568)
        self.logoImageTopContraint.constant = 40.0;
    
    [self initTextFields];
    
    [self initAttributedLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)clickedRightBarButtonItem:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
//    RCSignupViewController* temp = [[RCSignupViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:temp animated:YES];

}

- (IBAction)clickedLoginButton:(id)sender
{
    NSLog(@"clickedLoginButton");
    
    if(0 == [self.phoneNumber.text length])
    {
        [RCTool showAlert:@"提示" message:@"请输入手机号！"];
        return;
    }
    
    if(0 == [self.password.text length])
    {
        [RCTool showAlert:@"提示" message:@"请输入密码！"];
        return;
    }
    
    
    NSString* urlString = [NSString stringWithFormat:@"%@?m=%@&c=%@&a=%@&t=%f&mobile=%@&password=%@&token=%@",BASE_URL,@"api",@"user",@"login",[NSDate date].timeIntervalSince1970,self.phoneNumber.text,self.password.text,[RCTool getDeviceToken]];
    
    
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
            NSDictionary* data= [result objectForKey:@"data"];
            if(data && [data isKindOfClass:[NSDictionary class]])
            {
                [RCTool saveUserInfo:data];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
                return;
                
//                NSString* msg = [result objectForKey:@"msg"];
//                if([msg length])
//                {
//                    [RCTool showAlert:@"提示" message:msg];
//                    
//                    return;
//                }
            }
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
    
    [RCTool showAlert:@"提示" message:@"登录失败，请检查网络，稍后尝试！"];
}

#pragma mark - TextField

- (void)initTextFields
{
    UIColor *color = [UIColor whiteColor];
    self.phoneNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.phoneNumber.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.password.placeholder attributes:@{NSForegroundColorAttributeName: color}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

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
    if(self.forgotPwd)
    {
        [self.forgotPwd setLinkUnderlineStyle:kCTUnderlineStyleSingle];
        self.forgotPwd.tag = ATTRIBUTED_LABEL_TAG;

        self.forgotPwd.underlineLinks = YES;
        self.forgotPwd.lineBreakMode =
        UILineBreakModeWordWrap;
        self.forgotPwd.backgroundColor = [UIColor clearColor];
        self.forgotPwd.delegate = self;
        NSString* text = @"忘记密码？";
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:text];
        self.forgotPwd.attributedText = attrStr;
        [self.forgotPwd addCustomLink:[NSURL URLWithString:text] inRange:NSMakeRange(0, [text length])];
        
//        CGSize expectedLabelSize = [text sizeWithFont:_attributedLabel.font
//                                          constrainedToSize:CGSizeMake(300,20)
//                                              lineBreakMode:_attributedLabel.lineBreakMode];
//        CGFloat stringWidth = expectedLabelSize.width - 3;
//        _attributedLabel.frame = CGRectMake(([RCTool getScreenSize].width - stringWidth)/2.0, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - 260, stringWidth, 20);
    }
    
}

-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
    NSLog(@"shouldFollowLink");
    if(ATTRIBUTED_LABEL_TAG == attributedLabel.tag)
    {
        //self.navigationController.navigationBar.translucent = NO;
        RCResetViewController* temp = [[RCResetViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:temp animated:YES];
    }
    
    return YES;
}

-(UIColor*)attributedLabel:(OHAttributedLabel*)attributedLabel colorForLink:(NSTextCheckingResult*)linkInfo underlineStyle:(int32_t*)underlineStyle
{
    return [UIColor whiteColor];
}

@end
