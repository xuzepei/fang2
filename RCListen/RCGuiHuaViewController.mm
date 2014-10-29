//
//  RCGuiHuaViewController.m
//  RCFang
//
//  Created by xuzepei on 9/10/14.
//  Copyright (c) 2014 xuzepei. All rights reserved.
//

#import "RCGuiHuaViewController.h"
#import "RCSearchAddressTableViewController.h"
#import "RCCreateDDViewController.h"
#import "RCPointOverlayView.h"
#import "RouteAnnotation.h"
#import "RCPointAnnotation.h"
#import "RCDDStep2ViewController.h"

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

@interface RCGuiHuaViewController ()

@end

@implementation RCGuiHuaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"路径规划";
        
        UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBackButton:)];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
        
//        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选定" style:UIBarButtonItemStylePlain target:self action:@selector(clickedFinishButton:)];
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
    }
    return self;
}

- (void)dealloc {
    
    self.tf0 = nil;
    self.tf1 = nil;
    self.delegate = nil;
    
    if (_search != nil) {
        self.search = nil;
    }
    if (_mapView) {
        self.mapView = nil;
    }
    
    self.routePlan = nil;
    self.qdInfo = nil;
    self.zdInfo = nil;
    
    [super dealloc];
}

- (void)clickedBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickedFinishButton:(id)sender
{
    [self clickedNextButton:nil];
}

- (IBAction)clickedNextButton:(id)sender
{
    if(nil == self.routePlan)
    {
        [RCTool showAlert:@"提示" message:@"对不起，您还未完成路径规划，请稍候尝试。"];
        return;
    }
    
    NSString* username = [RCTool getUsername];
    if(0 == [username length])
    {
        [RCTool showAlert:@"提示" message:@"请先登录！"];
        return ;
    }
    
    NSString* begin_address = self.qdInfo.name;
    if(0 == [begin_address length])
    {
        [RCTool showAlert:@"提示" message:@"请输入起点位置!"];
        return ;
    }
    
    NSString* end_address = self.zdInfo.name;
    if(0 == [end_address length])
    {
        [RCTool showAlert:@"提示" message:@"请输入终点点位置!"];
        return ;
    }
    
    NSString* mileage =[NSString stringWithFormat:@"约%.1f公里",self.routePlan.distance/1000.0];
    if(0 == [mileage length])
    {
        [RCTool showAlert:@"提示" message:@"里程计算失败，请稍后尝试!"];
        return ;
    }
    else
    {
        mileage = [NSString stringWithFormat:@"%.2f",self.routePlan.distance/1000.0];
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/order_remover.php?apiid=%@&pwd=%@",BASE_URL,APIID,PWD];
    
    NSString* token = [NSString stringWithFormat:@"type=remover&step=2&username=%@&begin_address=%@&end_address=%@&mileage=%@",username,begin_address,end_address,mileage];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init];
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedPostRequest:) token:token];
    if(b)
    {
        [RCTool showIndicator:@"请稍候..."];
    }
}

- (void)finishedPostRequest:(NSString*)jsonString
{
    [RCTool hideIndicator];
    
    if(0 == [jsonString length])
        return;
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        NSString* error = [result objectForKey:@"error"];
        if(0 == [error length])
        {
            RCDDStep2ViewController* temp = [[RCDDStep2ViewController alloc] initWithNibName:nil bundle:nil];
            [temp updateContent:result];
            [self.navigationController pushViewController:temp animated:YES];
            return;
        }
        
        [RCTool showAlert:@"提示" message:error];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locationService.delegate = self;
    
    if(self.qdInfo)
    {
        self.tf0.text = self.qdInfo.name;
    }
    
    if(self.zdInfo)
    {
        self.tf1.text = self.zdInfo.name;
    }
    
    [self route];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil; // 不用时，置nil
    _locationService.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(_mapView)
    {
       _mapView.delegate = self;
        [_mapView setShowsUserLocation:YES];

        [_mapView setZoomLevel:15];
    }
    
    //初始化BMKLocationService
    if(nil == _locationService)
    {
        _locationService = [[BMKLocationService alloc] init];
        _locationService.delegate = self;
        //启动LocationService
        [_locationService startUserLocationService];
    }
    
    
    if(nil == _search)
        _search = [[BMKRouteSearch alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(100 == textField.tag)
    {
        RCSearchAddressTableViewController* temp = [[RCSearchAddressTableViewController alloc] initWithNibName:nil bundle:nil];
        temp.delegate = self;
        NSDictionary* dict = @{@"placeholder":@"请输入起点位置",@"type":@"0"};
        [temp updateContent:dict];
        [self.navigationController pushViewController:temp      animated:YES];
    }
    else if(101 == textField.tag)
    {
        RCSearchAddressTableViewController* temp = [[RCSearchAddressTableViewController alloc] initWithNibName:nil bundle:nil];
        temp.delegate = self;
        NSDictionary* dict = @{@"placeholder":@"请输入终点位置",@"type":@"1"};
        [temp updateContent:dict];
        [self.navigationController pushViewController:temp      animated:YES];
    }
    
    return NO;
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
        [annotation release];
    }
}


// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:self.mapView viewForAnnotation:(RouteAnnotation*)annotation];
	}
    else if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title];
        newAnnotationView.image = [UIImage imageNamed:@"map_mark"];
        newAnnotationView.canShowCallout = NO;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return [newAnnotationView autorelease];
    }
    
    
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    
}

