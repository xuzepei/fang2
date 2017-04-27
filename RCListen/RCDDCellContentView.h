//
//  RCDDCellContentView.h
//  RCFang
//
//  Created by xuzepei on 6/18/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPublicCellContentView.h"

@protocol RCDDCellContentViewDelegate <NSObject>

- (void)clickedButton:(id)token;

@end

@interface RCDDCellContentView : RCPublicCellContentView

@property(nonatomic,assign)BOOL isSelectedButton;
@property(nonatomic,strong)UILabel* yzLabel;

@end
