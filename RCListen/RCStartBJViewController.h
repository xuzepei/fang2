//
//  RCStartBJViewController.h
//  RCFang
//
//  Created by xuzepei on 10/13/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCStartBJViewController : UIViewController

@property(nonatomic,strong)IBOutlet UIScrollView* scrollView;
@property(nonatomic,strong)IBOutlet UIImageView* imageView;
@property(nonatomic,strong)IBOutlet UILabel* myLabel;
@property(nonatomic,strong)IBOutlet UITextView* textView;
@property(nonatomic,strong)IBOutlet UIButton* startButton;
@property(nonatomic,strong)NSDictionary* item;

- (IBAction)clickedButton:(id)sender;

@end
