//
//  RCNewsTableViewCellContentView.h
//  RCFang
//
//  Created by xuzepei on 03/05/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCNewsTableViewCellContentView : UIView

@property(nonatomic,retain)NSDictionary* item;
@property(assign)BOOL highlighted;

- (void)updateContent:(NSDictionary*)item;

@end
