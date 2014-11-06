//
//  RCStartBJViewController.m
//  RCFang
//
//  Created by xuzepei on 10/13/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCStartBJViewController.h"
#import "RCCreateDDViewController.h"
#import "RCHttpRequest.h"
#import "WRTipView.h"
#import "RCGuiHuaViewController.h"
#import "RCLoginViewController.h"

@interface RCStartBJViewController ()

@end

@implementation RCStartBJViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"我要搬家";
        
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
    
    self.scrollView.contentSize = CGSizeMake([RCTool getScreenSize].width, 700);
    
    [self updateContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedButton:(id)sender
{
    NSString* username = [RCTool getUsername];
    if(0 == [username length])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请先登录大管家。"
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        alert.tag = 111;
        [alert show];
        return ;
    }
    
    BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:@"no_show_tips"];
    if(NO == b)
    {
        WRTipView* tipView = [[WRTipView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, [RCTool getScreenSize].height)];
        tipView.backgroundColor = [UIColor clearColor];
        [tipView initScrollView:@[@"tip1",@"tip2",@"tip3",@"tip4"]];
        [[RCTool frontWindow] addSubview:tipView];
        
        return;
    }
    
    RCGuiHuaViewController* temp = [[RCGuiHuaViewController alloc] initWithNibName:nil bundle:nil];
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:NO];
}

- (void)updateContent
{
    if(nil == self.item)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/mover_now.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
        
        RCHttpRequest* temp = [[RCHttpRequest alloc] init];
        BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedPostRequest:) token:nil];
        if(b)
        {
            //[RCTool showIndicator:@"请稍候..."];
        }
    }
    else
    {
        NSString* tempStr = [NSString stringWithFormat:@"%@%@%@",[self.item objectForKey:@"count_text1"],[self.item objectForKey:@"count"],[self.item objectForKey:@"count_text2"]];
        
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:tempStr];
        NSMutableAttributedString* text =
        [[NSMutableAttributedString alloc]
         initWithAttributedString:attributedString];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor orangeColor]
                     range:NSMakeRange([[self.item objectForKey:@"count_text1"] length], [[self.item objectForKey:@"count"] length])];
        [self.myLabel setAttributedText:text];
        
        NSArray* list = [self.item objectForKey:@"list"];
        NSMutableString* temp = [[NSMutableString alloc] init];
        for(NSDictionary* dict in list)
        {
            NSString* text = [dict objectForKey:@"text"];
            if([text length])
            {
                [temp appendFormat:@"%@\n",text];
            }
        }
        
        self.textView.text = temp;
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
            self.item = result;
            
            [self updateContent];
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(111 == alertView.tag)
    {
        if(0 == buttonIndex)
        {
            NSLog(@"clickedLoginButton");
            
            RCLoginViewController* temp = [[RCLoginViewController alloc] initWithNibName:nil bundle:nil];
            temp.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:temp
                                                 animated:YES];
        }
    }
}

@end
