//
//  RCJFCell.h
//  RCFang
//
//  Created by xuzepei on 10/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCJFCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel* label0;
@property(nonatomic,weak)IBOutlet UILabel* label1;
@property(nonatomic,weak)IBOutlet UILabel* label2;
@property(nonatomic,weak)IBOutlet UILabel* label3;
@property(nonatomic,weak)IBOutlet UILabel* label4;

@property(nonatomic,strong)NSDictionary* item;

- (void)updateContent:(NSDictionary*)item;

@end
