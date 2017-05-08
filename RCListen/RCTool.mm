//
//  RCTool.m
//  rsscoffee
//
//  Created by beer on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RCTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import "TBXML.h"
#import "RCAppDelegate.h"
#import "MBProgressHUD.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>

static int g_reachabilityType = -1;

static SystemSoundID g_soundID = 0;
void systemSoundCompletionProc(SystemSoundID ssID,void *clientData)
{
	AudioServicesRemoveSystemSoundCompletion(ssID);
	AudioServicesDisposeSystemSoundID(g_soundID);
	g_soundID = 0;
}

@implementation RCTool

+ (NSString*)getUserDocumentDirectoryPath
{
//	NSArray* array = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
//	if([array count])
//		return [array objectAtIndex: 0];
//	else
//		return @"";
    
    return NSTemporaryDirectory();
}

+ (NSString *)md5:(NSString *)str 
{
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];	
}

+ (UIWindow*)frontWindow
{
	UIApplication *app = [UIApplication sharedApplication];
    NSArray* windows = [app windows];
    
    for(int i = [windows count] - 1; i >= 0; i--)
    {
        UIWindow *frontWindow = [windows objectAtIndex:i];
        //NSLog(@"window class:%@",[frontWindow class]);
//        if(![frontWindow isKindOfClass:[MTStatusBarOverlay class]])
            return frontWindow;
    }
    
	return nil;
}

+ (UITabBarController*)getTabBarController
{
    UIApplication *app = [UIApplication sharedApplication];
    RCAppDelegate* appDelegate = (RCAppDelegate*)app.delegate;
    return appDelegate.tabBarController;
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


#pragma mark -
#pragma mark network

+ (void)setReachabilityType:(int)type
{
	g_reachabilityType = type;
}

+ (int)getReachabilityType
{
	return g_reachabilityType;
}

+ (BOOL)isReachableViaInternet
{
	Reachability* internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	NetworkStatus netStatus = [internetReach currentReachabilityStatus];
	switch (netStatus)
    {
        case NotReachable:
        {
            return NO;
        }
        case ReachableViaWWAN:
        {
            return YES;
        }
        case ReachableViaWiFi:
        {
			return YES;
		}
		default:
			return NO;
	}
	
	return NO;
}

+ (BOOL)isReachableViaWiFi
{
	Reachability* internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	NetworkStatus netStatus = [internetReach currentReachabilityStatus];
	switch (netStatus)
    {
        case NotReachable:
        {
            return NO;
        }
        case ReachableViaWWAN:
        {
            return NO;
        }
        case ReachableViaWiFi:
        {
			return YES;
		}
		default:
			return NO;
	}
	
	return NO;
}

+ (NSDictionary*)getWifiInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    
    return SSIDInfo;
}

+ (BOOL)saveImage:(NSData*)data path:(NSString*)path
{
	if(nil == data || 0 == [path length])
		return NO;
    
    NSString* directoryPath = [NSString stringWithFormat:@"%@/images",[RCTool getUserDocumentDirectoryPath]];
    if(NO == [RCTool isExistingFile:directoryPath])
    {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:NULL];
    }
	
    NSString* suffix = nil;
	NSRange range = [path rangeOfString:@"." options:NSBackwardsSearch];
	if(range.location != NSNotFound)
		suffix = [path substringFromIndex:range.location + range.length];
	
	NSString* md5Path = [RCTool md5:path];
	NSString* savePath = nil;
	if([suffix length])
    {
		savePath = [NSString stringWithFormat:@"%@/images/%@.%@",[RCTool getUserDocumentDirectoryPath],md5Path,suffix];
        
//        saveSmallImagePath = [NSString stringWithFormat:@"%@/%@_s.%@",[RCTool getUserDocumentDirectoryPath],md5Path,suffix];
    }
	else
		return NO;
	
	//保存原图
	if(NO == [data writeToFile:savePath atomically:YES])
        return NO;
	
	
