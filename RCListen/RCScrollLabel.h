//
//  RCScrollLabel.h
//  RCFang
//
//  Created by xuzepei on 17/5/2.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCScrollLabelDelegate <NSObject>

@optional
- (void)clickedLabel:(id)token;

@end

@interface RCScrollLabel : UIView

@property(nonatomic,weak)id delegate;
@property(nonatomic,strong)UIView* currentView;
@property(nonatomic,strong)UILabel* currentLabel;
@property(nonatomic,strong)UIView* nextView;
@property(nonatomic,strong)UILabel* nextLabel;

- (void)updateContent:(NSArray*)content;

@end
