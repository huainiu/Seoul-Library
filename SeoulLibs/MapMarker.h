//
//  MapMarker.h
//  SeoulLibs
//
//  Created by SeokWoo Rho on 12. 8. 13..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface MapMarker : NSObject <MKAnnotation> 
{
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;	
    int libNumber;
}

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic) int libNumber;

@end
