//
//  BIDMapViewController.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 8. 3..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDMapViewController.h"
#import "MapMarker.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocation.h>
#import <MapKit/MKUserLocation.h>
#import <MapKit/MKPinAnnotationView.h>
#import "BIDLibInfoViewController.h"

@interface BIDMapViewController ()

@end

@implementation BIDMapViewController

@synthesize startPoint;
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"구 선택";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    MKCoordinateRegion region; //표시할 지도의 부분
    MKCoordinateSpan span; //보여줄 지도가 처리할 넓이. 숫자가 작을수록 확대되어 보임
    
    
    double sumLatitude = 0;
    double averageLatitude = 0;
    double sumLongtitude = 0;
    double averageLongtitude = 0;
    //지도의 센터를 설정해주기 위한 같잖은 알고리즘
    for(int i=0; i<[[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"]; i++) {
        
        sumLatitude = sumLatitude + [[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_latitude", i]] doubleValue];
        sumLongtitude = sumLongtitude + [[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_longtitude", i]] doubleValue];
    }

    averageLatitude = sumLatitude / ( [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"] );
    averageLongtitude = sumLongtitude / ( [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"] );
    NSLog(@"averageLatitude : %f", averageLatitude);
    NSLog(@"averageLongtitude : %f", averageLongtitude);
    
    span.longitudeDelta = 0.058;
    span.latitudeDelta = 0.058;
    
    region.center = CLLocationCoordinate2DMake(averageLatitude, averageLongtitude); //센터 위치 (위도,경도)
    region.span = span;
    
    [myMapView setRegion:region animated:YES];
    [myMapView setCenterCoordinate:region.center animated:YES];
    [myMapView regionThatFits:region];
    [myMapView setShowsUserLocation:YES];
    [myMapView .userLocation setTitle:@"현 위치"];
        
    for(int i=0; i<[[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"]; i++) {
        
        MapMarker *marker = [[MapMarker alloc] init];
        MKCoordinateRegion markerRegion;
        markerRegion.center = CLLocationCoordinate2DMake([[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_latitude", i]] doubleValue], [[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_longtitude", i]] doubleValue]);
                
        marker.coordinate = markerRegion.center;
        marker.title = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_name", i]];
        marker.libNumber = i;
        [myMapView addAnnotation:marker];
    }
}   
    

-(MKAnnotationView *)mapView:(MKMapView *)myMapView viewForAnnotation:(id<MKAnnotation>)annotation{
    NSLog(@"BIDMapViewController - viewForAnnotation 메서드 실행");
    
    MKPinAnnotationView *dropPin = nil; //마커 준비
    static NSString *reusePinID = @"branchPin"; //마커 객체를 재사용 하기위한 ID
    
    //마커 초기화
    dropPin = (MKPinAnnotationView *)[myMapView 
                                      dequeueReusableAnnotationViewWithIdentifier:reusePinID]; 
    if ( dropPin == nil ) dropPin = [[MKPinAnnotationView alloc]
                                     initWithAnnotation:annotation reuseIdentifier:reusePinID];
    
    //핀이 떨어지는 애니메이션
    dropPin.animatesDrop = YES;
        
    //마커 오른쪽에 (>) 모양 버튼 초기화.
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    dropPin.userInteractionEnabled = TRUE;
    dropPin.canShowCallout = YES;
    dropPin.rightCalloutAccessoryView = infoBtn;

    return dropPin;

}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"BIDMapViewController - calloutAccessoryControlTapped 메서드 실행");
    MapMarker *annotation = view.annotation;
    int i = annotation.libNumber;
    
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_class", i]] forKey:@"currentLibInfo_class"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_id", i]] forKey:@"currentLibInfo_id"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_distance", i]] forKey:@"currentLibInfo_distance"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_longtitude", i]] forKey:@"currentLibInfo_longtitude"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_latitude", i]] forKey:@"currentLibInfo_latitude"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_name", i]] forKey:@"currentLibInfo_name"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_category", i]] forKey:@"currentLibInfo_category"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_guname", i]] forKey:@"currentLibInfo_guname"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_dongname", i]] forKey:@"currentLibInfo_dongname"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_slaveno", i]] forKey:@"currentLibInfo_slaveno"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_organization", i]] forKey:@"currentLibInfo_organization"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_opendate", i]] forKey:@"currentLibInfo_guname"];

    BIDLibInfoViewController *libInfoViewController = [BIDLibInfoViewController alloc];
    [self.navigationController pushViewController:libInfoViewController animated:YES];

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
