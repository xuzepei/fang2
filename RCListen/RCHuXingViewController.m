//
//  RCHuXingViewController.m
//  RCFang
//
//  Created by xuzepei on 4/8/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCHuXingViewController.h"
#import "RCHttpRequest.h"
#import "RCTool.h"
#import "RCFangInfoDongTaiCell.h"

#define AD_FRAME_HEIGHT 200.0

#define NAME_CELL_HEIGHT 30.0
#define CHANQUANMIANJI_CELL_HEIGHT 30.0
#define SHIDEMIANJI_CELL_HEIGHT 30.0
#define JIESHAO_CELL_HEIGHT 100.0

@interface RCHuXingViewController ()

@end

@implementation RCHuXingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        [self initAdScrollView];
        
    }
    return self;
}

- (void)dealloc
{
    self.adScrollView = nil;
    self.tableView = nil;
    self.detailInfo = nil;
    self.item = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [self initAdScrollView];
    
    [self initTableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.adScrollView = nil;
    self.tableView = nil;
}

- (void)updateContent:(NSDictionary*)item
{
    NSLog(@"item:%@",item);
    
    self.item = item;
    
    NSString* name = [self.item objectForKey:@"name"];
    self.title = name;
    
    NSString* id = [self.item objectForKey:@"id"];
    if(0 == [id length])
        return;
    
    NSString* urlString = [NSString stringWithFormat:@"%@/units.php?apiid=%@&pwd=%@&id=%@&ios=1",BASE_URL,APIID,PWD,id];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp request:urlString delegate:self resultSelector:@selector(finishedRequest:) token:nil];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }

}

- (void)finishedRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"result:%@",result);
        self.detailInfo = result;
        
        NSArray* imageArray = [self.detailInfo objectForKey:@"imgurl"];
        if(imageArray && [imageArray isKindOfClass:[NSArray class]])
        {
            [_adScrollView updateContent:imageArray];
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - AdScrollView

- (void)initAdScrollView
{
    self.adHeight = 0.0;
    if(nil == _adScrollView)
    {
        _adScrollView = [[RCAdScrollView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, AD_FRAME_HEIGHT)];
        
        self.adHeight = AD_FRAME_HEIGHT;
    }
    
    [self.view addSubview: _adScrollView];
}

#pragma mark - UITableView

- (void)initTableView
{
    if(nil == _tableView)
    {
        //init table view
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque = NO;
        _tableView.backgroundView = nil;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
	
	[self.view addSubview:_tableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize textSize = CGSizeZero;

    if(0 == indexPath.section)
    {
        if(0 == indexPath.row)
            return AD_FRAME_HEIGHT;
        else if(1 == indexPath.row)
            return NAME_CELL_HEIGHT;
        else if(2 == indexPath.row)
            return CHANQUANMIANJI_CELL_HEIGHT;
        else if(3 == indexPath.row)
            return SHIDEMIANJI_CELL_HEIGHT;
        else if(4 == indexPath.row)
        {
            NSString* intro = [_detailInfo objectForKey:@"intro"];
            if([intro length])
            {
                textSize = [intro sizeWithFont:[UIFont systemFontOfSize:12]
                            constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
            }
            
            return MAX(JIESHAO_CELL_HEIGHT,textSize.height);
        }
        else
            return 0;
    }

    return 0.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId0 = @"cellId0";
    static NSString *cellId1 = @"cellId1";
    static NSString *cellId4 = @"cellId4";
    
    UITableViewCell *cell = nil;
    
    if(0 ==  indexPath.section)
    {
        if(0 == indexPath.row)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId0];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                               reuseIdentifier: cellId0];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if(_adScrollView)
            {
                [cell addSubview:_adScrollView];
            }
        }
        else if(1 == indexPath.row || 2 == indexPath.row || 3 == indexPath.row)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                               reuseIdentifier: cellId1];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
            }

            if(_detailInfo)
            {
                if(1 == indexPath.row)
                {
                    NSString* temp = [_detailInfo objectForKey:@"name"];
                    if(0 == [temp length])
                        temp = @"未知";
                    cell.textLabel.text = [NSString stringWithFormat:@"户型: %@",temp];
                }
                else if(2 == indexPath.row)
                {
                    NSString* temp = [_detailInfo objectForKey:@"property_area"];
                    if(0 == [temp length])
                        temp = @"未知";
                    cell.textLabel.text = [NSString stringWithFormat:@"产权面积: %@",temp];
                }
                else if(3 == indexPath.row)
                {
                    NSString* temp = [_detailInfo objectForKey:@"actual_area"];
                    if(0 == [temp length])
                        temp = @"未知";
                    cell.textLabel.text = [NSString stringWithFormat:@"实得面积: %@",temp];
                }
            }
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId4];
            if (cell == nil)
            {
                cell = [[RCFangInfoDongTaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                               reuseIdentifier: cellId4];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            RCFangInfoDongTaiCell* temp = (RCFangInfoDongTaiCell*)cell;
            if(temp && _detailInfo)
            {
                NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
                [item setObject:@"户型介绍:" forKey:@"name"];
                
                NSString* desc = [_detailInfo objectForKey:@"intro"];
                if(0 == [desc length])
                    desc = @"未知";
                [item setObject:desc forKey:@"desc"];
                
                [temp updateContent:item];

            }
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

@end
