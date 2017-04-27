//
//  RCPickerView.h
//  RCFang
//
//  Created by xuzepei on 3/13/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCPickerViewDelegate <NSObject>

- (void)clickedSureValueButton:(int)index token:(id)token;

@end

@interface RCPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,weak)id delegate;
@property(nonatomic,strong)UIPickerView* pickerView;
@property(nonatomic,strong)NSMutableArray* itemArray;
@property(nonatomic,strong)UIToolbar* toolbar;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIView* protectView;
@property(nonatomic,strong)NSDictionary* item;

- (void)updateContent:(NSDictionary*)item;
- (void)show;
- (void)hide;

@end
