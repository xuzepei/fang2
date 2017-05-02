//
//  RCScrollLabel.h
//  RCFang
//
//  Created by xuzepei on 17/5/2.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCScrollLabelView.h"

@protocol RCScrollLabelDelegate <NSObject>

@optional
- (void)clickedLabel:(id)token;

@end

@interface RCScrollLabel : UIView

@property(nonatomic,weak)id delegate;
@property(nonatomic,strong)RCScrollLabelView* currentView;
@property(nonatomic,strong)NSArray* content;
@property(nonatomic,strong)RCScrollLabelView* nextView;
@property(nonatomic,assign)int index;

- (void)updateContent:(NSArray*)content;

@end
