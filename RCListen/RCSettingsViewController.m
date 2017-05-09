//
//  RCSettingsViewController.m
//  RCFang
//
//  Created by xuzepei on 04/05/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import "RCSettingsViewController.h"
#import "RCLoginViewController.h"
#import "RCResetViewController.h"
#import "RCChangePasswordViewController.h"

@interface RCSettingsViewController ()

@end

@implementation RCSettingsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(nil == [RCTool getUserInfo])
        [self goToLoginViewController];
    
    self.phoneNumber.text = [RCTool getPhoneNumber];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeAccount:(id)sender {
    
    [RCTool removeUserInfo];
    [self goToLoginViewController];
}

- (IBAction)clickedResetButton:(id)sender {
    
    RCResetViewController* temp = [[RCResetViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:temp animated:YES];
}

- (IBAction)clickedChangePasswordButton:(id)sender {
    
    RCChangePasswordViewController* temp = [[RCChangePasswordViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:temp animated:YES];
}



- (void)goToLoginViewController
{
    RCLoginViewController* temp = [[RCLoginViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:temp];
    
    [self presentViewController:navController animated:NO completion:^{
        
    }];
}

@end
