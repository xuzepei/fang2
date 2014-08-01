//
//  RCFJCellContentView.h
//  RCFang
//
//  Created by xuzepei on 6/17/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPublicCellContentView.h"

@protocol RCFJCellContentViewDelegate <NSObject>

@optional
- (void)clickedCell:(NSDictionary*)token;
- (void)clickedCallRect:(NSDictionary*)token;

@end

@interface RCFJCellContentView : RCPublicCellContentView

@end
