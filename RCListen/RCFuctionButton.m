//
//  RCFuctionButton.m
//  RCFang
//
//  Created by xuzepei on 17/4/28.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import "RCFuctionButton.h"

@implementation RCFuctionButton

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    // Drawing code
    
//    if(self.isTouched)
//    {
//        [[UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1.0] set];
//        UIRectFill(self.bounds);
//    }
    
    if(self.item)
    {
        NSString* imageName = [self.item objectForKey:@"image"];
        UIImage* image = [UIImage imageNamed:imageName];
        if(image)
        {
            [image drawInRect:CGRectMake(6, 8, image.size.width, image.size.height)];
        }
        
        NSString* text = [self.item objectForKey:@"text"];
        
        if([text length])
        {
            [[UIColor whiteColor] set];
            
            [text drawInRect:CGRectMake(6, self.bounds.size.height - 20, self.bounds.size.width - 12, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail];
        }
    
    }
}


- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    NSString* bgColor = [self.item objectForKey:@"color"];
    self.backgroundColor = [RCTool colorWithHexString:bgColor];
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isTouched = YES;
    self.alpha = 0.3;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isTouched = NO;
    self.alpha = 1.0;
    [self setNeedsDisplay];
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if(CGRectContainsPoint(self.bounds, touchPoint))
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedFuctionButton:token:)])
        {
            [self.delegate clickedFuctionButton:self token:self.item];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isTouched = NO;
    self.alpha = 1.0;
    [self setNeedsDisplay];
}

@end
