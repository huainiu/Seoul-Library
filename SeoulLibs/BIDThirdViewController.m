//
//  BIDThirdViewController.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 7. 31..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDThirdViewController.h"
#import "HTTPRequestPost.h"
#import "HTTPRequest.h"
#import "SBJson.h"

@interface BIDThirdViewController ()

@end

NSString *dataFlag1 = nil; //어떤 데이터를 받아온건지 구분해주는 flag

@implementation BIDThirdViewController
@synthesize listData;
//NSString *guName = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"도서관목록", @"도서관목록");
        self.tabBarItem.image = [UIImage imageNamed:@"Third"];
        self.navigationItem.title = @"도서관 목록";
        // Custom initialization
    }
    
    
    
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"구 목록";
    // Do any additional setup after loading the view from its nib.
    NSArray *guArray = [[NSArray alloc] initWithObjects:@"강남구", @"강동구", @"강북구", @"강서구", @"관악구", @"광진구", @"구로구", @"금천구", @"노원구", @"도봉구", @"동대문구", @"동작구", @"마포구", @"서대문구", @"서초구", @"성동구", @"성북구", @"송파구", @"양천구", @"영등포구", @"용산구", @"은평구", @"종로구", @"중구", @"중랑구", nil] ;
    self.listData = guArray;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.listData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSUserDefaults standardUserDefaults] setValue:[listData objectAtIndex:indexPath.row] forKey:@"guName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self getDist:@"large" gu:[[NSUserDefaults standardUserDefaults] stringForKey:@"guName"] dong:nil];
    
}



//행정구역 검색. GET
- (void) getDist:(NSString *)library_class gu:(NSString *)gu dong:(NSString *)dong { 
    NSLog(@"getDist 메서드 실행");
    
    NSString *url = nil;
    dataFlag1 = @"getDist";
    
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
    
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    NSMutableDictionary* dist = [ parser objectWithString: jsonString ];
    
    NSLog(@"요청처리시간: %@", [dist valueForKey:@"time"]);
    NSLog(@"반경검색 결과의 수: %@", [dist valueForKey:@"total_rows"]);
    
    [[NSUserDefaults standardUserDefaults] setInteger:[[dist valueForKey:@"total_rows"] intValue] forKey:@"resultCount"];
    
    NSArray *rowsArray = [ dist objectForKey:@"rows"];
    
    for (int i=0; i < [rowsArray count]; i++) {
        NSLog(@"도서관 id%i: %@", i,[[rowsArray objectAtIndex:i] valueForKey:@"cartodb_id"]);
        NSLog(@"도서관의 좌표%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"st_astext"]);
        NSLog(@"도서관 이름%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"fclty_nm"]);
        NSLog(@"도서관 구분%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"fly_gbn"]);
        NSLog(@"행정구 이름%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"gu_nm"]);
        [[NSUserDefaults standardUserDefaults] setValue:[[rowsArray objectAtIndex:i] valueForKey:@"fclty_nm"] forKey:[NSString stringWithFormat:@"lib%i", i]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"행정동 이름%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"hnr_nm"]);
        NSLog(@"주 지번%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"masterno"]);
        NSLog(@"보조 지번%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"slaveno"]);
        NSLog(@"운영 주최%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"orn_org"]);
        NSLog(@"개관일%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"opnng_de"]);
    }
    
    
    
    //    NSMutableDictionary *distResult = [NSMutableDictionary dictionaryWithCapacity:total_rows];
    //    for (int i=0; i < [rowsArray count]; i++) {
    //        [distResult setObject:[[rowsArray objectAtIndex:i] valueForKey:@"fclty_nm"] forKey:[NSString stringWithFormat:@"lib%i", i]];
    //    }
    
    
    
    //    [[NSUserDefaults standardUserDefaults] setValue:distResult forKey:@"distResult"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    BID2ndDepthViewController *secondViewController = [[BID2ndDepthViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:secondViewController animated:YES];
    
}


//HTTP통신 완료되었을 경우 실행되는 메서드(데이터를 받아왔을 때)
- (void)didReceiveFinished:(NSString *)result
{
    NSLog(@"didReceiveFinished 메소드 실행. dataFlag : %@", dataFlag1);
    
    NSString *jsonString = result;
    
    //dataFlag 값에 따라서 각각 다른 파싱메서드를 호출해준다
    if ([dataFlag1 isEqualToString:@"getRadius"]) {
        //        [self parseRadius:jsonString];
    }
    else if ([dataFlag1 isEqualToString:@"getDist"]) {
        [self parseDist:jsonString];
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



#pragma mark-
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [listData objectAtIndex:row];
    return cell;
}

@end
