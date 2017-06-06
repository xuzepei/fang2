//
//  RCFangTests.m
//  RCFangTests
//
//  Created by xuzepei on 05/06/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface RCFangTests : XCTestCase

@end

@implementation RCFangTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    NSString* redirectUrl = @"http://10.1.1.1/auth/wfidogAuth/login/?gw_id=00d011223344&gw_sn=1234942570128可能是电话号码，是否拨号?&gw_address=172.18.163.1&gw_port=2060&ip=172.18.163.109&mac=4c:2b:48:ac:55:6a&ssid=ap-test&url= http%3A%2F%2Fwww%2Eqq%2Ecom%2F";
    if(redirectUrl.length)
    {
        NSLog(@"++++重定向url：%@",redirectUrl);
        
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
                    NSLog(@"+++++获取到的IP地址：%@",ipAddress);
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
                            NSLog(@"+++++获取到的mac：%@",macAddress);
                        }
                    }
                }
            }
        }
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
