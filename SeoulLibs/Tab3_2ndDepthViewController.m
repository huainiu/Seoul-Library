//
//  Tab3_2ndDepthViewController.m
//  SeoulLibs
//
//  Created by SeokWoo Rho on 12. 8. 15..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "Tab3_2ndDepthViewController.h"
#import "BIDThirdViewController.h"
#import "Tab3_3ndDepthViewController.h"
#import "SBJson.h"
#import "HTTPRequest.h"

@interface Tab3_2ndDepthViewController ()

@end


NSString *dataFlag3 = nil; //어떤 데이터를 받아온건지 구분해주는 flag
int getDataFlag = 0;
NSMutableArray *distDataArray = nil; 
NSMutableArray *distSumArray = nil; 
NSMutableArray *distResultArray = nil;


@implementation Tab3_2ndDepthViewController

@synthesize dongListTable;
@synthesize dongListData;
@synthesize activityIndicator;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"]]; //상단 타이틀 설정("ㅇㅇ구")
    
    NSArray *dongArray; //테이블뷰로 나타낼 동 리스트들을 세팅
    
    if ( [[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"강남구"] ) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기", @"개포동",@"논현동",@"대치동",@"도곡동",@"삼성동",@"역삼동",@"일원동",@"청담동", nil] ;
    } else if( [[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"강동구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"고덕동",@"길동",@"둔촌동",@"명일동",@"상일동",@"성내동",@"암사동",@"천호동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"강북구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"미아동",@"번동",@"수유동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"강서구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"가양동",@"공항동",@"내발산동",@"등촌동",@"방화동",@"염창동",@"화곡동",  nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"관악구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"남현동",@"봉천동",@"신림동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"광진구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"광장동",@"구의동",@"군자동",@"노유동",@"능동",@"자양동",@"중곡동",@"화양동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"구로구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"가리봉동",@"개봉동",@"고척동",@"구로동",@"궁동",@"신도림동",@"오류동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"금천구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"가산동",@"독산동",@"시흥동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"노원구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"공릉동",@"상계동",@"월계동",@"중계동",@"하계동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"도봉구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"도봉동",@"방학동",@"쌍문동",@"창동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"동대문구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"답십리동",@"신설동",@"용두동",@"이문동",@"장안동",@"전농동",@"제기동",@"청량리동",@"회기동",@"휘경동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"동작구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"노량진동",@"대방동",@"본동",@"사당동",@"상도동",@"신대방동",@"흑석동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"마포구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"공덕동",@"노고산동",@"도화동",@"망원동",@"상암동",@"서교동",@"성산동",@"신공덕동",@"신수동",@"아현동",@"연남동",@"염리동",@"용강동",@"창전동",@"토정동",@"합정동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"서대문구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"남가좌동",@"북가좌동",@"북아현동",@"연희동",@"영천동",@"창천동",@"천연동",@"충정로3가",@"현저동",@"홍은동",@"홍제동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"서초구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"반포동",@"방배동",@"서초동",@"양재동",@"염곡동",@"잠원동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"성동구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"금호동1가",@"금호동2가",@"금호동4가",@"마장동",@"사근동",@"상왕십리동",@"성수동1가",@"성수동2가",@"송정동",@"옥수동",@"용답동",@"응봉동",@"하왕십리동",@"행당동",@"홍익동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"성북구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"길음동",@"돈암동",@"동선동3가",@"보문동7가",@"삼선동2가",@"삼선동3가",@"삼선동4가",@"상월곡동",@"석관동",@"성북동1가",@"안암동2가",@"장위동",@"정릉동",@"종암동",@"하월곡동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"송파구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"가락동",@"거여동",@"문정동",@"방이동",@"송파동",@"신천동",@"오금동",@"잠실동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"양천구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"목동",@"신월동",@"신정동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"영등포구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"당산동",@"당산동1가",@"당산동3가",@"대림동",@"도림동",@"문래동3가",@"문래동4가",@"신길동",@"양평동1가",@"양평동4가",@"여의도동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"용산구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"갈월동",@"보광동",@"산천동",@"용문동",@"용산동2가",@"이태원동",@"청파동1가",@"청파동3가",@"한강로3가",@"한남동",@"효창동",@"후암동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"은평구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"갈현동",@"구산동",@"녹번동",@"대조동",@"불광동",@"수색동",@"신사동",@"역촌동",@"응암동",@"증산동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"종로구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"가회동",@"경운동",@"궁정동",@"명륜1가",@"명륜3가",@"무악동",@"부암동",@"사직동",@"삼청동",@"숭인동",@"옥인동",@"원서동",@"이화동",@"종로2가",@"창신동",@"팔판동",@"평동",@"평창동",@"행촌동",@"혜화동",@"화동",@"효제동", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"중구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"묵정동",@"신당동",@"필동2가",@"황학동",@"회현동1가", nil] ;
    } else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] isEqualToString:@"중랑구"]) {
        dongArray = [[NSArray alloc] initWithObjects:@"전체보기",@"망우동",@"면목동",@"묵동",@"상봉동",@"신내동",@"중화동", nil] ;
    } 

    self.dongListData = dongArray;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.dongListData = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dongListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [dongListData objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [[NSUserDefaults standardUserDefaults] setValue:[dongListData objectAtIndex:indexPath.row] forKey:@"selectedDong"];
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"tabFlag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
    
    [dongListTable deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( [[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedDong"] isEqualToString:@"전체보기"] ) { //전체보기를 선택했을 경우에는 동이름 없이, 구 이름으로 행정구역 검색
        [self getDist:@"large" gu:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] dong:nil];
        [self getDist:@"small" gu:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] dong:nil];
    } else { //특정 동을 선택했을 경우에는 구와 동 이름을 가지고 행정구역 검색
        [self getDist:@"large" gu:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] dong:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedDong"]];
        [self getDist:@"small" gu:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"] dong:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedDong"]];
    }
    

}

