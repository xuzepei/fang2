//
//  RCFuctionButton.h
//  RCFang
//
//  Created by xuzepei on 17/4/28.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCFuctionButton : UIView

@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,weak)id delegate;
@property(nonatomic,assign)BOOL isTouched;

- (void)updateContent:(NSDictionary*)item;

@end

@protocol RCFuctionButtonDelegate <NSObject>
@optional
- (void)clickedFuctionButton:(RCFuctionButton*)button token:(id)token;
@end
