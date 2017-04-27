//
//  RCFangDaiRateCell.h
//  RCFang
//
//  Created by xuzepei on 3/15/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCFangDaiRateCell : UITableViewCell

@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)UILabel* valueLabel;
@property(nonatomic,retain)UILabel* valueLabel1;

- (void)updateContent:(NSString*)value value1:(NSString*)value1;


@end
