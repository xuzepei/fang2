//
//  RCFangInfoDiZhiCell.h
//  RCFang
//
//  Created by xuzepei on 3/20/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCFangInfoDiZhiCellContentView.h"

@interface RCFangInfoDiZhiCell : UITableViewCell

@property(nonatomic,retain)RCFangInfoDiZhiCellContentView* myContentView;
@property(assign)id delegate;

- (void)updateContent:(NSDictionary*)item;

@end
