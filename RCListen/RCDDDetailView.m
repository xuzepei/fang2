//
//  RCDDDetailView.m
//  RCFang
//
//  Created by xuzepei on 10/29/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDDetailView.h"

@implementation RCDDDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(nil == self.item)
        return;
    
    CGFloat offset_x = 10.0f;
    CGFloat offset_y = 10.0f;
    
    UIImage* carImage = [UIImage imageNamed:@"car.png"];
    if(carImage)
    {
        [carImage drawInRect:CGRectMake([RCTool getScreenSize].width - 80, offset_y, 63, 33)];
    }
    
    [[UIColor grayColor] set];
    NSString* str = [NSString stringWithFormat:@"订单编号：%@",[self.item objectForKey:@"order_num"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 16.0f;
    }
    
    str = [NSString stringWithFormat:@"下单时间：%@",[self.item objectForKey:@"order_time"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 16.0f;
    }
    
    str = [NSString stringWithFormat:@"下单时间：%@",[self.item objectForKey:@"order_price"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 24.0f;
    }
    
    CGRect line = CGRectMake(6,offset_y,[RCTool getScreenSize].width - 12, 0.5);
    UIRectFill(line);
    offset_y += 8.0f;
    
    str = [NSString stringWithFormat:@"%@",[self.item objectForKey:@"order_type_text"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 16.0f;
    }
    
    str = [NSString stringWithFormat:@"联系人：%@",[self.item objectForKey:@"linkman"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 16.0f;
    }
    
    str = [NSString stringWithFormat:@"起点：%@",[self.item objectForKey:@"order_begin"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 16.0f;
    }
    
    str = [NSString stringWithFormat:@"终点：%@",[self.item objectForKey:@"begin_info"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 16.0f;
    }
    
    str = [NSString stringWithFormat:@"终点：%@",[self.item objectForKey:@"end_info"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 16.0f;
    }
    
    NSArray* array = [self.item objectForKey:@"price_info_list"];
    if(array && [array isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* dic in array)
        {
            NSString* title = [dic objectForKey:@"title"];
            NSString* price_info = [dic objectForKey:@"price_info"];
            str = [NSString stringWithFormat:@"%@ %@",title,price_info];
            [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
            
            offset_y += 16.0f;
        }
    }

    str = [NSString stringWithFormat:@"%@",[self.item objectForKey:@"total_price_info"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 16.0f;
    }
    
    str = [NSString stringWithFormat:@"%@",[self.item objectForKey:@"remover_activity_info"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 16.0f;
    }
    
    str = [NSString stringWithFormat:@"折后价格：%@",[self.item objectForKey:@"activity_price"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 16.0f;
    }
    
    NSString* coupon_num = [self.item objectForKey:@"coupon_num"];
    str = [NSString stringWithFormat:@"优惠码：%@",coupon_num];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 16.0f;
    }
    
    str = [NSString stringWithFormat:@"最后价格：%@",[self.item objectForKey:@"final_price"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 24.0f;
    }
    
    line = CGRectMake(6,offset_y,[RCTool getScreenSize].width - 12, 0.5);
    UIRectFill(line);
    offset_y += 10.0f;
    
    str = [NSString stringWithFormat:@"状态：%@",[self.item objectForKey:@"order_state_text"]];
    if([str length])
    {
        [NAVIGATION_BAR_COLOR set];
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 30.0f;
    }
    
    [[UIColor grayColor] set];
    line = CGRectMake(6,offset_y,[RCTool getScreenSize].width - 12, 0.5);
    UIRectFill(line);
    offset_y += 10.0f;
    
    array = [self.item objectForKey:@"running_list"];
    if(array && [array isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* dic in array)
        {
            NSString* time = [dic objectForKey:@"time"];
            NSString* text = [dic objectForKey:@"text"];
            str = [NSString stringWithFormat:@"%@ %@",time,text];
            [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
            
            offset_y += 16.0f;
        }
    }
    
    offset_y += 8.0f;
    line = CGRectMake(6,offset_y,[RCTool getScreenSize].width - 12, 0.5);
    UIRectFill(line);
    offset_y += 10.0f;
    
    str = [NSString stringWithFormat:@"评分：%@",[self.item objectForKey:@"appraise"]];
    if([str length])
    {
        [NAVIGATION_BAR_COLOR set];
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 30.0f;
    }
    
    CGRect tempRect = self.frame;
    if(tempRect.size.height < offset_y)
        tempRect.size.height = offset_y;
    self.frame = tempRect;
    
    [[UIColor grayColor] set];
    line = CGRectMake(6,offset_y,[RCTool getScreenSize].width - 12, 0.5);
    UIRectFill(line);
    offset_y += 10.0f;
    
    str = [NSString stringWithFormat:@"%@",[self.item objectForKey:@"appraise_text"]];
    if([str length])
    {
        [str drawInRect:CGRectMake(offset_x, offset_y, [RCTool getScreenSize].width - 20.0f, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        offset_y += 24.0f;
    }
    
    for(int i = 110; i < 113; i++)
    {
        UIView* button = [self viewWithTag:i];
        CGRect buttonRect = button.frame;
        buttonRect.origin.y = self.bounds.size.height - 50.0;
        button.frame = buttonRect;
    }
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    [self setNeedsDisplay];
}

- (IBAction)clickedButton:(id)sender
{
    NSString* phoneNum = @"";
    UIButton* button = (UIButton*)sender;
    if(110 == button.tag)
    {
        phoneNum = [self.item objectForKey:@"service_tel"];
    }
    else if(111 == button.tag)
    {
        phoneNum = [self.item objectForKey:@"remover_tel"];
    }
    else if(112 == button.tag)
    {
        phoneNum = [self.item objectForKey:@"remover_linkman_tel"];
    }
    
    if([phoneNum isKindOfClass:[NSString class]] && [phoneNum length])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
    }
}

@end
