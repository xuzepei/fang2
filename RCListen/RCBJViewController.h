//
//  RCBJViewController.h
//  RCFang
//
//  Created by xuzepei on 6/6/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCBJViewController : UIViewController

@property(nonatomic,weak)IBOutlet UIButton* button0;
@property(nonatomic,weak)IBOutlet UIButton* button1;
@property(nonatomic,weak)IBOutlet UIButton* button2;


- (IBAction)clickedButton0:(id)sender;
- (IBAction)clickedButton1:(id)sender;
- (IBAction)clickedButton2:(id)sender;

@end
