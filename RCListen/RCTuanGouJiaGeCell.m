//
//  RCTuanGouJiaGeCell.m
//  RCFang
//
//  Created by xuzepei on 6/6/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCTuanGouJiaGeCell.h"

@implementation RCTuanGouJiaGeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.nameLabel = nil;
    self.infoLabel = nil;
    self.timeLabel = nil;
    self.commentButton = nil;
    self.applyButton = nil;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickedCommentButton:(id)sender
{
    NSLog(@"clickedCommentButton");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_COMMENT_NOTIFICATION object:nil];
}

- (IBAction)clickedApplyButton:(id)sender
{
    NSLog(@"clickedApplyButton");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CLICKED_APPLY_BUTTON_NOTIFICATION object:nil];
}

@end
