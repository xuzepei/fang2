//
//  RCDDDetailViewController.m
//  RCFang
//
//  Created by xuzepei on 10/29/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDDetailViewController.h"
#import "RCHttpRequest.h"

@interface RCDDDetailViewController ()

@end

@implementation RCDDDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"订单详细";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView.contentSize = CGSizeMake([RCTool getScreenSize].width, 800);
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
    NSString* order_num = [self.item objectForKey:@"order_num"];

    NSString* urlString = [NSString stringWithFormat:@"%@/user_order.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    NSString* type = @"more";

    NSString* token = [NSString stringWithFormat:@"username=%@&password=%@&type=%@&order_num=%@",username,password,type,order_num];

    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedRequest0:) token:token];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedRequest0:(NSString*)jsonString
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
            if(self.detailView)
            {
                NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
                [item addEntriesFromDictionary:self.item];
                [item addEntriesFromDictionary:result];
                [self.detailView updateContent:item];
            }
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}


@end
