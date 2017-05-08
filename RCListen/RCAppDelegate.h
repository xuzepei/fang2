//
//  RCAppDelegate.h
//  RCFang
//
//  Created by xuzepei on 1/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCHomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RCLaunchAdView.h"
#import <StoreKit/StoreKit.h>

@interface RCAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,SKStoreProductViewControllerDelegate>
{
    UIBackgroundTaskIdentifier _bgTask;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,retain)RCHomeViewController* homeViewController;
@property (nonatomic,retain)UINavigationController* homeNavigationController;

@property (nonatomic,retain)UITabBarController* tabBarController;

@property (nonatomic,retain)RCLaunchAdView* lauchAdView;
@property (nonatomic,retain)NSString* updateUrlString;
//@property (nonatomic,retain)BMKMapManager* mapManager;
//@property (nonatomic,strong)BMKLocationService* locationService;
//@property (nonatomic,strong)BMKUserLocation* userLocation;
//@property (nonatomic,strong)NSString* locationName;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)updateUserLocation;

@end
