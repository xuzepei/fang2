//
//  RCLaunchAdView.m
//  RCFang
//
//  Created by xuzepei on 3/31/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCLaunchAdView.h"
#import "RCTool.h"
#import "RCImageLoader.h"

@implementation RCLaunchAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
    self.headImageUrl = nil;
    self.headImage = nil;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(_headImage)
    {
        [_headImage drawInRect:self.bounds];
    }
}


- (void)updateContent:(NSDictionary *)item
{
    if(nil == item)
        return;
    
    self.item = item;
    
    self.headImageUrl = [_item objectForKey:@"image_url"];
    self.headImage = [UIImage imageNamed:@"launch_default"];
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
//	NSDictionary* dict = (NSDictionary*)result;
//	NSString* urlString = [dict valueForKey: @"url"];
//	
//    if([urlString isEqualToString: _headImageUrl])
//	{
//		self.headImage = [RCTool getImageFromLocal:_headImageUrl];
//		[self setNeedsDisplay];
//	}
}

@end
