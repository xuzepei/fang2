//
//  RCPasswordView.h
//  RCFang
//
//  Created by xuzepei on 8/21/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCCheckButton.h"
#import "RCWebViewController.h"

@protocol RCPasswordViewDelegate <NSObject>

- (void)clickedNextButton:(int)type token:(NSDictionary*)token;

@end

@interface RCPasswordView : UIView<UITextFieldDelegate>

@property(nonatomic,assign)int type;
@property(nonatomic,strong)UITextField* phoneTF;
@property(nonatomic,strong)UITextField* yuanmimaTF;
@property(nonatomic,strong)UITextField* yanzhengmaTF;
@property(nonatomic,strong)UITextField* mima0TF;
@property(nonatomic,strong)UITextField* mima1TF;
@property(nonatomic,strong)UIButton* button;
@property(nonatomic,weak)id delegate;
@property(nonatomic,strong)NSDictionary* step1Token;
@property(nonatomic,strong)NSDictionary* step2Token;
@property(nonatomic,strong)RCCheckButton* checkButton;
@property(nonatomic,strong)UIButton* resendButton;

- (void)updateContent:(int)type token:(NSDictionary*)token;

@end