//	//保存小图
//	UIImage* image = [UIImage imageWithData:data];
//	if(nil == image)
//		return NO;
//    
//    if(image.size.width <= 140 || image.size.height <= 140)
//    {
//        return [data writeToFile:saveSmallImagePath atomically:YES];
//    }
//	
//	CGSize size = CGSizeMake(140, 140);
//	// 创建一个bitmap的context  
//	// 并把它设置成为当前正在使用的context  
//	UIGraphicsBeginImageContext(size);  
//	
//	// 绘制改变大小的图片  
//	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];  
//	
//	// 从当前context中创建一个改变大小后的图片  
//	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
//	
//	// 使当前的context出堆栈  
//	UIGraphicsEndImageContext();  
//	
//	NSData* data2 = UIImagePNGRepresentation(scaledImage);
//	if(data2)
//    {
//		return [data2 writeToFile:saveSmallImagePath atomically:YES];
//    }
	
	return YES;
}


+ (UIImage*)getImageFromLocal:(NSString*)path
{
	if(0 == [path length])
		return nil;
	
	NSString* suffix = nil;
	NSRange range = [path rangeOfString:@"." options:NSBackwardsSearch];
	if(range.location != NSNotFound)
		suffix = [path substringFromIndex:range.location + range.length];
	
	NSString* md5Path = [RCTool md5:path];
	NSString* savePath = nil;
	if([suffix length])
		savePath = [NSString stringWithFormat:@"%@/images/%@.%@",[RCTool getUserDocumentDirectoryPath],md5Path,suffix];
	else
		return nil;
	
	return [UIImage imageWithContentsOfFile:savePath];
}

+ (NSString*)getImageLocalPath:(NSString *)path
{
	if(0 == [path length])
		return nil;
	
    NSString* suffix = nil;
	NSRange range = [path rangeOfString:@"." options:NSBackwardsSearch];
	if(range.location != NSNotFound)
		suffix = [path substringFromIndex:range.location + range.length];
	
	NSString* md5Path = [RCTool md5:path];
	if([suffix length])
		return [NSString stringWithFormat:@"%@/images/%@.%@",[RCTool getUserDocumentDirectoryPath],md5Path,suffix];
	else
		return nil;
}


+ (BOOL)isExistingFile:(NSString*)path
{
	if(0 == [path length])
		return NO;
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:path];
}

+ (void)removeFile:(NSString*)filePath
{
    if([filePath length])
        [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                   error:nil];
}

+ (NSPersistentStoreCoordinator*)getPersistentStoreCoordinator
{
	RCAppDelegate* appDelegate = (RCAppDelegate*)[[UIApplication sharedApplication] delegate];
	return [appDelegate persistentStoreCoordinator];
}

+ (NSManagedObjectContext*)getManagedObjectContext
{
	RCAppDelegate* appDelegate = (RCAppDelegate*)[[UIApplication sharedApplication] delegate];
	return [appDelegate managedObjectContext];
}

+ (NSManagedObjectID*)getExistingEntityObjectIDForName:(NSString*)entityName
											 predicate:(NSPredicate*)predicate
									   sortDescriptors:(NSArray*)sortDescriptors
											   context:(NSManagedObjectContext*)context

{
	if(0 == [entityName length] || nil == context)
		return nil;
	
	//NSManagedObjectContext* context = [RCTool getManagedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	
	//sortDescriptors 是必传属性
	NSArray *temp = [NSArray arrayWithArray: sortDescriptors];
	[fetchRequest setSortDescriptors:temp];
	
	
	//set predicate
	[fetchRequest setPredicate:predicate];
	
	//设置返回类型
	[fetchRequest setResultType:NSManagedObjectIDResultType];
	
	
	//	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] 
	//															initWithFetchRequest:fetchRequest 
	//															managedObjectContext:context 
	//															sectionNameKeyPath:nil 
	//															cacheName:@"Root"];
	//	
	//	//[context tryLock];
	//	[fetchedResultsController performFetch:nil];
	//	//[context unlock];
	
	NSArray* objectIDs = [context executeFetchRequest:fetchRequest error:nil];
	
	if(objectIDs && [objectIDs count])
		return [objectIDs lastObject];
	else
		return nil;
}

