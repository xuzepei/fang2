//
//  RCDDCell.h
//  RCFang
//
//  Created by xuzepei on 10/22/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCDDCellDelegate <NSObject>

- (void)clickedButton:(int)type token:(NSDictionary*)token;

@end

@interface RCDDCell : UITableViewCell<UIAlertViewDelegate>

@property(nonatomic,strong)NSDictionary* item;

@property(nonatomic,weak)IBOutlet UILabel* label0;
@property(nonatomic,weak)IBOutlet UILabel* label1;
@property(nonatomic,weak)IBOutlet UILabel* label2;
@property(nonatomic,weak)IBOutlet UILabel* label3;
@property(nonatomic,weak)IBOutlet UILabel* label4;
@property(nonatomic,weak)IBOutlet UILabel* label5;
@property(nonatomic,weak)IBOutlet UILabel* label6;

@property(nonatomic,weak)IBOutlet UIButton* button0;
@property(nonatomic,weak)IBOutlet UIButton* button1;
@property(nonatomic,weak)IBOutlet UIButton* button2;
@property(nonatomic,weak)id delegate;
@property(nonatomic,assign)int index;

- (IBAction)clickedDetailButton:(id)sender;

- (void)updateContent:(NSDictionary*)item;

@end
