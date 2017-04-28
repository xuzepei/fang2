//
//  RCDDStep6ViewController.m
//  RCFang
//
//  Created by xuzepei on 10/26/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCDDStep6ViewController.h"
#import "RCWebViewController.h"
//#import "AlixLibService.h"
//#import "DataSigner.h"
//#import "AlixPayResult.h"
//#import "DataVerifier.h"
//#import "AlixPayOrder.h"

@interface RCDDStep6ViewController ()

@end

@implementation RCDDStep6ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"订单支付";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self updateContent:self.item];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (void)updateContent:(NSDictionary*)item
{
    self.item = item;
    
    self.tf0.text = [self.item objectForKey:@"order_num"];
    self.tf1.text = [RCTool getUsername];
    self.tf2.text = [self.item objectForKey:@"order_price"];
}

- (IBAction)clickedNextButton:(id)sender
{
//    NSString* urlString = [NSString stringWithFormat:@"%@/alipay/alipayapi.php?apiid=%@&apikey=%@&order_num=%@&username=%@&order_price=%@",BASE_URL,APIID,PWD,[self.item objectForKey:@"order_num"],[RCTool getUsername],[self.item objectForKey:@"order_price"]];
//    
//    RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
//    temp.hidesBottomBarWhenPushed = YES;
//    [temp updateContent:urlString title:nil];
//    [self.navigationController pushViewController:temp animated:YES];
    
    if(nil == self.item)
        return;
    
    NSString *appScheme = SCHEME_FOR_ALIPAY;
    NSString* orderInfo = [self getOrderInfo];
    NSString* signedStr = [self doRsa:orderInfo];
    
    NSLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
    
//    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
}

-(void)paymentResult:(NSString *)resultd
{
//    //结果处理
//#if ! __has_feature(objc_arc)
//    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
//#else
//    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
//#endif
//    if (result)
//    {
//        
//        if (result.statusCode == 9000)
//        {
//            /*
//             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
//             */
//            
//            //交易成功
//            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
//            id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//            
//            if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                //验证签名成功，交易结果无篡改
//                NSLog(@"验证签名成功，交易结果无篡改");
//            }
//            
//            [RCTool showAlert:@"提示" message:@"交易成功"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//        else
//        {
//            //交易失败
//        }
//    }
//    else
//    {
//        //失败
//    }
//    
//    NSLog(@"//失败");
}


- (NSString*)getOrderInfo
{

//    AlixPayOrder *order = [[AlixPayOrder alloc] init];
//    order.partner = PartnerID;
//    order.seller = SellerID;
//    
//    order.tradeNO = [self.item objectForKey:@"order_num"]; //订单ID（由商家自行制定）
//    order.productName = [NSString stringWithFormat:@"%@购买搬家服务",[RCTool getUsername]]; //商品标题
//    order.productDescription = @"搬家服务"; //商品描述
//    order.amount = [self.item objectForKey:@"order_price"]; //商品价格
//    order.notifyURL =  [NSString stringWithFormat:@"%@/alipay/notify.php",BASE_URL]; //回调URL
//    
//    return [order description];
    
        return @"";
}

-(NSString*)doRsa:(NSString*)orderInfo
{
//    id<DataSigner> signer;
//    signer = CreateRSADataSigner(PartnerPrivKey);
//    NSString *signedString = [signer signString:orderInfo];
//    return signedString;
    
        return @"";
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}


@end
