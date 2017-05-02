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

@implementation RCAdScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        _itemArray = [[NSMutableArray alloc] init];
        
        if(nil == _scrollView)
        {
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            _scrollView.pagingEnabled = YES;
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.scrollsToTop = NO;
            _scrollView.delegate = self;
            _scrollView.bouncesZoom = NO;
        }
        
        [self addSubview: _scrollView];

        
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
    
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * [self.itemArray count], self.bounds.size.height);
    
    for(UIView* subview in [self.scrollView subviews])
    {
        [subview removeFromSuperview];
    }
    

    int i = 0;
    for(NSDictionary* item in itemArray)
    {
        RCAdView* adView = [[RCAdView alloc] initWithFrame:CGRectMake(self.bounds.size.width * i,0,self.bounds.size.width,self.bounds.size.height)];
        adView.delegate = self;
        [adView updateContent:item];
        [self.scrollView addSubview:adView];
        
        i++;
    }
    
    
    if(nil == _pageControl)
    {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,self.bounds.size.height - 16,self.bounds.size.width,16)];
    }
    
//	_pageControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _pageControl.backgroundColor = [UIColor clearColor];
	_pageControl.numberOfPages = [self.itemArray count];
	_pageControl.currentPage = 0;
	[_pageControl addTarget:self
					 action:@selector(changePage:)
		   forControlEvents:UIControlEventValueChanged];
    
    [self addSubview: _pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    int page = floor((self.scrollView.contentOffset.x - self.bounds.size.width / 2) / self.bounds.size.width) + 1;
    _pageControl.currentPage = page;
}

- (IBAction)changePage:(id)sender
{
	int page = _pageControl.currentPage;
    CGRect frame = self.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)goToIndex:(int)index
{
    _pageControl.currentPage = index;
   
    [self changePage:nil];
}

- (void)handleTimer:(NSTimer*)timer
{
    static BOOL forward = YES;
    if(_pageControl.currentPage == [self.itemArray count] - 1)
        forward = NO;
    else if(_pageControl.currentPage == 0)
        forward = YES;
        
    if(forward) 
    {
        if(_pageControl.currentPage < [self.itemArray count])
            [self goToIndex: _pageControl.currentPage + 1];
    }
    else
    {
        //int index = _pageControl.currentPage - 1;
        _pageControl.currentPage = 0;
        int index = _pageControl.currentPage;
        if(index < [self.itemArray count] && index != -1)
            [self goToIndex: index];
    }
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