+ (NSArray*)getExistingEntityObjectsForName:(NSString*)entityName
								  predicate:(NSPredicate*)predicate
							sortDescriptors:(NSArray*)sortDescriptors
{
	if(0 == [entityName length])
		return nil;
	
	NSManagedObjectContext* context = [RCTool getManagedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	
	//sortDescriptors 是必传属性
	NSArray *temp = [NSArray arrayWithArray: sortDescriptors];
	[fetchRequest setSortDescriptors:temp];
	
	
	//set predicate
	[fetchRequest setPredicate:predicate];
	
	//设置返回类型
	[fetchRequest setResultType:NSManagedObjectResultType];
	
	NSArray* objects = [context executeFetchRequest:fetchRequest error:nil];

	
	return objects;
}

+ (id)insertEntityObjectForName:(NSString*)entityName 
		   managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
{
	if(0 == [entityName length] || nil == managedObjectContext)
		return nil;
	
	NSManagedObjectContext* context = managedObjectContext;
	id entityObject = [NSEntityDescription insertNewObjectForEntityForName:entityName 
													inManagedObjectContext:context];
	
	
	return entityObject;
	
}

+ (id)insertEntityObjectForID:(NSManagedObjectID*)objectID 
		 managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
{
	if(nil == objectID || nil == managedObjectContext)
		return nil;
	
	return [managedObjectContext objectWithID:objectID];
}

+ (void)saveCoreData
{
	RCAppDelegate* appDelegate = (RCAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSError *error = nil;
    if ([appDelegate managedObjectContext] != nil) 
	{
        if ([[appDelegate managedObjectContext] hasChanges] && ![[appDelegate managedObjectContext] save:&error]) 
		{
            
        } 
    }
}

+ (BOOL)isBigFont
{
	NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
	NSNumber* b = [temp objectForKey:@"bigFont"];
	if(b)
        return [b boolValue];
	
	return NO;
}

+ (BOOL)isAutoScroll
{
	NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
	NSNumber* b = [temp objectForKey:@"autoScroll"];
	if(b)
		return [b boolValue];
	
	return YES;
}

+ (BOOL)isManualRefresh
{
	NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
	NSNumber* b = [temp objectForKey:@"manualRefresh"];
	if(b)
		return [b boolValue];
	
	return NO;
}

+ (BOOL)isWifiOnly
{
	NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
	NSNumber* b = [temp objectForKey:@"wifiOnly"];
	if(b)
		return [b boolValue];
	
	return NO;
}

+ (BOOL)isImageUrl:(NSString*)urlString
{
	NSRange range = [urlString rangeOfString:@"." options:NSBackwardsSearch];
	if(NSNotFound == range.location)
		return NO;
	
	NSString* suffix = [urlString substringFromIndex:range.location];
	BOOL isValid = NO;
	if(NSOrderedSame == [suffix compare:@".png" options:NSCaseInsensitiveSearch])
		isValid = YES;
	if(NSOrderedSame == [suffix compare:@".bmp" options:NSCaseInsensitiveSearch])
		isValid = YES;
	else if(NSOrderedSame == [suffix compare:@".jpeg" options:NSCaseInsensitiveSearch])
		isValid = YES;
	else if(NSOrderedSame == [suffix compare:@".jpg" options:NSCaseInsensitiveSearch])
		isValid = YES;
	else if(NSOrderedSame == [suffix compare:@".ico" options:NSCaseInsensitiveSearch])
		isValid = YES;
	else if(NSOrderedSame == [suffix compare:@".gif" options:NSCaseInsensitiveSearch])
		isValid = YES;
	
	return isValid;
}

+ (UIView*)getAdView
{
//	VOAAppDelegate* appDelegate = (VOAAppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    if(appDelegate._adMobView)
//    {
//        return appDelegate._adMobView;
//    }
//    else if(appDelegate._adBannerView && appDelegate._adBannerView.isBannerLoaded)
//    {
//        return appDelegate._adBannerView;
//    }
//	
	return nil;
}

+ (void)autoDeleteItems
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* temp = [userDefaults objectForKey:@"autoDeleteItems_30"];
    if(temp && NO == [temp boolValue])
        return;
    
    NSManagedObjectContext* context = [RCTool getManagedObjectContext];
    
    NSArray* array = [RCTool getExistingEntityObjectsForName: @"Category"
                                                   predicate: nil
                                             sortDescriptors: nil];
    
    for(NSManagedObject* object in array)
    {
        [context deleteObject:object];
    }
    
    array = [RCTool getExistingEntityObjectsForName: @"Item"
                                          predicate: nil
                                    sortDescriptors: nil];
    
    for(NSManagedObject* object in array)
    {
        [context deleteObject:object];
    }
    
    [RCTool saveCoreData];
    
    
    [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:@"autoDeleteItems_30"];
    [userDefaults synchronize];
    
}


/**
 显示提示筐
 */
+ (void)showAlert:(NSString*)aTitle message:(NSString*)message
{
	if(0 == [aTitle length] || 0 == [message length])
		return;
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: aTitle
													message: message
												   delegate: self
										  cancelButtonTitle: @"OK"
										  otherButtonTitles: nil];
    alert.tag = 110;
	[alert show];

    
}

