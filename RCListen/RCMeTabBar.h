//
//  RCMeTabBar.h
//  RCFang
//
//  Created by xuzepei on 6/7/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCMeTabBarDelegate <NSObject>

@optional
- (void)clickedTabItem:(int)index token:(id)token;

@end

@interface RCMeTabBar : UIView

@property(nonatomic,retain)NSMutableArray* itemArray;
@property(assign)id delegate;
@property(nonatomic,retain)UIView* underlineView;

- (void)updateContent:(NSArray*)itemArray;

@end
