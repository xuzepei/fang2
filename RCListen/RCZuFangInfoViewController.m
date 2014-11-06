//
//  RCZuFangInfoViewController.m
//  RCFang
//
//  Created by xuzepei on 3/31/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCZuFangInfoViewController.h"
#import "RCTool.h"
#import "RCFangInfoJiaGeCell.h"
#import "RCFangInfoDiZhiCell.h"
#import "RCMapViewController.h"
#import "RCFangInfoDongTaiCell.h"
#import "RCPictureCategoryViewController.h"
#import "RCHttpRequest.h"
#import "RCSecondHandHouseXiaoQuCell.h"
#import "RCSecondHandHouseZouShiCell.h"
#import "RCCommentViewController.h"
#import "RCZuFangBaseInfoCell.h"
#import "RCZuFangListViewController.h"

#define AD_FRAME_HEIGHT 200.0

#define BASEINFO_CELL_HEIGHT 347.0
#define XIAOQU_CELL_HEIGHT 120.0
#define ZOUSHI_CELL_HEIGHT 185.0
#define DIZHI_CELL_HEIGHT 185.0
#define DONGTAI_CELL_HEIGHT 90.0
#define HUXING_CELL_HEIGHT 30.0
#define CANSHU_CELL_HEIGHT 400.0
#define JIESHAO_CELL_HEIGHT 200.0
#define JIAOTONG_CELL_HEIGHT 90.0
#define ZHOUBIAN_CELL_HEIGHT 30.0
#define TONGJIAWEI_CELL_HEIGHT 30.0

#define TOOLBAR_HEIGHT 50.0

@interface RCZuFangInfoViewController ()

@end

@implementation RCZuFangInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _itemArray = [[NSMutableArray alloc] init];
        
        [self initAdScrollView];
        
        [self initTableView];
        
        [self initContactToolbar];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showComment:) name:SHOW_COMMENT_NOTIFICATION object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.adScrollView = nil;
    self.tableView = nil;
    self.itemArray = nil;
    self.item = nil;
    self.toolbar = nil;
    self.callButton = nil;
    self.sendMessageButton = nil;
    self.detailInfo = nil;
    self.units = nil;
    self.delid = nil;
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    
    [self initAdScrollView];
    
    [self initTableView];
    
    [self initContactToolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.adScrollView = nil;
    self.tableView = nil;
    self.toolbar = nil;
    self.callButton = nil;
    self.sendMessageButton = nil;
}

- (void)clickedRightBarButtonItem:(id)sender
{
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    NSString* name = [self.item objectForKey:@"name"];
    self.title = name;
    
    NSString* id = [self.item objectForKey:@"id"];
    if(0 == [id length])
        return;
    
    NSString* urlString = [NSString stringWithFormat:@"%@/rent_content.php?apiid=%@&apikey=%@&id=%@&username=%@&ios=1",BASE_URL,APIID,PWD,id,[RCTool getUsername]];
    
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
        //NSLog(@"result:%@",result);
        self.detailInfo = result;
        
        NSArray* imageArray = [self.detailInfo objectForKey:@"imgurl"];
        if(imageArray && [imageArray isKindOfClass:[NSArray class]])
        {
            [_adScrollView updateContent:imageArray];
        }
        
        if(self.detailInfo)
        {
            if(_toolbar)
            [_toolbar updateContent:self.detailInfo];
        }
        
        NSArray* units = [self.detailInfo objectForKey:@"units"];
        if(units && [units isKindOfClass:[NSArray class]])
        {
            self.units = units;
        }
        
        NSString* favorite_id = [self.detailInfo objectForKey:@"favorite_id"];
        self.delid = favorite_id;
        
        [self updateFavoriteButton];
    }
    
    [_tableView reloadData];
}

#pragma mark - AdScrollView

