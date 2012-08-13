//
//  BIDSecondViewController.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 7. 31..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDSecondViewController.h"
#import "BIDMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKUserLocation.h>
#import <CoreLocation/CLLocation.h>
#import "HTTPRequestPost.h"
#import "HTTPRequest.h"
#import "SBJson.h"

@interface BIDSecondViewController ()

@end

NSString *dataFlag2 = nil; //어떤 데이터를 받아온건지 구분해주는 flag
int getDataFlag2 = 0;
NSMutableArray *distDataArray2 = nil; 
NSMutableArray *distSumArray2 = nil; 
NSMutableArray *distResultArray2 = nil;


@implementation BIDSecondViewController
@synthesize guText;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
                
        self.title = NSLocalizedString(@"지도 검색", @"지도 검색");
        self.tabBarItem.image = [UIImage imageNamed:@"Second"];
        self.navigationItem.title = @"지도 검색";
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)showUserLocation{
    
}

- (IBAction)goToInnerDepth:(id)sender{
    BIDMapViewController *mapview = [BIDMapViewController new];
    [self.navigationController pushViewController:mapview animated:YES];
}

- (IBAction)goSearch:(id)sender {
    
    
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
    
    [self getDist:@"large" gu:guText.text dong:nil];
    [self getDist:@"small" gu:guText.text dong:nil];
}


