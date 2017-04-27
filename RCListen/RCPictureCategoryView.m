//
//  RCPictureCategoryView.m
//  RCFang
//
//  Created by xuzepei on 3/25/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCPictureCategoryView.h"

#define RECT0 CGRectMake(40,30,100,100)
#define RECT1 CGRectMake(40+100+40,30,100,100)
#define RECT2 CGRectMake(40,30+100+30,100,100)
#define RECT3 CGRectMake(40+100+40,30+100+30,100,100)
#define RECT4 CGRectMake(40,30+(100+30)*2,100,100)
#define RECT5 CGRectMake(40+100+40,30+(100+30)*2,100,100)

@implementation RCPictureCategoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _itemArray = [[NSMutableArray alloc] init];
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
    [[UIColor redColor] set];
    UIRectFill(RECT0);
    UIRectFill(RECT1);
    UIRectFill(RECT2);
    UIRectFill(RECT3);
    UIRectFill(RECT4);
    UIRectFill(RECT5);
    
    
    [[UIColor blackColor] set];
    NSString* temp = @"实景图(32)";
    [temp drawInRect:CGRectMake(RECT0.origin.x, RECT0.origin.y + RECT0.size.height + 2, RECT0.size.width, 30) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    temp = @"外景图(16)";
    [temp drawInRect:CGRectMake(RECT1.origin.x, RECT1.origin.y + RECT1.size.height + 2, RECT1.size.width, 30) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    
    temp = @"交通图(3)";
    [temp drawInRect:CGRectMake(RECT2.origin.x, RECT2.origin.y + RECT2.size.height + 2, RECT2.size.width, 30) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    temp = @"配套图(2)";
    [temp drawInRect:CGRectMake(RECT3.origin.x, RECT3.origin.y + RECT3.size.height + 2, RECT3.size.width, 30) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    temp = @"户型图(24)";
    [temp drawInRect:CGRectMake(RECT4.origin.x, RECT4.origin.y + RECT4.size.height + 2, RECT4.size.width, 30) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    temp = @"样板图(33)";
    [temp drawInRect:CGRectMake(RECT5.origin.x, RECT5.origin.y + RECT5.size.height + 2, RECT5.size.width, 30) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
}

- (void)updateContent:(NSArray*)itemArray
{
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if(CGRectContainsPoint(RECT0, point))
    {
    }
    else if(CGRectContainsPoint(RECT1, point))
    {
    }
    else if(CGRectContainsPoint(RECT2, point))
    {
    }
    else if(CGRectContainsPoint(RECT3, point))
    {
    }
    else if(CGRectContainsPoint(RECT4, point))
    {
    }
    else if(CGRectContainsPoint(RECT5, point))
    {
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(clickedPictureCategory:)])
    {
        [_delegate clickedPictureCategory:nil];
    }
}


@end
