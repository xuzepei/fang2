//
//  RCShuiFeiViewController.m
//  RCFang
//
//  Created by xuzepei on 3/16/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCShuiFeiViewController.h"
#import "RCTool.h"
#import "RCShuiFeiResultViewController.h"

#define DANJIA_TAG 100
#define MIANJI_TAG 101

@interface RCShuiFeiViewController ()

@end

@implementation RCShuiFeiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
		self.title = @"税费计算器";
        
        _itemArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self initTextFields];
    
    [self initTableView];
    
    [self initButtons];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.tableView = nil;
    self.danjiaTF = nil;
    self.mianjiTF = nil;
}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        _tableView.dataSource = self;
    }
	
	[self.view addSubview:_tableView];
    
    if(0 == [_itemArray count])
    {
        [_itemArray addObject:@"单价: "];
        [_itemArray addObject:@"面积: "];
    }
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath
{
	if(indexPath.row >= [_itemArray count])
		return nil;
	
	return [_itemArray objectAtIndex: indexPath.row];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_itemArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    static NSString *cellId1 = @"cellId1";
    
    UITableViewCell *cell = nil;
    
    if(0 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(200, 12, 100, 20)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = UITextAlignmentRight;
            label.text = @"元／平米";
            [cell addSubview: label];
        }
        
        [cell addSubview:_danjiaTF];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId1];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(200, 12, 100, 20)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = UITextAlignmentRight;
            label.text = @"平米";
            [cell addSubview: label];
        }
        
        [cell addSubview:_mianjiTF];
    }
    
    NSString* item  = [self getCellDataAtIndexPath:indexPath];
    cell.textLabel.text = item;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark Buttons

