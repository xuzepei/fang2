//
//  RCCountView.h
//  RCFang
//
//  Created by xuzepei on 10/13/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCCountView : UIView<UITextFieldDelegate>

@property(nonatomic,strong)UITextField* tf;
@property(nonatomic,assign)int count;
@property(nonatomic,strong)NSDictionary* item;

- (void)updateContent:(NSDictionary*)item;

@end
