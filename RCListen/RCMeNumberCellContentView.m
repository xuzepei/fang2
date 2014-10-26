//
//  RCMeNumberCellContentView.m
//  RCFang
//
//  Created by xuzepei on 6/9/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCMeNumberCellContentView.h"

#define EDGE_INSETS UIEdgeInsetsMake(7, 9, 8, 9)

@implementation RCMeNumberCellContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(nil == self.item)
        return;
    
    NSString* temp = nil;
    int number = [[self.item objectForKey:@"count"] intValue];
    if(number <= 99999)
        temp = [NSString stringWithFormat:@"%d",number];
    else
        temp = @"99999+";
    
    CGSize size = [temp sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIImage* bgImage = [UIImage imageNamed:@"number_bg"];
    if(bgImage)
    {
        bgImage = [bgImage resizableImageWithCapInsets:EDGE_INSETS];
        [bgImage drawInRect:CGRectMake(150, (self.bounds.size.height - 19)/2.0, MAX(size.width + 11,24), 19)];
    }
    
    [[UIColor whiteColor] set];
    CGRect tempRect = CGRectMake(150, (self.bounds.size.height - 19)/2.0 + 2.0, MAX(size.width + 11,24), 19);
    tempRect.size.width = MAX(size.width + 11,24);
    [temp drawInRect:tempRect
            withFont:[UIFont boldSystemFontOfSize:12] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
}


@end
