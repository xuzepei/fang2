//
//  RCFJCellContentView.m
//  RCFang
//
//  Created by xuzepei on 6/17/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCFJCellContentView.h"

#define SUBTITLE_COLOR [RCTool colorWithHex:0xafafaf]
#define LINE_COLOR [RCTool colorWithHex:0xcccccc]

#define CALL_RECT CGRectMake(self.bounds.size.width - 60,0,60,self.bounds.size.height)

@implementation RCFJCellContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //draw name
    NSString* name = [self.item objectForKey:@"title"];
    if([name length])
    {
        [name drawInRect:CGRectMake(10, 12, 240, 20) withFont:[UIFont systemFontOfSize:16] lineBreakMode:NSLineBreakByTruncatingTail];
    }
    
    //draw address
    NSString* address = [self.item objectForKey:@"intro"];
    if([address length])
    {
        UIImage* image = [UIImage imageNamed:@"did"];
        if(image)
            [image drawInRect:CGRectMake(12, 38, image.size.width, image.size.height)];
        
        [SUBTITLE_COLOR set];
        [address drawInRect:CGRectMake(30, 38, (CALL_RECT.origin.x - 40)/2.0, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail];
    }
    
    NSString* pinfen = [self.item objectForKey:@"rank"];
    if([pinfen length])
    {
        [SUBTITLE_COLOR set];
        
        NSString* temp = [NSString stringWithFormat:@"评分:%@",pinfen];
        [temp drawInRect:CGRectMake(40+(CALL_RECT.origin.x - 40)/2.0, 38, (CALL_RECT.origin.x - 40)/2.0, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail];
    }
    
    
    //draw times
    UIImage* image = [UIImage imageNamed:@"lianxi"];
    if(image)
    {
        [image drawInRect:CGRectMake(self.bounds.size.width - 60/2.0 - image.size.width/2.0, 14, image.size.width, image.size.height)];
        
        NSString* times = [self.item objectForKey:@"sucess"];
        if([times length])
        {
            [SUBTITLE_COLOR set];
            [times drawInRect:CGRectMake(CALL_RECT.origin.x,40,CALL_RECT.size.width,20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        }
    }
    
    
    [LINE_COLOR set];
    CGRect lineRect = CGRectMake(self.bounds.size.width - 60, 10, 1, self.bounds.size.height - 20);
    UIRectFill(lineRect);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint endPoint = [touch locationInView:self];
    if(CGRectContainsPoint(CALL_RECT, endPoint))
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedCallRect:)])
        {
            [self.delegate clickedCallRect:self.item];
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedCell:)])
        {
            [self.delegate clickedCell:self.item];
        }
    }
}

@end
