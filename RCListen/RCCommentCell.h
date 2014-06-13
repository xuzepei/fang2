//
//  RCCommentCell.h
//  RCFang
//
//  Created by xuzepei on 4/11/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCCommentCellContentView.h"

@interface RCCommentCell : UITableViewCell

@property(nonatomic,retain)RCCommentCellContentView* myContentView;
@property(assign)id delegate;

- (void)updateContent:(NSDictionary*)item;

@end
