//
//  RCNewsTableViewCellContentView.m
//  RCFang
//
//  Created by xuzepei on 03/05/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import "RCNewsTableViewCellContentView.h"
#import "RCTool.h"
#import "RCImageLoader.h"
#import "RCWebViewController.h"

#define MARGIN_X 20.0f
#define MARGIN_Y 50.0f

@implementation RCNewsTableViewCellContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.highlighted = NO;
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
}

- (void)drawRect:(CGRect)rect
{
    if(self.item)
    {
        CGRect rect = CGRectMake(MARGIN_X, MARGIN_Y, self.bounds.size.width - MARGIN_X*2, self.bounds.size.height - MARGIN_Y);
        UIColor* color = self.highlighted?HIGHLIGHT_COLOR:[UIColor whiteColor];
        [color set];
        UIRectFill(rect);
        
        NSString* temp = [self.item objectForKey:@"createtime"];
        
        if([temp length])
        {
            color = [UIColor grayColor];
            [color set];
            
            [temp drawInRect:CGRectMake(MARGIN_X, (MARGIN_Y - 14)/2.0, self.bounds.size.width - MARGIN_X*2, 20) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        }
        
        
        temp = [self.item objectForKey:@"title"];
        if([temp length])
        {
            color = self.highlighted?[UIColor whiteColor]:[UIColor blackColor];
            [color set];

            [temp drawInRect:CGRectMake(MARGIN_X + 10, MARGIN_Y + 16, self.bounds.size.width - (MARGIN_X + 10)*2, 20) withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail];
        }
        
        temp = [self.item objectForKey:@"describe"];
        if([temp length])
        {
            color = self.highlighted?[UIColor whiteColor]:[UIColor grayColor];
            [color set];
            
            [temp drawInRect:CGRectMake(MARGIN_X + 20, MARGIN_Y + 46, self.bounds.size.width - (MARGIN_X + 20)*2, 40) withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail];
        }
        
    }
    
    UIColor* color = self.highlighted?[UIColor whiteColor]:BG_COLOR;
    [color set];
    rect = CGRectMake(MARGIN_X, self.bounds.size.height - 34, self.bounds.size.width - MARGIN_X*2, 1);
    UIRectFill(rect);
    
    color = self.highlighted?[UIColor whiteColor]:[UIColor blackColor] ;
    [color set];
    [@"查看详情" drawInRect:CGRectMake(MARGIN_X + 10, self.bounds.size.height - 24, 100, 20) withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail];
    
    UIImage* image = [UIImage imageNamed:@"jiantou1"];
    if(image)
    {
        [image drawAtPoint:CGPointMake(self.bounds.size.width - MARGIN_X - image.size.width - 10, self.bounds.size.height - 24)];
    }
}

- (void)updateContent:(NSDictionary *)item
{
    if(nil == item)
        return;
    
    self.item = item;

    [self setNeedsDisplay];
}

#pragma mark - RCImageLoader Delegate

- (void)succeedLoad:(id)result token:(id)token
{
    NSDictionary* dict = (NSDictionary*)result;
    NSString* urlString = [dict valueForKey: @"url"];
    
//    if([urlString isEqualToString: _headImageUrl])
//    {
//        self.headImage = [RCTool getImageFromLocal:_headImageUrl];
//        [self setNeedsDisplay];
//    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    CGRect rect = CGRectMake(MARGIN_X, MARGIN_Y, self.bounds.size.width - MARGIN_X*2, self.bounds.size.height - MARGIN_Y);
    if(CGRectContainsPoint(rect, touchPoint))
    {
        if(self.item)
        {
            NSString* linkUrl = [self.item objectForKey:@"linkurl"];
            NSString* title = @"消息详情";//[self.item objectForKey:@"title"];
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

    }
}

@end
