//
//  RCFangInfoJiaGeCell.h
//  RCFang
//
//  Created by xuzepei on 3/19/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCFangInfoJiaGeCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UILabel* nameLabel;
@property(nonatomic,retain)IBOutlet UILabel* jiageLabel;
@property(nonatomic,retain)IBOutlet UILabel* timeLabel;
@property(nonatomic,retain)IBOutlet UIButton* commentButton;

- (IBAction)clickedCommentButton:(id)sender;

//@property(nonatomic,retain)RCFangInfoJiaGeCellContentView* myContentView;
//@property(assign)id delegate;
//
//- (void)updateContent:(NSDictionary*)item;

@end
