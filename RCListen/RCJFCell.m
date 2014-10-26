//
//  RCJFCell.m
//  RCFang
//
//  Created by xuzepei on 10/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCJFCell.h"

@implementation RCJFCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    self.label0.text = [self.item objectForKey:@"credit_action"];
    self.label1.text = [self.item objectForKey:@"now_credit"];
    self.label2.text = [self.item objectForKey:@"old_credit"];
    self.label3.text = [self.item objectForKey:@"credit_change"];
    self.label4.text = [self.item objectForKey:@"action_time"];
}

@end
