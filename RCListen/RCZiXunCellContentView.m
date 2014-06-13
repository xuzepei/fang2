//
//  RCZiXunCellContentView.m
//  RCFang
//
//  Created by xuzepei on 4/6/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCZiXunCellContentView.h"
#import "RCTool.h"
#import "RCImageLoader.h"

@implementation RCZiXunCellContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.highlighted = NO;
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
    self.headImageUrl = nil;
    self.headImage = nil;
}

- (void)drawRect:(CGRect)rect
{
    if(nil == _item)
        return;
    
    if(_headImage)
    {
        [_headImage drawInRect:CGRectMake(10, (self.bounds.size.height - 56)/2.0, 73, 56)];
    }
    
    CGFloat offset_y = 4;
    NSString* title = [_item objectForKey:@"title"];
    if([title length])
    {
        if(_highlighted)
            [[UIColor whiteColor] set];
        else
            [[UIColor blackColor] set];
        
        [title drawInRect:CGRectMake(10, offset_y, 290, 20)
                withFont:[UIFont boldSystemFontOfSize:14]
           lineBreakMode:UILineBreakModeTailTruncation];
        
        offset_y += 22;
    }
    
    
    NSString* intro = [_item objectForKey:@"intro"];
    if([intro length])
    {
        if(_highlighted)
            [[UIColor whiteColor] set];
        else
            [[UIColor grayColor] set];
        
        [intro drawInRect:CGRectMake(10, offset_y, 290, 20)
                     withFont:[UIFont systemFontOfSize:12]
                lineBreakMode:UILineBreakModeTailTruncation];
        
        offset_y += 22;
    }
    
    NSString* looktime = [_item objectForKey:@"looktime"];
    if([looktime length])
    {
        if(_highlighted)
            [[UIColor whiteColor] set];
        else
            [[UIColor grayColor] set];
        
        NSString* temp = [NSString stringWithFormat:@"浏览次数:%@",looktime];
        [temp drawInRect:CGRectMake(10, offset_y, 290, 20)
                withFont:[UIFont systemFontOfSize:10]
           lineBreakMode:UILineBreakModeTailTruncation];
    }
}

- (void)updateContent:(NSDictionary *)item
{
    if(nil == item)
        return;
    
    self.item = item;
    
//    self.headImageUrl = [_item objectForKey:@"image_url"];
//    self.headImage = [UIImage imageNamed:@"list_image_default"];
//	if([_headImageUrl length])
//	{
//		UIImage* image = [RCTool getImageFromLocal:_headImageUrl];
//		if(nil == image)
//		{
//			RCImageLoader* temp = [RCImageLoader sharedInstance];
//			[temp saveImage:_headImageUrl delegate:self token:nil];
//		}
//		else
//		{
//			self.headImage = image;
//		}
//	}
    
	[self setNeedsDisplay];
    
}

#pragma mark - RCImageLoader Delegate

- (void)succeedLoad:(id)result token:(id)token
{
	NSDictionary* dict = (NSDictionary*)result;
	NSString* urlString = [dict valueForKey: @"url"];
	
    if([urlString isEqualToString: _headImageUrl])
	{
		self.headImage = [RCTool getImageFromLocal:_headImageUrl];
		[self setNeedsDisplay];
	}
}


@end
