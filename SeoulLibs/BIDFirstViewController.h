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

@interface BIDFirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate >
{
    UITableView *resultTable;
    CLLocationManager *locationManager;
    CLLocation *startingPoint;
    UIActivityIndicatorView *activityIndicator; //가운데 로딩 돌아가는거
    NSArray *radiusArray; //반경 목록 어레이
    NSArray *listData;
    __weak IBOutlet UILabel *selectedRadius;
    __weak IBOutlet UIButton *radiusButton;
    
}

- (void) getRadius:(NSString *)library_class longtitude:(NSString *)longtitude latitude:(NSString *)latitude radius:(NSString *)radius; //반경 검색
- (void) parseRadius:(NSString *)jsonString; //반경 파싱

- (IBAction)popupSetting;
// 반경 버튼을 클릭하여 반경을 선택하는 모달뷰를 띄운다.

- (IBAction)selectRadius;
//반경 선택 액션

- (IBAction)refresh;
//새로고침 메서드

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator; //가운데 로딩 돌아가는거
@property (strong, nonatomic) NSArray *listData;
@property (nonatomic, retain) IBOutlet UITableView *resultTable;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startingPoint;
@property (nonatomic, retain) UIActionSheet *myActionSheet;
@property (weak, nonatomic) IBOutlet UILabel *selectedRadius; //선택된 반경값
@property (weak, nonatomic) IBOutlet UIButton *radiusButton;




@end
