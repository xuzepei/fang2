//
//  RCScrollLabel.m
//  RCFang
//
//  Created by xuzepei on 17/5/2.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import "RCScrollLabel.h"

@implementation RCScrollLabel

- (void)dealloc
{
    self.delegate = nil;
    self.currentView = nil;
    self.nextView = nil;
    self.currentLabel = nil;
    self.nextLabel = nil;
}


- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        
        [self initCurrentView];
    }
    
    return self;
}

- (void)initCurrentView {
    
    if(nil == _currentView)
    {
        self.currentView = [[UIView alloc] initWithFrame:self.bounds];
        self.currentView.backgroundColor = [UIColor redColor];
        [self addSubview:self.currentView];
    }
    
    if(nil == _currentLabel)
    {
        self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        [self.currentView addSubview:self.currentLabel];
    }
    
    if(nil == _nextView)
    {
        self.nextView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
        self.nextView.backgroundColor = [UIColor blueColor];
        [self addSubview:self.nextView];
    }
    
    if(nil == _nextLabel)
    {
        self.nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        [self.nextView addSubview:self.nextLabel];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//}




- (void)updateContent:(NSArray*)content
{
    self.currentLabel.text = @"以前的房主没有留下任何转递地址。";
    self.nextLabel.text = @"皮尔斯先生的一个前合伙人是这个计划的热心支持者之一。";
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
            
            UIView* temp = self.currentView;
            self.currentView = self.nextView;
            
            CGRect rect = temp.frame;
            rect.origin.y = self.bounds.size.height;
            temp.frame = rect;
            self.nextView = temp;
            
            [self doAnimation];
        }];
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"@@@@@@touchesEnded");
}


@end
