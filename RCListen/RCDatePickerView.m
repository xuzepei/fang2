//
//  RCDatePickerView.m
//  EMart
//
//  Created by xuzepei on 9/9/14.
//  Copyright (c) 2014 NCS Pte. Ltd. All rights reserved.
//

#import "RCDatePickerView.h"

@implementation RCDatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initToolbar];
        
        _pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, [RCTool getScreenSize].width, 216)];
        _pickerView.datePickerMode = UIDatePickerModeDate;
        _pickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-DD"];
        NSString *minDateString = @"1900-01-01";
        NSDate* minDate = [NSDate date];
        
        NSString *maxDateString = @"2099-01-01";
        NSDate* maxDate = [dateFormater dateFromString:maxDateString];
        _pickerView.minimumDate = minDate;
        _pickerView.maximumDate = maxDate;
        
        [_pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_pickerView];
    }
    return self;
}

- (void)dateChanged:(id)sender
{
    UIDatePicker* control = (UIDatePicker*)sender;
    self.selectedDate = control.date;
}

- (void)updateContent:(NSDate*)date
{
    if(nil == date)
        return;
    
    self.selectedDate = date;
    
    if(_pickerView)
        [_pickerView setDate:self.selectedDate animated:YES];
}

- (void)initToolbar
{
    if(nil == _toolbar)
    {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
        _toolbar.tintColor = NAVIGATION_BAR_TINT_COLOR;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = NAVIGATION_BAR_TINT_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_toolbar addSubview: _titleLabel];
    }
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc]
                                   initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clickedCancelButton:)];
    [items addObject:buttonItem];
    
    buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                               target:nil
                                                               action:nil];
	buttonItem.width = 186;
    [items addObject:buttonItem];
    
    
    buttonItem = [[UIBarButtonItem alloc]
                  initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(clickedDoneButton:)];
    [items addObject:buttonItem];
    
    
    [_toolbar setItems:items animated:YES];
    
    [self addSubview:_toolbar];
}

- (void)clickedCancelButton:(id)sender
{
    NSLog(@"clickedCancelButton");
    
    [self hide];
}

- (void)clickedDoneButton:(id)sender
{
    NSLog(@"clickedDoneButton");
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedSureDateButton:)])
    {
        [self.delegate clickedSureDateButton:self.selectedDate];
    }
    
    [self hide];
}

- (void)show
{
    if(nil == _protectView)
    {
        _protectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, [RCTool getScreenSize].height)];
        _protectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
    
    [[RCTool frontWindow] addSubview: _protectView];
    [[RCTool frontWindow] addSubview: self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = self.frame;
        rect.origin.y = [RCTool getScreenSize].height - rect.size.height;
        self.frame = rect;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = self.frame;
                         rect.origin.y = [RCTool getScreenSize].height;
                         self.frame = rect;
                     } completion:^(BOOL finished) {
                         
                         [_protectView removeFromSuperview];
                         [self removeFromSuperview];
                     }];
}

@end