/**
 隐藏UIWebView拖拽时顶部的阴影效果
 */
+ (void)hidenWebViewShadow:(UIWebView*)webView
{
    if(nil == webView)
        return;
    
    if ([[webView subviews] count])
    {
        for (UIView* shadowView in [[[webView subviews] objectAtIndex:0] subviews])
        {
            [shadowView setHidden:YES];
        }
        
        // unhide the last view so it is visible again because it has the content
        [[[[[webView subviews] objectAtIndex:0] subviews] lastObject] setHidden:NO];
    }
}

+ (void)deleteOldData
{
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isFavorited == NO && isDownloaded == NO && isHidden == NO"];
//    
//	NSArray* array = [RCTool getExistingEntityObjectsForName:@"Item"
//                                                   predicate:predicate
//                                             sortDescriptors:nil
//                                           ];
//    
//    for(Item* item in array)
//    {
//        NSString* pubDate = item.pubDate;
//        if([pubDate length])
//        {
//            NSDate* date = [RCTool getDateByString:pubDate];
//            NSDate* today = [NSDate date];
//            if([today timeIntervalSinceDate:date] <= 3*7*24*60*60)
//                continue;
//            
//        }
//        
//        item.isHidden = [NSNumber numberWithBool:YES];
//    }
    
    [RCTool saveCoreData];
}

#pragma mark - 兼容iOS6和iPhone5

+ (CGSize)getScreenSize
{
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGRect)getScreenRect
{
    return [[UIScreen mainScreen] bounds];
}

+ (BOOL)isIphone5
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        if(568 == size.height)
        {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)isIpad
{
	UIDevice* device = [UIDevice currentDevice];
	if(device.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
	{
		return NO;
	}
	else if(device.userInterfaceIdiom == UIUserInterfaceIdiomPad)
	{
		return YES;
	}
	
	return NO;
}

+ (CGFloat)systemVersion
{
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    return systemVersion;
}

#pragma mark - 搜索条件缓存

+ (BOOL)setSearchCondition:(NSArray*)conditionArray type:(int)type
{
    if(STT_UNKNOWN == type || nil == conditionArray)
        return NO;
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:conditionArray forKey:[NSString stringWithFormat:@"search_condition_%d",type]];
    [userDefaults synchronize];
    
    return YES;
}

