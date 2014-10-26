//
//  WRTipView.m
//  WRadio
//
//  Created by xuzepei on 9/13/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import "WRTipView.h"

#define TIP_FRAME_WIDTH [RCTool getScreenSize].width
#define TIP_FRAME_HEIGHT [RCTool getScreenSize].height

@implementation WRTipView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {

}


- (void)initScrollView:(NSArray*)imageNameArray
{
    self.imageNameArray = imageNameArray;
    if(0 == [self.imageNameArray count])
        return;
    
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
	_scrollView.pagingEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
	_scrollView.contentSize = CGSizeMake(self.bounds.size.width * [_imageNameArray count], self.bounds.size.height);
	[self addSubview: _scrollView];
    
    for(int i = 0; i < [_imageNameArray count]; i++)
    {
        UIImage *tipImage = [UIImage imageNamed:[_imageNameArray objectAtIndex:i]];
        
        UIImageView* subView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * i,0,self.bounds.size.width,self.bounds.size.height)];
        subView.backgroundColor = [UIColor clearColor];
        subView.image = tipImage;
        [_scrollView addSubview:subView];
    }
	
	_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,self.bounds.size.height - 26,self.bounds.size.width,26)];
	_pageControl.backgroundColor = [UIColor clearColor];
	_pageControl.numberOfPages = [_imageNameArray count];
	_pageControl.currentPage = 0;
	[_pageControl addTarget:self 
					 action:@selector(changePage:) 
		   forControlEvents:UIControlEventValueChanged];
	[self addSubview: _pageControl];
    _pageControl.hidden = YES;
	
}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
    int page = floor((_scrollView.contentOffset.x - TIP_FRAME_WIDTH / 2) / TIP_FRAME_WIDTH) + 1;
    _pageControl.currentPage = page;

	if(page == [_imageNameArray count] - 1)
	{
        [UIView animateWithDuration:2.0 animations:^{
            self.alpha = 0.0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"no_show_tips"];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (IBAction)changePage:(id)sender
{
	int page = _pageControl.currentPage;
	
	CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
	
}


@end
