//
//  RCSHDetailView.m
//  RCFang
//
//  Created by xuzepei on 8/18/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCSHDetailView.h"

@implementation RCSHDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[RCTool colorWithHex:0xe0e0de] set];
    CGRect line = CGRectMake(10, 44, 300, 1);
    UIRectFill(line);
    
    NSString* content =  @"比如可以自己动手制造或者改造出精品模型的御宅；喜欢玩游戏并且拥有很高电脑操作技术的宅御；喜欢动画并且可以用乐器惟妙惟肖演奏出动画中音乐的御宅。";//[self.item objectForKey:@"content"];
    if([content length])
    {
        [[UIColor blackColor] set];
        CGRect value3Rect = self.value3.frame;
        CGFloat offset_y = value3Rect.origin.y + value3Rect.size.height + 6;
        [content drawInRect:CGRectMake(12, offset_y, [RCTool getScreenSize].width - 24, self.bounds.size.height - 48 - offset_y) withFont:[UIFont systemFontOfSize:16] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
    }

    [[RCTool colorWithHex:0x01a4f1] set];
    line = CGRectMake(10, self.bounds.size.height - 44, 300, 1);
    UIRectFill(line);
}

- (void)updateContent:(NSDictionary *)item
{
    self.item = item;
    
    self.title.text = [self.item objectForKey:@"title"];
    self.value0.text = [self.item objectForKey:@"baseprice"];
    self.value1.text = [self.item objectForKey:@"insurance_state"];
    self.value2.text = [self.item objectForKey:@"insurance_limit"];
    self.value3.text = [self.item objectForKey:@"service_area"];
    //self.value4.text = [self.item objectForKey:@"content"];
    self.value5.text = [self.item objectForKey:@"title"];
    
    [self setNeedsDisplay];
}

@end
