//
//  RCSelectAreaButton.h
//  RCFang
//
//  Created by xuzepei on 6/5/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCSelectAreaButtonDelegate <NSObject>

- (void)clickedSelectionButton:(id)sender;

@end

@interface RCSelectAreaButton : UIView

@property(nonatomic,retain)NSString* name;
@property(nonatomic,assign)id delegate;

- (void)updateContent:(NSString*)name;

@end
