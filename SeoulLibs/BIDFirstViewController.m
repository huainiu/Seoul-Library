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
    [super viewDidLoad];
    self.title = @"내 주변";
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear {    
    CLLocationManager *locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    currentLatitude = [[NSString alloc] initWithFormat:@"위도 : %g°", newLocation.coordinate.latitude];    
    currentLongtitude = [[NSString alloc] initWithFormat:@"경도 : %g°", newLocation.coordinate.longitude];

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
            NSLog(@"i : %i", i);
            NSLog(@"도서관 id%i: %@", i,[[radiusResultArray objectAtIndex:i] valueForKey:@"cartodb_id"]);
            NSLog(@"도서관의 좌표%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"st_astext"]);
            NSLog(@"도서관 이름%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"fclty_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[radiusResultArray objectAtIndex:i] valueForKey:@"fclty_nm"] forKey:[NSString stringWithFormat:@"lib%i", i]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"도서관 구분%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"fly_gbn"]);
            NSLog(@"행정구 이름%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"gu_nm"]);
            NSLog(@"행정동 이름%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"hnr_nm"]);
            NSLog(@"주 지번%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"masterno"]);
            NSLog(@"보조 지번%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"slaveno"]);
            NSLog(@"운영 주최%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"orn_org"]);
            NSLog(@"개관일%i: %@", i, [[radiusResultArray objectAtIndex:i] valueForKey:@"opnng_de"]);
            
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
    [self.navigationController pushViewController:libInfoViewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"lib%i", indexPath.row]];
    return cell;
}
    
@end
