//
//  RCCreateDDSetp0View.h
//  RCFang
//
//  Created by xuzepei on 9/10/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCCreateDDSetp0ViewDelegate <NSObject>

- (void)clickedTextField;

@end

@interface RCCreateDDSetp0View : UIView<UITextFieldDelegate>

@property(nonatomic,weak)IBOutlet UITextField* tf0;
@property(nonatomic,weak)IBOutlet UITextField* tf1;
@property(nonatomic,weak)IBOutlet UITextField* tf2;
@property(nonatomic,weak)IBOutlet id delegate;




@end
