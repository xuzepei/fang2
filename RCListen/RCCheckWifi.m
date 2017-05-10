//
//  RCCheckWifi.m
//  RCFang
//
//  Created by xuzepei on 09/05/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import "RCCheckWifi.h"
#import "RCWebViewController.h"

@implementation RCCheckWifi

+ (RCCheckWifi*)sharedInstance
{
    static RCCheckWifi* shareInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [RCCheckWifi new];
    });
    
    return shareInstance;
}

- (void)checkWifiConnection
{
    if(self.isChecking)
        return;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString* urlString = [@"http://www.baidu.com" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:5];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    
    BOOL isSuccess = YES;
    
    NSURLConnection * urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (urlConnection)
    {
        self.isChecking = YES;
        [RCTool showIndicator:@"检测中..."];
    }
    else
    {
        isSuccess = NO;
    }
    
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    
    NSLog(@"----will send request\n%@", [request URL]);
    NSLog(@"----redirect response\n%@", [response URL]);
    
    NSString* redirectUrl = [response URL].absoluteString;
    if(redirectUrl.length)
    {
        NSRange range =  [redirectUrl rangeOfString:@"wlanstamac"];
        if(range.location != NSNotFound)
        {
            NSString* temp = [redirectUrl substringFromIndex:range.location+range.length+1];
            range = [temp rangeOfString:@"&"];
            if(range.location != NSNotFound)
            {
                NSString* macAddress = [temp substringToIndex:range.location];
                if(macAddress.length)
                    [RCTool saveMacAddress:macAddress];
            }
        }
    }
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.httpStatusCode = [(NSHTTPURLResponse*)response statusCode];
    NSDictionary* header = [(NSHTTPURLResponse*)response allHeaderFields];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.isChecking = NO;
    [RCTool hideIndicator];
    
    NSLog(@"checkWifiConnection, finish:%d",self.httpStatusCode);
    
    if(200 == self.httpStatusCode)
    {
        if([RCTool isReachableViaWiFi])
        {
            NSString* wifiName = [RCTool getWifiName];
            NSString* phoneNumber = [RCTool getPhoneNumber];
            
            UINavigationController* naviController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            
            if([naviController.topViewController isKindOfClass:[RCWebViewController class]])
                return;
            
            if([phoneNumber length])
            {
                NSString* urlString = [NSString stringWithFormat:@"http://downapp.tfeyes.com:8081/home/index/onlinestatus.html?macaddress=%@&wifiname=%@&gdmobile=%@",@"",wifiName,phoneNumber];
                RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
                temp.hidesBottomBarWhenPushed = YES;
                [temp updateContent:urlString title:nil];
                
                UINavigationController* naviController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                [naviController pushViewController:temp animated:YES];
            }
        }
    }
    else if(302 == self.httpStatusCode)
    {
        if([RCTool isReachableViaWiFi])
        {
            UINavigationController* naviController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            if([naviController.topViewController isKindOfClass:[RCWebViewController class]])
                return;
            
            NSString* urlString = [NSString stringWithFormat:@"http://www.baidu.com"];
            RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:urlString title:nil];
            
            [naviController pushViewController:temp animated:YES];
        }
    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    self.isChecking = NO;
    [RCTool hideIndicator];

    NSLog(@"checkWifiConnection, fail:%d",self.httpStatusCode);
    
    if(302 == self.httpStatusCode)
    {
        if([RCTool isReachableViaWiFi])
        {
            UINavigationController* naviController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            if([naviController.topViewController isKindOfClass:[RCWebViewController class]])
                return;
            
            NSString* urlString = [NSString stringWithFormat:@"http://www.baidu.com"];
            RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:urlString title:nil];
            
            [naviController pushViewController:temp animated:YES];
        }
    }
    else
    {
        
    }
    
}

@end
