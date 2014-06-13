//
//  RCMeTopView.m
//  RCFang
//
//  Created by xuzepei on 6/6/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMeTopView.h"

#define TEXT_COLOR [UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0]

@implementation RCMeTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIImage* bgImage = [UIImage imageNamed:@"me_top_view_bg"];
    if(bgImage)
    {
        [bgImage drawInRect:self.bounds];
    }
    
    if([RCTool isLogined])
    {
        //nickname
        [[RCTool colorWithHex:0x3e3c3d] set];
        NSString* nickname = [NSString stringWithFormat:@"昵称：%@",@""];
        [nickname drawInRect:CGRectMake(10, 10, 200, 20) withFont:[UIFont boldSystemFontOfSize:16] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
        
        //phone
        [[RCTool colorWithHex:0x5b5b5b] set];
        NSString* phone = [NSString stringWithFormat:@"手机号：%@",@""];
        [phone drawInRect:CGRectMake(10, 36, 200, 20) withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
        
        //jifen
        NSString* jifen = [NSString stringWithFormat:@"积分：%@",@""];
        [jifen drawInRect:CGRectMake(10, 58, 200, 20) withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
    }
    else
    {
        NSString* temp = @"欢迎来到房管家";
        [TEXT_COLOR set];
        [temp drawInRect:CGRectMake(0, 15, self.bounds.size.width, 20) withFont:[UIFont boldSystemFontOfSize:16] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    }

    
}


- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    [self setNeedsDisplay];
}

@end
