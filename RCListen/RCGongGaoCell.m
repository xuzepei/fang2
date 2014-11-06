//
//  RCGongGaoCell.m
//  RCFang
//
//  Created by xuzepei on 11/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCGongGaoCell.h"

@implementation RCGongGaoCell

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
    self.label0.text = [item objectForKey:@"title"];
    self.label1.text = [item objectForKey:@"intro"];
    self.label2.text = [NSString stringWithFormat:@"浏览次数：%@",[item objectForKey:@"looktime"]];
}

@end
