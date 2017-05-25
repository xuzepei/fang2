//
//  RCAppDelegate.m
//  RCFang
//
//  Created by xuzepei on 1/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCAppDelegate.h"
#import "RCTool.h"
#import "RCHttpRequest.h"
//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"

#define UPDATE_TAG 122


@implementation RCAppDelegate

- (void)dealloc
{
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    UIApplication* app = [UIApplication sharedApplication];
//	app.applicationIconBadgeNumber = 0;
//	[app registerForRemoteNotificationTypes:
//	 (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
//    
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //TFXQ_GDZJ, Changed user agent of webview
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSMutableString* temp = [[NSMutableString alloc] init];
    if(userAgent.length)
        [temp appendFormat:@"%@ TFXQ_GDZJ",userAgent];
    else
        [temp appendString:@"TFXQ_GDZJ"];

    NSDictionary *dictionary = @{@"UserAgent":temp};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //homepage
    _homeViewController = [[RCHomeViewController alloc] initWithNibName:nil bundle:nil];
	
	_homeNavigationController = [[UINavigationController alloc]
                                 initWithRootViewController:_homeViewController];
    _homeNavigationController.navigationBar.tintColor = NAVIGATION_BAR_COLOR;
    [_homeNavigationController.navigationBar setTranslucent:NO];
    
    
//    //search
//    _telephoneViewController = [[RCTelephoneViewController alloc] initWithNibName:nil bundle:nil];
//	
//	_telephoneNavigationController = [[UINavigationController alloc]
//                                   initWithRootViewController:_telephoneViewController];
//    _telephoneNavigationController.navigationBar.tintColor = NAVIGATION_BAR_COLOR;
//        [_telephoneNavigationController.navigationBar setTranslucent:NO];
//    
//    
//    //me
//    _meViewController = [[RCMeViewController alloc] initWithNibName:nil bundle:nil];
//	
//	_meNavigationController = [[UINavigationController alloc]
//                               initWithRootViewController:_meViewController];
//    _meNavigationController.navigationBar.tintColor = NAVIGATION_BAR_COLOR;
//    _meNavigationController.navigationBar.translucent = NO;
//    
//    //more
//    _moreViewController = [[RCMoreViewController alloc] initWithNibName:nil bundle:nil];
//	
//	_moreNavigationController = [[UINavigationController alloc]
//                                 initWithRootViewController:_moreViewController];
//    _moreNavigationController.navigationBar.tintColor = NAVIGATION_BAR_COLOR;
//            [_moreNavigationController.navigationBar setTranslucent:NO];
//    
//    
//    _tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
//    
//    NSArray* array = [[NSArray alloc] initWithObjects:
//                      _homeNavigationController,
//                      _telephoneNavigationController,_meNavigationController,_moreNavigationController,nil];
//    
//	[_tabBarController setViewControllers:array animated:YES];
    
    self.window.rootViewController = _homeNavigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
//    BOOL showAD = YES;
//    NSString* imageUrl = nil;
//    NSDictionary* ad = [RCTool getAdByType:@"open"];
//    if(ad)
//    {
//        NSString* show = [ad objectForKey:@"show"];
//        if([show isEqualToString:@"0"])
//        {
//            showAD = NO;
//        }
//        else
//        {
//            NSArray* urlArray = [ad objectForKey:@"urllist"];
//            if(urlArray && [urlArray isKindOfClass:[NSArray class]])
//            {
//                if([urlArray count])
//                    imageUrl = [[urlArray objectAtIndex:0] objectForKey:@"url"];
//            }
//        }
//    }
//    
//    if(nil == _lauchAdView && showAD)
//    {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//        
//        _lauchAdView = [[RCLaunchAdView alloc] initWithFrame:[RCTool getScreenRect]];
//        
//        if(0 == [imageUrl length])
//            imageUrl = @"";
//        
//        NSMutableDictionary* item = [[NSMutableDictionary alloc] init];
//        [item setObject:imageUrl forKey:@"image_url"];
//        [_lauchAdView updateContent:item];
//        
//        [[RCTool frontWindow] addSubview:_lauchAdView];
//        
//        [self performSelector:@selector(removeLauchAdView) withObject:nil afterDelay:1.0];
//    }
    
    
//    //首页广告
//    NSString* urlString = [NSString stringWithFormat:@"%@/ad.php?apiid=%@&apikey=%@&type=open",BASE_URL,APIID,PWD];
//    
//    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
//    [temp request:urlString delegate:self resultSelector:@selector(finishedAdRequest:) token:nil];
//    
//    //获取区域和类型
//    urlString = [NSString stringWithFormat:@"%@/xinfang_search.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
//    
//    temp = [[RCHttpRequest alloc] init];
//    [temp request:urlString delegate:self resultSelector:@selector(finishedAreaRequest:) token:nil];
//    
//    
//    //获取分享信息
//    urlString = [NSString stringWithFormat:@"%@/share_text.php?apiid=%@&apikey=%@",BASE_URL,APIID,PWD];
//    temp = [[RCHttpRequest alloc] init];
//    [temp request:urlString delegate:self resultSelector:@selector(finishedShareTextRequest:) token:nil];
//    
//    
//    //检查最新版本
//    urlString = [NSString stringWithFormat:@"%@/check_update.php?apiid=%@&apikey=%@&ios=1",BASE_URL,APIID,PWD];
//    temp = [[RCHttpRequest alloc] init];
//    [temp request:urlString delegate:self resultSelector:@selector(finishedCheckRequest:) token:nil];
    
    
    [[UINavigationBar appearance] setBarTintColor:NAVIGATION_BAR_COLOR];
    
    [[UITabBar appearance] setTintColor:TAB_BAR_TEXT_COLOR];
    [[UITabBar appearance] setBarTintColor:TAB_BAR_COLOR];
    
    
    //状态栏颜色
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //导航条返回按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [UINavigationBar appearance].translucent = NO;
    //导航条标题颜色
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
               [UIFont boldSystemFontOfSize:21], NSFontAttributeName, nil]];
    
    