//행정구역 검색. GET
- (void) getDist:(NSString *)library_class gu:(NSString *)gu dong:(NSString *)dong {
    NSLog(@"getDist 메서드 실행");
    
    NSString *url = nil;
    dataFlag2 = @"getDist";
    
    //접속할 주소 설정
    //예시 : http://seoullibrary.herokuapp.com/dist/large/관악구
    if (dong ==nil || [dong isEqualToString:@""]) { //dong 입력 안 되었을 경우
        url = [[NSString stringWithFormat: @"http://seoullibrary.herokuapp.com/dist/%@/%@", library_class, gu] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else {
        url = [[NSString stringWithFormat: @"http://seoullibrary.herokuapp.com/dist/%@/%@/%@", library_class, gu, dong] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"url : %@", url);
    // HTTP Request 인스턴스 생성
    HTTPRequest *httpRequest = [[HTTPRequest alloc] init];
    
    // POST로 전송할 데이터 설정
    NSDictionary *bodyObject = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    
    // 통신 완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
    
    // 페이지 호출
    [httpRequest requestUrl:url bodyObject:bodyObject];
}


//행정구역 파싱
- (void) parseDist:(NSString *)jsonString {
    
    getDataFlag2 = getDataFlag2 + 1; //데이터 1번 받아온거 확보되었으니 flag에 1을 더해줌
    
    //파서 객체 생성
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    //getDist로 서버에서 받아온 데이터를 딕셔너리에 넣음
    NSMutableDictionary* dist = [ parser objectWithString: jsonString ];
    
    NSLog(@"요청처리시간: %@", [dist valueForKey:@"time"]);
    NSLog(@"반경검색 결과의 수: %@", [dist valueForKey:@"total_rows"]);
    
    if (getDataFlag2 == 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:[[dist valueForKey:@"total_rows"] intValue] forKey:@"resultCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"resultCount : %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"]);
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"] +[[dist valueForKey:@"total_rows"] intValue] forKey:@"resultCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"resultCount : %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"]);
    }
    
    distDataArray2 = [dist objectForKey:@"rows"];
    NSLog(@"[distDataArray objectAtIndex:0] : %@", [distDataArray2 objectAtIndex:0]);
    
    NSLog(@"distDataArray count : %i", [distDataArray2 count]);
    
    
    if (getDataFlag2 == 1) {
        distSumArray2 = distDataArray2;
        [distSumArray2 setArray:distDataArray2]; //새로 받아온 데이터 Array중 rows 부분을 sumArray에 넣어준다
    }
    else {
        for (int i=0; i < [distDataArray2 count]; i++) {
            [distSumArray2 addObject:[distDataArray2 objectAtIndex:i]];
        }
    }
    
    if(getDataFlag2 == 2) { //데이터를 2번 받아왔다면(large, small)
        
        distResultArray2 = distSumArray2;
        
        //정렬
        NSSortDescriptor *arraySorter = [[NSSortDescriptor alloc] initWithKey:@"fclty_nm" ascending:YES];
        [distResultArray2 sortUsingDescriptors:[NSArray arrayWithObject:arraySorter]];
        
        //        resultArray = [resultArray sortedArrayUsingSelector:@selector(nameCompare:)];
        
        for (int i=0; i < [distResultArray2 count]; i++) {
            NSLog(@"도서관 id%i: %@", i,[[distResultArray2 objectAtIndex:i] valueForKey:@"cartodb_id"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray2 objectAtIndex:i] valueForKey:@"cartodb_id"] forKey:[NSString stringWithFormat:@"2_lib%i_id", i]];
            NSLog(@"도서관의 좌표%i: %@", i, [[distResultArray2 objectAtIndex:i] valueForKey:@"st_astext"]);
            
            //좌표 받아온거 파싱해서 longtitude와 latitude로 분리하기
            NSArray *pointTempArray1 = [[[distResultArray2 objectAtIndex:i] valueForKey:@"st_astext"] componentsSeparatedByString:@"POINT("];
            NSString *pointTempString1 = ((NSString *)[pointTempArray1 objectAtIndex:1]);
            NSArray *pointTempArray2 = [pointTempString1 componentsSeparatedByString:@" "];
            NSString *longtitude = ((NSString *)[pointTempArray2 objectAtIndex:0]);
            NSArray *pointTempArray3 = [((NSString *)[pointTempArray2 objectAtIndex:1]) componentsSeparatedByString:@")"];
            NSString *latitude = ((NSString *)[pointTempArray3 objectAtIndex:0]);
            
            [[NSUserDefaults standardUserDefaults] setValue:longtitude forKey:[NSString stringWithFormat:@"2_lib%i_longtitude", i]];
            [[NSUserDefaults standardUserDefaults] setValue:latitude forKey:[NSString stringWithFormat:@"2_lib%i_latitude", i]];
            NSLog(@"longtitude : %@, latitude : %@", longtitude, latitude);
            
            
                                       
/*            
            //dirkey, ukey 파싱
            NSString *pushMessage = [NSString stringWithFormat:@"%@", userInfo];
            
            NSArray *dirkeyTempArray1 = [pushMessage componentsSeparatedByString:@"dirkey="];
            NSString *dirkeyTempString1 = ((NSString *)[dirkeyTempArray1 objectAtIndex:1]);
            NSArray *dirkeyTempArray2 = [dirkeyTempString1 componentsSeparatedByString:@"\""];
            NSString *dirKey = ((NSString *)[dirkeyTempArray2 objectAtIndex:0]);
            
            NSArray *ukeyTempArray1 = [pushMessage componentsSeparatedByString:@"ukey="];
            NSString *ukeyTempString1 = ((NSString *)[ukeyTempArray1 objectAtIndex:1]);
            NSArray *ukeyTempArray2 = [ukeyTempString1 componentsSeparatedByString:@"\""];
            NSString *uKey = ((NSString *)[ukeyTempArray2 objectAtIndex:0]);
*/
            
            
            
            NSLog(@"도서관 이름%i: %@", i, [[distResultArray2 objectAtIndex:i] valueForKey:@"fclty_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray2 objectAtIndex:i] valueForKey:@"fclty_nm"] forKey:[NSString stringWithFormat:@"2_lib%i_name", i]];
            NSLog(@"도서관 구분%i: %@", i, [[distResultArray2 objectAtIndex:i] valueForKey:@"fly_gbn"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray2 objectAtIndex:i] valueForKey:@"fly_gbn"] forKey:[NSString stringWithFormat:@"2_lib%i_category", i]];
            NSLog(@"행정구 이름%i: %@", i, [[distResultArray2 objectAtIndex:i] valueForKey:@"gu_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray2 objectAtIndex:i] valueForKey:@"gu_nm"] forKey:[NSString stringWithFormat:@"2_lib%i_guname", i]];
            NSLog(@"행정동 이름%i: %@", i, [[distResultArray2 objectAtIndex:i] valueForKey:@"hnr_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray2 objectAtIndex:i] valueForKey:@"hnr_nm"] forKey:[NSString stringWithFormat:@"2_lib%i_dongname", i]];
            NSLog(@"주 지번%i: %@", i, [[distResultArray2 objectAtIndex:i] valueForKey:@"masterno"]);
            NSLog(@"보조 지번%i: %@", i, [[distResultArray2 objectAtIndex:i] valueForKey:@"slaveno"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray2 objectAtIndex:i] valueForKey:@"slaveno"] forKey:[NSString stringWithFormat:@"2_lib%i_slaveno", i]];
            NSLog(@"운영 주최%i: %@", i, [[distResultArray2 objectAtIndex:i] valueForKey:@"orn_org"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray2 objectAtIndex:i] valueForKey:@"orn_org"] forKey:[NSString stringWithFormat:@"2_lib%i_organization", i]];
            NSLog(@"개관일%i: %@", i, [[distResultArray2 objectAtIndex:i] valueForKey:@"opnng_de"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray2 objectAtIndex:i] valueForKey:@"opnng_de"] forKey:[NSString stringWithFormat:@"2_lib%i_opendate", i]];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        //Activity Indicator 비활성화.
        [activityIndicator stopAnimating];     
        activityIndicator.hidden= TRUE;
        
        //해당 구의 도서관 목록 띄워주는 페이지 호출
        BIDMapViewController *mapview = [BIDMapViewController new];
        [self.navigationController pushViewController:mapview animated:YES];
    }
    
    //    NSMutableDictionary *distResult = [NSMutableDictionary dictionaryWithCapacity:total_rows];
    //    for (int i=0; i < [rowsArray count]; i++) {
    //        [distResult setObject:[[rowsArray objectAtIndex:i] valueForKey:@"fclty_nm"] forKey:[NSString stringWithFormat:@"lib%i", i]];
    //    }
    
    //    [[NSUserDefaults standardUserDefaults] setValue:distResult forKey:@"distResult"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


//HTTP통신 완료되었을 경우 실행되는 메서드(데이터를 받아왔을 때)
- (void)didReceiveFinished:(NSString *)result
{
    NSLog(@"didReceiveFinished 메소드 실행. dataFlag : %@", dataFlag2);
    
    NSString *jsonString = result;
    
    //dataFlag 값에 따라서 각각 다른 파싱메서드를 호출해준다
    if ([dataFlag2 isEqualToString:@"getRadius"]) {
        //        [self parseRadius:jsonString];
    }
    else if ([dataFlag2 isEqualToString:@"getDist"]) {
        [self parseDist:jsonString];
    }
    else if ([dataFlag2 isEqualToString:@"getComment"]) {
        //        [self parseComment:jsonString];
    }
    else if ([dataFlag2 isEqualToString:@"updateComment"]) {
        //        [self parseUpdateComment:jsonString];
    }
    else if ([dataFlag2 isEqualToString:@"getRating"]) {
        //        [self parseRating:jsonString];
    }
    else if ([dataFlag2 isEqualToString:@"updateRating"]) {
        //        [self parseUpdateRating:jsonString];
    }
    else {
        
    }
}




@end
