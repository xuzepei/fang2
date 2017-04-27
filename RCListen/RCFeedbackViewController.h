//
//  RCFeedbackViewController.h
//  RCFang
//
//  Created by xuzepei on 5/10/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPlaceHolderTextView.h"

@interface RCFeedbackViewController : UIViewController

@property(nonatomic,retain)RCPlaceHolderTextView* textView;

- (void)initTextView;

@end
