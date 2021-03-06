//
//  RCTabBar.m
//  RCFang
//
//  Created by xuzepei on 3/12/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCTabBar.h"

#define RECT_0 CGRectMake(10,12,100,40)
#define RECT_1 CGRectMake(10+100,12,100,40)
#define RECT_2 CGRectMake(10+100*2,12,100,40)

@implementation RCTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _itemArray = [[NSMutableArray alloc] init];
        
        _underlineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height - 3, 100, 3)];
        _underlineView.backgroundColor = NAVIGATION_BAR_COLOR;
        [self addSubview: _underlineView];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_bg"]];
    }
    return self;
}

- (void)dealloc
{

}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if([_itemArray count] < 3)
        return;
    
    [[UIColor blackColor] set];
    NSString* temp = [_itemArray objectAtIndex:0];
    [temp drawInRect:RECT_0 withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    
    temp = [_itemArray objectAtIndex:1];
    [temp drawInRect:RECT_1 withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    
    temp = [_itemArray objectAtIndex:2];
    [temp drawInRect:RECT_2 withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
}


- (void)updateContent:(NSArray*)itemArray
{
    [_itemArray removeAllObjects];
    [_itemArray addObjectsFromArray:itemArray];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    int index = -1;
    CGRect toRect = CGRectZero;
    if(CGRectContainsPoint(RECT_0, point))
    {
        index = 0;
        toRect = RECT_0;
    }
    else if(CGRectContainsPoint(RECT_1, point))
    {
        index = 1;
        toRect = RECT_1;
    }
    else if(CGRectContainsPoint(RECT_2, point))
    {
        index = 2;
        toRect = RECT_2;
    }
    
    if(toRect.origin.x)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             
            CGRect rect = _underlineView.frame;
            rect.origin.x = toRect.origin.x;
            _underlineView.frame = rect;
        }];
    }
    
    if(-1 != index)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedTabItem:token:)])
        {
            [self.delegate clickedTabItem:index token:nil];
        }
    }
    
    [super touchesEnded:touches withEvent:event];
}

@end
