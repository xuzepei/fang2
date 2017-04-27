//
//  RCSHViewController.m
//  RCFang
//
//  Created by xuzepei on 8/18/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCSHViewController.h"
#import "RCHttpRequest.h"

#define AD_FRAME_HEIGHT 140.0

@interface RCSHViewController ()

@end

@implementation RCSHViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initAdScrollView];
    
    if(self.detailView)
    {
        [self.detailView updateContent:self.result];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item
{
    if(nil == item)
        return;
    
    self.item = item;
    
    self.title = @"商户简介";
    
    NSString* num = [self.item objectForKey:@"num"];
    if(0 == [num length])
        return;
    
    NSString* params = [NSString stringWithFormat:@"num=%@",num];
    NSString* urlString = [NSString stringWithFormat:@"%@/mover_more.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedContentRequest:) token:params];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedContentRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        self.result = result;
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            NSArray* imageArray = [self.result objectForKey:@"imglist"];
            if(imageArray && [imageArray isKindOfClass:[NSArray class]])
            {
                if(_adScrollView)
                   [_adScrollView updateContent:imageArray];
            }
        }
        else
        {
            [RCTool showAlert:@"提示" message:error];
            return;
        }
    }
    
    if(self.detailView)
    {
        //self.detailView.frame = CGRectMake(0, AD_FRAME_HEIGHT, [RCTool getScreenSize].width, [RCTool getScreenSize].height - (NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT + AD_FRAME_HEIGHT));
        [self.detailView updateContent:self.result];
    }
}



#pragma mark - AdScrollView

- (void)initAdScrollView
{
    if(nil == _adScrollView)
    {
        _adScrollView = [[RCAdScrollView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, AD_FRAME_HEIGHT)];
    }

    [self.view addSubview: _adScrollView];
}

#pragma mark - Order

- (IBAction)clickedOrderButton:(id)sender
{
    NSLog(@"clickedOrderButton");
}

@end
