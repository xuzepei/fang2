//
//  RCScrollLabelView.h
//  RCFang
//
//  Created by xuzepei on 02/05/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCScrollLabelView : UIView

@property(nonatomic, strong)NSDictionary* line0;
@property(nonatomic, strong)NSDictionary* line1;
@property(nonatomic, assign)CGRect line0Rect;
@property(nonatomic, assign)CGRect line1Rect;

- (void)updateContent:(NSDictionary*)line0 line1:(NSDictionary*)line1;

@end
