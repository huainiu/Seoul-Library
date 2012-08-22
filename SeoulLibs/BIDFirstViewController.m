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
int resultCount = 0; //반경검색 결과의 수를 저장할 변수.
NSString *radiusValue = @"100m"; //반경 범위를 담아둘 변수. 디폴트가 100임.
NSString *radiusIntValue = @"100"; //반경 범위의 실제 숫자 값을 담아둘 변수. 디폴트 100.
NSMutableArray *radiusDataArray = nil; 
NSMutableArray *radiusSumArray = nil; 
NSMutableArray *radiusResultArray = nil;

NSMutableArray *libClass; //큰도서관,작은도서관 여부 데이터 저장 어레이
NSMutableArray *libId; //도서관 id 저장 어레이
NSMutableArray *libDistance; //도서관 거리 저장 어레이
NSMutableArray *libLongitude; //도서관 경도 저장 어레이
NSMutableArray *libLatitude; //도서관 위도 저장 어레이
NSMutableArray *libName; //도서관 이름 저장 어레이
NSMutableArray *libCategory; //도서관 분류 저장 어레이
NSMutableArray *libGuname; //도서관 구이름 저장 어레이
NSMutableArray *libDongname; //도서관 동이름 저장 어레이
NSMutableArray *libMasterno; //도서관 주지번 저장 어레이
NSMutableArray *libSlaveno; //도서관 보조지번 저장 어레이
NSMutableArray *libOrganization; //도서관  저장 어레이
NSMutableArray *libOpendate; //도서관 개관일 저장 어레이



@interface BIDFirstViewController ()

@end

UIActionSheet *myActionSheet = nil;

@implementation BIDFirstViewController
@synthesize radiusButton;//반경 선택 버튼
@synthesize listData;
@synthesize resultTable;
@synthesize locationManager;
@synthesize startingPoint;
@synthesize activityIndicator;
//@synthesize myActionSheet;


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
    self.title = @"내 주변";
    radiusArray = [[NSArray alloc] initWithObjects:@"100m", @"300m", @"500m", @"1km", @"3km", nil];
    [self.radiusButton setTitle:@"100m" forState:UIControlStateNormal]; //반경 버튼 초기값 100m
    
}


- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"FirstViewController viewDidAppear 메서드 실행");
    
    radiusButton.titleLabel.text = [NSString stringWithFormat:@"%@m", radiusValue]; //반경선택 버튼 타이틀을, 현재 저장된 반경으로 세팅
    
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}


//새로고침 버튼 클릭
- (IBAction)refresh {
    [self viewDidAppear:NO];
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

    [self getRadius:@"large" longtitude:currentLongtitude latitude:currentLatitude radius:radiusIntValue];
    [self getRadius:@"small" longtitude:currentLongtitude latitude:currentLatitude radius:radiusIntValue];
    
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
    
    NSLog(@"반경검색 결과의 수: %@", [radius valueForKey:@"total_rows"]);
    
    if (getRadiusDataFlag == 1) {
        resultCount = [[radius valueForKey:@"total_rows"] intValue];
        NSLog(@"resultCount : %i", resultCount);
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"] +[[radius valueForKey:@"total_rows"] intValue] forKey:@"resultCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        resultCount = resultCount + [[radius valueForKey:@"total_rows"] intValue];
        NSLog(@"resultCount 합계: %i", resultCount);
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
        NSSortDescriptor *arraySorter = [[NSSortDescriptor alloc] initWithKey:@"st_distance" ascending:YES];
        [radiusResultArray sortUsingDescriptors:[NSArray arrayWithObject:arraySorter]];
        
        libClass = [[NSMutableArray alloc] init]; 
        libId = [[NSMutableArray alloc] init];
        libDistance = [[NSMutableArray alloc] init];
        libLongitude = [[NSMutableArray alloc] init];
        libLatitude = [[NSMutableArray alloc] init];
        libName = [[NSMutableArray alloc] init];
        libCategory = [[NSMutableArray alloc] init];
        libGuname = [[NSMutableArray alloc] init];
        libDongname = [[NSMutableArray alloc] init];
        libMasterno = [[NSMutableArray alloc] init];
        libSlaveno = [[NSMutableArray alloc] init];
        libOrganization = [[NSMutableArray alloc] init];
        libOpendate = [[NSMutableArray alloc] init];
        
        
        for (int i=0; i < [radiusResultArray count]; i++) {
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"lib_class"] forKey:[NSString stringWithFormat:@"1_lib%i_class", i]];
//            [libClass addObject:[[radiusResultArray objectAtIndex:i] valueForKey:@"lib_class"]];
            
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"cartodb_id"] forKey:[NSString stringWithFormat:@"1_lib%i_id", i]];
//            [libId addObject:[[radiusResultArray objectAtIndex:i] valueForKey:@"cartodb_id"]];
            NSLog(@"도서관 distance%i: %@", i,[[radiusResultArray objectAtIndex:i] valueForKey:@"st_distance"]);
            
            NSLog(@"distance floatValue : %f", [[[radiusResultArray objectAtIndex:i] valueForKey:@"st_distance"] floatValue]);
            
            [[NSUserDefaults standardUserDefaults] setFloat:[[[radiusResultArray objectAtIndex:i] valueForKey:@"st_distance"] floatValue] forKey:[NSString stringWithFormat:@"1_lib%i_distance", i]];
