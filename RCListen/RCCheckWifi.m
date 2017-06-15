//
//  RCCheckWifi.m
//  RCFang
//
//  Created by xuzepei on 09/05/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import "RCCheckWifi.h"
#import "RCWebViewController.h"
#import "UIView+Toast.h"

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
    
    self.isRedirected = NO;
    
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
    
    self.httpStatusCode = [(NSHTTPURLResponse*)response statusCode];
    
    NSString* redirectUrl = [response URL].absoluteString;
    if(self.httpStatusCode == 302 && redirectUrl.length)
    {
        [RCTool showText:[NSString stringWithFormat:@"++++重定向url：%@",redirectUrl]];
        
        NSRange range =  [redirectUrl rangeOfString:@"&ip="];
        if(range.location != NSNotFound)
        {
            NSString* temp = [redirectUrl substringFromIndex:range.location+range.length];
            range = [temp rangeOfString:@"&"];
            if(range.location != NSNotFound)
            {
                NSString* ipAddress = [temp substringToIndex:range.location];
                if(ipAddress.length)
                {
                    [RCTool showText:[NSString stringWithFormat:@"+++++获取到的IP地址：%@",ipAddress]];
                    [RCTool saveIPAddress:ipAddress];
                }
                
                
                //mac address
                NSRange range = [temp rangeOfString:@"&mac="];
                if(range.location != NSNotFound)
                {
                    temp = [temp substringFromIndex:range.location+range.length];
                    
                    range = [temp rangeOfString:@"&"];
                    if(range.location != NSNotFound)
                    {
                        NSString* macAddress = [temp substringToIndex:range.location];
                        if(macAddress.length)
                        {
                            [RCTool showText:[NSString stringWithFormat:@"+++++获取到的mac：%@",macAddress]];
                            [RCTool saveMacAddress:macAddress];
                        }
                    }
                }
            }
            
            
            self.isRedirected = YES;
            return nil;
        }
    }
    
    return request;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.httpStatusCode = [(NSHTTPURLResponse*)response statusCode];
    
    [RCTool showText:[NSString stringWithFormat:@"-----，HTTP状态码：%d",self.httpStatusCode]];
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

    if(/*200 == self.httpStatusCode &&*/ [RCTool isReachableViaWiFi] && self.isRedirected == NO) //已连接
    {
            UINavigationController* naviController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            
            if([naviController.topViewController isKindOfClass:[RCWebViewController class]])
                return;
            
            NSString* urlString = [NSString stringWithFormat:@"http://downapp.tfeyes.com:8081/auth/wifidogAuth/portal.html"];
            RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
            temp.needToChangeTitle = YES;
            temp.hidesBottomBarWhenPushed = YES;
            [temp updateContent:urlString title:@"上WiFi"];
            
            [naviController pushViewController:temp animated:YES];
    }
    else
    {
        [self goToBaidu];
    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    self.isChecking = NO;
    [RCTool hideIndicator];

    NSLog(@"checkWifiConnection, fail:%d",self.httpStatusCode);
    
    [RCTool showText:[NSString stringWithFormat:@"访问baidu失败，HTTP状态码：%d",self.httpStatusCode]];
    

    [self goToBaidu];

}

- (void)goToBaidu
{
    UINavigationController* naviController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    if([naviController.topViewController isKindOfClass:[RCWebViewController class]])
        return;
    
    NSString* urlString = [NSString stringWithFormat:@"http://www.baidu.com"];
    RCWebViewController* temp = [[RCWebViewController alloc] init:YES];
    temp.hidesBottomBarWhenPushed = YES;
    [temp updateContent:urlString title:@"上WiFi"];
    
    [naviController pushViewController:temp animated:YES];
}

@end
