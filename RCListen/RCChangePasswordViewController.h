//
//  RCChangePasswordViewController.h
//  RCFang
//
//  Created by xuzepei on 17/5/5.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCChangePasswordViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *anotherPassword;


- (IBAction)clickedChangeButton:(id)sender;

@end
