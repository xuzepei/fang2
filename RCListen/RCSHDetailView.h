//
//  RCSHDetailView.h
//  RCFang
//
//  Created by xuzepei on 8/18/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCSHDetailView : UIView

@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,weak)IBOutlet UILabel* title;
@property(nonatomic,weak)IBOutlet UILabel* value0;
@property(nonatomic,weak)IBOutlet UILabel* value1;
@property(nonatomic,weak)IBOutlet UILabel* value2;
@property(nonatomic,weak)IBOutlet UILabel* value3;
@property(nonatomic,weak)IBOutlet UILabel* value4;
@property(nonatomic,weak)IBOutlet UILabel* value5;

- (void)updateContent:(NSDictionary*)item;

@end