+ (NSArray*)getSearchConditionByType:(int)type
{
    if(STT_UNKNOWN == type)
        return nil;
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray* conditionArray = [userDefaults objectForKey:[NSString stringWithFormat:@"search_condition_%d",type]];
    
    if(nil == conditionArray)
    {
        NSMutableArray* searchConditionForType = [[NSMutableArray alloc] init];
        
        if(STT_0 == type)
        {
            //区域
            NSMutableDictionary* searchCondition = [[NSMutableDictionary alloc] init];
            [searchCondition setObject:@"区域" forKey:@"name"];
            
            NSMutableArray* values = [[NSMutableArray alloc] init];
            NSArray* areas = [RCTool getArea];
            if(areas && [areas count])
                [values addObjectsFromArray:areas];
            else
                [values addObject:@"不限"];
            [searchCondition setObject:values forKey:@"values"];
            [searchCondition setObject:[NSNumber numberWithInt:type] forKey:@"stt"];
            [searchCondition setObject:[NSNumber numberWithInt:0] forKey:@"subtype"];
            [searchConditionForType addObject:searchCondition];
            
            //类型
            searchCondition = [[NSMutableDictionary alloc] init];
            [searchCondition setObject:@"类型" forKey:@"name"];
            values = [[NSMutableArray alloc] init];
            NSArray* types = [RCTool getHouseType];
            if(types && [types count])
                [values addObjectsFromArray:types];
            [searchCondition setObject:values forKey:@"values"];
            [searchCondition setObject:[NSNumber numberWithInt:type] forKey:@"stt"];
            [searchCondition setObject:[NSNumber numberWithInt:1] forKey:@"subtype"];
            [searchConditionForType addObject:searchCondition];
            
            //价格
            searchCondition = [[NSMutableDictionary alloc] init];
            [searchCondition setObject:@"价格" forKey:@"name"];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:@"不限"];
            [array addObject:@"3000元每平米以下"];
            [array addObject:@"3000~5000元每平米"];
            [array addObject:@"5000~7000元每平米"];
            [array addObject:@"7000~90000元每平米"];
            [array addObject:@"9000~110000元每平米"];
            [array addObject:@"110000元每平米以上"];
            [searchCondition setObject:array forKey:@"values"];
            [searchCondition setObject:[NSNumber numberWithInt:type] forKey:@"stt"];
            [searchCondition setObject:[NSNumber numberWithInt:2] forKey:@"subtype"];
            [searchConditionForType addObject:searchCondition];
            
        }
        else if(STT_1 == type)
        {
            //区域
            NSMutableDictionary* searchCondition = [[NSMutableDictionary alloc] init];
            [searchCondition setObject:@"区域" forKey:@"name"];
            
            NSMutableArray* values = [[NSMutableArray alloc] init];
            NSArray* areas = [RCTool getArea];
            if(areas && [areas count])
                [values addObjectsFromArray:areas];
            else
                [values addObject:@"不限"];
            [searchCondition setObject:values forKey:@"values"];
            [searchCondition setObject:[NSNumber numberWithInt:type] forKey:@"stt"];
            [searchCondition setObject:[NSNumber numberWithInt:0] forKey:@"subtype"];
            [searchConditionForType addObject:searchCondition];
            
            //户型
            searchCondition = [[NSMutableDictionary alloc] init];
            [searchCondition setObject:@"户型" forKey:@"name"];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:@"不限"];
            [array addObject:@"一居"];
            [array addObject:@"二居"];
            [array addObject:@"三居"];
            [array addObject:@"四居"];
            [array addObject:@"五居"];
            [array addObject:@"五居以上"];
            [searchCondition setObject:array forKey:@"values"];
            [searchCondition setObject:[NSNumber numberWithInt:type] forKey:@"stt"];
            [searchCondition setObject:[NSNumber numberWithInt:1] forKey:@"subtype"];
            [searchConditionForType addObject:searchCondition];
            
            //总价
            searchCondition = [[NSMutableDictionary alloc] init];
            [searchCondition setObject:@"总价" forKey:@"name"];
            array = [[NSMutableArray alloc] init];
            [array addObject:@"不限"];
            [array addObject:@"15万以下"];
            [array addObject:@"15万~35万"];
            [array addObject:@"35万~55万"];
            [array addObject:@"55万~75万"];
            [array addObject:@"75万~100万"];
            [array addObject:@"100万~150万"];
            [array addObject:@"150万~200万"];
            [array addObject:@"200万~300万"];
            [array addObject:@"300万以上"];
            [searchCondition setObject:array forKey:@"values"];
            [searchCondition setObject:[NSNumber numberWithInt:type] forKey:@"stt"];
            [searchCondition setObject:[NSNumber numberWithInt:2] forKey:@"subtype"];
            [searchConditionForType addObject:searchCondition];
            
        }
        else if(STT_2 == type)
        {
            //区域
            NSMutableDictionary* searchCondition = [[NSMutableDictionary alloc] init];
            [searchCondition setObject:@"区域" forKey:@"name"];
            
            NSMutableArray* values = [[NSMutableArray alloc] init];
            NSArray* areas = [RCTool getArea];
            if(areas && [areas count])
                [values addObjectsFromArray:areas];
            else
                [values addObject:@"不限"];
            [searchCondition setObject:values forKey:@"values"];
            [searchCondition setObject:[NSNumber numberWithInt:type] forKey:@"stt"];
            [searchCondition setObject:[NSNumber numberWithInt:0] forKey:@"subtype"];
            [searchConditionForType addObject:searchCondition];
            
            
            searchCondition = [[NSMutableDictionary alloc] init];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:@"不限"];
            [array addObject:@"个人"];
            [array addObject:@"经纪人"];
            [searchCondition setObject:array forKey:@"values"];
            [searchCondition setObject:@"来源" forKey:@"name"];
            [searchCondition setObject:[NSNumber numberWithInt:type] forKey:@"stt"];
            [searchCondition setObject:[NSNumber numberWithInt:1] forKey:@"subtype"];
            [searchConditionForType addObject:searchCondition];
            
            
            searchCondition = [[NSMutableDictionary alloc] init];
            array = [[NSMutableArray alloc] init];
            [array addObject:@"不限"];
            [array addObject:@"500元/月以下"];
            [array addObject:@"500元～1000元/月"];
            [array addObject:@"1000元～2000元/月"];
            [array addObject:@"2000元～3000元/月"];
            [array addObject:@"3000元～5000元/月"];
            [array addObject:@"5000元～8000元/月"];
            [array addObject:@"8000元/月元以上"];
            [searchCondition setObject:array forKey:@"values"];
            [searchCondition setObject:@"租金" forKey:@"name"];
            [searchCondition setObject:[NSNumber numberWithInt:type] forKey:@"stt"];
            [searchCondition setObject:[NSNumber numberWithInt:2] forKey:@"subtype"];
            [searchConditionForType addObject:searchCondition];
            
        }
        
        return searchConditionForType;
    }
    
    return conditionArray;
}


