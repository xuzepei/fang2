//
//  RCSettingsViewController.h
//  RCFang
//
//  Created by xuzepei on 04/05/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

- (IBAction)changeAccount:(id)sender;
- (IBAction)clickedResetButton:(id)sender;
- (IBAction)clickedChangePasswordButton:(id)sender;


@end
