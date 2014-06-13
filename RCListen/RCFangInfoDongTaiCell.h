//
//  RCFangInfoDongTaiCell.h
//  RCFang
//
//  Created by xuzepei on 3/20/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCFangInfoDongTaiCellContentView.h"

@interface RCFangInfoDongTaiCell : UITableViewCell

@property(nonatomic,retain)RCFangInfoDongTaiCellContentView* myContentView;
@property(assign)id delegate;

- (void)updateContent:(NSDictionary*)item;

@end
