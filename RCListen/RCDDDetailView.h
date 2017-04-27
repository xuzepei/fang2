//
//  RCDDDetailView.h
//  RCFang
//
//  Created by xuzepei on 10/29/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDDDetailView : UIView

@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,weak)IBOutlet UIButton* button0;
@property(nonatomic,weak)IBOutlet UIButton* button1;
@property(nonatomic,weak)IBOutlet UIButton* button2;

- (void)updateContent:(NSDictionary*)item;
- (IBAction)clickedButton:(id)sender;

@end
