//
//  RCDDDetailViewController.h
//  RCFang
//
//  Created by xuzepei on 10/29/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDDDetailView.h"

@interface RCDDDetailViewController : UIViewController

@property(nonatomic,weak)IBOutlet UIScrollView* scrollView;
@property(nonatomic,weak)IBOutlet RCDDDetailView* detailView;
@property(nonatomic,strong)NSDictionary* item;

- (void)updateContent:(NSDictionary*)item;

@end
