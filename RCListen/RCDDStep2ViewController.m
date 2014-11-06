//
//  RCDDStep2ViewController.m
//  RCFang
//
//  Created by xuzepei on 9/23/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDStep2ViewController.h"
#import "RCDDStep3ViewController.h"
#import "RCHttpRequest.h"

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

@interface RCDDStep2ViewController ()

@end

@implementation RCDDStep2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"填写详细信息";
        
        self.selected_index0 = -1;
        self.selected_index1 = -1;
        self.selected_index2 = -1;
        self.selected_index3 = -1;
        self.selected_index4 = -1;
        self.selected_index5 = -1;
        self.selected_index6 = -1;
        self.selected_index7 = -1;
        
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

    self.scrollView.contentSize = CGSizeMake([RCTool getScreenSize].width, 800);
    
    self.tf2.text = [self.item objectForKey:@"begin_address"];
    self.tf7.text = [self.item objectForKey:@"end_address"];
    
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
    [dict setObject:@"请选择搬家类别" forKey:@"name"];
    NSArray* array = @[@"住家",@"公司"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_0] forKey:@"tag"];
    self.selection0 = dict;
    self.selected_index0 = 0;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"请选择搬家需求" forKey:@"name"];
    array = @[@"全包",@"只要车"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_1] forKey:@"tag"];
    self.selection1 = dict;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"请选择楼层" forKey:@"name"];
    
    NSMutableArray* mutableArray = [[NSMutableArray alloc] init];
    for(int i = -3; i <= 100; i++)
    {
        if(0 == i)
            continue;
        
        [mutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [dict setObject:mutableArray forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_4] forKey:@"tag"];
    self.selection2 = dict;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"请选择是否电梯" forKey:@"name"];
    array = @[@"否",@"是"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_5] forKey:@"tag"];
    self.selection3 = dict;
    self.selected_index3 = 1;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"请选择是否可停车到楼下" forKey:@"name"];
    array = @[@"否",@"是"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_6] forKey:@"tag"];
    self.selection4 = dict;
    self.selected_index4 = 1;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"请选择楼层" forKey:@"name"];
    
    mutableArray = [[NSMutableArray alloc] init];
    for(int i = -3; i <= 100; i++)
    {
        if(0 == i)
            continue;
        
        [mutableArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [dict setObject:mutableArray forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_9] forKey:@"tag"];
    self.selection5 = dict;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"请选择是否电梯" forKey:@"name"];
    array = @[@"否",@"是"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_10] forKey:@"tag"];
    self.selection6 = dict;
    self.selected_index6 = 1;
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"请选择是否可停车到楼下" forKey:@"name"];
    array = @[@"否",@"是"];
    [dict setObject:array forKey:@"values"];
    [dict setObject:[NSNumber numberWithInt:TF_TAG_11] forKey:@"tag"];
    self.selection7 = dict;
    self.selected_index7 = 1;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(TF_TAG_3 == textField.tag || TF_TAG_8 == textField.tag)
    {
        return YES;
    }
    else {
        
        [self.tf3 resignFirstResponder];
        [self.tf8 resignFirstResponder];
        
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
        else if(TF_TAG_4 == textField.tag)
        {
            [_pickerView updateContent:self.selection2];
            [_pickerView show];
        }
        else if(TF_TAG_5 == textField.tag)
        {
            [_pickerView updateContent:self.selection3];
            [_pickerView show];
        }
        else if(TF_TAG_6 == textField.tag)
        {
            [_pickerView updateContent:self.selection4];
            [_pickerView show];
        }
        else if(TF_TAG_9 == textField.tag)
        {
            [_pickerView updateContent:self.selection5];
            [_pickerView show];
        }
        else if(TF_TAG_10 == textField.tag)
        {
            [_pickerView updateContent:self.selection6];
            [_pickerView show];
        }
        else if(TF_TAG_11 == textField.tag)
        {
            [_pickerView updateContent:self.selection7];
            [_pickerView show];
        }
        
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
    if(TF_TAG_3 == textField.tag || TF_TAG_8 == textField.tag)
    {
        NSString* numbers = @"0123456789-－";
        NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL b = [string isEqualToString:filtered];
        if(!b)
        {
            return NO;
        }
    }
    
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
    else if(TF_TAG_4 == tag)
    {
        self.selected_index2 = index;
        NSArray* array = [self.selection2 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [NSString stringWithFormat:@"%@楼",[array objectAtIndex:index]];
    }
    else if(TF_TAG_5 == tag)
    {
        self.selected_index3 = index;
        NSArray* array = [self.selection3 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [array objectAtIndex:index];
        
        if(0 == index)
        {
            [RCTool showAlert:@"温馨提示" message:@"无电梯每层加收50元"];
        }
    }
    else if(TF_TAG_6 == tag)
    {
        self.selected_index4 = index;
        NSArray* array = [self.selection4 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [array objectAtIndex:index];
        
        if(0 == index)
        {
            [RCTool showAlert:@"温馨提示" message:@"不能停车到楼下加收100元"];
        }
    }
    else if(TF_TAG_9 == tag)
    {
        self.selected_index5 = index;
        NSArray* array = [self.selection5 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [NSString stringWithFormat:@"%@楼",[array objectAtIndex:index]];
    }
    else if(TF_TAG_10 == tag)
    {
        self.selected_index6 = index;
        NSArray* array = [self.selection6 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [array objectAtIndex:index];
        
        if(0 == index)
        {
            [RCTool showAlert:@"温馨提示" message:@"无电梯每层加收50元"];
        }
    }
    else if(TF_TAG_11 == tag)
    {
        self.selected_index7 = index;
        NSArray* array = [self.selection7 objectForKey:@"values"];
        UITextField* tf = (UITextField*)[self.view viewWithTag:tag];
        tf.text = [array objectAtIndex:index];
        
        if(0 == index)
        {
            [RCTool showAlert:@"温馨提示" message:@"不能停车到楼下加收100元"];
        }
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
        [RCTool showAlert:@"提示" message:@"请选择搬家类型！"];
        return;
    }
    
//    if(-1 == self.selected_index1)
//    {
//        [RCTool showAlert:@"提示" message:@"请选择搬家方式！"];
//        return;
//    }
    
//    NSString* begin_room_num = self.tf3.text;
//    if(0 == [begin_room_num length])
//    {
//        [RCTool showAlert:@"提示" message:@"请输入起点房号！"];
//        return;
//    }
    
//    if(-1 == self.selected_index2)
//    {
//        [RCTool showAlert:@"提示" message:@"请选择起点楼层！"];
//        return;
//    }
    
    if(-1 == self.selected_index3)
    {
        [RCTool showAlert:@"提示" message:@"请选择是否电梯！"];
        return;
    }
    
    if(-1 == self.selected_index4)
    {
        [RCTool showAlert:@"提示" message:@"请选择是否可停车到楼下！"];
        return;
    }
    
//    NSString* end_room_num = self.tf8.text;
//    if(0 == [end_room_num length])
//    {
//        [RCTool showAlert:@"提示" message:@"请输入终点房号！"];
//        return;
//    }
    
    NSString* remover_type = [NSString stringWithFormat:@"%d",self.selected_index0 + 1];
//    NSString* remover_class = [NSString stringWithFormat:@"%d",self.selected_index1 + 1];
    
    NSString* order_num = [self.item objectForKey:@"order_num"];
    NSString* begin_address = [self.item objectForKey:@"begin_address"];
    
    NSString* begin_floor = @"";
    if(self.selected_index2 != -1)
    {
        NSArray* array = [self.selection2 objectForKey:@"values"];
        begin_floor = [array objectAtIndex:self.selected_index2];
    }
    
    NSString* begin_lift = [NSString stringWithFormat:@"%d",self.selected_index3];
    
    NSString* begin_park = [NSString stringWithFormat:@"%d",self.selected_index4];
    
    NSString* end_address = [self.item objectForKey:@"end_address"];
    
    NSString* end_floor = @"";
    if(self.selected_index5 != -1)
    {
        NSArray* array = [self.selection5 objectForKey:@"values"];
        end_floor = [array objectAtIndex:self.selected_index5];
    }
    
    NSString* end_lift = [NSString stringWithFormat:@"%d",self.selected_index6];
    
    NSString* end_park = [NSString stringWithFormat:@"%d",self.selected_index7];
    
    //    remover_type  -- 搬家类型
    //    remover_class -- 搬家方式
    //    order_num      -- 订单编号
    //    begin_address  -- 起点地址
    //    begin_room_num   -- 起点房号
    //    begin_floor      -- 起点楼层
    //    begin_lift       --起点是否有电梯
    //    begin_park       --起点是否可直接停楼下
    //    end_address  -- 终点地址
    //    end_room_num   -- 终点房号
    //    end_floor      -- 终点楼层
    //    end_lift       --终点是否有电梯
    //    end_park       --终点是否可直接停楼下
    
    NSString* urlString = [NSString stringWithFormat:@"%@/order_remover.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
    

    NSString* token = [NSString stringWithFormat:@"type=remover&step=3&username=%@&remover_type=%@&order_num=%@&begin_address=%@&begin_floor=%@&begin_lift=%@&begin_park=%@&end_address=%@&end_floor=%@&end_lift=%@&end_park=%@",username,remover_type,order_num,begin_address,begin_floor,begin_lift,begin_park,end_address,end_floor,end_lift,end_park];
    
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
            RCDDStep3ViewController* temp = [[RCDDStep3ViewController alloc] initWithNibName:nil bundle:nil];
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
