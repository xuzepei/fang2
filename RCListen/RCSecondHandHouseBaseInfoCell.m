//
//  RCSecondHandHouseBaseInfoCell.m
//  RCFang
//
//  Created by xuzepei on 4/22/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCSecondHandHouseBaseInfoCell.h"

@implementation RCSecondHandHouseBaseInfoCell

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
    self.zongjiaLabel = nil;
    self.huxingLabel = nil;
    self.danjiaLabel = nil;
    self.mainjiLabel = nil;
    self.chaoxiangLabel = nil;
    self.loucengLabel = nil;
    self.zhuangxiuLabel = nil;
    self.chanquanLabel = nil;
    self.jiegouLabel = nil;
    self.tesheLabel = nil;
    self.leibieLabel = nil;
    self.peitaoLabel = nil;
    self.shijianLabel = nil;
    self.commentButton = nil;

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

@end