//    //获取当前位置
//    BMKMapView* mapView = [[BMKMapView alloc] init];
//    //mapView.delegate  = self;
//    [mapView setShowsUserLocation:YES];
    
    
    return YES;
}

- (void)finishedAdRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        [RCTool setAd:@"open" ad:result];
    }
    
}

- (void)finishedAreaRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSArray* array = [result objectForKey:@"arealist"];
        if(array && [array isKindOfClass:[NSArray class]])
        {
            [RCTool setArea:array];
        }
        
        array = [result objectForKey:@"typelist"];
        if(array && [array isKindOfClass:[NSArray class]])
        {
            [RCTool setHouseType:array];
        }
    }
}

- (void)finishedShareTextRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            [RCTool setShareItem:result];
        }
    }
}


- (void)finishedCheckRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* version = [result objectForKey:@"version"];
        self.updateUrlString = [result objectForKey:@"url"];
        if([version floatValue] > [VERSION floatValue])
        {
            if([self.updateUrlString length])
            {
                NSString* message = [result objectForKey:@"update"];
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"版本升级提示", nil)
                                                                     message:message
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消" otherButtonTitles:@"立刻下载",nil];
                alertView.tag = UPDATE_TAG;
                [alertView show];

            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(UPDATE_TAG == alertView.tag)
    {
        NSLog(@"clickedButtonAtIndex:%d",buttonIndex);
        
        if(0 == buttonIndex)
        {
            
        }
        else if(1 == buttonIndex)
        {
            if([self.updateUrlString length])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrlString]];
            }
        }
    }
}

- (void)removeLauchAdView
{
    if(_lauchAdView)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
        [UIView animateWithDuration:2.0 animations:^{
            _lauchAdView.alpha = 0.0;
        }completion:^(BOOL finished) {
            [_lauchAdView removeFromSuperview];
            self.lauchAdView = nil;
            
            [_homeViewController clickedLocationButton:nil];
        }];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    UIApplication* app = [UIApplication sharedApplication];
	app.applicationIconBadgeNumber = 0;
	[app registerForRemoteNotificationTypes:
	 (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    
    [[AVAudioSession sharedInstance]
     setActive: YES error: &activationErr];
    
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RCFang" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RCFang.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Push Notification

- (void)sendProviderDeviceToken:(NSData*)devToken
{
	if(nil == devToken)
		return;
    
    NSString* temp = [devToken description];
	NSString* token = [temp stringByTrimmingCharactersInSet:
					   [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	NSLog(@"token:%@",token);
    
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [RCTool setDeviceToken:token];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/ad.php?apiid=%@&apikey=%@&type=index&iostoken=%@",BASE_URL,APIID,PWD,token];
    
    RCHttpRequest* temp2 = [[RCHttpRequest alloc] init] ;
    [temp2 request:urlString delegate:self resultSelector:nil token:nil];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [self sendProviderDeviceToken: devToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	NSLog(@"%@",[userInfo valueForKeyPath:@"aps.alert"]);
	
	UIApplication* app = [UIApplication sharedApplication];
	if(app.applicationIconBadgeNumber)
		app.applicationIconBadgeNumber = 0;
	else
	{
		NSString* message = [userInfo valueForKeyPath:@"aps.alert"];
		if([message length])
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"房管家"
															message: message delegate: self
												  cancelButtonTitle: @"确定"
												  otherButtonTitles: nil];
			[alert show];

		}
	}
}

#pragma mark - Location

//- (void)updateUserLocation
//{
//    if(nil == _locationService)
//    {
//        _locationService = [[BMKLocationService alloc]init];
//        _locationService.delegate = self;
//    }
//    
//    [_locationService stopUserLocationService];
//    [_locationService startUserLocationService];
//}
//
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    //NSLog(@"heading is %@,title:%@",userLocation.heading,[userLocation.location description]);
//    
//    self.userLocation = userLocation;
//    
//    [_locationService stopUserLocationService];
//    
//    //获取位置名称
//    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
//    CLGeocodeCompletionHandler handler = ^(NSArray *place, NSError *error) {
//        
//        for (CLPlacemark *placemark in place) {
//            
//            NSString* cityStr=placemark.thoroughfare;
//            
//            NSString* cityName=placemark.locality;
//            
//            if([cityStr length] && [cityName length])
//                self.locationName = [NSString stringWithFormat:@"%@,%@",cityName,cityStr];
//            
//            break;
//        }
//        
//    };
//    
//    CLLocation *loc = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
//    
//    [geocoder reverseGeocodeLocation:loc completionHandler:handler];
//    
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATED_LOCATION_NOTIFICATION object:nil];
//}
//
////处理位置坐标更新
//- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
//{
//    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//}
//
//- (void)didFailToLocateUserWithError:(NSError *)error
//{
//        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATED_LOCATION_NOTIFICATION object:nil];
//}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    if(viewController)
    {
        [viewController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

@end
