//
//  WRCheckButton.h
//  WRadio
//
//  Created by xuzepei on 6/21/13.
//  Copyright (c) 2013 Rumtel Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRCheckButton : UIButton

@property(nonatomic,assign)BOOL isChecked;

- (void)setChecked:(BOOL)isChecked;
- (BOOL)isChecked;

@end
