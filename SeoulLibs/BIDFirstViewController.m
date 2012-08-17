//
//  BIDFirstViewController.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 7. 31..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDFirstViewController.h"
#import "BIDLibInfoViewController.h"
#import "HTTPRequest.h"
#import "SBJson.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BIDRadiusSelectViewController.h"


NSString *dataFlag1 = nil; //어떤 데이터를 받아온건지 구분해주는 flag
NSString *currentLatitude = nil;
NSString *currentLongtitude = nil;

int getRadiusDataFlag = 0;
NSMutableArray *radiusDataArray = nil; 
NSMutableArray *radiusSumArray = nil; 
NSMutableArray *radiusResultArray = nil;

@interface BIDFirstViewController ()

@end

@implementation BIDFirstViewController
@synthesize listData;
@synthesize resultTable;
@synthesize locationManager;
@synthesize startingPoint;
@synthesize activityIndicator;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"내주변", @"내주변");
        self.tabBarItem.image = [UIImage imageNamed:@"First"];
        self.navigationItem.title = @"내 주변";
    }
    return self;
}
							
- (void)viewDidLoad
{
    NSLog(@"FirstViewController viewDidLoad 메서드 실행");
    
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    self.title = @"내 주변";
    
    radiusArray = [[NSArray alloc] initWithObjects:@"100m", @"300m", @"500m", @"1km", @"3km", nil];

    
}

- (void)viewDidAppear {    
    NSLog(@"FirstViewController viewDidAppear 메서드 실행");

}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"FirstViewController didUpdateToLocation 메서드 실행");

    if (startingPoint == nil) {
        self.startingPoint = newLocation;
    }
    
    currentLatitude = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.latitude];
    currentLongtitude = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.longitude];
    
    [locationManager stopUpdatingLocation];

    
    
    if(activityIndicator == nil){
        //Activity Indicator 세팅
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [activityIndicator setCenter:self.view.center];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview : activityIndicator];
    }
    
    //Activity Indicator 활성화.
    activityIndicator.hidden= FALSE;
    [activityIndicator startAnimating];
    
    NSLog(@"latitude : %@, longtitude : %@", currentLatitude, currentLongtitude);

    [self getRadius:@"large" longtitude:currentLongtitude latitude:currentLatitude radius:@"2000"];
    [self getRadius:@"small" longtitude:currentLongtitude latitude:currentLatitude radius:@"2000"];
    
}


//반경 검색. GET
- (void) getRadius:(NSString *)library_class longtitude:(NSString *)longtitude latitude:(NSString *)latitude radius:(NSString *)radius { 
    NSLog(@"getRadius 메서드 실행");
    
    dataFlag1 = @"getRadius";
    
    //접속할 주소 설정
    //예시 : http://seoullibrary.herokuapp.com/large/126.943500840537/37.5091943655437/1000
    NSString *url = [[NSString alloc] initWithFormat:@"http://seoullibrary.herokuapp.com/%@/%@/%@/%@", library_class, longtitude, latitude, radius];
    
    // HTTP Request 인스턴스 생성
    HTTPRequest *httpRequest = [[HTTPRequest alloc] init];
    
    // POST로 전송할 데이터 설정
    NSDictionary *bodyObject = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    
    // 통신 완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
    
    // 페이지 호출
    [httpRequest requestUrl:url bodyObject:bodyObject];
}

//HTTP통신 완료되었을 경우 실행되는 메서드(데이터를 받아왔을 때)
- (void)didReceiveFinished:(NSString *)result
{
    NSLog(@"didReceiveFinished 메소드 실행. dataFlag1 : %@", dataFlag1);
    
    NSString *jsonString = result;
    
    //dataFlag1 값에 따라서 각각 다른 파싱메서드를 호출해준다
    if ([dataFlag1 isEqualToString:@"getRadius"]) {
        [self parseRadius:jsonString];
    }
    else if ([dataFlag1 isEqualToString:@"getDist"]) {
//        [self parseDist:jsonString];
    }
    else if ([dataFlag1 isEqualToString:@"getComment"]) {
//        [self parseComment:jsonString];
    }
    else if ([dataFlag1 isEqualToString:@"updateComment"]) {
//        [self parseUpdateComment:jsonString];
    }
    else if ([dataFlag1 isEqualToString:@"getRating"]) {
//        [self parseRating:jsonString];
    }
    else if ([dataFlag1 isEqualToString:@"updateRating"]) {
//        [self parseUpdateRating:jsonString];
    }
    else {
        
    }
}



