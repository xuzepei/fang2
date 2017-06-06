//
//  RCScrollLabelView.m
//  RCFang
//
//  Created by xuzepei on 02/05/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import "RCScrollLabelView.h"
#import "RCWebViewController.h"

#define MARGIN_X 30.0f

@implementation RCScrollLabelView

- (void)dealloc
{
    self.line0 = nil;
    self.line1 = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.line0Rect = CGRectZero;
        self.line1Rect = CGRectZero;
        
        self.image0 = [UIImage imageNamed:@"zhiding"];
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    if(self.line0)
    {
        NSString* text = [self.line0 objectForKey:@"title"];
        if([text length])
        {
            [[UIColor blackColor] set];
            
            int fontSize = 12;
            CGFloat offset_y = ((self.bounds.size.height/2.0) - fontSize)/2.0;
            if(self.image0)
                [self.image0 drawAtPoint:CGPointMake(4, offset_y + 2)];
            
            
            self.line0Rect = CGRectMake(MARGIN_X, offset_y, self.bounds.size.width - MARGIN_X, 20);
            [text drawInRect:self.line0Rect withFont:[UIFont systemFontOfSize:fontSize] lineBreakMode:NSLineBreakByTruncatingTail];
        }
        
    }
    
    if(self.line1)
    {
        
        NSString* text = [self.line1 objectForKey:@"title"];
        
        if([text length])
        {
            [[UIColor blackColor] set];
            int fontSize = 12;
            CGFloat offset_y = (self.bounds.size.height/2.0) + ((self.bounds.size.height/2.0) - fontSize)/2.0;
            if(self.image0)
                [self.image0 drawAtPoint:CGPointMake(4, offset_y + 2)];
            self.line1Rect = CGRectMake(MARGIN_X,  offset_y, self.bounds.size.width - MARGIN_X, 20);
            [text drawInRect:self.line1Rect withFont:[UIFont systemFontOfSize:fontSize] lineBreakMode:NSLineBreakByTruncatingTail];
        }
        
    }
}

- (void)updateContent:(NSDictionary*)line0 line1:(NSDictionary*)line1
{
    self.line0 = line0;
    self.line1 = line1;
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    NSString* linkUrl = nil;
    NSString* title = nil;
    if(CGRectContainsPoint(self.line0Rect, touchPoint))
    {
//        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedFuctionButton:token:)])
//        {
//            [self.delegate clickedFuctionButton:self token:self.item];
//        }
        
        if(self.line0)
        {
            linkUrl = [self.line0 objectForKey:@"linkurl"];
            title = @"消息详情";//[self.line0 objectForKey:@"title"];
        }
        
        
    }
    else if(CGRectContainsPoint(self.line1Rect, touchPoint))
    {
        if(self.line1)
        {
            linkUrl = [self.line1 objectForKey:@"linkurl"];
            title = @"消息详情";//[self.line1 objectForKey:@"title"];
        }
    }
    
    if([linkUrl length])
    {
        RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
        temp.hidesBottomBarWhenPushed = YES;
        temp.needToChangeTitle = YES;
        [temp updateContent:linkUrl title:title];
        
        UINavigationController* naviController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        [naviController pushViewController:temp animated:YES];
    }
    
}


@end