- (void)initButtons
{
    if(nil == _calculateButton)
    {
        self.calculateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _calculateButton.frame = CGRectMake(40, 140, 240, 40);
        //        [_loginButton setImage:[UIImage imageNamed:@"location_button"] forState:UIControlStateNormal];
        [_calculateButton setTitle:@"开始计算" forState:UIControlStateNormal];
        [_calculateButton addTarget:self action:@selector(clickedCalculateButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview: _calculateButton];
    }
    
}

- (NSDictionary*)getResult
{
    if(0 == [_danjiaTF.text length] || [_danjiaTF.text hasPrefix:@"."] || [_danjiaTF.text hasSuffix:@"."])
    {
        [RCTool showAlert:@"提示" message:@"请输入正确的单价"];
        return nil;
    }
    
    if(0 == [_mianjiTF.text length] || [_mianjiTF.text hasPrefix:@"."] || [_mianjiTF.text hasSuffix:@"."])
    {
        [RCTool showAlert:@"提示" message:@"请输入正确的面积"];
        return nil;
    }
    
//    function runjs3(obj){
//        dj3 = parseFloat(obj.dj3.value);
//        mj3 = parseFloat(obj.mj3.value);
//        fkz3 = dj3 * mj3;
//        yh = fkz3 * 0.0005;
//        if(dj3 <= 9432) q = fkz3 * 0.015;
//        else if(dj3 > 9432) q = fkz3 * 0.03;
//        if(mj3 <= 120) fw = 500;
//        else if(120 < mj3 <= 5000) fw = 1500;
//        if(mj3 > 5000) fw = 5000;
//        gzh = fkz3 * 0.003;
//        obj.yh.value = Math.round(yh * 100,5) / 100;
//        obj.fkz3.value = Math.round(fkz3 * 100,5) / 100;
//        obj.q.value = Math.round(q * 100,5) / 100;
//        obj.gzh.value = Math.round(gzh * 100,5) / 100;
//        obj.wt.value = Math.round(gzh * 100,5) / 100;
//        obj.fw.value = Math.round(fw * 100,5) / 100;
//    }

    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    float danjia = [_danjiaTF.text floatValue];
    float mianji = [_mianjiTF.text floatValue];
    float zongjia = danjia * mianji;
    float yinhuashui = zongjia * 0.0005;
    float fangwumaimaishouxufei = 0.0;
    float gongzhengfei = 0.0;
    float weituofei = 0.0;
    float qishui = 0.0;
    if(danjia <= 9432)
        qishui = zongjia * 0.015;
    else
        qishui = zongjia * 0.003;
    
    if(mianji <= 120)
        fangwumaimaishouxufei = 500;
    else if(mianji > 120 && mianji <= 5000)
        fangwumaimaishouxufei = 1500;
    else if(mianji > 5000)
        fangwumaimaishouxufei = 5000;
    
    gongzhengfei = zongjia * 0.003;
        
    //weituofei = gongzhengfei;//foo
    
    zongjia = round(zongjia*100)/100;
    yinhuashui = round(yinhuashui*100)/100;
    gongzhengfei = round(gongzhengfei*100)/100;
    qishui = round(qishui*100)/100;
    weituofei = gongzhengfei;
    fangwumaimaishouxufei = round(fangwumaimaishouxufei*100)/100;
    
    [result setObject:[NSString stringWithFormat:@"%.2f",zongjia] forKey:@"zongjia"];
    [result setObject:[NSString stringWithFormat:@"%.2f",yinhuashui] forKey:@"yinhuashui"];
    [result setObject:[NSString stringWithFormat:@"%.2f",gongzhengfei] forKey:@"gongzhengfei"];
    [result setObject:[NSString stringWithFormat:@"%.2f",qishui] forKey:@"qishui"];
    [result setObject:[NSString stringWithFormat:@"%.2f",weituofei] forKey:@"weituofei"];
    [result setObject:[NSString stringWithFormat:@"%.2f",fangwumaimaishouxufei] forKey:@"fangwumaimaishouxufei"];
    
    return result;
    
}

- (void)clickedCalculateButton:(id)sender
{
    NSDictionary* result = [self getResult];
    if(result)
    {
        RCShuiFeiResultViewController* temp = [[RCShuiFeiResultViewController alloc] initWithNibName:nil bundle:nil];
        [temp updateContent:result];
        [self.navigationController pushViewController:temp animated:YES];

    }
}

#pragma mark - TextFields

- (void)initTextFields
{
    if(nil == _danjiaTF)
    {
        _danjiaTF = [[UITextField alloc] initWithFrame:CGRectMake(70, 12, 160, 30)];
        _danjiaTF.tag = DANJIA_TAG;
        _danjiaTF.backgroundColor = [UIColor clearColor];
        _danjiaTF.borderStyle = UITextBorderStyleNone;
        _danjiaTF.font = [UIFont systemFontOfSize:16];
        _danjiaTF.placeholder = @"请输入单价";
        _danjiaTF.returnKeyType = UIReturnKeyDone;
        _danjiaTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _danjiaTF.delegate = self;
    }
    
    if(nil == _mianjiTF)
    {
        _mianjiTF = [[UITextField alloc] initWithFrame:CGRectMake(70, 12, 160, 30)];
        _mianjiTF.tag = MIANJI_TAG;
        _mianjiTF.backgroundColor = [UIColor clearColor];
        _mianjiTF.borderStyle = UITextBorderStyleNone;
        _mianjiTF.font = [UIFont systemFontOfSize:16];
        _mianjiTF.placeholder = @"请输入面积";
        _mianjiTF.returnKeyType = UIReturnKeyDone;
        _mianjiTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _mianjiTF.delegate = self;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString* numbers = @"0123456789.";
    NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL b = [string isEqualToString:filtered];
    if(!b)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    
    if(DANJIA_TAG == textField.tag)
    {
        if([textField.text hasPrefix:@"."] || [textField.text hasSuffix:@"."])
        {
            [RCTool showAlert:@"提示" message:@"请输入正确的单价"];
            return NO;
        }
        
        [_mianjiTF becomeFirstResponder];
    }
    else if(MIANJI_TAG == textField.tag)
    {
        if([textField.text hasPrefix:@"."] || [textField.text hasSuffix:@"."])
        {
            [RCTool showAlert:@"提示" message:@"请输入正确的面积"];
            return NO;
        }
        
        [_mianjiTF resignFirstResponder];
    }
    
    return YES;
}


@end
