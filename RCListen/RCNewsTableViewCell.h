//
//  RCNewsTableViewCell.h
//  RCFang
//
//  Created by xuzepei on 03/05/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCNewsTableViewCellContentView.h"

@interface RCNewsTableViewCell : UITableViewCell

@property(nonatomic,retain)RCNewsTableViewCellContentView* myContentView;
@property(weak)id delegate;

- (void)updateContent:(NSDictionary*)item cellHeight:(CGFloat)cellHeight;

@end
