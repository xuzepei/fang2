//
//  RCDDStep3ViewController.m
//  RCFang
//
//  Created by xuzepei on 9/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDStep3ViewController.h"
#import "RCDDStep4ViewController.h"
#import "RCHttpRequest.h"
#import "RCCountView.h"

@interface RCDDStep3ViewController ()

@end

enum {
    TF_TAG_0 = 200,
    TF_TAG_1,
    TF_TAG_2,
    TF_TAG_3,
    TF_TAG_4,
    TF_TAG_5,
    TF_TAG_6,
    TF_TAG_7,
    TF_TAG_8,
    TF_TAG_9,
    TF_TAG_10,
    TF_TAG_11,
    TF_TAG_12,
};

@implementation RCDDStep3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"填写物品信息";
        
        self.selected_index0 = -1;
        self.selected_index1 = -1;
        self.selected_index2 = -1;
        self.selected_index3 = -1;
        self.selected_index4 = -1;
        self.selected_index5 = -1;
        self.selected_index6 = -1;
        
        UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBackButton:)];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
    return self;
}

- (void)clickedBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //默认车辆选择
    NSArray* temparray = [self.selection4 objectForKey:@"values"];
    UITextField* tf = (UITextField*)[self.view viewWithTag:TF_TAG_4];
    tf.text = [temparray objectAtIndex:self.selected_index4];
    
    NSArray* cartype = [self.item objectForKey:@"cartype"];
    if(self.selected_index4 < [cartype count])
    {
        self.infoLabel2.text = [[cartype objectAtIndex:self.selected_index4] objectForKey:@"intro"];
    }
    
    self.scrollView.contentSize = CGSizeMake([RCTool getScreenSize].width, 800);
    
    NSString* intro = [self.item objectForKey:@"intro"];
    if([intro length])
        self.infoLabel.text = intro;
    
    NSString* car_type_text = [self.item objectForKey:@"car_type_text"];
    if([car_type_text length])
    {
        NSArray* array = [car_type_text componentsSeparatedByString:@","];
        
        if([array count])
        {
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"车辆类型" forKey:@"name"];
            [dict setObject:array forKey:@"values"];
            [dict setObject:[NSNumber numberWithInt:TF_TAG_4] forKey:@"tag"];
            self.selection4 = dict;
        }
    }
    
    [self initPickerView];
    
    //特殊物品
    NSString* urlString = [NSString stringWithFormat:@"%@/remover_special.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"remover_type=%@",[self.item objectForKey:@"remover_type"]];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedSpecialRequest:) token:token];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
    
    
    //不搬物品
    urlString = [NSString stringWithFormat:@"%@/remover_noservice.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    temp = [[RCHttpRequest alloc] init];
    b = [temp post:urlString delegate:self resultSelector:@selector(finishedBuBanRequest:) token:nil];
    if(b)
    {
        //[RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedSpecialRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            self.specialList = [result objectForKey:@"list"];
            
            CGFloat offset_y = 180.0f;
            int i = 0;
            for(NSDictionary* dict in self.specialList)
            {
                RCCountView* countView = [[RCCountView alloc] initWithFrame:CGRectMake(10, offset_y, 300, 50)];
                countView.tag = 1000 + i;
                [countView updateContent:dict];
                [self.scrollView addSubview:countView];
                
                offset_y += 50.0f;
                
                if(offset_y >= 680)
                    break;
                i++;
            }
            
            if(nil == _checkButton)
            {
                self.checkButton = [WRCheckButton buttonWithType:UIButtonTypeCustom];
                _checkButton.frame = CGRectMake(6, offset_y, 30, 30);
            }
            
            [_checkButton setChecked:NO];
            [_checkButton addTarget:self
                             action:@selector(clickedCheckButton:)
                   forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:_checkButton];
            
            CGRect rect = self.infoLabel3.frame;
            rect.origin.y = offset_y + 3;
            self.infoLabel3.frame = rect;
            NSString* noservice_intro = [self.item objectForKey:@"noservice_intro"];
            self.infoLabel3.text = noservice_intro;
            
            offset_y += 1.0f;
            rect = self.gzwpButton.frame;
            rect.origin.y = offset_y;
            self.gzwpButton.frame = rect;
            offset_y += rect.size.height + 10.0f;
            
            rect = self.infoLabel.frame;
            rect.origin.y = offset_y+ 3;
            self.infoLabel.frame = rect;
            offset_y += rect.size.height + 10.0f;
            
            rect = self.nextButton.frame;
            rect.origin.y = offset_y;
            self.nextButton.frame = rect;
            offset_y += rect.size.height + 10.0f;
            
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)finishedBuBanRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            self.bubanList = [result objectForKey:@"list"];
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;

    NSArray* cartype = [self.item objectForKey:@"cartype"];
    if([cartype count])
    {
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        for(NSDictionary* tempItem in cartype)
        {
            [tempArray addObject:[tempItem objectForKey:@"name"]];
        }
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"请选择车辆类型" forKey:@"name"];
        NSArray* array = tempArray;
        [dict setObject:array forKey:@"values"];
        [dict setObject:[NSNumber numberWithInt:TF_TAG_4] forKey:@"tag"];
        self.selection4 = dict;
        self.selected_index4 = 0;
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"请选择车辆数量" forKey:@"name"];
    NSMutableArray* mutableArray = [[NSMutableArray alloc] init];
    for(int i = 1; i <= 100; i++)
    {
        [mutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [dict setObject:mutableArray forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_5] forKey:@"tag"];
    self.selection5 = dict;
    self.selected_index5 = 0;
    
}

#pragma mark - UITextView

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.textView resignFirstResponder];
    
    if(TF_TAG_0 == textField.tag)
    {
        [_pickerView updateContent:self.selection0];
        [_pickerView show];
    }
    else if(TF_TAG_1 == textField.tag)
    {
        [_pickerView updateContent:self.selection1];
        [_pickerView show];
    }
    else if(TF_TAG_2 == textField.tag)
    {
        [_pickerView updateContent:self.selection2];
        [_pickerView show];
    }
    else if(TF_TAG_3 == textField.tag)
    {
        [_pickerView updateContent:self.selection3];
        [_pickerView show];
    }
    else if(TF_TAG_4 == textField.tag)
    {
        [_pickerView updateContent:self.selection4];
        [_pickerView show];
    }
    else if(TF_TAG_5 == textField.tag)
    {
        [_pickerView updateContent:self.selection5];
        [_pickerView show];
    }
    else if(TF_TAG_6 == textField.tag)
    {
        [_pickerView updateContent:self.selection6];
        [_pickerView show];
    }

    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
