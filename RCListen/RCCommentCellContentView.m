//
//  RCCommentCellContentView.m
//  RCFang
//
//  Created by xuzepei on 4/11/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCCommentCellContentView.h"
#import "RCTool.h"
#import "RCImageLoader.h"

@implementation RCCommentCellContentView

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
    
    NSString* content = [_item objectForKey:@"content"];
    if([content isKindOfClass:[NSString class]] && [content length])
    {
        [[UIColor blackColor] set];
        
        [content drawInRect:CGRectMake(10, 4, 300, CGFLOAT_MAX)
                withFont:[UIFont systemFontOfSize:14]
           lineBreakMode:UILineBreakModeTailTruncation];
    }
    
    NSString* user = [_item objectForKey:@"user"];
    if([user length])
    {
        [[UIColor grayColor] set];
        
        if([user length] > 4)
        {
            user = [user stringByReplacingCharactersInRange:NSMakeRange([user length] - 4, 4) withString:@"****"];
        }
        
        NSString* temp = [NSString stringWithFormat:@"用户:%@",user];
        [temp drawInRect:CGRectMake(10, self.bounds.size.height - 20, 150,20)
                withFont:[UIFont systemFontOfSize:12]
           lineBreakMode:UILineBreakModeTailTruncation];
    }
    
    NSString* time = [_item objectForKey:@"time"];
    if([time length])
    {
        [[UIColor grayColor] set];
        
        //NSString* temp = [NSString stringWithFormat:@"用户:%@",user];
        [time drawInRect:CGRectMake(310 - 160, self.bounds.size.height - 20, 160,20)
                withFont:[UIFont systemFontOfSize:12]
           lineBreakMode:UILineBreakModeTailTruncation
         alignment:NSTextAlignmentRight];
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
