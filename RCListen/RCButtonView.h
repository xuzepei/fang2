//
//  RCButtonView.h
//  RCFang
//
//  Created by xuzepei on 3/18/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCButtonViewDelegate <NSObject>

- (void)clickedHeaderButton:(int)tag token:(id)token;

@end

@interface RCButtonView : UIView

@property(nonatomic,strong)UIImage* image;
@property(nonatomic,strong)NSString* text;
@property(nonatomic,weak)id delegate;

- (void)updateContent:(NSString*)text;

@end
