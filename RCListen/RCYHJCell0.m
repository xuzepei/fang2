//
//  RCYHJCell0.m
//  RCFang
//
//  Created by xuzepei on 10/29/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCYHJCell0.h"

@implementation RCYHJCell0

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
    if(nil == item)
        return;
    
    self.label0.text = [item objectForKey:@"coupon_num"];
    self.label1.text = [item objectForKey:@"coupon_area"];
    self.label2.text = [item objectForKey:@"coupon_price"];
}

@end
