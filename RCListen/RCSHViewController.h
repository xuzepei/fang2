//
//  RCSHViewController.h
//  RCFang
//
//  Created by xuzepei on 8/18/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCAdScrollView.h"
#import "RCSHDetailView.h"

@interface RCSHViewController : UIViewController<RCAdScrollViewDelegate>

@property(nonatomic,strong)RCAdScrollView* adScrollView;
@property(nonatomic,weak)IBOutlet RCSHDetailView* detailView;
@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,strong)NSDictionary* result;

- (void)updateContent:(NSDictionary*)item;
- (IBAction)clickedOrderButton:(id)sender;

@end
