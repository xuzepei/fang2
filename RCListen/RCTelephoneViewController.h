//
//  RCTelephoneViewController.h
//  RCFang
//
//  Created by xuzepei on 10/14/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCTelephoneViewController : UIViewController

@property(nonatomic,strong)IBOutlet UILabel* label0;
@property(nonatomic,strong)IBOutlet UILabel* label1;
@property(nonatomic,strong)IBOutlet UIButton* button;
@property(nonatomic,strong)NSDictionary* item;

- (IBAction)clickedButton:(id)sender;

@end
