//
//  RCPickerView.m
//  RCFang
//
//  Created by xuzepei on 3/13/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCPickerView.h"
#import "RCTool.h"

#define TOOLBAR_HEIGHT 36.0f

@implementation RCPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initToolbar];

        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, [RCTool getScreenSize].width, PICKER_VIEW_HEIGHT)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        self.pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerView];
        
        _itemArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateContent:(NSDictionary*)item;
{
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    
    NSArray* values = [item objectForKey:@"values"];
    if(values && [values isKindOfClass:[NSArray class]])
    {
        [_itemArray removeAllObjects];
        [_itemArray addObjectsFromArray:values];
        [_pickerView reloadAllComponents];
    }
    
    NSString* name = [item objectForKey:@"name"];
    if([name length])
    {
        NSString* title = [NSString stringWithFormat:@"%@",[item objectForKey:@"name"]];
        _titleLabel.text = title;
    }
    else
        _titleLabel.text = @"";

    
    self.item = item;
}

- (void)initToolbar
{
    if(nil == _toolbar)
    {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 4, [RCTool getScreenSize].width, TOOLBAR_HEIGHT)];
        //_toolbar.tintColor = NAVIGATION_BAR_COLOR;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //_titleLabel.shadowColor = [UIColor blackColor];
        //_titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        
        [_toolbar addSubview: _titleLabel];
    }
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc]
                                    initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clickedCancelButton:)];
    [items addObject:buttonItem];
    
    buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                target:nil
                                                                action:nil];
	buttonItem.width = 220;
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
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedSureValueButton:token:)])
    {
        [self.delegate clickedSureValueButton:[self.pickerView selectedRowInComponent:0] token:self.item];
    }
    
    [self hide];
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(0 == component)
    {
        if([_itemArray count])
            return [_itemArray count];
    }
    
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 320.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(0 == component)
    {
        if(row < [_itemArray count])
        {
            NSString* title = @"";
            NSDictionary* value = [_itemArray objectAtIndex:row];
            if(value && [value isKindOfClass:[NSDictionary class]])
                title = [value objectForKey:@"name"];
            else if([value isKindOfClass:[NSString class]])
                title = (NSString*)value;
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
            label.numberOfLines = 2;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:20];
            label.text = title;
            
            return label;
        }
    }
    
    return nil;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(0 == component)
    {
        if(row < [_itemArray count])
        {
            NSDictionary* value = [_itemArray objectAtIndex:row];
            if(value && [value isKindOfClass:[NSDictionary class]])
                return [value objectForKey:@"name"];
            else if([value isKindOfClass:[NSString class]])
                return (NSString*)value;
                
        }
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if (component == 0) {
//        NSString *area = [_areaArray objectAtIndex:row];
//        [self fetchCityData:area];
//        [pickerView reloadComponent:1];
//        [pickerView selectRow:0 inComponent:1 animated:YES];
//    }
}

- (void)show
{
    if(nil == _protectView)
    {
        _protectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, [RCTool getScreenSize].height)];
        _protectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
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
