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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"空调数量" forKey:@"name"];
    NSMutableArray* mutableArray = [[NSMutableArray alloc] init];
    for(int i = 0; i <= 100; i++)
    {
        [mutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [dict setObject:mutableArray forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_0] forKey:@"tag"];
    self.selection0 = dict;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"保险柜数量" forKey:@"name"];
    mutableArray = [[NSMutableArray alloc] init];
    for(int i = 0; i <= 100; i++)
    {
        [mutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [dict setObject:mutableArray forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_1] forKey:@"tag"];
    self.selection1 = dict;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"隔断数量" forKey:@"name"];
    
    mutableArray = [[NSMutableArray alloc] init];
    for(int i = 0; i <= 100; i++)
    {
        [mutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [dict setObject:mutableArray forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_2] forKey:@"tag"];
    self.selection2 = dict;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"大型办公桌数量" forKey:@"name"];
    mutableArray = [[NSMutableArray alloc] init];
    for(int i = 0; i <= 100; i++)
    {
        [mutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [dict setObject:mutableArray forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_3] forKey:@"tag"];
    self.selection3 = dict;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"车辆类型" forKey:@"name"];
    NSArray* array = @[@"小车",@"中车",@"大车"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_4] forKey:@"tag"];
    self.selection4 = dict;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"车辆数量" forKey:@"name"];
    mutableArray = [[NSMutableArray alloc] init];
    for(int i = 1; i <= 100; i++)
    {
        [mutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [dict setObject:mutableArray forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_5] forKey:@"tag"];
    self.selection5 = dict;
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

- (IBAction)clickedNextButton:(id)sender
{
    NSString* username = [RCTool getUsername];
    if(0 == [username length])
    {
        [RCTool showAlert:@"提示" message:@"请先登录！"];
        return ;
    }
    
    if(-1 == self.selected_index0)
    {
        [RCTool showAlert:@"提示" message:@"请选择空调数量！"];
        return;
    }
    
    if(-1 == self.selected_index1)
    {
        [RCTool showAlert:@"提示" message:@"请选择保险柜数量！"];
        return;
    }
    
    if(-1 == self.selected_index2)
    {
        [RCTool showAlert:@"提示" message:@"请选择办公隔断数量！"];
        return;
    }
    
    if(-1 == self.selected_index3)
    {
        [RCTool showAlert:@"提示" message:@"请选择大型办公桌数量！"];
        return;
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
    
    NSArray* array = [self.selection0 objectForKey:@"values"];
    NSString* conditioner = [array objectAtIndex:self.selected_index0];
    
    array = [self.selection1 objectForKey:@"values"];
    NSString* safebox = [array objectAtIndex:self.selected_index1];
    
    array = [self.selection2 objectForKey:@"values"];
    NSString* partition = [array objectAtIndex:self.selected_index2];
    
    array = [self.selection3 objectForKey:@"values"];
    NSString* large_table = [array objectAtIndex:self.selected_index3];

    NSString* car_type = [NSString stringWithFormat:@"%d",self.selected_index4 + 1];
    
    array = [self.selection5 objectForKey:@"values"];
    NSString* car_count = [array objectAtIndex:self.selected_index5];
    
    NSString* other_question = self.textView.text;
    if(0 == [other_question length])
        other_question = @"";

//    order_num      -- 订单编号
//    conditioner    -- 空调数量
//    safebox        -- 保险柜数量
//    partition      -- 办公隔断数量
//    large_table    -- 大型办公桌数量
//    car_type       -- 车辆类型 1/2/3
//    car_count      -- 车辆数量
//    other_question  -- 其他贵重物品和需求
    
    NSString* urlString = [NSString stringWithFormat:@"%@/order_remover.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
 
    NSString* token = [NSString stringWithFormat:@"type=remover&step=4&username=%@&order_num=%@&conditioner=%@&safebox=%@&partition=%@&large_table=%@&car_type=%@&car_count=%@&other_question=%@",username,order_num,conditioner,safebox,partition,large_table,car_type,car_count,other_question];
    
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
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}


@end
