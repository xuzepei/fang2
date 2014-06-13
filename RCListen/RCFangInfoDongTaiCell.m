//
//  RCFangInfoDongTaiCell.m
//  RCFang
//
//  Created by xuzepei on 3/20/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCFangInfoDongTaiCell.h"

@implementation RCFangInfoDongTaiCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _myContentView = [[RCFangInfoDongTaiCellContentView alloc]
						  initWithFrame:CGRectMake(0,0,320,80)];
		[self.contentView addSubview: _myContentView];
        
    }
    return self;
}

- (void)dealloc
{
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
    
    CGSize textSize = CGSizeZero;
    
    NSString* desc = [item objectForKey:@"desc"];
    if([desc length])
    {
        textSize = [desc sizeWithFont:[UIFont systemFontOfSize:12]
         constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    }
    
    CGFloat height = 30 + MAX(20,textSize.height);

    CGRect rect = _myContentView.frame;
    rect.size.height = height;
    _myContentView.frame = rect;
    
	[_myContentView updateContent:item];
}

@end
