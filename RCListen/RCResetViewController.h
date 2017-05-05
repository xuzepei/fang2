//
//  RCResetViewController.h
//  RCFang
//
//  Created by xuzepei on 17/5/5.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCResetViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *identity;

- (IBAction)clickedResetButton:(id)sender;

@end
