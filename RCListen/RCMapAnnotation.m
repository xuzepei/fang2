//
//  RCMapAnnotation.m
//  RCFang
//
//  Created by xuzepei on 3/20/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCMapAnnotation.h"

@implementation RCMapAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)myCoordinate
{
    if(self = [super init])
    {
        _coordinate = myCoordinate;
    }
    
    return  self;
}


-(void)dealloc
{

}

@end
