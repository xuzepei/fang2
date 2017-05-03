//
//  RCNewsTableViewCell.m
//  RCFang
//
//  Created by xuzepei on 03/05/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import "RCNewsTableViewCell.h"
#import "RCTool.h"

@implementation RCNewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [UIView new];
        self.selectedBackgroundView = [UIView new];
        
        _myContentView = [[RCNewsTableViewCellContentView alloc]
                          initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,80)];
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

- (void)updateContent:(NSDictionary*)item cellHeight:(CGFloat)cellHeight
{
    if(nil == item)
        return;
    
    CGRect rect = _myContentView.frame;
    rect.size.height = cellHeight;
    _myContentView.frame = rect;
    [_myContentView updateContent:item];
}


@end
