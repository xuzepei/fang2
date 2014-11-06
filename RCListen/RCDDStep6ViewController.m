//
//  RCDDStep6ViewController.m
//  RCFang
//
//  Created by xuzepei on 10/26/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDStep6ViewController.h"
#import "RCWebViewController.h"

@interface RCDDStep6ViewController ()

@end

@implementation RCDDStep6ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"订单支付";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self updateContent:self.item];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    self.tf0.text = [self.item objectForKey:@"order_num"];
    self.tf1.text = [RCTool getUsername];
    self.tf2.text = [self.item objectForKey:@"order_price"];
}

- (IBAction)clickedNextButton:(id)sender
{
    NSString* urlString = [NSString stringWithFormat:@"%@/alipay/alipayapi.php?apiid=%@&apikey=%@&order_num=%@&username=%@&order_price=%@",BASE_URL,APIID,PWD,[self.item objectForKey:@"order_num"],[RCTool getUsername],[self.item objectForKey:@"order_price"]];
    
    RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
    temp.hidesBottomBarWhenPushed = YES;
    [temp updateContent:urlString title:nil];
    [self.navigationController pushViewController:temp animated:YES];
}

@end
