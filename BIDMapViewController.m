//
//  BIDMapViewController.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 8. 3..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocation.h>
#import <MapKit/MKUserLocation.h>

@interface BIDMapViewController ()

@end

@implementation BIDMapViewController
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
    MKCoordinateRegion region; //표시할 지도의 부분
    MKCoordinateSpan span; //보여줄 지도가 처리할 넓이. 숫자가 작을수록 확대되어 보임
    
    span.longitudeDelta = 0.005;
    span.latitudeDelta = 0.005;
    
    region.center = CLLocationCoordinate2DMake(37.564123, 126.974702); //위도,경도
    region.span = span;
    
    [myMapView setRegion:region animated:YES];
    [myMapView setCenterCoordinate:region.center animated:YES];
    [myMapView regionThatFits:region];
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
