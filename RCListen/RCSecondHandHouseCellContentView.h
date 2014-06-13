//
//  RCSecondHandHouseCellContentView.h
//  RCFang
//
//  Created by xuzepei on 3/26/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RCSecondHandHouseCellContentView : UIView

@property(nonatomic,retain)NSDictionary* item;
@property(assign)BOOL highlighted;

@property(nonatomic,retain)NSString* headImageUrl;
@property(nonatomic,retain)UIImage* headImage;

- (void)updateContent:(NSDictionary*)item;

@end
