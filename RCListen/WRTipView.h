//
//  WRTipView.h
//  WRadio
//
//  Created by xuzepei on 9/13/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRTipView : UIView<UIScrollViewDelegate> {

}

@property(nonatomic,strong)UIScrollView* scrollView;
@property(nonatomic,strong)UIPageControl* pageControl;
@property(nonatomic,strong)NSArray* imageNameArray;

- (void)initScrollView:(NSArray*)imageNameArray;

@end