//    if(TF_TAG_3 == textField.tag || TF_TAG_8 == textField.tag)
//    {
//        NSString* numbers = @"0123456789-－";
//        NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        BOOL b = [string isEqualToString:filtered];
//        if(!b)
//        {
//            return NO;
//        }
//    }
    
    return YES;
}

#pragma mark - Picker View

- (void)initPickerView
{
    if(nil == _pickerView)
    {
        _pickerView = [[RCPickerView alloc] initWithFrame:CGRectMake(0, [RCTool getScreenSize].height, [RCTool getScreenSize].width, PICKER_VIEW_HEIGHT)];
        _pickerView.delegate = self;
    }
}

- (void)clickedSureValueButton:(int)index token:(id)token
{
    if(nil == token || -1 == index)
        return;
    
    NSDictionary* dict = (NSDictionary*)token;
    int tag = [[dict objectForKey:@"tag"] intValue];
    if(TF_TAG_0 == tag)
    {
        self.selected_index0 = index;
        NSArray* array = [self.selection0 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [array objectAtIndex:index];
    }
    else if(TF_TAG_1 == tag)
    {
        self.selected_index1 = index;
        NSArray* array = [self.selection1 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [array objectAtIndex:index];
    }
    else if(TF_TAG_2 == tag)
    {
        self.selected_index2 = index;
        NSArray* array = [self.selection2 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [array objectAtIndex:index];
    }
    else if(TF_TAG_3 == tag)
    {
        self.selected_index3 = index;
        NSArray* array = [self.selection3 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [array objectAtIndex:index];
    }
    else if(TF_TAG_4 == tag)
    {
        self.selected_index4 = index;
        NSArray* array = [self.selection4 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [array objectAtIndex:index];
        
        NSArray* cartype = [self.item objectForKey:@"cartype"];
        if(self.selected_index4 < [cartype count])
        {
            self.infoLabel2.text = [[cartype objectAtIndex:self.selected_index4] objectForKey:@"intro"];
        }
    }
    else if(TF_TAG_5 == tag)
    {
        self.selected_index5 = index;
        NSArray* array = [self.selection5 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [NSString stringWithFormat:@"%@辆",[array objectAtIndex:index]];
    }

}

#pragma mark -

- (void)clickedCheckButton:(id)sender
{
    BOOL b = [_checkButton isChecked]?NO:YES;
    [_checkButton setChecked:b];
}

- (IBAction)clickedBuBanButton:(id)sender
{
    NSLog(@"clickedBuBanButton");
    
    if(_pickerView && [_bubanList count])
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"以下物品恕不搬运，详情请致电客服" forKey:@"name"];
        [dict setObject:_bubanList forKey:@"values"];
        [_pickerView updateContent:dict];
        [_pickerView show];
    }
}

- (IBAction)clickedNextButton:(id)sender
{
    NSString* username = [RCTool getUsername];
    if(0 == [username length])
    {
        [RCTool showAlert:@"提示" message:@"请先登录！"];
        return ;
    }

    if(-1 == self.selected_index4)
    {
        [RCTool showAlert:@"提示" message:@"请选择车辆类型！"];
        return;
    }
    
    if(-1 == self.selected_index5)
    {
        [RCTool showAlert:@"提示" message:@"请选择车辆数量！"];
        return;
    }
    
    NSString* order_num = [self.item objectForKey:@"order_num"];

    NSString* car_type = [NSString stringWithFormat:@"%d",self.selected_index4 + 1];
    
    NSArray* array = [self.selection5 objectForKey:@"values"];
    NSString* car_count = [array objectAtIndex:self.selected_index5];
    
    NSString* exp_item = [_checkButton isChecked]?@"1":@"0";
    NSMutableString* other_item = [[NSMutableString alloc] init];
    NSMutableString* other_item_count = [[NSMutableString alloc] init];
    
    [other_item appendString:@"{"];
    [other_item_count appendString:@"{"];
    
    
    if([self.specialList count])
    {
        int i = 0;
        for(NSDictionary* dict in self.specialList)
        {
            RCCountView* countView = (RCCountView*)[self.scrollView viewWithTag:1000 + i];
            if(countView)
            {
                if(i != 0)
                {
                   [other_item appendString:@"|"];
                   [other_item_count appendString:@"|"];
                }
                    
                
                NSString* id = [dict objectForKey:@"id"];
                NSString* count = [NSString stringWithFormat:@"%d",countView.count];
                [other_item appendString:id];
                [other_item_count appendString:count];
            }
            
            i++;
        }
    }
    
    [other_item appendString:@"}"];
    [other_item_count appendString:@"}"];



//    order_num      -- 订单编号
//    car_type        -- 车辆类型
//    car_count       -- 车辆数量
//    exp_item       -- 是否有不能搬的贵重物品
//    other_item     -- 其他特殊物品的ID号，组成字符串 {1|2|3}
//    other_item_count   -- 其他特殊物品的数量{0|0|1}
    
    NSString* urlString = [NSString stringWithFormat:@"%@/order_remover.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
 
    NSString* token = [NSString stringWithFormat:@"type=remover&step=4&username=%@&order_num=%@&car_type=%@&car_count=%@&exp_item=%@&other_item=%@&other_item_count=%@",username,order_num,car_type,car_count,exp_item,other_item,other_item_count];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedPostRequest:) token:token];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedPostRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            RCDDStep4ViewController* temp = [[RCDDStep4ViewController alloc] initWithNibName:nil bundle:nil];
            NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
            [item addEntriesFromDictionary:self.item];
            [item addEntriesFromDictionary:result];
            [temp updateContent:item];
            [self.navigationController pushViewController:temp animated:YES];
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}


@end
