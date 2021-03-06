//
//  RCTuanGouCellContentView.h
//  RCFang
//
//  Created by xuzepei on 6/6/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCTuanGouCellContentView : UIView

@property(nonatomic,retain)NSDictionary* item;
@property(assign)BOOL highlighted;

@property(nonatomic,retain)NSString* headImageUrl;
@property(nonatomic,retain)UIImage* headImage;

- (void)updateContent:(NSDictionary*)item;

@end
