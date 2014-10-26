//
//  RCTelephoneViewController.m
//  RCFang
//
//  Created by xuzepei on 10/14/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCTelephoneViewController.h"
#import "RCHttpRequest.h"

@interface RCTelephoneViewController ()

@end

@implementation RCTelephoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"电话"
														   image:[UIImage imageNamed:@"pyq"]
															 tag:TT_GROUP];
        
		self.tabBarItem = item;
        
        self.navigationItem.title = @"电话";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.item)
    {
        self.label0.text = [self.item objectForKey:@"phone"];
        self.label1.text = [self.item objectForKey:@"text"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString* urlString = [NSString stringWithFormat:@"%@/service_phone.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];

    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedRequest:) token:nil];
    if(b)
    {
        //[RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            self.item = result;
            
            self.label0.text = [self.item objectForKey:@"phone"];
            self.label1.text = [self.item objectForKey:@"text"];
            
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

- (IBAction)clickedButton:(id)sender
{
    if(nil == self.item)
        return;
    
    NSString* phoneNum = [self.item objectForKey:@"phone"];
    if([phoneNum isKindOfClass:[NSString class]] && [phoneNum length])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
    }
}

@end
