//
//  RCScrollLabel.m
//  RCFang
//
//  Created by xuzepei on 17/5/2.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import "RCScrollLabel.h"


#define HEADER_WIDTH 100.0

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
        self.currentView = [[RCScrollLabelView alloc] initWithFrame:CGRectMake(HEADER_WIDTH, 0, self.bounds.size.width - HEADER_WIDTH, self.bounds.size.height)];
        self.currentView.backgroundColor = [UIColor redColor];
        [self addSubview:self.currentView];
    }
    
//    if(nil == _currentLabel)
//    {
//        self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
//        [self.currentView addSubview:self.currentLabel];
//    }
    
    if(nil == _nextView)
    {
        self.nextView = [[RCScrollLabelView alloc] initWithFrame:CGRectMake(HEADER_WIDTH, self.bounds.size.height, self.bounds.size.width - HEADER_WIDTH, self.bounds.size.height)];
        self.nextView.backgroundColor = [UIColor blueColor];
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
//- (void)drawRect:(CGRect)rect {
//}


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
            rect.origin.y = 0;
            self.nextView.frame = rect;
            
        } completion:^(BOOL finished) {
            
            RCScrollLabelView* temp = self.currentView;
            self.currentView = self.nextView;
            
            CGRect rect = temp.frame;
            rect.origin.y = self.bounds.size.height;
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
    //[super touchesEnded:touches withEvent:event];
    NSLog(@"@@@@@@touchesEnded");
}


@end