- (void)initAdScrollView
{
    if(nil == _adScrollView)
    {
        _adScrollView = [[RCAdScrollView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, AD_FRAME_HEIGHT)];
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

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath
{
	if(indexPath.row >= [_itemArray count])
		return nil;
	
	return [_itemArray objectAtIndex: indexPath.row];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(0 == section)
        return TOOLBAR_HEIGHT + 2;
    
    return 0.0;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize textSize = CGSizeZero;
    NSString* desc = nil;
    
    if(0 == indexPath.row)
        return AD_FRAME_HEIGHT;
    else if(1 == indexPath.row)
        return BASEINFO_CELL_HEIGHT;
    else if(2 == indexPath.row)
    {
        desc = [_detailInfo objectForKey:@"h_intro"];
    }
    else if(3 == indexPath.row)
        return XIAOQU_CELL_HEIGHT;
    else if(4 == indexPath.row)
        return DIZHI_CELL_HEIGHT;
    else if(5 == indexPath.row)
    {
        desc = [_detailInfo objectForKey:@"supporting"];
    }
    else if(6 == indexPath.row)
    {
        desc = [_detailInfo objectForKey:@"traffic_supporting"];
    }
    else if(7 == indexPath.row)
    {
        return HUXING_CELL_HEIGHT;
    }
    else if(8 == indexPath.row)
    {
        return HUXING_CELL_HEIGHT;
    }
    
    
    if([desc length])
    {
        textSize = [desc sizeWithFont:[UIFont systemFontOfSize:12]
                    constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    }
    
    CGFloat height = 30 + MAX(20,textSize.height);
    return height;
    
    return 0.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId0 = @"cellId0";
    static NSString *cellId1 = @"cellId1";
    static NSString *cellId2 = @"cellId2";
    static NSString *cellId3 = @"cellId3";
    static NSString *cellId5 = @"cellId5";
    static NSString *cellId6 = @"cellId6";
    static NSString *cellId7 = @"cellId7";
    static NSString *cellId8 = @"cellId8";
    
    UITableViewCell *cell = nil;
    
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
    else if(1 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (cell == nil)
        {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RCZuFangBaseInfoCell" owner:self options:nil];
            cell = [objects objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(_detailInfo)
        {
            RCZuFangBaseInfoCell* temp = (RCZuFangBaseInfoCell*)cell;
            temp.name.text = [_detailInfo objectForKey:@"h_name"];
            temp.zujin.text = [_detailInfo objectForKey:@"h_price"];
            temp.mianji.text = [_detailInfo objectForKey:@"h_large"];
            temp.fangshi.text = [_detailInfo objectForKey:@"h_type"];
            temp.huxing.text = [_detailInfo objectForKey:@"h_unit"];
            temp.louceng.text = [_detailInfo objectForKey:@"h_floor"];
            temp.zhuangxiu.text = [_detailInfo objectForKey:@"h_decoration"];
            temp.chaoxiang.text = [_detailInfo objectForKey:@"h_face"];
            temp.ruzhu.text = [_detailInfo objectForKey:@"h_checkin_date"];
            temp.kanfang.text = [_detailInfo objectForKey:@"h_showtime"];
            temp.teshe.text = [_detailInfo objectForKey:@"h_special"];
            temp.shinei.text = [_detailInfo objectForKey:@"h_indoor_facilities"];
            temp.peitao.text = [_detailInfo objectForKey:@"h_facility"];
            temp.fabu.text = [_detailInfo objectForKey:@"h_releasetime"];
            
            
            NSString* title = [_detailInfo objectForKey:@"comment_num"];
            if(0 == [title length])
                title = @"0";
            [temp.commentButton setTitle:[NSString stringWithFormat:@"%@条评论",title]forState:UIControlStateNormal];
        }
    }
    else if(2 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if(cell == nil)
        {
            cell = [[RCFangInfoDongTaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                 reuseIdentifier: cellId2];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        RCFangInfoDongTaiCell* temp = (RCFangInfoDongTaiCell*)cell;
        if(temp && _detailInfo)
        {
            NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
            [item setObject:@"房源描述" forKey:@"name"];
            
            NSString* desc = [_detailInfo objectForKey:@"h_intro"];
            if([desc length])
                [item setObject:desc forKey:@"desc"];
            
            [temp updateContent:item];

        }
    }
    else if(3 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId3];
        if (cell == nil)
        {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RCSecondHandHouseXiaoQuCell" owner:self options:nil];
            cell = [objects objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(_detailInfo)
        {
            RCSecondHandHouseXiaoQuCell* temp = (RCSecondHandHouseXiaoQuCell*)cell;
            temp.xiaoqu.text = [_detailInfo objectForKey:@"name"];
            temp.quyu.text = [_detailInfo objectForKey:@"area"];
            temp.leixing.text = [_detailInfo objectForKey:@"property_type"];
            temp.shijian.text = [_detailInfo objectForKey:@"checkin_date"];
        }
    }
    else if(4 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId5];
        if (cell == nil)
        {
            cell = [[RCFangInfoDiZhiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                               reuseIdentifier: cellId5];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        RCFangInfoDiZhiCell* temp = (RCFangInfoDiZhiCell*)cell;
        [temp updateContent:_detailInfo];
    }
    else if(5 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId6];
        if(cell == nil)
        {
            cell = [[RCFangInfoDongTaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                 reuseIdentifier: cellId6];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        RCFangInfoDongTaiCell* temp = (RCFangInfoDongTaiCell*)cell;
        if(temp && _detailInfo)
        {
            NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
            [item setObject:@"周边配套" forKey:@"name"];
            
            NSString* desc = [_detailInfo objectForKey:@"supporting"];
            if([desc length])
                [item setObject:desc forKey:@"desc"];
            
            [temp updateContent:item];

        }
    }
    else if(6 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId7];
        if(cell == nil)
        {
            cell = [[RCFangInfoDongTaiCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                 reuseIdentifier: cellId7];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        RCFangInfoDongTaiCell* temp = (RCFangInfoDongTaiCell*)cell;
        if(temp && _detailInfo)
        {
            NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
            [item setObject:@"交通配套" forKey:@"name"];
            
            NSString* desc = [_detailInfo objectForKey:@"traffic_supporting"];
            if([desc length])
                [item setObject:desc forKey:@"desc"];
            
            [temp updateContent:item];

        }
    }
    else if(7 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId7];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId7];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.font = [UIFont systemFontOfSize:12];
        }
        
        cell.textLabel.text = @"同价位房源";
    }
    else if(8 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId8];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId8];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.font = [UIFont systemFontOfSize:12];
        }
        
        cell.textLabel.text = @"同小区房源";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(5 == indexPath.row)
    {
        if(_detailInfo)
        {
            RCMapViewController* temp = [[RCMapViewController alloc] initWithNibName:nil bundle:nil];
            [temp updateContent:[_detailInfo objectForKey:@"mapimg"]];
            [self.navigationController pushViewController:temp animated:YES];

        }
    }
    else if(4 == indexPath.row)
    {

    }
    else if(7 == indexPath.row)
    {
        if(_detailInfo)
        {
            RCZuFangListViewController* temp = [[RCZuFangListViewController alloc] initWithNibName:nil bundle:nil];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:@"price" info:_detailInfo];
            [self.navigationController pushViewController:temp animated:YES];

        }
    }
    else if(8 == indexPath.row)
    {
        if(_detailInfo)
        {
            RCZuFangListViewController* temp = [[RCZuFangListViewController alloc] initWithNibName:nil bundle:nil];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:@"same" info:_detailInfo];
            [self.navigationController pushViewController:temp animated:YES];

        }
    }
    
}

#pragma mark Contact Toolbar

- (void)initContactToolbar
{
    if(nil == _toolbar)
    {
        _toolbar = [[RCContactToolbar alloc] initWithFrame:CGRectMake(0, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TOOLBAR_HEIGHT, 320, TOOLBAR_HEIGHT)];
    }
    
    [self.view addSubview: _toolbar];
    
    if(nil == _callButton)
    {
        self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _callButton.frame = CGRectMake(260, 6, 40, 40);
        [_callButton setImage:[UIImage imageNamed:@"dadianhua"] forState:UIControlStateNormal];
        [_callButton addTarget:self action:@selector(clickedCallButton:) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview: _callButton];
    }
    
    if(nil == _sendMessageButton)
    {
        self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendMessageButton.frame = CGRectMake(210, 6, 40, 40);
        [_sendMessageButton setImage:[UIImage imageNamed:@"faduanxin"] forState:UIControlStateNormal];
        [_sendMessageButton addTarget:self action:@selector(clickedSendMessageButton:) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview: _sendMessageButton];
    }
}

- (void)clickedCallButton:(id)sender
{
    if(_detailInfo)
    {
        NSString* phoneNum = [_detailInfo objectForKey:@"broker_tel"];
        if([phoneNum isKindOfClass:[NSString class]] && [phoneNum length])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
        }
    }
}

- (void)clickedSendMessageButton:(id)sender
{
    if(_detailInfo)
    {
        NSString* phoneNum = [_detailInfo objectForKey:@"broker_tel"];
        if([phoneNum isKindOfClass:[NSString class]] && [phoneNum length])
        {
            [self sendMessage:[_detailInfo objectForKey:@"h_name"] number:phoneNum];
        }
    }
}

- (void)sendMessage:(NSString*)text number:(NSString*)number
{
    if(0 == [number length])
        return;
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if(messageClass)
    {
        if(NO == [MFMessageComposeViewController canSendText])
        {
            [RCTool showAlert:@"提示" message:@"设备没有短信功能"];
            return;
        }
    }
    else
    {
        [RCTool showAlert:@"提示" message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
        return;
    }
    
    MFMessageComposeViewController* compose = [[MFMessageComposeViewController alloc] init];
    
    compose.messageComposeDelegate = self;
    if([number length])
    compose.recipients = [NSArray arrayWithObject:number];
    compose.body = text;
    [self presentModalViewController:compose animated:YES];

}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
    
    switch ( result ) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
        {
            [RCTool showAlert:@"提示" message:@"短信发送成功!"];
            break;
        }
        default:
            break;
    }
    
}


- (void)showComment:(NSNotification*)noti
{
    NSString* id = [self.item objectForKey:@"id"];
    if(0 == [id length])
        return;
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:id,@"id",@"3",@"type",nil];
    
    RCCommentViewController* temp = [[RCCommentViewController alloc] initWithNibName:nil bundle:nil];
    [temp updateContent:dict];
    [self.navigationController pushViewController:temp animated:YES];
}


#pragma mark - Favorite

- (void)updateFavoriteButton
{
    BOOL b = [self.delid intValue] > 0;
    NSString* favoriteButtonText = b? @"取消收藏":@"收藏";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:favoriteButtonText style:UIBarButtonItemStylePlain target:self action:@selector(clickedFavoriteButton:)];
}

- (void)clickedFavoriteButton:(id)sender
{
    if(0 == [[RCTool getUsername] length])
    {
        [RCTool showAlert:@"提示" message:@"登录用户才能使用收藏功能!"];
        return;
    }
    
    NSString* hid = [self.item objectForKey:@"id"];
    if(0 == [hid length])
        return;
    
    NSString* urlString = nil;
    if([self.delid intValue])
    {
        urlString = [NSString stringWithFormat:@"%@/favorite.php?apiid=%@&apikey=%@&action=del&class=3&hid=%@&username=%@",BASE_URL,APIID,PWD,hid,[RCTool getUsername]];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@/favorite.php?apiid=%@&apikey=%@&action=add&class=3&hid=%@&username=%@",BASE_URL,APIID,PWD,hid,[RCTool getUsername]];
    }
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedFavoriteRequest:) token:nil];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedFavoriteRequest:(NSString*)jsonString
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
            NSString* favorite_id = [result objectForKey:@"favorite_id"];
            if([self.delid intValue])
            {
                self.delid = nil;
            }
            else
            {
                self.delid = favorite_id;
            }
            
            [self updateFavoriteButton];
            
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

@end