//행정구역 검색. GET
- (void) getDist:(NSString *)library_class gu:(NSString *)gu dong:(NSString *)dong {
    NSLog(@"getDist 메서드 실행");
    
    NSString *url = nil;
    dataFlag3 = @"getDist";
    
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
    
    getDataFlag = getDataFlag + 1; //데이터 1번 받아온거 확보되었으니 flag에 1을 더해줌
    
    NSLog(@"jsonString : %@", jsonString);
    
    //파서 객체 생성
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    //getDist로 서버에서 받아온 데이터를 딕셔너리에 넣음
    NSMutableDictionary* dist = [ parser objectWithString: jsonString ];
    
    NSLog(@"요청처리시간: %@", [dist valueForKey:@"time"]);
    NSLog(@"반경검색 결과의 수: %@", [dist valueForKey:@"total_rows"]);
    
    if (getDataFlag == 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:[[dist valueForKey:@"total_rows"] intValue] forKey:@"resultCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"resultCount : %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"]);
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"] +[[dist valueForKey:@"total_rows"] intValue] forKey:@"resultCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"resultCount : %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"]);
    }
    
    distDataArray = [dist objectForKey:@"rows"];    
    NSLog(@"distDataArray count : %i", [distDataArray count]);
    
    
    if (getDataFlag == 1) {
        distSumArray = distDataArray;
        [distSumArray setArray:distDataArray]; //새로 받아온 데이터 Array중 rows 부분을 sumArray에 넣어준다
    }
    else {
        for (int i=0; i < [distDataArray count]; i++) {
            [distSumArray addObject:[distDataArray objectAtIndex:i]];
        }
    }
    
    if(getDataFlag == 2) { //데이터를 2번 받아왔다면(large, small)
        
        distResultArray = distSumArray;
        
        //정렬
        NSSortDescriptor *arraySorter = [[NSSortDescriptor alloc] initWithKey:@"fclty_nm" ascending:YES];
        [distResultArray sortUsingDescriptors:[NSArray arrayWithObject:arraySorter]];
        
        //        resultArray = [resultArray sortedArrayUsingSelector:@selector(nameCompare:)];
        
        for (int i=0; i < [distResultArray count]; i++) {
            NSLog(@"도서관 종류%i: %@", i,[[distResultArray objectAtIndex:i] valueForKey:@"lib_class"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray objectAtIndex:i] valueForKey:@"lib_class"] forKey:[NSString stringWithFormat:@"3_lib%i_class", i]];
            NSLog(@"도서관 id%i: %@", i,[[distResultArray objectAtIndex:i] valueForKey:@"cartodb_id"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray objectAtIndex:i] valueForKey:@"cartodb_id"] forKey:[NSString stringWithFormat:@"3_lib%i_id", i]];
            NSLog(@"도서관의 좌표%i: %@", i, [[distResultArray objectAtIndex:i] valueForKey:@"st_astext"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray objectAtIndex:i] valueForKey:@"st_astext"] forKey:[NSString stringWithFormat:@"3_lib%i_point", i]];
            NSLog(@"도서관 이름%i: %@", i, [[distResultArray objectAtIndex:i] valueForKey:@"fclty_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray objectAtIndex:i] valueForKey:@"fclty_nm"] forKey:[NSString stringWithFormat:@"3_lib%i_name", i]];
            NSLog(@"도서관 구분%i: %@", i, [[distResultArray objectAtIndex:i] valueForKey:@"fly_gbn"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray objectAtIndex:i] valueForKey:@"fly_gbn"] forKey:[NSString stringWithFormat:@"3_lib%i_category", i]];
            NSLog(@"행정구 이름%i: %@", i, [[distResultArray objectAtIndex:i] valueForKey:@"gu_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray objectAtIndex:i] valueForKey:@"gu_nm"] forKey:[NSString stringWithFormat:@"3_lib%i_guname", i]];
            NSLog(@"행정동 이름%i: %@", i, [[distResultArray objectAtIndex:i] valueForKey:@"hnr_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray objectAtIndex:i] valueForKey:@"hnr_nm"] forKey:[NSString stringWithFormat:@"3_lib%i_dongname", i]];
            NSLog(@"주 지번%i: %@", i, [[distResultArray objectAtIndex:i] valueForKey:@"masterno"]);
            NSLog(@"보조 지번%i: %@", i, [[distResultArray objectAtIndex:i] valueForKey:@"slaveno"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray objectAtIndex:i] valueForKey:@"slaveno"] forKey:[NSString stringWithFormat:@"3_lib%i_slaveno", i]];
            NSLog(@"운영 주최%i: %@", i, [[distResultArray objectAtIndex:i] valueForKey:@"orn_org"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray objectAtIndex:i] valueForKey:@"orn_org"] forKey:[NSString stringWithFormat:@"3_lib%i_organization", i]];
            NSLog(@"개관일%i: %@", i, [[distResultArray objectAtIndex:i] valueForKey:@"opnng_de"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[distResultArray objectAtIndex:i] valueForKey:@"opnng_de"] forKey:[NSString stringWithFormat:@"3_lib%i_opendate", i]];
            
            [[NSUserDefaults standardUserDefaults] synchronize];

            getDataFlag = 0;
        }
        
        //Activity Indicator 비활성화.
        [activityIndicator stopAnimating];     
        activityIndicator.hidden= TRUE;
        
        //해당 구,동의 도서관 목록 띄워주는 페이지 호출
        Tab3_3ndDepthViewController *libListViewController = [Tab3_3ndDepthViewController alloc];
        [self.navigationController pushViewController:libListViewController animated:YES];
    }
}
    
    
//HTTP통신 완료되었을 경우 실행되는 메서드(데이터를 받아왔을 때)
- (void)didReceiveFinished:(NSString *)result
{
    NSLog(@"didReceiveFinished 메소드 실행. dataFlag : %@", dataFlag3);
    
    NSString *jsonString = result;
    
    //dataFlag 값에 따라서 각각 다른 파싱메서드를 호출해준다
    if ([dataFlag3 isEqualToString:@"getRadius"]) {
        //        [self parseRadius:jsonString];
    }
    else if ([dataFlag3 isEqualToString:@"getDist"]) {
        [self parseDist:jsonString];
    }
    else if ([dataFlag3 isEqualToString:@"getComment"]) {
        //        [self parseComment:jsonString];
    }
    else if ([dataFlag3 isEqualToString:@"updateComment"]) {
        //        [self parseUpdateComment:jsonString];
    }
    else if ([dataFlag3 isEqualToString:@"getRating"]) {
        //        [self parseRating:jsonString];
    }
    else if ([dataFlag3 isEqualToString:@"updateRating"]) {
        //        [self parseUpdateRating:jsonString];
    }
    else {
        
    }
}



@end
