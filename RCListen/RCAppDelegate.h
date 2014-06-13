//
//  RCAppDelegate.h
//  RCFang
//
//  Created by xuzepei on 1/14/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCHomeViewController.h"
#import "RCSearchViewController.h"
#import "RCMeViewController.h"
#import "RCMoreViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RCLaunchAdView.h"

@interface RCAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
    UIBackgroundTaskIdentifier _bgTask;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,retain)RCHomeViewController* homeViewController;
@property (nonatomic,retain)RCSearchViewController* searchViewController;
@property (nonatomic,retain)RCMeViewController* meViewController;
@property (nonatomic,retain)RCMoreViewController* moreViewController;

@property (nonatomic,retain)UINavigationController* homeNavigationController;
@property (nonatomic,retain)UINavigationController* searchNavigationController;
@property (nonatomic,retain)UINavigationController* meNavigationController;
@property (nonatomic,retain)UINavigationController* moreNavigationController;

@property (nonatomic,retain)UITabBarController* tabBarController;

@property (nonatomic,retain)RCLaunchAdView* lauchAdView;
@property (nonatomic,retain)NSString* updateUrlString;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
