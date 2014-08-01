//
//  WRCheckButton.h
//  WRadio
//
//  Created by xuzepei on 6/21/13.
//  Copyright (c) 2013 Rumtel Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCCheckButton : UIButton
{
    BOOL _isChecked;
}

@property(nonatomic,strong)NSString* normalImageName;
@property(nonatomic,strong)NSString* selectedImageName;

- (void)setChecked:(BOOL)isChecked;
- (BOOL)isChecked;

@end
