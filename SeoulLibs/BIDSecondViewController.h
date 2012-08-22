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
// 구 선택하면 지도 뷰 컨트롤러로 이동
- (IBAction)goSearch:(id)sender;

- (IBAction)gangseogu:(id)sender; //강서구
- (IBAction)yangcheongu:(id)sender; //양천구
- (IBAction)jongrogu:(id)sender; //종로구



@end
