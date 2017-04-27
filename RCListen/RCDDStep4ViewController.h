//
//  RCDDStep4ViewController.h
//  RCFang
//
//  Created by xuzepei on 9/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPickerView.h"
#import "RCDatePickerView.h"

@interface RCDDStep4ViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic,weak)IBOutlet UITextField* tf0;
@property(nonatomic,weak)IBOutlet UITextField* tf1;
@property(nonatomic,weak)IBOutlet UITextField* tf2;
@property(nonatomic,weak)IBOutlet UITextField* tf3;
@property(nonatomic,weak)IBOutlet UITextField* tf4;
@property(nonatomic,weak)IBOutlet UITextField* tf5;
@property(nonatomic,strong)RCPickerView* pickerView;
@property(nonatomic,strong)NSDictionary* selection0;
@property(nonatomic,assign)int selected_index0;
@property(nonatomic,strong)RCDatePickerView* datePickerView;


- (void)updateContent:(NSDictionary*)item;
- (IBAction)clickedNextButton:(id)sender;

@end
