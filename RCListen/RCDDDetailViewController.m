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
    
    self.scrollView.contentSize = CGSizeMake([RCTool getScreenSize].width, 1000);
    
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

    NSString* urlString = [NSString stringWithFormat:@"%@/user_order.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    
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
                
                CGFloat height = 20.0f;
                height += 80.0f + 16*10 + 18 + 40 + 18 + 40 + 24 + 80;
                NSArray* array = [item objectForKey:@"price_info_list"];
                if([array count])
                    height += 16.0*[array count];
                
                array = [item objectForKey:@"running_list"];
                if([array count])
                    height += 16.0*[array count];
                
                self.scrollView.contentSize = CGSizeMake([RCTool getScreenSize].width, height+100);
                
                [self.detailView updateContent:item];
            }
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}


@end
