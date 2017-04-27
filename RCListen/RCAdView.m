//
//  RCAdView.m
//  RCFang
//
//  Created by xuzepei on 3/10/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCAdView.h"
#import "RCImageLoader.h"
#import "RCTool.h"

@implementation RCAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.image = [UIImage imageNamed:@"guanggao"];
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
    self.imageUrl = nil;
    self.image = nil;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(self.image)
    {
        [self.image drawInRect:self.bounds];
    }
}

- (void)updateContent:(NSDictionary*)item
{
    self.image = nil;
    
    self.imageUrl = [item objectForKey:@"url"];
    if([self.imageUrl length])
    {
        UIImage* image = [RCTool getImageFromLocal:self.imageUrl];
        if(image)
            self.image = image;
        else
        {
            [[RCImageLoader sharedInstance] saveImage:self.imageUrl
                                             delegate:self
                                                token:nil];
        }
    }
    
    
    [self setNeedsDisplay];
}

- (void)succeedLoad:(id)result token:(id)token
{
	NSDictionary* dict = (NSDictionary*)result;
	NSString* urlString = [dict valueForKey: @"url"];
    
	if([urlString isEqualToString: self.imageUrl])
	{
		self.image = [RCTool getImageFromLocal:self.imageUrl];
		[self setNeedsDisplay];
	}
}


@end
