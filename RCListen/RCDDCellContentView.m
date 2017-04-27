//
//  RCDDCellContentView.m
//  RCFang
//
//  Created by xuzepei on 6/18/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDCellContentView.h"

#define LINE_COLOR [RCTool colorWithHex:0xcccccc]
#define FONT_SIZE 15
#define BUTTON_RECT CGRectMake(220,self.bounds.size.height - 36,89,29)
#define BLUE_TEXT_COLOR [RCTool colorWithHex:0x02a3f1]

@implementation RCDDCellContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        _yzLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _yzLabel.font = [UIFont systemFontOfSize:15];
        _yzLabel.textColor = [UIColor blackColor];
        _yzLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_yzLabel];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(self.item)
    {
        CGFloat offset_x = 10.0f;
        CGFloat offset_y = 0.0f;
        NSString* ddbh = [self.item objectForKey:@"ddbh"];
        if([ddbh length])
        {
            offset_y += 6.0f;
            CGSize size = [@"订单编号: " drawInRect:CGRectMake(offset_x, offset_y, 200, 16) withFont:[UIFont systemFontOfSize:FONT_SIZE] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
            
            size = [ddbh drawInRect:CGRectMake(offset_x + size.width + 2, offset_y, 220, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:FONT_SIZE] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
            
            offset_y += MAX(size.height, 16) +6.0f;
        }
        
        NSString* bx = [self.item objectForKey:@"bx"];
        if([bx length])
        {
            NSString* temp = [NSString stringWithFormat:@"保险: %@",bx];
            [temp drawInRect:CGRectMake(170, offset_y, 130, 16) withFont:[UIFont systemFontOfSize:FONT_SIZE] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
        }
        
        NSString* fwxq = [self.item objectForKey:@"fwxq"];
        if([fwxq length])
        {
            CGSize size = [@"服务详情: " drawInRect:CGRectMake(offset_x, offset_y, 200, 16) withFont:[UIFont systemFontOfSize:FONT_SIZE] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
            
            size = [fwxq drawInRect:CGRectMake(offset_x + size.width + 2, offset_y, 80, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:FONT_SIZE] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
            
            offset_y += MAX(size.height, 16);
        }
        
        NSString* yq = [self.item objectForKey:@"yq"];
        if([yq length])
        {
            offset_y += 6.0f;
            CGSize size = [@"要求: " drawInRect:CGRectMake(offset_x, offset_y, 200, 16) withFont:[UIFont systemFontOfSize:FONT_SIZE] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
            
            size = [yq drawInRect:CGRectMake(offset_x + size.width + 2, offset_y, 240, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:FONT_SIZE] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
            
            offset_y += MAX(size.height, 16);
        }
    }
    
    [LINE_COLOR set];
    CGRect lineRect = CGRectMake(5, self.bounds.size.height - 44, self.bounds.size.width - 10, 1);
    UIRectFill(lineRect);
    
    UIImage* ztImage = [UIImage imageNamed:@"yifb"];
    if(ztImage)
    {
        [ztImage drawInRect:CGRectMake(12, self.bounds.size.height - 30, ztImage.size.width, ztImage.size.height)];
        
        NSString* temp = @"已发布";
        if([temp length])
        {
            NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
            style.alignment = NSTextAlignmentLeft;
            style.lineBreakMode = NSLineBreakByWordWrapping;
            
            [temp drawInRect:CGRectMake(30, self.bounds.size.height - 32, 200, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                                    NSForegroundColorAttributeName:BLUE_TEXT_COLOR,
                                                                                                    NSParagraphStyleAttributeName:style}];
        }
        
    }
    
    UIImage* buttonImage = [UIImage imageNamed:_isSelectedButton?@"quxdd_on":@"quxdd"];
    if(buttonImage)
        [buttonImage drawInRect:BUTTON_RECT];
}

- (void)updateContent:(NSDictionary*)item delegate:(id)delegate token:(NSDictionary*)token
{
    [super updateContent:item delegate:delegate token:token];
    
    _yzLabel.frame = CGRectMake(80, self.bounds.size.height - 32, 130, 20);
    
    NSString* yz = [self.item objectForKey:@"yz"];
    if(0 == [yz length])
        yz = @"0";
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"有 %@ 家商户应征",yz]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:BLUE_TEXT_COLOR range:NSMakeRange(2,[yz length])];
    _yzLabel.attributedText = attributedString;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(CGRectContainsPoint(BUTTON_RECT, point))
    {
        self.isSelectedButton = YES;
        [self setNeedsDisplay];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.isSelectedButton = NO;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.isSelectedButton = NO;
    [self setNeedsDisplay];
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(CGRectContainsPoint(BUTTON_RECT, point))
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickedButton:)])
        {
            [self.delegate clickedButton:self.item];
        }
    }
}


@end
