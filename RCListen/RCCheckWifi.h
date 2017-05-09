//
//  RCCheckWifi.h
//  RCFang
//
//  Created by xuzepei on 09/05/2017.
//  Copyright © 2017 xuzepei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCCheckWifi : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property(nonatomic,assign)BOOL isChecking;
@property(nonatomic,assign)int httpStatusCode;

+ (RCCheckWifi*)sharedInstance;

- (void)checkWifiConnection;

@end