+ (void)showIndicator:(NSString*)text
{
    MBProgressHUD * indicator = [MBProgressHUD showHUDAddedTo:[RCTool frontWindow] animated:YES];
    indicator.labelText = text;
}

+ (void)hideIndicator
{
    [MBProgressHUD hideHUDForView:[RCTool frontWindow] animated:YES];
}


//解析谷歌地图地址
+ (NSDictionary*)parseAddress:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return nil;
    
    return nil;
}

+ (NSDictionary*)parseToDictionary:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return nil;
    
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if(nil == data)
        return nil;
    
    NSError* error = nil;
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if(error)
    {
        NSLog(@"parse errror:%@",[error localizedDescription]);
        return nil;
    }
    
    if([json isKindOfClass:[NSDictionary class]])
    {
        return (NSDictionary *)json;
    }
    
    return nil;
}

+ (void)playSound:(NSString*)filename
{
    if(g_soundID || 0 == [filename length])
	    return;
    
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
	
	NSURL *fileUrl = [NSURL fileURLWithPath:path];
	g_soundID = 0;
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &g_soundID);
    
	AudioServicesAddSystemSoundCompletion(g_soundID,NULL,NULL,systemSoundCompletionProc, NULL);
	AudioServicesPlaySystemSound(g_soundID);
}

+ (void)setAd:(NSString*)type ad:(NSDictionary*)ad
{
    if(0 == type || nil == ad)
        return;
    
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:ad forKey:[NSString stringWithFormat:@"ad_%@",type]];
    [temp synchronize];
}

