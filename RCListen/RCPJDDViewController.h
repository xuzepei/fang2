//
//  RCPJDDViewController.h
//  RCFang
//
//  Created by xuzepei on 10/26/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPickerView.h"
#import "RCPlaceHolderTextView.h"

@interface RCPJDDViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,weak)IBOutlet RCPlaceHolderTextView* tv;
@property(nonatomic,weak)IBOutlet UITextField* tf;
@property(nonatomic,weak)IBOutlet UIButton* button;
@property(nonatomic,strong)RCPickerView* pickerView;
@property(nonatomic,strong)NSDictionary* selection0;
@property(nonatomic,assign)int selected_index0;
@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,strong)NSArray* pfList;


- (IBAction)clickedButton:(id)sender;
- (void)updateContent:(NSDictionary*)item;

@end
