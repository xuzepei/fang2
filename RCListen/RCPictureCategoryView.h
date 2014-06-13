//
//  RCPictureCategoryView.h
//  RCFang
//
//  Created by xuzepei on 3/25/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCPictureCategoryViewDelegate <NSObject>

- (void)clickedPictureCategory:(id)token;

@end

@interface RCPictureCategoryView : UIView

@property(assign)id delegate;
@property(nonatomic,retain)NSMutableArray* itemArray;

- (void)updateContent:(NSArray*)itemArray;

@end
