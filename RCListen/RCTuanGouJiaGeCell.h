//
//  RCTuanGouJiaGeCell.h
//  RCFang
//
//  Created by xuzepei on 6/6/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCTuanGouJiaGeCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UILabel* nameLabel;
@property(nonatomic,retain)IBOutlet UITextView* infoLabel;
@property(nonatomic,retain)IBOutlet UILabel* timeLabel;
@property(nonatomic,retain)IBOutlet UIButton* commentButton;
@property(nonatomic,retain)IBOutlet UIButton* applyButton;

- (IBAction)clickedCommentButton:(id)sender;

@end
