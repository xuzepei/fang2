//
//  RCAdScrollView.m
//  RCFang
//
//  Created by xuzepei on 3/10/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//



#import "RCAdScrollView.h"
#import "RCWebViewController.h"

#define CHANGE_TIME_INTERVAL 6
#define AD_WIDTH self.bounds.size.width
#define AD_HEIGHT self.bounds.size.height

@implementation RCAdScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        _itemArray = [[NSMutableArray alloc] init];
        _adViews= [[NSMutableArray alloc] init];
        
        if(nil == _scrollView)
        {
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, AD_WIDTH, AD_HEIGHT)];
            _scrollView.contentSize = CGSizeMake(AD_WIDTH*3, AD_HEIGHT);
            _scrollView.contentOffset = CGPointMake(AD_WIDTH*1, 0);
            _scrollView.pagingEnabled = YES;
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.scrollsToTop = NO;
            _scrollView.delegate = self;
            _scrollView.bouncesZoom = NO;
            _scrollView.bounces = NO; //important
        }
        
        [self addSubview: _scrollView];
        
        for(int i = 0; i < 3; i++)
        {
            RCAdView* adView = [[RCAdView alloc] initWithFrame:CGRectMake(AD_WIDTH * i,0,AD_WIDTH,AD_HEIGHT)];
            adView.delegate = self;
            [self.adViews addObject:adView];
        }
        
        if(nil == _pageControl)
        {
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,AD_HEIGHT - 16,AD_WIDTH,16)];
        }

        
        if(nil == _timer)
        {
            self.timer = [NSTimer
                           scheduledTimerWithTimeInterval:CHANGE_TIME_INTERVAL
                           target:self
                           selector:@selector(handleTimer:)
                           userInfo:nil
                           repeats:YES
                           ];
        }
        
        [_timer fire];
    }
    return self;
}

- (void)dealloc
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    self.itemArray = nil;
    self.pageControl = nil;
    self.adViews = nil;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateContent:(NSArray*)itemArray
{
    [self.itemArray removeAllObjects];
    [self.itemArray addObjectsFromArray:itemArray];
    
    

    
//	_pageControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _pageControl.backgroundColor = [UIColor clearColor];
	_pageControl.numberOfPages = [self.itemArray count];
	_pageControl.currentPage = 0;
	[_pageControl addTarget:self
					 action:@selector(changePage:)
		   forControlEvents:UIControlEventValueChanged];
    
    [self addSubview: _pageControl];
    
    [self rearrangeAdViews];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    //int page = floor((self.scrollView.contentOffset.x - AD_WIDTH / 2) / AD_WIDTH) + 1;
    
    //[self goToIndex:_pageControl.currentPage];
    
    CGFloat temp = self.scrollView.contentOffset.x/AD_WIDTH;
    
    if(temp > 1)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake(AD_WIDTH*2, 0);
        } completion:^(BOOL finished) {
   
            _pageControl.currentPage = _pageControl.currentPage + 1 < self.itemArray.count ? _pageControl.currentPage + 1 : 0;
            
            self.scrollView.contentOffset = CGPointMake(AD_WIDTH*1, 0);
            [self rearrangeAdViews];
        }];
    } else if (temp < 1) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            
            _pageControl.currentPage = _pageControl.currentPage - 1 >= 0 ? _pageControl.currentPage - 1 : self.itemArray.count - 1;
            
            self.scrollView.contentOffset = CGPointMake(AD_WIDTH*1, 0);
            [self rearrangeAdViews];
        }];
        
    }
}

- (IBAction)changePage:(id)sender
{
//	int page = _pageControl.currentPage;
//    CGRect frame = self.frame;
//    frame.origin.x = frame.size.width * page;
//    frame.origin.y = 0;
//    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)goToIndex:(int)index
{
    _pageControl.currentPage = index;
    

   [UIView animateWithDuration:0.5 animations:^{
       self.scrollView.contentOffset = CGPointMake(AD_WIDTH*2, 0);
   } completion:^(BOOL finished) {
       self.scrollView.contentOffset = CGPointMake(AD_WIDTH*1, 0);
       [self rearrangeAdViews];
   }];
}

- (void)rearrangeAdViews
{
    for(UIView* subView in self.scrollView.subviews)
    {
        if([subView isKindOfClass:[RCAdView class]])
        {
            [subView removeFromSuperview];
        }
    }
    
    //Middle Ad View
    RCAdView* adView = self.adViews[1];
    [adView updateContent:self.itemArray[_pageControl.currentPage]];
    adView.frame = CGRectMake(AD_WIDTH, 0, AD_WIDTH, AD_HEIGHT);
    [self.scrollView addSubview:adView];
    
    //Left Ad View
    adView = self.adViews[0];
    int index = (int)_pageControl.currentPage - 1;
    if(index < 0)
    {
        index = (int)[self.itemArray count] - 1;
    }
    
    [adView updateContent:self.itemArray[index]];
    adView.frame = CGRectMake(0, 0, AD_WIDTH, AD_HEIGHT);
    [self.scrollView addSubview:adView];
    
    
    //Right Ad View
    adView = self.adViews[2];
    index = (int)_pageControl.currentPage + 1;
    if(index >= [self.itemArray count])
    {
        index = 0;
    }
    [adView updateContent:self.itemArray[index]];
    adView.frame = CGRectMake(AD_WIDTH*2, 0, AD_WIDTH, AD_HEIGHT);
    [self.scrollView addSubview:adView];
    
}

- (void)handleTimer:(NSTimer*)timer
{
    if(self.pageControl.currentPage + 1 < [self.itemArray count])
        self.pageControl.currentPage = self.pageControl.currentPage + 1;
    else
    {
        self.pageControl.currentPage = 0;
    }
    
    [self goToIndex: (int)self.pageControl.currentPage];
}

#pragma mark - 

- (void)clickedAd:(id)token {

    if(token && [token isKindOfClass:[NSDictionary class]]) {
    
        NSString* linkUrl = [token objectForKey:@"linkurl"];
        
        if([linkUrl length])
        {
            RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:linkUrl title:nil];
            
            UINavigationController* naviController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            [naviController pushViewController:temp animated:YES];
        }
    }
}

@end
