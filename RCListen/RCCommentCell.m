//
//  RCCommentCell.m
//  RCFang
//
//  Created by xuzepei on 4/11/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCCommentCell.h"

@implementation RCCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _myContentView = [[RCCommentCellContentView alloc]
						  initWithFrame:CGRectMake(0,0,320,60)];
		[self.contentView addSubview: _myContentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.myContentView = nil;
    self.delegate = nil;
}

- (void)updateContent:(NSDictionary*)item
{
	if(nil == item)
		return;
    
    CGSize textSize = CGSizeZero;
    
    NSString* content = [item objectForKey:@"content"];
    if([content isKindOfClass:[NSString class]] && [content length])
    {
        textSize = [content sizeWithFont:[UIFont systemFontOfSize:14]
                       constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    }
    
    CGFloat height = 24.0 + MAX(24,textSize.height);
    
    CGRect rect = _myContentView.frame;
    rect.size.height = height;
    _myContentView.frame = rect;
    
	[_myContentView updateContent:item];
}


@end
