//
//  RCDDStep2ViewController.h
//  RCFang
//
//  Created by xuzepei on 9/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPickerView.h"

@interface RCDDStep2ViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic,weak)IBOutlet UITextField* tf2;
@property(nonatomic,weak)IBOutlet UITextField* tf3;
@property(nonatomic,weak)IBOutlet UITextField* tf7;
@property(nonatomic,weak)IBOutlet UITextField* tf8;
@property(nonatomic,strong)RCPickerView* pickerView;
@property(nonatomic,strong)NSDictionary* selection0;
@property(nonatomic,strong)NSDictionary* selection1;
@property(nonatomic,strong)NSDictionary* selection2;
@property(nonatomic,strong)NSDictionary* selection3;
@property(nonatomic,strong)NSDictionary* selection4;
@property(nonatomic,strong)NSDictionary* selection5;
@property(nonatomic,strong)NSDictionary* selection6;
@property(nonatomic,strong)NSDictionary* selection7;
@property(nonatomic,assign)int selected_index0;
@property(nonatomic,assign)int selected_index1;
@property(nonatomic,assign)int selected_index2;
@property(nonatomic,assign)int selected_index3;
@property(nonatomic,assign)int selected_index4;
@property(nonatomic,assign)int selected_index5;
@property(nonatomic,assign)int selected_index6;
@property(nonatomic,assign)int selected_index7;

- (void)updateContent:(NSDictionary*)item;
- (IBAction)clickedNextButton:(id)sender;

@end
