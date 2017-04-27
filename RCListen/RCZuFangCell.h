//
//  RCZuFangCell.h
//  RCFang
//
//  Created by xuzepei on 3/31/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCZuFangCellContentView.h"

@interface RCZuFangCell : UITableViewCell

@property(nonatomic,retain)RCZuFangCellContentView* myContentView;
@property(assign)id delegate;

- (void)updateContent:(NSDictionary*)item;

@end
