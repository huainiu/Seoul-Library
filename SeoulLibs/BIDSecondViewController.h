//
//  BIDSecondViewController.h
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 7. 31..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>
#import <MapKit/MKUserLocation.h>

@interface BIDSecondViewController : UIViewController
{
    UITextField *guText;
    UIActivityIndicatorView *activityIndicator; //가운데 로딩 돌아가는거

}

@property (nonatomic, retain) IBOutlet UITextField *guText;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator; //가운데 로딩 돌아가는거

- (IBAction)goToInnerDepth:(id)sender;
- (IBAction)goSearch:(id)sender;

@end
