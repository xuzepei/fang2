//
//  RCMeTabBar.m
//  RCFang
//
//  Created by xuzepei on 6/7/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMeTabBar.h"

#define RECT_0 CGRectMake(0,0,320/3.0,53)
#define RECT_1 CGRectMake(320/3.0,0,320/3.0,53)
#define RECT_2 CGRectMake(320/3.0*2,0,320/3.0,53)


@implementation RCMeTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _itemArray = [[NSMutableArray alloc] init];
        
        _underlineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height - 3, 100, 3)];
        _underlineView.backgroundColor = NAVIGATION_BAR_COLOR;
        //[self addSubview: _underlineView];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"me_tabbar_bg"]];
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
    if([_itemArray count] < 3)
        return;
    
    [[RCTool colorWithHex:0x999999] set];
    NSString* temp = [_itemArray objectAtIndex:0];
    
    CGRect tempRect = RECT_0;
    tempRect.origin.x += 50;
    tempRect.origin.y += 17;
    [temp drawInRect:tempRect withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentLeft];
    
    temp = [_itemArray objectAtIndex:1];
    tempRect = RECT_1;
    tempRect.origin.x += 42;
    tempRect.origin.y += 17;
    [temp drawInRect:tempRect withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentLeft];
    
    temp = [_itemArray objectAtIndex:2];
    tempRect = RECT_2;
    tempRect.origin.x += 42;
    tempRect.origin.y += 17;
    [temp drawInRect:tempRect withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentLeft];
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
//        toRect = RECT_0;
    }
    else if(CGRectContainsPoint(RECT_1, point))
    {
        index = 1;
//        toRect = RECT_1;
    }
    else if(CGRectContainsPoint(RECT_2, point))
    {
        index = 2;
//        toRect = RECT_2;
    }
    
//    if(toRect.origin.x)
//    {
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             
//                             CGRect rect = _underlineView.frame;
//                             rect.origin.x = toRect.origin.x;
//                             _underlineView.frame = rect;
//                         }];
//    }
    
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
