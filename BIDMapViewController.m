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

@interface BIDMapViewController ()

@end

@implementation BIDMapViewController

@synthesize startPoint;
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize longtitudeArray;
@synthesize latitudeArray;



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
    
    span.longitudeDelta = 0.05;
    span.latitudeDelta = 0.05;
    
    region.center = CLLocationCoordinate2DMake([[[NSUserDefaults standardUserDefaults] stringForKey:@"2_lib1_latitude"] doubleValue], [[[NSUserDefaults standardUserDefaults] stringForKey:@"2_lib1_longtitude"] doubleValue]); //위도,경도
    region.span = span;
    
    [myMapView setRegion:region animated:YES];
    [myMapView setCenterCoordinate:region.center animated:YES];
    [myMapView regionThatFits:region];
    [myMapView setShowsUserLocation:YES];
    [myMapView .userLocation setTitle:@"현 위치"];
    
    longtitudeArray = [[NSMutableArray alloc] init];
    latitudeArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *markerArray = nil;
    
    for(int i=0; i<[[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"]; i++) {
        MapMarker *marker = [[MapMarker alloc] init];
        MKCoordinateRegion markerRegion;
        markerRegion.center = CLLocationCoordinate2DMake([[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_latitude", i]] doubleValue], [[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_longtitude", i]] doubleValue]);
        marker.coordinate = markerRegion.center;
        marker.title = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"2_lib%i_name", i]];
        [myMapView addAnnotation:marker];

    }
    

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
