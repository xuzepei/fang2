//
//  RCZuFangCell.m
//  RCFang
//
//  Created by xuzepei on 3/31/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCZuFangCell.h"

@implementation RCZuFangCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _myContentView = [[RCZuFangCellContentView alloc]
						  initWithFrame:CGRectMake(0,0,320,80)];
		[self.contentView addSubview: _myContentView];
        
    }
    return self;
}

- (void)dealloc
{
    self.myContentView = nil;
    self.delegate = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
	_myContentView.highlighted = selected;
	[_myContentView setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	
	_myContentView.highlighted = highlighted;
	[_myContentView setNeedsDisplay];
}

- (void)updateContent:(NSDictionary*)item
{
	if(nil == item)
		return;
    
	[_myContentView updateContent:item];
}

@end
