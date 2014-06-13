//
//  RCTuanGouApplyViewController.h
//  RCFang
//
//  Created by xuzepei on 6/7/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCTuanGouApplyViewController : UIViewController

@property(nonatomic,retain)UITextField* textField;
@property(nonatomic,retain)NSString* tg_id;

- (void)updateContent:(NSString*)tg_id;

@end
