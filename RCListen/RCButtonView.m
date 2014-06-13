//
//  RCButtonView.m
//  RCFang
//
//  Created by xuzepei on 3/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCButtonView.h"

@implementation RCButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        self.image = [UIImage imageNamed:@"button_view_bg"];
    }
    return self;
}

- (void)dealloc
{
}

- (void)updateContent:(NSString*)text
{
    self.text = text;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(_image)
    {
        [_image drawInRect:self.bounds];
    }
    
    if([_text length] < 4)
    {
        [_text drawInRect:CGRectMake(0, 9, self.bounds.size.width - 16, self.bounds.size.height) withFont:[UIFont boldSystemFontOfSize:14]
         lineBreakMode:NSLineBreakByWordWrapping
         alignment:NSTextAlignmentCenter];
    }
    else
    {
        [_text drawInRect:CGRectMake(0, 2, self.bounds.size.width - 16, self.bounds.size.height) withFont:[UIFont boldSystemFontOfSize:13]
            lineBreakMode:NSLineBreakByWordWrapping
                alignment:NSTextAlignmentLeft];
    }


}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    //UITouch* touch = [touches anyObject];

    if(_delegate && [_delegate respondsToSelector:@selector(clickedHeaderButton:token:)])
    {
        [_delegate clickedHeaderButton:self.tag token:nil];
    }
}


@end
