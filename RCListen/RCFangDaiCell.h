//
//  RCFangDaiCell.h
//  RCFang
//
//  Created by xuzepei on 3/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCFangDaiCell : UITableViewCell

@property(nonatomic,retain)NSDictionary* item;
@property(nonatomic,retain)UILabel* valueLabel;

- (void)updateContent:(NSString*)value;

@end
