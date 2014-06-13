//
//  RCFangInfoDiZhiCellContentView.m
//  RCFang
//
//  Created by xuzepei on 3/20/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCFangInfoDiZhiCellContentView.h"
#import "RCTool.h"
#import "RCImageLoader.h"

@implementation RCFangInfoDiZhiCellContentView

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

    [[UIColor blackColor] set];
    
    [@"地址:" drawInRect:CGRectMake(9, offset_y, 60, 20)
               withFont:[UIFont systemFontOfSize:14]
          lineBreakMode:UILineBreakModeTailTruncation];
    
//    UIImage* image = [UIImage imageNamed:@"right_arrow"];
//    [image drawAtPoint:CGPointMake(300, offset_y + 6)];
    
    NSString* address = [_item objectForKey:@"address"];
    if([address length])
    {
        [[UIColor grayColor] set];
        
        [address drawInRect:CGRectMake(46, offset_y+2, 250, 28)
                withFont:[UIFont systemFontOfSize:12]
           lineBreakMode:UILineBreakModeTailTruncation];
    }

}

- (void)updateContent:(NSDictionary *)item
{
    if(nil == item)
        return;
    
    self.item = item;
    
    NSString* latelng = [self.item objectForKey:@"mapimg"];
    NSString* map = [NSString stringWithFormat:@"http://maps.google.cn/maps/api/staticmap?center=%@&zoom=12&size=600x270&&markers=size:large|color:red|%@&sensor=true",latelng,latelng];
    
    self.headImageUrl = map;
    
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
