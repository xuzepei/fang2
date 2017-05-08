//
//  RCSignUpView.m
//  RCFang
//
//  Created by xuzepei on 7/30/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCSignUpView.h"
#import "RCSignupViewController.h"
#import "RCHttpRequest.h"

#define HIGHTLIGHT_COLOR [RCTool colorWithHexString:@"#01a4f1"]
#define COMMON_COLOR [RCTool colorWithHexString:@"#7a828d"]

#define PHONE_TAG 111
#define YANZHENG_TAG 112
#define PASS_TAG 113
#define REPASS_TAG 114

@implementation RCSignUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _type = 3;
    
    self.backgroundColor = [RCTool colorWithHexString:@"#f0f0f0"];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat offset_y = 100 - 64.0f;
    
    UIImage* image = [UIImage imageNamed:@"1"];
    if(image)
        [image drawInRect:CGRectMake(36, offset_y, 24, 24)];
    
    image = [UIImage imageNamed:@"2"];
    if(image)
        [image drawInRect:CGRectMake(self.bounds.size.width/2.0 - 12, offset_y, 24, 24)];
    
    image = [UIImage imageNamed:@"3"];
    if(image)
        [image drawInRect:CGRectMake(self.bounds.size.width - 36.0f - 24.0f, offset_y, 24, 24)];
    
    
    if(1 == _type)
    {
        UIImage* image = [UIImage imageNamed:@"1_on"];
        if(image)
            [image drawInRect:CGRectMake(36, offset_y, 24, 24)];
    }
    else if(2 == _type)
    {
        UIImage* image = [UIImage imageNamed:@"2_on"];
        if(image)
            [image drawInRect:CGRectMake(self.bounds.size.width/2.0 - 12, offset_y, 24, 24)];
    }
    else if(3 == _type)
    {
        UIImage* image = [UIImage imageNamed:@"3_on"];
        if(image)
            [image drawInRect:CGRectMake(self.bounds.size.width - 36.0f - 24.0f, offset_y, 24, 24)];
    }
    
    
    //draw line
    if(1 == _type)
        [HIGHTLIGHT_COLOR set];
    else
        [COMMON_COLOR set];
    
    CGRect lineOne = CGRectMake(66, offset_y + 11, 76, 1);
    UIRectFill(lineOne);
    
    NSString* text = @"输入手机号";
    [text drawInRect:CGRectMake(-10, offset_y + 32, 120, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    if(2 == _type || 3 == _type)
        [HIGHTLIGHT_COLOR set];
    else
        [COMMON_COLOR set];
    
    CGRect lineTwo = CGRectMake(178, offset_y + 11, 76, 1);
    UIRectFill(lineTwo);
    
    
    if(2 == _type)
        [HIGHTLIGHT_COLOR set];
    else
        [COMMON_COLOR set];
    text = @"输入验证码";
    [text drawInRect:CGRectMake(100, offset_y + 32, 120, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    if(3 == _type)
        [HIGHTLIGHT_COLOR set];
    else
        [COMMON_COLOR set];
    text = @"设置密码";
    [text drawInRect:CGRectMake(212, offset_y + 32, 120, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    if(3 == _type)
    {
        [COMMON_COLOR set];
        text = @"我已阅读并同意";
        [text drawInRect:CGRectMake(44, 275 - 64, 120, 20) withFont:[UIFont systemFontOfSize:15] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    }
    
}

- (void)updateContent:(int)type token:(NSDictionary*)token
{
    self.type = type;
    
    if(nil == _button)
    {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0, 226, 35);
        self.button.center = CGPointMake([RCTool getScreenSize].width/2.0, 260 - 32);
        [self.button setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [self.button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(clickedNextButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self addSubview:self.button];
    
    if(1 == _type)
    {
        if(nil == _phoneTF)
        {
            _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(16, 170 - 64, [RCTool getScreenSize].width - 32, 40)];
            _phoneTF.tag = PHONE_TAG;
            _phoneTF.borderStyle = UITextBorderStyleLine;
            _phoneTF.layer.borderColor = [RCTool colorWithHexString:@"#dadada"].CGColor;
            _phoneTF.layer.borderWidth = 1;
            _phoneTF.backgroundColor = [UIColor whiteColor];
            _phoneTF.placeholder = @" 输入手机号码";
            _phoneTF.delegate = self;
            _phoneTF.returnKeyType = UIReturnKeyDone;
        }
        
        [self addSubview:_phoneTF];
    }
    else if(2 == _type)
    {
        self.step1Token = token;
        [_phoneTF removeFromSuperview];
        [self.button setTitle:@"下一步" forState:UIControlStateNormal];
        self.button.center = CGPointMake([RCTool getScreenSize].width/2.0, 300 - 32);
        
        if(nil == _yanzhengmaTF)
        {
            _yanzhengmaTF = [[UITextField alloc] initWithFrame:CGRectMake(16, 170 - 64, [RCTool getScreenSize].width - 32, 40)];
            _yanzhengmaTF.tag = YANZHENG_TAG;
            _yanzhengmaTF.borderStyle = UITextBorderStyleLine;
            _yanzhengmaTF.layer.borderColor = [RCTool colorWithHexString:@"#dadada"].CGColor;
            _yanzhengmaTF.layer.borderWidth = 1;
            _yanzhengmaTF.backgroundColor = [UIColor whiteColor];
            _yanzhengmaTF.placeholder = @" 输入短信验证码";
            _yanzhengmaTF.delegate = self;
            _yanzhengmaTF.returnKeyType = UIReturnKeyDone;
        }
        
        [self addSubview:_yanzhengmaTF];
        
        if(nil == _resendButton)
        {
            self.resendButton = [UIButton buttonWithType:UIButtonTypeSystem];
            self.resendButton.frame = CGRectMake(190, 226 - 64,120, 30);
            //[self.resendButton setTitleColor:HIGHTLIGHT_COLOR forState:UIControlStateNormal];
            [self.resendButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
            [self.resendButton addTarget:self action:@selector(clickedResendButton:) forControlEvents:UIControlEventTouchUpInside];
            
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"重新获取验证码"];
            
            [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [title length])];
            
            [self.resendButton setAttributedTitle: title forState:UIControlStateNormal];
        }
        
        [self addSubview:self.resendButton];
    }
    else if(3 == _type)
    {
        self.step2Token = token;
        [_yanzhengmaTF removeFromSuperview];
        [_resendButton removeFromSuperview];
        
        self.button.center = CGPointMake([RCTool getScreenSize].width/2.0, 340 - 32);
        
        if(nil == _mima0TF)
        {
            _mima0TF = [[UITextField alloc] initWithFrame:CGRectMake(16, 170 - 64, [RCTool getScreenSize].width - 32, 40)];
            _mima0TF.tag = PASS_TAG;
            _mima0TF.borderStyle = UITextBorderStyleLine;
            _mima0TF.layer.borderColor = [RCTool colorWithHexString:@"#dadada"].CGColor;
            _mima0TF.layer.borderWidth = 1;
            _mima0TF.backgroundColor = [UIColor whiteColor];
            _mima0TF.placeholder = @" 输入密码";
            _mima0TF.delegate = self;
            _mima0TF.secureTextEntry = YES;
            _mima0TF.returnKeyType = UIReturnKeyDone;
        }
        
        [self addSubview:_mima0TF];
        
        if(nil == _mima1TF)
        {
            _mima1TF = [[UITextField alloc] initWithFrame:CGRectMake(16, 220 - 64, [RCTool getScreenSize].width - 32, 40)];
            _mima1TF.tag = REPASS_TAG;
            _mima1TF.borderStyle = UITextBorderStyleLine;
            _mima1TF.layer.borderColor = [RCTool colorWithHexString:@"#dadada"].CGColor;
            _mima1TF.layer.borderWidth = 1;
            _mima1TF.backgroundColor = [UIColor whiteColor];
            _mima1TF.placeholder = @" 确认密码";
            _mima1TF.delegate = self;
            _mima1TF.secureTextEntry = YES;
            _mima1TF.returnKeyType = UIReturnKeyDone;
        }
        
        [self addSubview:_mima1TF];
        
        if(nil == _checkButton)
        {
//            _checkButton = [RCCheckButton buttonWithType:UIButtonTypeCustom];
//            _checkButton.frame = CGRectMake(16, 270 - 64, 30, 30);
//            _checkButton.normalImageName = @"wugou";
//            _checkButton.selectedImageName = @"yougou";
//            [_checkButton setChecked:NO];
//            [_checkButton addTarget:self action:@selector(clickedCheckButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview:_checkButton];
        
        UIButton* treatyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        treatyButton.frame = CGRectMake(140, 269 - 64,100, 30);
        [treatyButton setTitle:@"《用户协议》" forState:UIControlStateNormal];
        [treatyButton setTitleColor:HIGHTLIGHT_COLOR forState:UIControlStateNormal];
        [treatyButton addTarget:self action:@selector(clickedTreatyButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:treatyButton];
    }
    
    
    [self setNeedsDisplay];
}

- (IBAction)clickedNextButton:(id)sender
{
    NSLog(@"clickedNextButton");
    
    if(1 == _type)
    {
        [_phoneTF resignFirstResponder];
        NSString* text = _phoneTF.text;
        if(0 == [text length])
        {
            [RCTool showAlert:@"提示" message:@"请输入手机号"];
            return;
        }
        else
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(clickedNextButton:token:)])
            {
                NSDictionary* token = @{@"phone":text};
                [self.delegate clickedNextButton:_type token:token];
            }
        }
    }
    else if(2 == _type)
    {
        [_yanzhengmaTF resignFirstResponder];
        NSString* text = _yanzhengmaTF.text;
        if(0 == [text length])
        {
            [RCTool showAlert:@"提示" message:@"输入短信验证码"];
            return;
        }
        else
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(clickedNextButton:token:)])
            {
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict addEntriesFromDictionary:self.step1Token];
                [dict setObject:text forKey:@"verify_code"];
                
                [self.delegate clickedNextButton:_type token:dict];
            }
        }
    }
    else if(3 == _type)
    {
        if(0 == [_mima0TF.text length])
        {
            [RCTool showAlert:@"提示" message:@"请输入密码"];
            return;
        }
        
        if(0 == [_mima1TF.text length])
        {
            [RCTool showAlert:@"提示" message:@"请确认密码"];
            return;
        }
        
        if(NO == [_mima0TF.text isEqualToString: _mima1TF.text])
        {
            [RCTool showAlert:@"提示" message:@"两次密码输入不一致"];
            return;
        }
        
//        if(NO == [_checkButton isChecked])
//        {
//            [RCTool showAlert:@"提示" message:@"请阅读并同意用户协议"];
//            return;
//        }
        
 
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedNextButton:token:)])
        {
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict addEntriesFromDictionary:self.step2Token];
            [dict setObject:_mima0TF.text forKey:@"pass"];
            [dict setObject:_mima1TF.text forKey:@"repass"];
            
            [self.delegate clickedNextButton:_type token:dict];
        }

    }
}

