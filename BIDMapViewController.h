//
//  BIDMapViewController.h
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 8. 3..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKMapView.h>

@interface BIDMapViewController : UIViewController
{
    IBOutlet MKMapView *myMapView;
    CLLocationCoordinate2D coordinate; //핀 좌표
    NSString *title; //핀 제목
    NSString *subtitle; //핀 부제
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
