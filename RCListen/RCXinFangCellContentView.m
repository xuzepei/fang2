//
//  RCXinFangCellContentView.m
//  RCFang
//
//  Created by xuzepei on 3/19/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCXinFangCellContentView.h"
#import "RCTool.h"
#import "RCImageLoader.h"

@implementation RCXinFangCellContentView

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
        [_headImage drawInRect:CGRectMake(10, (self.bounds.size.height - 56)/2.0, 73, 56)];
    }
    
    CGFloat offset_y = 10;
    NSString* name = [_item objectForKey:@"name"];
    if([name length])
    {
        if(_highlighted)
            [[UIColor whiteColor] set];
        else
            [[UIColor blackColor] set];
        
        [name drawInRect:CGRectMake(86, offset_y, 200, 20)
                withFont:[UIFont boldSystemFontOfSize:14]
           lineBreakMode:UILineBreakModeTailTruncation];
    }
    
    NSString* zhuangtai = [_item objectForKey:@"state"];
    if([zhuangtai length])
    {
        if(_highlighted)
            [[UIColor whiteColor] set];
        else
            [[UIColor grayColor] set];
        
        [zhuangtai drawInRect:CGRectMake(290, offset_y, 200, 20)
                withFont:[UIFont systemFontOfSize:12]
           lineBreakMode:UILineBreakModeTailTruncation];
    }
    
    offset_y += 20;
    NSString* quyu = [_item objectForKey:@"area"];
    if([quyu length])
    {
        UIImage* dingweiImage = [UIImage imageNamed:@"dingwei"];
        if(dingweiImage)
        {
            [dingweiImage drawInRect:CGRectMake(86, offset_y, 10, 13)];
        }
        
        if(_highlighted)
            [[UIColor whiteColor] set];
        else
            [[UIColor grayColor] set];
        
        [quyu drawInRect:CGRectMake(102, offset_y, 200, 20)
                     withFont:[UIFont systemFontOfSize:10]
                lineBreakMode:UILineBreakModeTailTruncation];
    }
    
    NSString* jiage = [_item objectForKey:@"price"];
    if([jiage length])
    {
        if(_highlighted)
            [[UIColor whiteColor] set];
        else
            [[UIColor colorWithRed:0.09 green:0.45 blue:0.85 alpha:1.00] set];
        
        [jiage drawInRect:CGRectMake(314 - 100, offset_y, 100, 20)
                withFont:[UIFont boldSystemFontOfSize:12]
           lineBreakMode:UILineBreakModeTailTruncation
         alignment:NSTextAlignmentRight];
    }
    
    offset_y += 20;
    NSString* dizhi = [_item objectForKey:@"address"];
    if([dizhi length])
    {
        if(_highlighted)
            [[UIColor whiteColor] set];
        else
            [[UIColor grayColor] set];
        
        [dizhi drawInRect:CGRectMake(86, offset_y, 220, 20)
                withFont:[UIFont systemFontOfSize:10]
           lineBreakMode:UILineBreakModeTailTruncation];
    }
    
    
    offset_y += 14;
    NSString* teshe = [_item objectForKey:@"special"];
    if([teshe length])
    {
        if(_highlighted)
            [[UIColor whiteColor] set];
        else
            [[UIColor orangeColor] set];
        
        [teshe drawInRect:CGRectMake(86, offset_y, 220, 20)
                 withFont:[UIFont systemFontOfSize:10]
            lineBreakMode:UILineBreakModeTailTruncation];
    }
    
    
//
//    NSString * beginTime = [WRTool getTimeStringByInterval:[[_item objectForKey:@"if_starttime"] doubleValue]/1000
//                                                withFormat:@"HH:mm"];
//    NSString * endTime = [WRTool getTimeStringByInterval:[[_item objectForKey:@"if_endtime"] doubleValue]/1000
//                                              withFormat:@"HH:mm"];
//    
//    NSString * detailString = [NSString stringWithFormat:@"%@ (%@ ~ %@)", nickname,beginTime, endTime];
//    
//    if([detailString length])
//    {
//        if(_highlighted)
//            [[UIColor whiteColor] set];
//        else
//            [[UIColor grayColor] set];
//        
//        [detailString drawInRect:CGRectMake(60, 32, 180, 20)
//                        withFont:[UIFont systemFontOfSize:14]
//                   lineBreakMode:UILineBreakModeTailTruncation];
//    }
//    
//    [SEPARATED_LINE_COLOR set];
//    UIRectFill(CGRectMake(10, self.bounds.size.height - 1, 300, 1));
}

- (void)updateContent:(NSDictionary *)item
{
    if(nil == item)
        return;
    
    self.item = item;
    
    self.headImageUrl = [_item objectForKey:@"imgurl"];
    self.headImage = [UIImage imageNamed:@"list_image_default"];
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
