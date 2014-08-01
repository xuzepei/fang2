//
//  RCBJViewController.m
//  RCFang
//
//  Created by xuzepei on 6/6/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCBJViewController.h"
#import "RCFJViewController.h"
#import "RCDDViewController.h"

@interface RCBJViewController ()

@end

@implementation RCBJViewController

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
    
//    //NavBar background color:
//    self.navigationController.navigationBar.barTintColor=[UIColor redColor];
    //NavBar tint color for elements:
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.title = @"我要搬家";
    
    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)clickedBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedButton0:(id)sender
{
    RCFJViewController* temp = [[RCFJViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:temp animated:YES];
}

- (IBAction)clickedButton1:(id)sender
{
    RCDDViewController* temp = [[RCDDViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:temp animated:YES];
}

- (IBAction)clickedButton2:(id)sender
{
}

@end
