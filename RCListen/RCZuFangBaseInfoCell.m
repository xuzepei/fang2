//
//  RCZuFangBaseInfoCell.m
//  RCFang
//
//  Created by xuzepei on 4/22/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCZuFangBaseInfoCell.h"

@implementation RCZuFangBaseInfoCell

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
    self.name = nil;
    self.zujin = nil;
    self.mianji = nil;
    self.fangshi = nil;
    self.huxing = nil;
    self.louceng = nil;
    self.zhuangxiu = nil;
    self.chaoxiang = nil;
    self.ruzhu = nil;
    self.kanfang = nil;
    self.teshe = nil;
    self.shinei = nil;
    self.peitao = nil;
    self.fabu = nil;
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
