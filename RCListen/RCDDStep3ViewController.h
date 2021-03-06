//
//  RCDDStep3ViewController.h
//  RCFang
//
//  Created by xuzepei on 9/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCPickerView.h"
#import "WRCheckButton.h"

@interface RCDDStep3ViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic,weak)IBOutlet UITextView* textView;
@property(nonatomic,weak)IBOutlet UILabel* infoLabel;
@property(nonatomic,weak)IBOutlet UILabel* infoLabel2;
@property(nonatomic,weak)IBOutlet UILabel* infoLabel3;
@property(nonatomic,weak)IBOutlet UIButton* gzwpButton;
@property(nonatomic,weak)IBOutlet UIButton* nextButton;
@property(nonatomic,strong)RCPickerView* pickerView;
@property(nonatomic,strong)NSDictionary* selection0;
@property(nonatomic,strong)NSDictionary* selection1;
@property(nonatomic,strong)NSDictionary* selection2;
@property(nonatomic,strong)NSDictionary* selection3;
@property(nonatomic,strong)NSDictionary* selection4;
@property(nonatomic,strong)NSDictionary* selection5;
@property(nonatomic,strong)NSDictionary* selection6;
@property(nonatomic,assign)int selected_index0;
@property(nonatomic,assign)int selected_index1;
@property(nonatomic,assign)int selected_index2;
@property(nonatomic,assign)int selected_index3;
@property(nonatomic,assign)int selected_index4;
@property(nonatomic,assign)int selected_index5;
@property(nonatomic,assign)int selected_index6;
@property(nonatomic,strong)NSDictionary* specialList;
@property(nonatomic,strong)WRCheckButton* checkButton;
@property(nonatomic,strong)NSArray* bubanList;

- (void)updateContent:(NSDictionary*)item;
- (IBAction)clickedNextButton:(id)sender;
- (IBAction)clickedBuBanButton:(id)sender;

@end