- (void)clickedCheckButton:(id)sender
{
//    BOOL b = [_checkButton isChecked]?NO:YES;
//    [_checkButton setChecked:b];
}

- (void)clickedTreatyButton:(id)sender
{
    NSString* urlString = [NSString stringWithFormat:@"%@/treaty.php?apiid=%@&apikey=%@&type=register",BASE_URL,APIID,PWD];
    RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
    temp.hidesBottomBarWhenPushed = YES;
    [temp updateContent:urlString title:@"用户协议"];
    
    RCSignupViewController* controller = (RCSignupViewController*)self.delegate;
    [controller.navigationController pushViewController:temp animated:YES];
}

- (void)clickedResendButton:(id)sender
{
    NSLog(@"clickedResendButton");
    
    NSString* username = [self.step1Token objectForKey:@"username"];
    if(0 == [username length])
        return;
    
    NSString* verify_list = [self.step1Token objectForKey:@"verify_list"];
    if(0 == [verify_list length])
        return;
    
    NSString* params = [NSString stringWithFormat:@"type=user_register&username=%@&verify_list=%@",username,verify_list];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/resend_verify_code.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedResendRequest:) token:params];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }

}

- (void)finishedResendRequest:(NSString*)jsonString
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
            self.step1Token = result;
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if(PHONE_TAG == textField.tag)
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

@end
