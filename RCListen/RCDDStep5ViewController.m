//
//  RCDDStep5ViewController.m
//  RCFang
//
//  Created by xuzepei on 9/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDStep5ViewController.h"
#import "RCHttpRequest.h"
#import "RCDDStep6ViewController.h"

#define YHM_TAG 211

@interface RCDDStep5ViewController ()

@end

@implementation RCDDStep5ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"订单生成";
        
        self.selected_index0 = -1;
        
        UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBackButton:)];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
    return self;
}

- (void)clickedBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initPickerView];
    
    self.scrollView.contentSize = CGSizeMake([RCTool getScreenSize].width, 700);
    
    [self updateContent:self.item];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/coupon_convert.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"username=%@&type=remover",[self.item objectForKey:@"username"]];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedYHMRequest:) token:token];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedYHMRequest:(NSString*)jsonString
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
            self.yhmList = [result objectForKey:@"coupon_list"];
            
            if([self.yhmList count])
            {
                NSMutableArray* array = [[NSMutableArray alloc] init];
                for(NSDictionary* item in self.yhmList)
                {
                    [array addObject:[item objectForKey:@"text"]];
                }
                
                if([array count])
                    [array addObject:@"不使用优惠卷"];

                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"请选择优惠卷" forKey:@"name"];
                [dict setObject:array forKey:@"values"];
                [dict setObject:[NSNumber numberWithInt:YHM_TAG] forKey:@"tag"];
                self.selection0 = dict;
            }
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    NSString* username = [self.item objectForKey:@"username"];
    self.label0.text = [NSString stringWithFormat:@"用户: %@",username];
    
    NSString* begin_info = [self.item objectForKey:@"begin_info"];
    self.label1.text = [NSString stringWithFormat:@"%@",begin_info];
    
    NSString* end_info = [self.item objectForKey:@"end_info"];
    self.label2.text = [NSString stringWithFormat:@"%@",end_info];
    
    NSArray* price_info_list = [self.item objectForKey:@"price_info_list"];
    CGFloat offset_y = 130.0f;
    for(NSDictionary* item in price_info_list)
    {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, offset_y, 300, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        
        NSString* title = [item objectForKey:@"title"];
        NSString* price_info = [item objectForKey:@"price_info"];
        NSString* temp = [NSString stringWithFormat:@"%@ %@",title,price_info];
        
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:temp];
        NSMutableAttributedString* text =
        [[NSMutableAttributedString alloc]
         initWithAttributedString:attributedString];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor grayColor]
                     range:NSMakeRange(0, [title length] + 1)];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor orangeColor]
                     range:NSMakeRange([title length] + 1, [price_info length])];
        [label setAttributedText:text];
        
        [self.scrollView addSubview:label];
        
        offset_y += 24.0;
    }
    
    offset_y += 10.0;
    CGRect rect = self.label3.frame;
    rect.origin.y = offset_y;
    self.label3.frame = rect;
    NSString* total_price_info = [self.item objectForKey:@"total_price_info"];
    self.label3.text = total_price_info;
    offset_y += 24.0;
    
    rect = self.label4.frame;
    rect.origin.y = offset_y;
    self.label4.frame = rect;
    NSString* remover_activity_info = [self.item objectForKey:@"remover_activity_info"];
    self.label4.text = remover_activity_info;
    offset_y += 40.0;
    
    rect = self.label5.frame;
    rect.origin.y = offset_y + 3;
    self.label5.frame = rect;
    
    rect = self.tf0.frame;
    rect.origin.y = offset_y;
    self.tf0.frame = rect;
    
    offset_y += 40.0;
    
    rect = self.label6.frame;
    rect.origin.y = offset_y + 3;
    self.label6.frame = rect;
    
    rect = self.tf1.frame;
    rect.origin.y = offset_y;
    self.tf1.frame = rect;
    NSString* total_price = [self.item objectForKey:@"final_price"];
    self.tf1.textColor = [UIColor orangeColor];
    self.tf1.text = total_price;
    offset_y += 60.0;
    
    rect = self.nextButton.frame;
    rect.origin.y = offset_y;
    self.nextButton.frame = rect;
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == YHM_TAG)
    {
        [_pickerView updateContent:self.selection0];
        [_pickerView show];
    }
    
    
    return NO;
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
    if(YHM_TAG == tag)
    {
        self.selected_index0 = index;
        NSArray* array = [self.selection0 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [array objectAtIndex:index];
        
        
        if(self.selected_index0 >=0 && self.selected_index0 < [self.yhmList count])
        {
            NSDictionary* item = [self.yhmList objectAtIndex:self.selected_index0];
            CGFloat price = [[item objectForKey:@"price"] floatValue];
            CGFloat final_price = [[self.item objectForKey:@"final_price"] floatValue];
            self.tf1.text = [NSString stringWithFormat:@"%.2f",MAX(final_price - price,0.0f)];
        }
        else
        {
            CGFloat final_price = [[self.item objectForKey:@"final_price"] floatValue];
            self.tf1.text = [NSString stringWithFormat:@"%.2f",MAX(final_price,0.0f)];
        }
    }
}

- (IBAction)clickedNextButton:(id)sender
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
    
    NSString* final_price = [self.item objectForKey:@"final_price"];
    
    NSString* coupon_code = @"";
    if(self.selected_index0 >=0 && self.selected_index0 < [self.yhmList count])
    {
        NSDictionary* item = [self.yhmList objectAtIndex:self.selected_index0];
        coupon_code = [item objectForKey:@"num"];
    }
    
    
    NSString* urlString = [NSString stringWithFormat:@"%@/order_charge.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"type=remover&step=6&username=%@&password=%@&order_num=%@&final_price=%@&coupon_code=%@",username,password,order_num,final_price,coupon_code];
    
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
            RCDDStep6ViewController* temp = [[RCDDStep6ViewController alloc] initWithNibName:nil bundle:nil];
//            NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
//            [item addEntriesFromDictionary:self.item];
//            [item addEntriesFromDictionary:result];
            [temp updateContent:result];
            [self.navigationController pushViewController:temp animated:YES];
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

@end
