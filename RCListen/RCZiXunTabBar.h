//
//  RCZiXunTabBar.h
//  RCFang
//
//  Created by xuzepei on 4/6/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCZiXunTabBarDelegate <NSObject>

@optional
- (void)clickedTabItem:(int)index token:(id)token;

@end

@interface RCZiXunTabBar : UIView

@property(nonatomic,retain)NSMutableArray* itemArray;
@property(assign)id delegate;
@property(nonatomic,retain)UIView* underlineView;

- (void)updateContent:(NSArray*)itemArray;
- (void)clickedTabItem:(int)index;


@end