//반경 파싱
- (void) parseRadius: (NSString *)jsonString {
    
    getRadiusDataFlag = getRadiusDataFlag + 1; //데이터 1번 받아온거 확보되었으니 flag에 1을 더해줌

    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    NSMutableDictionary* radius = [ parser objectWithString: jsonString ];
    
    NSLog(@"요청처리시간: %@", [radius valueForKey:@"time"]);
    NSLog(@"반경검색 결과의 수: %@", [radius valueForKey:@"total_rows"]);
    
    if (getRadiusDataFlag == 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:[[radius valueForKey:@"total_rows"] intValue] forKey:@"resultCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"resultCount : %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"]);
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"] +[[radius valueForKey:@"total_rows"] intValue] forKey:@"resultCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"resultCount : %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"]);
    }
    
    radiusDataArray = [radius objectForKey:@"rows"];

    if (getRadiusDataFlag == 1) {
        radiusSumArray = radiusDataArray;
        [radiusSumArray setArray:radiusDataArray]; //새로 받아온 데이터 Array중 rows 부분을 sumArray에 넣어준다
    }
    else {
        for (int i=0; i < [radiusDataArray count]; i++) {
            [radiusSumArray addObject:[radiusDataArray objectAtIndex:i]];
        }
    }

    if(getRadiusDataFlag == 2) { //데이터를 2번 받아왔다면(large, small)
        
        radiusResultArray = radiusSumArray;
    
        //정렬
        NSSortDescriptor *arraySorter = [[NSSortDescriptor alloc] initWithKey:@"fclty_nm" ascending:YES];
        [radiusResultArray sortUsingDescriptors:[NSArray arrayWithObject:arraySorter]];
        
        for (int i=0; i < [radiusResultArray count]; i++) {
            NSLog(@"도서관 종류%i: %@", i,[[radiusResultArray objectAtIndex:i] valueForKey:@"lib_class"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"lib_class"] forKey:[NSString stringWithFormat:@"1_lib%i_class", i]];
            NSLog(@"도서관 id%i: %@", i,[[radiusResultArray objectAtIndex:i] valueForKey:@"cartodb_id"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"cartodb_id"] forKey:[NSString stringWithFormat:@"1_lib%i_id", i]];
            NSLog(@"도서관의 좌표%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"st_astext"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"st_astext"] forKey:[NSString stringWithFormat:@"1_lib%i_point", i]];
            NSLog(@"도서관 이름%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"fclty_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"fclty_nm"] forKey:[NSString stringWithFormat:@"1_lib%i_name", i]];
            NSLog(@"도서관 구분%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"fly_gbn"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"fly_gbn"] forKey:[NSString stringWithFormat:@"1_lib%i_category", i]];
            NSLog(@"행정구 이름%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"gu_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"gu_nm"] forKey:[NSString stringWithFormat:@"1_lib%i_guname", i]];
            NSLog(@"행정동 이름%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"hnr_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"hnr_nm"] forKey:[NSString stringWithFormat:@"1_lib%i_dongname", i]];
            NSLog(@"주 지번%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"masterno"]);
            NSLog(@"보조 지번%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"slaveno"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"slaveno"] forKey:[NSString stringWithFormat:@"1_lib%i_slaveno", i]];
            NSLog(@"운영 주최%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"orn_org"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"orn_org"] forKey:[NSString stringWithFormat:@"1_lib%i_organization", i]];
            NSLog(@"개관일%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"opnng_de"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"opnng_de"] forKey:[NSString stringWithFormat:@"1_lib%i_opendate", i]];

            [[NSUserDefaults standardUserDefaults] synchronize];

            //Activity Indicator 비활성화.
            [activityIndicator stopAnimating];     
            activityIndicator.hidden= TRUE;
            
            [resultTable beginUpdates];
            NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:i inSection:0];
            
            NSArray *indexPathArray = [NSArray arrayWithObjects:indexPath0, nil];
            
            [resultTable reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            
            [resultTable endUpdates];

        }
    }
    
    
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BIDLibInfoViewController *libInfoViewController = [BIDLibInfoViewController alloc];
    
    [resultTable deselectRowAtIndexPath:indexPath animated:YES];
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"selectedLib"];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"tabFlag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController pushViewController:libInfoViewController animated:YES];
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_name", indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (IBAction)popupSetting {
    
    UIActionSheet *myActionSheet;
    myActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [myActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];//액션시트 스타일, 뭔지는 모르겠음

    UIPickerView *radiusPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    radiusPickerView.delegate = self;
    radiusPickerView.showsSelectionIndicator = YES;
    
    [myActionSheet addSubview:radiusPickerView]; //액션시트에 피커뷰 띄우기
    
    UIView *keyview = [[[[UIApplication sharedApplication] keyWindow]subviews]objectAtIndex:0]; // 최상단 뷰
    [myActionSheet showInView:keyview];//최상단 뷰에 액션시트 띄우기
    
    [myActionSheet setBounds:CGRectMake(0, 0, 320, 410)];
    
}


    

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    // 피커뷰의 컴포넌트 개수 정의 (세로로 구분되는 항목) - 우리 앱은 1개라서 리턴값 1.
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // 컴포넌트 별 항목 수 정의 , 컴포넌트가 여러개일 경우 switch문을 이용해서 분기.
    // 우리 어플은 컴포넌트가 1개이므로 걍 어레이의 데이터 행 개수와 동일
    return  [radiusArray count];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //각 행에 출력하는 이름 - 반경 어레이에서 가져옴
    return [radiusArray objectAtIndex:row];
}




@end
