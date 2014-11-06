//
//  RCDatePickerView.h
//  EMart
//
//  Created by xuzepei on 9/9/14.
//  Copyright (c) 2014 NCS Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCDatePickerViewDelegate <NSObject>

- (void)clickedSureDateButton:(NSDate*)date;

@end

@interface RCDatePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,weak)id delegate;
@property(nonatomic,strong)UIDatePicker* pickerView;
@property(nonatomic,strong)NSMutableArray* itemArray;
@property(nonatomic,strong)UIToolbar* toolbar;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIView* protectView;
@property(nonatomic,strong)NSDictionary* item;
@property(nonatomic,strong)NSDate* selectedDate;

- (void)updateContent:(NSDate*)date;
- (void)show;
- (void)hide;

@end
