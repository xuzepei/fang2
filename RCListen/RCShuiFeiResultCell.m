//
//  RCShuiFeiResultCell.m
//  RCFang
//
//  Created by xuzepei on 3/16/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCShuiFeiResultCell.h"

@implementation RCShuiFeiResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 200, 30)];
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textColor = [UIColor grayColor];
        _valueLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview: _valueLabel];
    }
    return self;
}

- (void)dealloc
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateContent:(NSString*)value
{
    if([self.textLabel.text length])
    {
        CGSize size = [self.textLabel.text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(CGFLOAT_MAX,20)];
        
        CGRect rect = self.valueLabel.frame;
        rect.origin.x = size.width + 20.0;
        self.valueLabel.frame = rect;
        
        self.valueLabel.text = value;
    }
        
    
}

@end