#pragma mark - addOverlay

- (void)addOverlay:(NSString*)address
{
    NSArray* array = [address componentsSeparatedByString:@","];
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
        return [view autorelease];
    }
    else if([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    
    return nil;
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation");
    
    [_locationService stopUserLocationService];
    
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    [self.mapView setRegion:region animated:YES];
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude =   userLocation.location.coordinate.latitude;
    coor.longitude =  userLocation.location.coordinate.longitude;
    annotation.coordinate = coor;
    annotation.title = @"当前位置";
    [_mapView addAnnotation:annotation];

}

#pragma mark - Route

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

//- (void)route
//{
//    if(nil == self.item)
//        return;
//    
//    NSArray* points = [self.item objectForKey:@"points"];
//    if(0 == [points count])
//        return;
//    
//    NSDictionary* point = [points objectAtIndex:0];
//    self.address = [point objectForKey:@"jd_gps"];
//    
//    if(0 == [self.address length])
//        self.address = [point objectForKey:@"gps"];
//    
//    if(1 == [points count])
//    {
//        NSDictionary* point = [points lastObject];
//        NSString* address = [point objectForKey:@"jd_gps"];
//        if(0 == [address length])
//            address = [point objectForKey:@"gps"];
//        
//        NSArray* array = [address componentsSeparatedByString:@","];
//        if(2 == [array count])
//        {
//            CLLocationCoordinate2D endLocation;
//            endLocation.latitude = [[array objectAtIndex:1] floatValue];
//            endLocation.longitude = [[array objectAtIndex:0] floatValue];
//            
//            CLLocationCoordinate2D startLocation = _mapView.userLocation.location.coordinate;
//            
//            BMKPlanNode* start = [[BMKPlanNode alloc]init];
//            start.pt = startLocation;
//            start.name = nil;
//            
//            BMKPlanNode* end = [[BMKPlanNode alloc]init];
//            end.pt = endLocation;
//            end.name = nil;
//            
//            BOOL flag = [_search drivingSearch:nil startNode:start endCity:nil endNode:end];
//            if (!flag) {
//                NSLog(@"search failed");
//                
//                //                static int i = 0;
//                //                if(i < 3)
//                //                {
//                //                    [self route];
//                //                    i++;
//                //                }
//            }
//            [start release];
//            [end release];
//        }
//    }
//    
//}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"] autorelease];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"] autorelease];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
        }
            break;
		default:
			break;
	}
	
	return view;
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
	if (error == BMK_SEARCH_NO_ERROR) {

        //从plan中获取距离和时间信息
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        self.routePlan = plan;
        
        // 计算路线方案中的路段数目
		int size = [plan.steps count];
		int planPointCounts = 0;
		for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                [item release];
                
                [_mapView setCenterCoordinate:plan.starting.location animated:YES];
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                [item release];
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            [item release];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
                [item release];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
		[_mapView addOverlay:polyLine]; // 添加路线overlay
		delete []temppoints;
        
		
	}
}


- (void)route
{
    if(nil == self.qdInfo || nil == self.zdInfo)
        return;
    
    CLLocationCoordinate2D endLocation = self.zdInfo.pt;
    
    CLLocationCoordinate2D startLocation = self.qdInfo.pt;
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = startLocation;
    start.name = nil;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = endLocation;
    end.name = nil;

    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_search drivingSearch:drivingRouteSearchOption];
    [drivingRouteSearchOption release];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}


@end
