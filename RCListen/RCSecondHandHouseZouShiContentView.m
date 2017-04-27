//
//  RCSecondHandHouseZouShiContentView.m
//  RCFang
//
//  Created by xuzepei on 4/22/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCSecondHandHouseZouShiContentView.h"
#import "RCTool.h"
#import "RCImageLoader.h"

@implementation RCSecondHandHouseZouShiContentView

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
        [_headImage drawInRect:CGRectMake(10,40, 300, 135)];
    }
    
    CGFloat offset_y = 3;
    
    NSString* name = [_item objectForKey:@"name"];
    if([name length])
    {
        [[UIColor blackColor] set];
        
        [name drawInRect:CGRectMake(9, offset_y+2, 250, 28)
                   withFont:[UIFont systemFontOfSize:12]
              lineBreakMode:UILineBreakModeTailTruncation];
    }
    
}

- (void)updateContent:(NSDictionary *)item
{
    if(nil == item)
        return;
    
    self.item = item;
    
    self.headImageUrl = [self.item objectForKey:@"image_url"];
    
    self.headImage = nil;
	if([_headImageUrl length])
	{
		UIImage* image = [RCTool getImageFromLocal:_headImageUrl];
		if(nil == image)
		{
			RCImageLoader* temp = [RCImageLoader sharedInstance];
			[temp saveImage:_headImageUrl delegate:self token:nil];
		}
		else
		{
			self.headImage = image;
		}
	}
    
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
