//
//  RCDDStep5ViewController.h
//  RCFang
//
//  Created by xuzepei on 9/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPickerView.h"

@interface RCDDStep5ViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic,weak)IBOutlet UILabel* label0;
@property(nonatomic,weak)IBOutlet UILabel* label1;
@property(nonatomic,weak)IBOutlet UILabel* label2;
@property(nonatomic,weak)IBOutlet UILabel* label3;
@property(nonatomic,weak)IBOutlet UILabel* label4;
@property(nonatomic,weak)IBOutlet UILabel* label5;
@property(nonatomic,weak)IBOutlet UILabel* label6;
@property(nonatomic,weak)IBOutlet UILabel* label7;
@property(nonatomic,weak)IBOutlet UILabel* label8;
@property(nonatomic,weak)IBOutlet UILabel* label9;
@property(nonatomic,weak)IBOutlet UILabel* label10;
@property(nonatomic,weak)IBOutlet UITextField* tf0;
@property(nonatomic,weak)IBOutlet UITextField* tf1;
@property(nonatomic,weak)IBOutlet UIButton* nextButton;
@property(nonatomic,strong)RCPickerView* pickerView;
@property(nonatomic,strong)NSDictionary* selection0;
@property(nonatomic,assign)int selected_index0;
@property(nonatomic,strong)NSArray* yhmList;

- (void)updateContent:(NSDictionary*)item;
- (IBAction)clickedNextButton:(id)sender;

@end
