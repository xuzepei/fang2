//
//  RCBaiDuMapViewController.m
//  RCFang
//
//  Created by xuzepei on 10/21/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCBaiDuMapViewController.h"
#import "RouteAnnotation.h"
#import "RCPointAnnotation.h"
#import "RCWebViewController.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end

@interface RCBaiDuMapViewController ()

@end

@implementation RCBaiDuMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        if(nil == _mapView)
        {
            _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width, [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)];
            _mapView.delegate = self;
            self.view = self.mapView;
            
            [_mapView setMapType:BMKMapTypeStandard];
            [_mapView setShowsUserLocation:NO];
            
            [self initButton];
            
        }
    }
    return self;
}

- (void)dealloc
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initButton];
}

- (void)clickedLeftBarButtonItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    if(self.locationButton)
        [[RCTool frontWindow] addSubview:self.locationButton];
    
    if(self.stepper)
        [[RCTool frontWindow] addSubview:self.stepper];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    if(self.locationButton)
        [self.locationButton removeFromSuperview];
    
    if(self.stepper)
        [self.stepper removeFromSuperview];
    
}

- (void)updateContent:(NSDictionary *)item zoom:(int)zoom
{
    if(nil == item)
        return;
    
    self.item = item;
    
    NSArray* list = [item objectForKey:@"list"];
    if(0 == [list count])
        return;
    
    NSDictionary* point = [list objectAtIndex:0];
    self.address = [point objectForKey:@"point"];
    self.address = @"104.033428,30.64105";
    
    if([self.address length])
    {
        if(_mapView)
        {
            NSArray* array = [self.address componentsSeparatedByString:@","];
            if(2 == [array count])
            {
                CLLocationCoordinate2D coor;
                coor.latitude = [[array objectAtIndex:1] floatValue];
                coor.longitude = [[array objectAtIndex:0] floatValue];
                
                if(CLLocationCoordinate2DIsValid(coor))
                {
                    BMKCoordinateSpan span;
                    span.latitudeDelta = 1.0;
                    span.longitudeDelta = 1.0;
                    
                    BMKCoordinateRegion region;
                    region.center = coor;
                    region.span = span;
                    
                    [_mapView setRegion:region animated:YES];
                    
                    [_mapView setZoomEnabled:YES];
                    [_mapView setZoomLevel:zoom];
                }
            }
        }
    }
    
    for(NSDictionary* point in list)
    {
        NSString* address = [point objectForKey:@"point"];
        address = @"104.033428,30.64105";
        NSString* title = [point objectForKey:@"title"];

        [self addAnnotation:address title:title token:point];
    }
    
}



- (void)updateContent:(NSDictionary*)item
{
    [self updateContent:item zoom:13];
}

#pragma mark - Annotation

- (void)addAnnotation:(NSString*)address title:(NSString*)title token:(id)token
{
    NSArray* array = [address componentsSeparatedByString:@","];
    if(2 == [array count])
    {
        // 添加一个PointAnnotation
        RCPointAnnotation* annotation = [[RCPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [[array objectAtIndex:1] floatValue];
        coor.longitude = [[array objectAtIndex:0] floatValue];
        annotation.coordinate = coor;
        annotation.title = title;
        annotation.token = token;
        [self.mapView addAnnotation:annotation];
    }
}


// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return nil;
	}
    else if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title];
        //newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.canShowCallout = NO;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }


    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    
    if([view.annotation isKindOfClass:[RCPointAnnotation class]])
    {
        RCPointAnnotation* annotation = ( RCPointAnnotation*)view.annotation;
        NSDictionary* token = (NSDictionary*)annotation.token;
        if(token && [token isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"token:%@",token);
            
            NSString* jd_gps = [token objectForKey:@"jd_gps"];
            if([jd_gps length])
            {

            }
            else
            {

            }
        }
    }
}

#pragma mark - addOverlay

- (void)addOverlay:(NSString*)address
{
    NSArray* array = [self.address componentsSeparatedByString:@","];
    if(2 == [array count])
    {
        CLLocationCoordinate2D coor;
        coor.latitude = [[array objectAtIndex:1] floatValue];
        coor.longitude = [[array objectAtIndex:0] floatValue];
        
        BMKCircle* circle = [BMKCircle circleWithCenterCoordinate:coor radius:1000];
        [self.mapView addOverlay:circle];
    }
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView *view = [[BMKCircleView alloc] initWithOverlay:overlay];
        //newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        //view.animatesDrop = YES;// 设置该标注点动画显示
        return view;
    }
    else if([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    
    return nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    //NSLog(@"mapViewWillStartLocatingUser");
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation");
}

- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    //NSLog(@"mapViewDidStopLocatingUser");
}



#pragma mark -

- (void)initButton
{
    if(nil == _stepper)
    {
        _stepper = [[UIStepper alloc] initWithFrame:CGRectMake(20,[RCTool getScreenSize].height - 60, 100, 40)];
        _stepper.value = 13;
        _stepper.maximumValue = 20;
        _stepper.minimumValue = 5;
        _stepper.stepValue = 1;
        
        if([RCTool systemVersion] < 7.0)
            _stepper.tintColor = [UIColor clearColor];
        else
            _stepper.tintColor = [UIColor blackColor];
        
        [_stepper setDecrementImage:[UIImage imageNamed:@"zoom_out"] forState:UIControlStateNormal];
        [_stepper setIncrementImage:[UIImage imageNamed:@"zoom_in"] forState:UIControlStateNormal];
        [_stepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    [[RCTool frontWindow] addSubview:self.stepper];
    
    if(nil == _locationButton)
    {
        self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.locationButton setImage:[UIImage imageNamed:@"location_button1"] forState:UIControlStateNormal];
        self.locationButton.frame = CGRectMake(0, 0, 40, 40);
        self.locationButton.center = CGPointMake([RCTool getScreenSize].width - 46, [RCTool getScreenSize].height - 46);
        self.locationButton.layer.borderColor = [UIColor blackColor].CGColor;
        self.locationButton.layer.borderWidth = 1;
        self.locationButton.layer.cornerRadius = 7.0f;
        
        [self.locationButton addTarget:self action:@selector(clickedLocationButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [[RCTool frontWindow] addSubview:self.locationButton];
}

- (void)stepperValueChanged:(id)sender
{
    UIStepper* stepper = (UIStepper*)sender;
    if(stepper)
    {
        NSLog(@"stepper.value:%f",stepper.value);
        
        [self.mapView setZoomLevel:(float)stepper.value];
    }
    
}

- (void)clickedLocationButton:(id)sender
{
    NSLog(@"clickedLocationButton");
    
    if(nil == self.mapView)
        return;
    
    RCAppDelegate* appDelegate = (RCAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.userLocation)
    {
        BMKCoordinateRegion region;
        region.center.latitude  = appDelegate.userLocation.location.coordinate.latitude;
        region.center.longitude = appDelegate.userLocation.location.coordinate.longitude;
        [self.mapView setRegion:region animated:YES];
    }
    

}

@end
