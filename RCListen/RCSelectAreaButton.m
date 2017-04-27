//
//  RCSelectAreaButton.m
//  RCFang
//
//  Created by xuzepei on 6/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCSelectAreaButton.h"

@implementation RCSelectAreaButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
    // Drawing code
    
    UIImage* image = [UIImage imageNamed:@"jiantou"];
    if(image)
    {
        [image drawInRect:CGRectMake(self.bounds.size.width - image.size.width, (self.bounds.size.height - image.size.height)/2.0, image.size.width, image.size.height)];
    
        if([self.name length])
        {
            [[UIColor whiteColor] set];
            [self.name drawInRect:CGRectMake(0, (self.bounds.size.height - 20)/2.0, self.bounds.size.width - image.size.width, 20) withFont:[UIFont boldSystemFontOfSize:18] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
        }
    }

}

- (void)updateContent:(NSString*)name
{
    self.name = name;
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedSelectionButton:)])
    {
        [self.delegate clickedSelectionButton:nil];
    }
}


@end
