//
//  RCMapViewController.m
//  RCFang
//
//  Created by xuzepei on 3/20/13.
//  Copyright (c) 2013 xuzepei. All rights reserved.
//

#import "RCMapViewController.h"
#import "RCTool.h"
#import "RCMapAnnotation.h"

@interface RCMapViewController ()

@end

@implementation RCMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(self.view){
            //call self.view to loadv iew
            
            self.title = @"地址";
            
            [self initMapView];
        }
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    //[self getGPS:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initMapView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.mapView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{

}

- (void)initMapView
{
    if (nil == _mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, [RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)];
        _mapView.delegate = self;
        [_mapView setZoomEnabled:YES];
        [_mapView setScrollEnabled:YES];
    }
    
    [self.view addSubview: _mapView];
}

- (void)updateContent:(NSString*)latlng
{
    if(0 == [latlng length])
        return;
    
    self.latlng = latlng;
    _isValidCoordinate = NO;
    
    if(_mapView)
    {
        NSRange range = [latlng rangeOfString:@","];
        if(range.location == NSNotFound)
            return;
        
        NSString* latitude = [latlng substringToIndex:range.location];
        NSString* longitude = [latlng substringFromIndex:range.location+1];
        if([latitude length] && [longitude length])
        {
            CLLocationCoordinate2D centerCoordinate;
            centerCoordinate.latitude = [latitude doubleValue];
            centerCoordinate.longitude = [longitude doubleValue];
            if(CLLocationCoordinate2DIsValid(centerCoordinate))
            {
                _isValidCoordinate = YES;
                [_mapView setCenterCoordinate:centerCoordinate animated:YES];
                
                RCMapAnnotation* annotation = [[RCMapAnnotation alloc] initWithCoordinate:centerCoordinate];
                annotation.title = @"";
                [_mapView addAnnotation:annotation];
                
                MKCoordinateSpan span;
                span.latitudeDelta = 0.01;
                span.longitudeDelta = 0.01;
                
                MKCoordinateRegion region;
                region.center = centerCoordinate;
                region.span = span;
                
                [_mapView setRegion:region animated:YES];
            }
        }
    }
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"mapViewDidFinishLoadingMap");
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"mapViewDidFailLoadingMap");
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        CGRect endFrame = aV.frame;
        
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [aV setFrame:endFrame];
        [UIView commitAnimations];
        
    }
}


- (void)getGPS:(id)token
{
    if(NO == [CLLocationManager locationServicesEnabled])
    {
        [RCTool showAlert:@"提示" message:@"定位服务已关闭，请先在系统设置中打开定位服务。"];
    }
    else
    {
        if(nil == _locationManager)
        {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [_locationManager startUpdatingLocation];
        }
    }
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
	NSLog(@"didFailWithError: %@", error);
    

    _locationManager = nil;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	NSLog(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    
    self.location = newLocation;
    if(_location)
    {
        self.coordinate = [NSString stringWithFormat:@"%lf,%lf",_location.coordinate.latitude,_location.coordinate.longitude];
        
    }
    

    _locationManager = nil;
	
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region  {

}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {

}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
}


@end
