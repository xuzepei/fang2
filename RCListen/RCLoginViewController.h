//
//  RCLoginViewController.h
//  RCFang
//
//  Created by xuzepei on 3/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"

@interface RCLoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,OHAttributedLabelDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *FormImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet OHAttributedLabel *forgotPwd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageTopContraint;

- (IBAction)clickedLoginButton:(id)sender;

@end
