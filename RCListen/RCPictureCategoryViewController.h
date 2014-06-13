//
//  RCPictureCategoryViewController.h
//  RCFang
//
//  Created by xuzepei on 3/25/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCPictureCategoryView.h"
#import "FGalleryViewController.h"

@interface RCPictureCategoryViewController : UIViewController<FGalleryViewControllerDelegate>

@property(nonatomic,retain)RCPictureCategoryView* categoryView;
@property(nonatomic,retain)FGalleryViewController *galleryController;
@property(nonatomic,retain)NSMutableArray* imageArray;

- (void)updateContent:(NSArray*)itemArray;

@end
