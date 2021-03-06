//
//  RCZiXunTabBar.m
//  RCFang
//
//  Created by xuzepei on 4/6/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCZiXunTabBar.h"

#define RECT_0 CGRectMake(10,12,75,40)
#define RECT_1 CGRectMake(10+75,12,75,40)
#define RECT_2 CGRectMake(10+75*2,12,75,40)
#define RECT_3 CGRectMake(10+75*3,12,75,40)

@implementation RCZiXunTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _itemArray = [[NSMutableArray alloc] init];
        
        _underlineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height - 3, 75, 3)];
        _underlineView.backgroundColor = NAVIGATION_BAR_COLOR;
        [self addSubview: _underlineView];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_bg"]];
    }
    return self;
}

- (void)dealloc
{
    self.itemArray = nil;
    self.delegate = nil;
    self.underlineView = nil;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if([_itemArray count] < 4)
        return;
    
    [[UIColor blackColor] set];
    NSString* temp = [_itemArray objectAtIndex:0];
    [temp drawInRect:RECT_0 withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    
    temp = [_itemArray objectAtIndex:1];
    [temp drawInRect:RECT_1 withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    
    temp = [_itemArray objectAtIndex:2];
    [temp drawInRect:RECT_2 withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    
    temp = [_itemArray objectAtIndex:3];
    [temp drawInRect:RECT_3 withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
}


- (void)updateContent:(NSArray*)itemArray
{
    [_itemArray removeAllObjects];
    [_itemArray addObjectsFromArray:itemArray];
    
    [self setNeedsDisplay];
}

- (void)clickedTabItem:(int)index
{
    if(-1 != index)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedTabItem:token:)])
        {
            [self.delegate clickedTabItem:index token:nil];
        }
    }
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
    else if(CGRectContainsPoint(RECT_3, point))
    {
        index = 3;
        toRect = RECT_3;
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
    
    [self clickedTabItem:index];
    
    
    [super touchesEnded:touches withEvent:event];
}

@end
