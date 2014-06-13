//
//  RCXinFangCell.h
//  RCFang
//
//  Created by xuzepei on 3/19/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCXinFangCellContentView.h"

@interface RCXinFangCell : UITableViewCell

@property(nonatomic,retain)RCXinFangCellContentView* myContentView;
@property(assign)id delegate;

- (void)updateContent:(NSDictionary*)item;

@end
