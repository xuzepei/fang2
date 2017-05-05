//
//  RCScrollLabel.m
//  RCFang
//
//  Created by xuzepei on 17/5/2.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import "RCScrollLabel.h"
#import "RCNewsViewController.h"

#define HEADER_WIDTH 80.0

@implementation RCScrollLabel

- (void)dealloc
{
    self.delegate = nil;
    self.currentView = nil;
    self.nextView = nil;
    self.content = nil;
}


- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        
        [self initViews];
    }
    
    return self;
}

- (void)initViews {
    
    if(nil == _currentView)
    {
        self.currentView = [[RCScrollLabelView alloc] initWithFrame:CGRectMake(HEADER_WIDTH, 1, self.bounds.size.width - HEADER_WIDTH, self.bounds.size.height - 1)];
        self.currentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.currentView];
    }
    
//    if(nil == _currentLabel)
//    {
//        self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
//        [self.currentView addSubview:self.currentLabel];
//    }
    
    if(nil == _nextView)
    {
        self.nextView = [[RCScrollLabelView alloc] initWithFrame:CGRectMake(HEADER_WIDTH, self.bounds.size.height + 1, self.bounds.size.width - HEADER_WIDTH, self.bounds.size.height - 1)];
        self.nextView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.nextView];
    }
    
//    if(nil == _nextLabel)
//    {
//        self.nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
//        [self.nextView addSubview:self.nextLabel];
//    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [NAVIGATION_BAR_COLOR set];
    UIRectFill(CGRectMake(0, 0, self.bounds.size.width, 1));
    
    UIImage* image = [UIImage imageNamed:@"zhongyaotongzhi"];
    if(image)
    {
        [image drawAtPoint:CGPointMake(16, 8)];
    }
}


- (NSDictionary*)getItemByIndex:(int)index {

    if(index < [self.content count])
    {
        return [self.content objectAtIndex:index];
    }
    
    return nil;
}


- (void)updateContent:(NSArray*)content
{
    self.content = content;
    self.index = 0;
    
    [self.currentView updateContent:[self getItemByIndex:self.index] line1:[self getItemByIndex:self.index+1]];
    
    [self.nextView updateContent:[self getItemByIndex:self.index+2] line1:[self getItemByIndex:self.index+3]];
    
    self.index = 3;
    if([self.content count] > 2)
        [self doAnimation];
}

- (void)doAnimation {

    if(self.currentView && self.nextView)
    {
        [UIView animateKeyframesWithDuration:0.5 delay:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect rect = self.currentView.frame;
            rect.origin.y = -self.currentView.bounds.size.height;
            self.currentView.frame = rect;
            
            rect = self.nextView.frame;
            rect.origin.y = 1;
            self.nextView.frame = rect;
            
        } completion:^(BOOL finished) {
            
            RCScrollLabelView* temp = self.currentView;
            self.currentView = self.nextView;
            
            CGRect rect = temp.frame;
            rect.origin.y = self.bounds.size.height + 1;
            temp.frame = rect;
            self.nextView = temp;
            
            self.index++;
            NSDictionary* line0 = [self getItemByIndex:self.index];
            if(nil == line0)
            {
                self.index = 0;
                line0 = [self getItemByIndex:self.index];
            }
            
            self.index++;
            NSDictionary* line1 = [self getItemByIndex:self.index];
            [self.nextView updateContent:line0 line1:line1];
            
            [self doAnimation];
        }];
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    CGRect headerRect = CGRectMake(0,0,HEADER_WIDTH,self.bounds.size.height);
    if(CGRectContainsPoint(headerRect, touchPoint))
    {
        RCNewsViewController* temp = [[RCNewsViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController* naviController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        [naviController pushViewController:temp animated:YES];
    }
}


@end
