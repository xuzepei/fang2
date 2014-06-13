//
//  RCContactToolbar.m
//  RCFang
//
//  Created by xuzepei on 3/21/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCContactToolbar.h"
#import "RCTool.h"
#import "RCImageLoader.h"

@implementation RCContactToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
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
    
    CGFloat offset_x = 4.0;
    if(_headImage)
    {
        [_headImage drawInRect:CGRectMake(offset_x, (self.bounds.size.height - 50)/2.0, 40, 50)];
        
        offset_x = 54;
    }
    
    CGSize size = CGSizeZero;
    NSString* name = [_item objectForKey:@"broker_name"];
    if([name length])
    {
        [[UIColor whiteColor] set];
        
        size = [name drawInRect:CGRectMake(offset_x, 4, 200, 20)
                withFont:[UIFont boldSystemFontOfSize:12]
           lineBreakMode:UILineBreakModeTailTruncation];
    }
    

    NSString* company = [_item objectForKey:@"broker_company"];
    if([company isKindOfClass:[NSString class]] && [company length])
    {
        [[UIColor whiteColor] set];

        [company drawInRect:CGRectMake(offset_x, 20, 200, 20)
                    withFont:[UIFont boldSystemFontOfSize:12]
               lineBreakMode:UILineBreakModeTailTruncation];
    }
    
    NSString* phoneNum = [_item objectForKey:@"broker_tel_string"];
    if(nil == phoneNum || 0 == [phoneNum length])
        phoneNum = [_item objectForKey:@"broker_tel"];
    
    if([phoneNum isKindOfClass:[NSString class]] && [phoneNum length])
    {
        [[UIColor whiteColor] set];
        
        if(0 == [_headImageUrl length] && 0 == [name length] && 0 == [company length])
        {
            offset_x = 10;
            [phoneNum drawInRect:CGRectMake(offset_x, 16, 200, 20)
                        withFont:[UIFont boldSystemFontOfSize:15]
                   lineBreakMode:UILineBreakModeTailTruncation];
        }
        else
        {
            [phoneNum drawInRect:CGRectMake(offset_x, 34, 200, 20)
                        withFont:[UIFont boldSystemFontOfSize:12]
                   lineBreakMode:UILineBreakModeTailTruncation];
        }
    }
}

- (void)updateContent:(NSDictionary *)item
{
    if(nil == item)
        return;
    
    self.item = item;
    
    self.headImageUrl = [_item objectForKey:@"broker_img"];
//    self.headImage = [UIImage imageNamed:@"list_image_default"];
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
