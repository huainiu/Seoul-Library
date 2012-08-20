//
//  BIDLibInfoViewController.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 8. 4..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDLibInfoViewController.h"
#import "BIDFirstViewController.h"
#import "BIDMapViewController.h"
#import "HTTPRequest.h"
#import "HTTPRequestPost.h"
#import "SBJson.h"


@interface BIDLibInfoViewController ()

@end

NSString *libInfoDataFlag = nil; //어떤 데이터를 받아온건지 구분해주는 flag

@implementation BIDLibInfoViewController

@synthesize scrollView = _scrollView;
@synthesize commentField;
@synthesize ratingLabel;
@synthesize ratingText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"currentLibInfo_name", [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedLib"]]];
                
    //스크롤뷰 생성
    _scrollView.frame = CGRectMake(0, 0, 320, 320);
    _scrollView.contentSize = CGSizeMake(320,800);
    
    // Do any additional setup after loading the view from its nib.
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollview 드래깅");
    
    //스크롤뷰 움직이면 키보드 사라지도록
    [commentField resignFirstResponder];
}



- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"LibInfoViewController - viewDidAppear 메서드 실행");

    [self getRating:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLibInfo_class"] idx:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLibInfo_id"]];
}


//평점 가져오기. GET
- (void) getRating:(NSString *)library_class idx:(NSString *)idx { 
    NSLog(@"getRating 메서드 실행");
    
    libInfoDataFlag = @"getRating";
    
    //접속할 주소 설정
    //예시 : http://seoullibrary.herokuapp.com/rating/small/1
    NSString *url = [[NSString alloc] initWithFormat:@"http://seoullibrary.herokuapp.com/rating/%@/%@", library_class, idx];
    
    // HTTP Request 인스턴스 생성
    HTTPRequest *httpRequest = [[HTTPRequest alloc] init];
    
    // POST로 전송할 데이터 설정
    NSDictionary *bodyObject = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    
    // 통신 완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
    
    // 페이지 호출
    [httpRequest requestUrl:url bodyObject:bodyObject];  
}


//평점 파싱
- (void) parseRating:(NSString *)jsonString {    
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    
    NSMutableDictionary* rating = [ parser objectWithString: jsonString ];    
    
    NSLog(@"요청처리시간: %@", [rating valueForKey:@"time"]);
    NSLog(@"결과의 수: %@", [rating valueForKey:@"total_rows"]);
    
    NSArray *rowsArray = [ rating objectForKey:@"rows"];
    
    for (int i=0; i < [rowsArray count]; i++) {
        NSLog(@"도서관 id: %@", [[rowsArray objectAtIndex:i] valueForKey:@"cartodb_id"]);
        NSLog(@"해당 도서관의 평점 평균: %@", [[rowsArray objectAtIndex:i] valueForKey:@"average"]);
        [[NSUserDefaults standardUserDefaults] setValue:[rowsArray objectAtIndex:i] forKey:@"averageRating"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    ratingLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"averageRating"];
}




//HTTP통신 완료되었을 경우 실행되는 메서드(데이터를 받아왔을 때)
- (void)didReceiveFinished:(NSString *)result
{
    NSLog(@"didReceiveFinished 메소드 실행. dataFlag : %@", libInfoDataFlag);
    
    NSString *jsonString = result;
    
    //dataFlag 값에 따라서 각각 다른 파싱메서드를 호출해준다
    if ([libInfoDataFlag isEqualToString:@"getRadius"]) {
        //        [self parseRadius:jsonString];
    }
    else if ([libInfoDataFlag isEqualToString:@"getDist"]) {
//        [self parseDist:jsonString];
    }
    else if ([libInfoDataFlag isEqualToString:@"getComment"]) {
        //        [self parseComment:jsonString];
    }
    else if ([libInfoDataFlag isEqualToString:@"updateComment"]) {
        //        [self parseUpdateComment:jsonString];
    }
    else if ([libInfoDataFlag isEqualToString:@"getRating"]) {
        [self parseRating:jsonString];
    }
    else if ([libInfoDataFlag isEqualToString:@"updateRating"]) {
        [self parseUpdateRating:jsonString];

    }
    else {
        
    }
}


- (IBAction)rate:(id)sender
{
    [self updateRating:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLibInfo_class"] idx:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLibInfo_id"] rating:ratingText.text uuid:[[NSUserDefaults standardUserDefaults] stringForKey:@"uuid"] ];
}


//평점 업데이트. POST
- (void) updateRating:(NSString *)library idx:(NSString *)idx rating:(NSString *)rating uuid:(NSString *)uuid {
    NSLog(@"updateRating 메서드 실행");
    
    libInfoDataFlag = @"updateRating";
    
    //접속할 주소 설정
    NSString *url = [[NSString alloc] initWithFormat:@"http://seoullibrary.herokuapp.com/rating/update"];
    
    // HTTP Request 인스턴스 생성
    HTTPRequestPost *httpRequestPost = [[HTTPRequestPost alloc] init];
    
    // POST로 전송할 데이터 설정
    NSDictionary *bodyObject = [NSDictionary dictionaryWithObjectsAndKeys:library,@"library",idx, @"idx", rating, @"rating", uuid, @"uuid", nil];
    
    // 통신 완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequestPost setDelegate:self selector:@selector(didReceiveFinished:)];
    
    // 페이지 호출
    [httpRequestPost requestUrl:url bodyObject:bodyObject];
}


//평점 업데이트 후 받아온 데이터 파싱
- (void) parseUpdateRating:(NSString *)jsonString {
    NSLog(@"parseUpdateRating 메서드 실행");
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    
    NSMutableDictionary* ratingResult = [ parser objectWithString: jsonString ];    
    
    NSLog(@"요청처리시간: %@", [ratingResult valueForKey:@"time"]);
    NSLog(@"평점 업데이트 결과: %@", [ratingResult valueForKey:@"result"]);    
    [self viewDidAppear:NO];
}



- (void)viewDidUnload
{
    [self setCommentField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)textFieldDoneEdit{
    [commentField resignFirstResponder]; // 배경을 탭하면 키보드 사라짐
}

- (IBAction)goToMap{
    //지도 보기 액션
    BIDMapViewController *mapview = [BIDMapViewController new];
    [self.navigationController pushViewController:mapview animated:YES];
}

- (IBAction)goToFindWay{
    //길찾기 액션
    BIDMapViewController *mapview = [BIDMapViewController new];
    [self.navigationController pushViewController:mapview animated:YES];
}

@end
