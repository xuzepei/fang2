//
//  RCFangDaiRateCell.m
//  RCFang
//
//  Created by xuzepei on 3/15/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCFangDaiRateCell.h"

@implementation RCFangDaiRateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 200, 30)];
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textColor = [UIColor grayColor];
        _valueLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview: _valueLabel];
        
        _valueLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, 200, 30)];
        _valueLabel1.backgroundColor = [UIColor clearColor];
        _valueLabel1.textColor = [UIColor grayColor];
        _valueLabel1.font = [UIFont systemFontOfSize:14];
    
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

- (void)updateContent:(NSString*)value value1:(NSString*)value1
{
    
    if([value1 length])
    {
        [self addSubview: _valueLabel1];
        
        self.valueLabel.text = [NSString stringWithFormat:@"商业利率: %@",value];
        self.valueLabel1.text = [NSString stringWithFormat:@"公积金利率: %@",value1];
    }
    else
    {
        self.valueLabel.text = value;
        [_valueLabel1 removeFromSuperview];
    }
}

@end
