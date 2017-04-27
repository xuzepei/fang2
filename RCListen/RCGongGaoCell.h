//
//  RCGongGaoCell.h
//  RCFang
//
//  Created by xuzepei on 11/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCGongGaoCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel* label0;
@property(nonatomic,weak)IBOutlet UILabel* label1;
@property(nonatomic,weak)IBOutlet UILabel* label2;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint* constraint;

- (void)updateContent:(NSDictionary*)item;

@end
