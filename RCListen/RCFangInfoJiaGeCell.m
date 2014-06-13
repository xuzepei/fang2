//
//  RCFangInfoJiaGeCell.m
//  RCFang
//
//  Created by xuzepei on 3/19/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCFangInfoJiaGeCell.h"

@implementation RCFangInfoJiaGeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
//        _myContentView = [[RCFangInfoJiaGeCellContentView alloc]
//                          initWithFrame:CGRectMake(0,0,320,70.0)];
//        [self.contentView addSubview: _myContentView];
        
    }
    return self;
}

- (void)dealloc
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
//	_myContentView.highlighted = selected;
//	[_myContentView setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	
//	_myContentView.highlighted = highlighted;
//	[_myContentView setNeedsDisplay];
}

//- (void)updateContent:(NSDictionary*)item
//{
//	if(nil == item)
//		return;
//    
//	[_myContentView updateContent:item];
//}

- (IBAction)clickedCommentButton:(id)sender
{
    NSLog(@"clickedCommentButton");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_COMMENT_NOTIFICATION object:nil];
}

@end
