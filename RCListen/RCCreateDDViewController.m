//
//  RCCreateDDViewController.m
//  RCFang
//
//  Created by xuzepei on 9/10/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCCreateDDViewController.h"
#import "RCGuiHuaViewController.h"
#import "RCDDStep2ViewController.h"
#import "RCHttpRequest.h"

@interface RCCreateDDViewController ()

@end

@implementation RCCreateDDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"订单生成";
        
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
    
    
    //[self performSelector:@selector(goTo) withObject:nil afterDelay:0.3];
    
    RCGuiHuaViewController* temp = [[RCGuiHuaViewController alloc] initWithNibName:nil bundle:nil];
    temp.delegate = self;
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.routePlan)
    {
        self.setp0View.tf0.text = self.qdInfo.name;
        self.setp0View.tf1.text = self.zdInfo.name;
        self.setp0View.tf2.text = [NSString stringWithFormat:@"约%.1f公里",self.routePlan.distance/1000.0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedTextField
{
    RCGuiHuaViewController* temp = [[RCGuiHuaViewController alloc] initWithNibName:nil bundle:nil];
    temp.delegate = self;
    [self.navigationController pushViewController:temp animated:YES];
}

- (IBAction)clickedNextButton:(id)sender
{
    NSString* username = [RCTool getUsername];
    if(0 == [username length])
    {
        [RCTool showAlert:@"提示" message:@"请先登录！"];
        return ;
    }
    
    NSString* begin_address = self.setp0View.tf0.text;
    if(0 == [begin_address length])
    {
        [RCTool showAlert:@"提示" message:@"请输入起点位置!"];
        return ;
    }
    
    NSString* end_address = self.setp0View.tf1.text;
    if(0 == [end_address length])
    {
        [RCTool showAlert:@"提示" message:@"请输入终点点位置!"];
        return ;
    }
    
    NSString* mileage = self.setp0View.tf2.text;
    if(0 == [mileage length])
    {
        [RCTool showAlert:@"提示" message:@"里程计算失败，请稍后尝试!"];
        return ;
    }
    else
    {
        mileage = [NSString stringWithFormat:@"%.2f",self.routePlan.distance/1000.0];
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/order_remover.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"type=remover&step=2&username=%@&begin_address=%@&end_address=%@&mileage=%@",username,begin_address,end_address,mileage];
    
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
            RCDDStep2ViewController* temp = [[RCDDStep2ViewController alloc] initWithNibName:nil bundle:nil];
            [temp updateContent:result];
            [self.navigationController pushViewController:temp animated:YES];
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

@end
