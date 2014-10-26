//
//  RCDDCell.m
//  RCFang
//
//  Created by xuzepei on 10/22/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDCell.h"

@implementation RCDDCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    self.label0.text = [self.item objectForKey:@"order_num"];
    self.label1.text = [self.item objectForKey:@"order_time"];
    self.label2.text = [self.item objectForKey:@"order_price"];
    self.label3.text = [self.item objectForKey:@"order_type_intro"];
    self.label4.text = [self.item objectForKey:@"order_begin"];
    self.label5.text = [self.item objectForKey:@"order_end"];
    self.label6.text = [self.item objectForKey:@"order_state_intro"];
    
    [self.button1 removeTarget:nil
                        action:NULL
              forControlEvents:UIControlEventAllEvents];
    [self.button2 removeTarget:nil
                        action:NULL
              forControlEvents:UIControlEventAllEvents];
    
    int state = [[self.item objectForKey:@"order_state"] intValue];
    if(0 == state) //未确认
    {
        self.button1.hidden = NO;
        self.button2.hidden = NO;
        
        [self.button1 setTitle:@"确认并支付" forState:UIControlStateNormal];
        [self.button2 setTitle:@"取消订单" forState:UIControlStateNormal];
        
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"button_bg3"] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"button_bg0"] forState:UIControlStateNormal];
        
        [self.button1 addTarget:self action:@selector(clickedButton0:) forControlEvents:UIControlEventTouchUpInside];
        [self.button2 addTarget:self action:@selector(clickedButton1:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(1 == state)//未支付
    {
        self.button1.hidden = NO;
        self.button2.hidden = NO;
        
        [self.button1 setTitle:@"支付" forState:UIControlStateNormal];
        [self.button2 setTitle:@"取消订单" forState:UIControlStateNormal];
        
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"button_bg3"] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"button_bg0"] forState:UIControlStateNormal];
        
        [self.button1 addTarget:self action:@selector(clickedButton2:) forControlEvents:UIControlEventTouchUpInside];
        [self.button2 addTarget:self action:@selector(clickedButton1:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(2 == state)//支付完成
    {
        self.button1.hidden = NO;
        self.button2.hidden = NO;
        
        [self.button1 setTitle:@"跟踪流程" forState:UIControlStateNormal];
        [self.button2 setTitle:@"取消订单" forState:UIControlStateNormal];
        
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"button_bg4"] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"button_bg0"] forState:UIControlStateNormal];
        
        [self.button1 addTarget:self action:@selector(clickedButton3:) forControlEvents:UIControlEventTouchUpInside];
        [self.button2 addTarget:self action:@selector(clickedButton1:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(3 == state)//正在搬家
    {
        self.button1.hidden = NO;
        self.button2.hidden = YES;
        
        [self.button1 setTitle:@"跟踪流程" forState:UIControlStateNormal];
        [self.button2 setTitle:@"取消订单" forState:UIControlStateNormal];
        
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"button_bg4"] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"button_bg0"] forState:UIControlStateNormal];
        
        [self.button1 addTarget:self action:@selector(clickedButton3:) forControlEvents:UIControlEventTouchUpInside];
        [self.button2 addTarget:self action:@selector(clickedButton1:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(4 == state)//搬家完成
    {
        self.button1.hidden = NO;
        self.button2.hidden = NO;
        
        [self.button1 setTitle:@"跟踪流程" forState:UIControlStateNormal];
        [self.button2 setTitle:@"完成订单" forState:UIControlStateNormal];
        
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"button_bg4"] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"button_bg2"] forState:UIControlStateNormal];
        
        [self.button1 addTarget:self action:@selector(clickedButton3:) forControlEvents:UIControlEventTouchUpInside];
        [self.button2 addTarget:self action:@selector(clickedButton4:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(5 == state)//订单结束
    {
        self.button1.hidden = NO;
        self.button2.hidden = NO;
        
        [self.button1 setTitle:@"跟踪流程" forState:UIControlStateNormal];
        [self.button2 setTitle:@"评价" forState:UIControlStateNormal];
        
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"button_bg4"] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"button_bg5"] forState:UIControlStateNormal];
        
        [self.button1 addTarget:self action:@selector(clickedButton3:) forControlEvents:UIControlEventTouchUpInside];
        [self.button2 addTarget:self action:@selector(clickedButton5:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (IBAction)clickedDetailButton:(id)sender
{
}

//确定并支付
- (IBAction)clickedButton0:(id)sender
{
    NSLog(@"clickedButton0");
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedButton:token:)])
    {
        [self.delegate clickedButton:0 token:self.item];
    }
}

//取消订单
- (IBAction)clickedButton1:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定要取消该订单？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.delegate = self;
    [alert show];
}

//支付
- (IBAction)clickedButton2:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedButton:token:)])
    {
        [self.delegate clickedButton:2 token:self.item];
    }
}

//跟踪流程
- (IBAction)clickedButton3:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedButton:token:)])
    {
        [self.delegate clickedButton:3 token:self.item];
    }
}

//完成订单
- (IBAction)clickedButton4:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedButton:token:)])
    {
        [self.delegate clickedButton:4 token:self.item];
    }
}

//评价
- (IBAction)clickedButton5:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedButton:token:)])
    {
        [self.delegate clickedButton:5 token:self.item];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    
    if(1 == buttonIndex)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedButton:token:)])
        {
            NSMutableDictionary* token = [[NSMutableDictionary alloc] init];
            [token addEntriesFromDictionary:self.item];
            [token setObject:[NSString stringWithFormat:@"%d",self.index] forKey:@"index"];
            [self.delegate clickedButton:1 token:token];
        }
    }
}

@end
