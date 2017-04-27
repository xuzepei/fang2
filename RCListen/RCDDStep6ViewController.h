//
//  RCDDStep6ViewController.h
//  RCFang
//
//  Created by xuzepei on 10/26/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlixLibService.h"

@interface RCDDStep6ViewController : UIViewController

@property(nonatomic,weak)IBOutlet UITextField* tf0;
@property(nonatomic,weak)IBOutlet UITextField* tf1;
@property(nonatomic,weak)IBOutlet UITextField* tf2;
@property(nonatomic,weak)IBOutlet UIButton* button;
@property(nonatomic,strong)NSDictionary* item;

- (void)updateContent:(NSDictionary*)item;
- (IBAction)clickedNextButton:(id)sender;

@end
