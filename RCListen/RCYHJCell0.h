//
//  RCYHJCell0.h
//  RCFang
//
//  Created by xuzepei on 10/29/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCYHJCell0 : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel* label0;
@property(nonatomic,weak)IBOutlet UILabel* label1;
@property(nonatomic,weak)IBOutlet UILabel* label2;
@property(nonatomic,weak)IBOutlet UILabel* label3;

- (void)updateContent:(NSDictionary*)item;

@end
