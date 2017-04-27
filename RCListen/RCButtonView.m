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
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.image = [UIImage imageNamed:@"jiantouxia"];
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
    if([_text length])
    {
        CGSize size = [_text drawInRect:CGRectMake(0, (self.bounds.size.height - 14)/2.0, self.bounds.size.width - 16, self.bounds.size.height) withFont:[UIFont boldSystemFontOfSize:14]
            lineBreakMode:NSLineBreakByWordWrapping
                alignment:NSTextAlignmentCenter];
        
        if(self.image)
        {
            [self.image drawInRect:CGRectMake(self.bounds.size.width/2 + size.width/2.0 + 4.0, (self.bounds.size.height - 2)/2.0, self.image.size.width,  self.image.size.height)];
        }
        
    }
    
    
    UIColor* lineColor = [RCTool colorWithHex:0xdddddd];
    [lineColor set];
    CGRect lineRect = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
    UIRectFill(lineRect);
    
    if(0 == self.frame.origin.x)
    {
        CGRect lineRect = CGRectMake(self.bounds.size.width - 1, 5, 1, self.bounds.size.height - 10);
        UIRectFill(lineRect);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    if(_delegate && [_delegate respondsToSelector:@selector(clickedHeaderButton:token:)])
    {
        [_delegate clickedHeaderButton:self.tag token:nil];
    }
}


@end
