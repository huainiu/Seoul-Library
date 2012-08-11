//
//  BIDFirstViewController.h
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 7. 31..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BIDLibInfoViewController.h"

@interface BIDFirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
{
    UITableView *resultTable;
    CLLocationManager *locationManager;
    CLLocation *startingPoint;
    UIActivityIndicatorView *activityIndicator; //가운데 로딩 돌아가는거

}

- (void) getRadius:(NSString *)library_class longtitude:(NSString *)longtitude latitude:(NSString *)latitude radius:(NSString *)radius; //반경 검색
- (void) parseRadius:(NSString *)jsonString; //반경 파싱

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator; //가운데 로딩 돌아가는거
@property (strong, nonatomic) NSArray *listData;
@property (nonatomic, retain) IBOutlet UITableView *resultTable;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startingPoint;


@end
