//
//  RCPictureCategoryViewController.m
//  RCFang
//
//  Created by xuzepei on 3/25/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCPictureCategoryViewController.h"
#import "RCTool.h"

@interface RCPictureCategoryViewController ()

@end

@implementation RCPictureCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _imageArray = [[NSMutableArray alloc] init];
        
        [_imageArray addObject:@"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg"];
        
        [_imageArray addObject:@"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg"];
    }
    return self;
}

- (void)dealloc
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initPictureCategoryView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.categoryView = nil;
    self.galleryController = nil;
}

- (void)updateContent:(NSArray*)itemArray
{
    self.title = @"小区相册";
    
    if(_categoryView)
    {
        [_categoryView updateContent:itemArray];
    }
}

- (void)initPictureCategoryView
{
    if(nil == _categoryView)
    {
        _categoryView = [[RCPictureCategoryView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - NAVIGATION_BAR_HEIGHT)];
        _categoryView.delegate = self;
    }
    
    [self.view addSubview: _categoryView];
}

- (void)clickedPictureCategory:(id)token
{
    if(nil == _galleryController)
    {
        _galleryController = [[FGalleryViewController alloc] initWithPhotoSource:self];
    }
    
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationController.navigationBar.translucent = 0.3;
    
    [self.navigationController pushViewController:_galleryController animated:YES];
}

#pragma mark - FGalleryViewControllerDelegate Methods

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    if(gallery == _galleryController)
    {
        return [_imageArray count];
    }
    
	return 0;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
	return @"";
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    
    return @"";
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    return [_imageArray objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}


- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}

@end