//            [libDistance addObject:[[radiusResultArray objectAtIndex:i] valueForKey:@"st_distance"]];
            
            //좌표 받아온거 파싱해서 longtitude와 latitude로 분리하기
            NSArray *pointTempArray1 = [[[radiusResultArray objectAtIndex:i] valueForKey:@"st_astext"] componentsSeparatedByString:@"POINT("];
            NSString *pointTempString1 = ((NSString *)[pointTempArray1 objectAtIndex:1]);
            NSArray *pointTempArray2 = [pointTempString1 componentsSeparatedByString:@" "];
            NSString *longtitude = ((NSString *)[pointTempArray2 objectAtIndex:0]);
            NSArray *pointTempArray3 = [((NSString *)[pointTempArray2 objectAtIndex:1]) componentsSeparatedByString:@")"];
            NSString *latitude = ((NSString *)[pointTempArray3 objectAtIndex:0]);
            
            [[NSUserDefaults standardUserDefaults] setValue:longtitude forKey:[NSString stringWithFormat:@"1_lib%i_longtitude", i]];
//            [libLongitude addObject:[[radiusResultArray objectAtIndex:i] valueForKey:longtitude]];
            [[NSUserDefaults standardUserDefaults] setValue:latitude forKey:[NSString stringWithFormat:@"1_lib%i_latitude", i]];
//            [libLatitude addObject:[[radiusResultArray objectAtIndex:i] valueForKey:latitude]];
            
            NSLog(@"도서관 이름%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"fclty_nm"]);
            [libName addObject:[[radiusResultArray objectAtIndex:i] valueForKey:@"fclty_nm"]];
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"fclty_nm"] forKey:[NSString stringWithFormat:@"1_lib%i_name", i]];
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"fly_gbn"] forKey:[NSString stringWithFormat:@"1_lib%i_category", i]];
//            [libCategory addObject:[[radiusResultArray objectAtIndex:i] valueForKey:@"fly_gbn"]];
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"gu_nm"] forKey:[NSString stringWithFormat:@"1_lib%i_guname", i]];
//            [libGuname addObject:[[radiusResultArray objectAtIndex:i] valueForKey:@"gu_nm"]];
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"hnr_nm"] forKey:[NSString stringWithFormat:@"1_lib%i_dongname", i]];
//            [libDongname addObject:[[radiusResultArray objectAtIndex:i] valueForKey:@"hnr_nm"]];
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"masterno"] forKey:[NSString stringWithFormat:@"1_lib%i_masterno", i]];
//            [libMasterno addObject:[[radiusResultArray objectAtIndex:i] valueForKey:@"masterno"]];
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"slaveno"] forKey:[NSString stringWithFormat:@"1_lib%i_slaveno", i]];
//            [libSlaveno addObject:[[radiusResultArray objectAtIndex:i] valueForKey:@"slaveno"]];
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"orn_org"] forKey:[NSString stringWithFormat:@"1_lib%i_organization", i]];
//            [libOrganization addObject:[[radiusResultArray objectAtIndex:i] valueForKey:@"orn_org"]];
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"opnng_de"] forKey:[NSString stringWithFormat:@"1_lib%i_opendate", i]];
//            [libOpendate addObject:[[radiusResultArray objectAtIndex:i] valueForKey:@"opnng_de"]];

            [[NSUserDefaults standardUserDefaults] synchronize];

            //Activity Indicator 비활성화.
            [activityIndicator stopAnimating];     
            activityIndicator.hidden= TRUE;

            
//            [resultTable beginUpdates];
//            NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:i inSection:0];
//            
//            NSArray *indexPathArray = [NSArray arrayWithObjects:indexPath0, nil];
//            
//            [resultTable reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
//            
//            [resultTable endUpdates];
//            
            getRadiusDataFlag = 0;
        }
        
        [resultTable reloadData];
        
    }
    
    
}




