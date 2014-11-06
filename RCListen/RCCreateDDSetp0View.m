//
//  RCCreateDDSetp0View.m
//  RCFang
//
//  Created by xuzepei on 9/10/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCCreateDDSetp0View.h"

@implementation RCCreateDDSetp0View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

@end