+ (NSDictionary*)getAdByType:(NSString*)type
{
    if(0 == type)
        return nil;
    
    //    固定参数：
    //    type=open    --  开机广告
    //    type=index    -- 首页广告
    //    type=newhouse   --新房的广告
    //    type=2hand  --  二手房的广告
    //    type=rent   --  租房的广告
    //    type=news    -- 新闻资讯广告位
    
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    return [temp objectForKey:[NSString stringWithFormat:@"ad_%@",type]];
}

+ (void)setArea:(id)area
{
    if(nil == area)
        return;
    
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:area forKey:@"search_area"];
    [temp synchronize];
}

+ (NSArray*)getArea
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    return [temp objectForKey:@"search_area"];
}

+ (void)setHouseType:(id)type
{
    if(nil == type)
        return;
    
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:type forKey:@"search_type"];
    [temp synchronize];
}

+ (NSArray*)getHouseType
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    return [temp objectForKey:@"search_type"];
}

+ (void)setUsername:(NSString*)username
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:username forKey:@"username"];
    [temp synchronize];
}

+ (NSString*)getUsername
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    NSString* username = [temp objectForKey:@"username"];
    if([username length])
        return username;
    
    return @"";
}

+ (void)setNickname:(NSString*)nickname
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:nickname forKey:@"nickname"];
    [temp synchronize];
}

+ (NSString*)getNickname
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    NSString* nickname = [temp objectForKey:@"nickname"];
    if([nickname length])
        return nickname;
    
    return @"";
}

+ (void)setPassword:(NSString*)password
{
    if(0 == [password length])
        return;
    
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:password forKey:@"password"];
    [temp synchronize];
}

+ (NSString*)getPassword
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    NSString* password = [temp objectForKey:@"password"];
    if([password length])
        return password;
    
    return @"";
}

+(NSString *)getIpAddress{
	
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}


+ (NSString*)base64forData:(NSData*)theData {
	
	const uint8_t* input = (const uint8_t*)[theData bytes];
	NSInteger length = [theData length];
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
	NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
		NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
			
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


+ (void)setShareItem:(NSDictionary*)item
{
    if(nil == item)
        return;
    
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:item forKey:@"share_item"];
    [temp synchronize];
}

+ (NSDictionary*)getShareItem
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    NSDictionary* share_item = [temp objectForKey:@"share_item"];
    if(share_item)
        return share_item;
    
    return nil;
}

+ (void)setDeviceToken:(NSString*)token
{
    if(0 == [token length])
        return;
    
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp setObject:token forKey:@"token"];
    [temp synchronize];
}

+ (NSString*)getDeviceToken
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    NSString* token = [temp objectForKey:@"token"];
    if([token length])
        return token;
    
    return @"";
}

+ (BOOL)isLogined
{
    NSString* username = [RCTool getUsername];
    if([username length])
        return YES;
    
    return NO;
}

+ (NSString*)getUserLocation
{
//    RCAppDelegate* appDelegate = (RCAppDelegate*)[[UIApplication sharedApplication] delegate];
//    if(appDelegate.userLocation)
//    {
//        return [NSString stringWithFormat:@"%lf,%lf",appDelegate.userLocation.location.coordinate.longitude,appDelegate.userLocation.location.coordinate.latitude];
//    }
    
    return @"";
}

+ (NSString*)getUserLocationName
{
//    RCAppDelegate* appDelegate = (RCAppDelegate*)[[UIApplication sharedApplication] delegate];
//    NSString* temp = appDelegate.locationName;
//    if(0 == [temp length])
//        return @"";
//    
//    return temp;
    
    return @"";
}

+ (void)saveUserInfo:(NSDictionary*)userInfo
{
    if(userInfo && [userInfo isKindOfClass:[NSDictionary class]])
    {
        NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
        [temp setObject:userInfo forKey:@"user_info"];
        [temp synchronize];
    }
}

+ (NSDictionary*)getUserInfo
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    return [temp objectForKey:@"user_info"];
}

+ (void)removeUserInfo
{
    NSUserDefaults* temp = [NSUserDefaults standardUserDefaults];
    [temp removeObjectForKey:@"user_info"];
    [temp synchronize];
}

@end