- (void)viewDidUnload
{
    radiusButton = nil;
    [self setRadiusButton:nil];
    radiusButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BIDLibInfoViewController *libInfoViewController = [BIDLibInfoViewController alloc];
    
    [resultTable deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_class", indexPath.row]] forKey:@"currentLibInfo_class"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_id", indexPath.row]] forKey:@"currentLibInfo_id"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_distance", indexPath.row]] forKey:@"currentLibInfo_distance"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_longtitude", indexPath.row]] forKey:@"currentLibInfo_longtitude"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_latitude", indexPath.row]] forKey:@"currentLibInfo_latitude"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_name", indexPath.row]] forKey:@"currentLibInfo_name"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_category", indexPath.row]] forKey:@"currentLibInfo_category"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_guname", indexPath.row]] forKey:@"currentLibInfo_guname"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_dongname", indexPath.row]] forKey:@"currentLibInfo_dongname"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_slaveno", indexPath.row]] forKey:@"currentLibInfo_slaveno"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_organization", indexPath.row]] forKey:@"currentLibInfo_organization"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_opendate", indexPath.row]] forKey:@"currentLibInfo_guname"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"tabFlag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController pushViewController:libInfoViewController animated:YES];
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"FirstViewController - numberOfRowsInSection 메서드 실행");
    
    if (resultCount == 0) {
        return 1;
    } else {
        return resultCount;
    }
    //테이블 row 개수를 데이터 받아온 시점에서 다시 세팅할 수 있는지 확인 필요. 우선은 넉넉하게 잡아둠.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"FirstViewController - cellForRowAtIndexPath 메서드 실행. row : %i", indexPath.row);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (resultCount == 0) {
        cell.textLabel.text = @"           검색 결과가 없습니다.";
        //Activity Indicator 비활성화.
        [activityIndicator stopAnimating];     
        activityIndicator.hidden= TRUE;
    } else {
        cell.textLabel.text = [libName objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%fm", [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat:@"1_lib%i_distance", indexPath.row]]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


- (IBAction)popupSetting {
    
    UIView *keyview = [[[[UIApplication sharedApplication] keyWindow]subviews]objectAtIndex:0]; // 최상단 뷰
    
    myActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [myActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];//액션시트 스타일, 뭔지는 모르겠음


    UIPickerView *radiusPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];//툴바 부분을 비워두고 44부터 시작

    
//    UIPickerView *radiusPickerView = [[UIPickerView alloc] init];
//    UIPickerView *radiusPickerView = [[UIPickerView alloc] init];
//    [radiusPickerView setFrame:CGRectMake(0.0f, keyview.frame.size.height - radiusPickerView.frame.size.height, keyview.frame.size.height, radiusPickerView.frame.size.height)]; //피커뷰 위치 지정
    

    radiusPickerView.delegate = self;
    radiusPickerView.showsSelectionIndicator = YES;
    
//    [keyview addSubview:radiusPickerView];
    
    
    [myActionSheet addSubview:radiusPickerView]; //액션시트에 피커뷰 띄우기
    [myActionSheet showInView:keyview];//최상단 뷰에 액션시트 띄우기
    [myActionSheet setBounds:CGRectMake(0, 0, 320, 500)]; //액션시트 위치 지정, 툴바와 피커 크기를 고려하여 바닥부터 크기를 설정
    
    //툴바
    actionSheetToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)]; //액션시트 프레임 기준으로 툴바의 위치, 크기
    actionSheetToolbar.barStyle = UIBarStyleBlackTranslucent;//툴바 스타일 검정 투명으로
    [actionSheetToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace]; //툴바에 빈공간 삽입
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissActionSheet:)];
    [barItems addObject:doneBtn]; //툴바에 done 버튼 삽입
    [actionSheetToolbar setItems:barItems animated:YES];
    
    [myActionSheet addSubview:actionSheetToolbar];//툴바 보여주기
    
}

//액션시트 사라지게 하는 메서드
//액션시트 툴바의 done 버튼 터치시 실행
- (void)dismissActionSheet:(id)sender{
    NSLog(@"FirstViewController - dismissActionSheet 메서드 실행");
    
    [myActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [myActionSheet removeFromSuperview];
    
    [self viewDidAppear:NO];
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //피커에서 선택한 반경을 버튼 타이틀로 반영
    NSLog(@"value:%i",row);
    radiusValue = [radiusArray objectAtIndex:row]; //피커에서 선택한 값을 저장
    [self.radiusButton setTitle:radiusValue forState:UIControlStateNormal];//반경 버튼 타이틀을 선택한 값으로 변경
    
    //picker에서 선택한 값의 실제 숫자(단위는 미터)값을 변수에 저장
    if ([radiusValue isEqualToString:@"100m"]) {
        radiusIntValue = @"100";
    } else if([radiusValue isEqualToString:@"300m"]) {
        radiusIntValue = @"300";
    } else if([radiusValue isEqualToString:@"500m"]) {
        radiusIntValue = @"500";
    } else if([radiusValue isEqualToString:@"1km"]) {
        radiusIntValue = @"1000";
    } else if ([radiusValue isEqualToString:@"3km"]) {
        radiusIntValue = @"3000";
    } else {
        radiusIntValue = @"100";
    }
    
    //여기서 액션시트 없어지면 이상해서 주석처리 해둠
    //[myActionSheet dismissWithClickedButtonIndex:0 animated:YES];//액션시트 닫기
    //[myActionSheet removeFromSuperview];//슈퍼뷰에서 액션시트 제거
}



@end
