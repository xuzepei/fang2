//
//  RCCountView.m
//  RCFang
//
//  Created by xuzepei on 10/13/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCCountView.h"

@implementation RCCountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _tf = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width - 60, (frame.size.height - 30)/2.0, 30, 30)];
        _tf.delegate = self;
        _tf.borderStyle = UITextBorderStyleLine;
        _tf.textAlignment = NSTextAlignmentCenter;
        _tf.enabled = NO;
        _tf.text = @"0";
        [self addSubview:_tf];
        
        UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        leftButton.frame = CGRectMake(frame.size.width - 90, (frame.size.height - 30)/2.0, 30, 30);
        leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [leftButton setTitle:@"-" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(clickedLeftButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.frame = CGRectMake(frame.size.width - 30, (frame.size.height - 30)/2.0, 30, 30);
        rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [rightButton setTitle:@"+" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(clickedRightButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
    }
    return self;
}

- (void)clickedLeftButton:(id)sender
{
    if(self.count)
        self.count--;
    self.tf.text = [NSString stringWithFormat:@"%d",self.count];
}

- (void)clickedRightButton:(id)sender
{
    self.count++;
    self.tf.text = [NSString stringWithFormat:@"%d",self.count];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}


- (void)drawRect:(CGRect)rect
{
   NSString* temp = [self.item objectForKey:@"intro"];
    if([temp length])
    {
        [[UIColor grayColor] set];
        
        CGSize size = [temp sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.bounds.size.width - 100, self.bounds.size.height - 12) lineBreakMode:NSLineBreakByTruncatingTail];
        
        [temp drawInRect:CGRectMake(6, (self.bounds.size.height - size.height)/2.0, self.bounds.size.width - 100, size.height) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
    }
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    [self setNeedsDisplay];
}


@end
