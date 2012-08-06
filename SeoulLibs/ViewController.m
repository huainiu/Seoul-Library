//
//  ViewController.m
//  SeoulLibrary_rho
//
//  Created by SeokWoo Rho on 12. 7. 29..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
// This is git hub test.

#import "ViewController.h"
#import "HTTPRequest.h"
#import "HTTPRequestPost.h"
#import "SBJson.h"

NSString *dataFlag = nil; //어떤 데이터를 받아온건지 구분해주는 flag

@interface ViewController ()

@end

@implementation ViewController

@synthesize getRadiusButton;
@synthesize getDistButton;
@synthesize getCommentButton;
@synthesize updateCommentButton;
@synthesize getRatingButton;
@synthesize updateRatingButton;


- (void)viewDidLoad
{
    NSLog(@"viewDidLoad 메서드 실행");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


//반경 검색. GET
- (void) getRadius:(NSString *)library_class longtitude:(NSString *)longtitude latitude:(NSString *)latitude radius:(NSString *)radius { 
    NSLog(@"getRadius 메서드 실행");
    
    dataFlag = @"getRadius";
    
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



//반경 파싱
- (void) parseRadius: (NSString *)jsonString {
    
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    NSMutableDictionary* radius = [ parser objectWithString: jsonString ];
    
    NSLog(@"요청처리시간: %@", [radius valueForKey:@"time"]);
    NSLog(@"반경검색 결과의 수: %@", [radius valueForKey:@"total_rows"]);
    
    NSArray *rowsArray = [ radius objectForKey:@"rows"];
    
    for (int i=0; i < [rowsArray count]; i++) {
        NSLog(@"i : %i", i);
        NSLog(@"도서관 id%i: %@", i,[[rowsArray objectAtIndex:i] valueForKey:@"cartodb_id"]);
        NSLog(@"도서관의 좌표%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"st_astext"]);
        NSLog(@"도서관 이름%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"fclty_nm"]);
        NSLog(@"도서관 구분%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"fly_gbn"]);
        NSLog(@"행정구 이름%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"gu_nm"]);
        NSLog(@"행정동 이름%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"hnr_nm"]);
        NSLog(@"주 지번%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"masterno"]);
        NSLog(@"보조 지번%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"slaveno"]);
        NSLog(@"운영 주최%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"orn_org"]);
        NSLog(@"개관일%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"opnng_de"]);
    }
}



//행정구역 검색. GET
- (void) getDist:(NSString *)library_class gu:(NSString *)gu dong:(NSString *)dong { 
    NSLog(@"getDist 메서드 실행");
    
    NSString *url = nil;
    dataFlag = @"getDist";
    
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
    
    NSArray *rowsArray = [ dist objectForKey:@"rows"];
    
    for (int i=0; i < [rowsArray count]; i++) {
        NSLog(@"도서관 id%i: %@", i,[[rowsArray objectAtIndex:i] valueForKey:@"cartodb_id"]);
        NSLog(@"도서관의 좌표%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"st_astext"]);
        NSLog(@"도서관 이름%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"fclty_nm"]);
        NSLog(@"도서관 구분%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"fly_gbn"]);
        NSLog(@"행정구 이름%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"gu_nm"]);
        NSLog(@"행정동 이름%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"hnr_nm"]);
        NSLog(@"주 지번%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"masterno"]);
        NSLog(@"보조 지번%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"slaveno"]);
        NSLog(@"운영 주최%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"orn_org"]);
        NSLog(@"개관일%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"opnng_de"]);
    }
}


//댓글 가져오기. GET
- (void) getComment:(NSString *)library_class idx:(NSString *)idx { 
    NSLog(@"getComment 메서드 실행");
    
    dataFlag = @"getComment";
    
    //접속할 주소 설정
    //예시 : http://seoullibrary.herokuapp.com/comment/small/1
    NSString *url = [[NSString alloc] initWithFormat:@"http://seoullibrary.herokuapp.com/comment/%@/%@", library_class, idx];
    
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
- (void) parseComment:(NSString *)jsonString {
    
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    
    NSMutableDictionary* comment = [ parser objectWithString: jsonString ];    
    
    NSLog(@"요청처리시간: %@", [comment valueForKey:@"time"]);
    NSLog(@"댓글요청 결과의 수: %@", [comment valueForKey:@"total_rows"]);
    
    NSArray *rowsArray = [ comment objectForKey:@"rows"];
    
    for (int i=0; i < [rowsArray count]; i++) {
        NSLog(@"해당 댓글의 id%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"comment_id"]);
        NSLog(@"도서관 id%i: %@", i,  [[rowsArray objectAtIndex:i] valueForKey:@"cartodb_id"]);
        NSLog(@"해당 댓글의 본문%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"comment_article"]);
        NSLog(@"댓글을 남긴 기기의 uuid%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"comment_uuid"]);
        NSLog(@"코멘트를 남긴 시각%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"comment_date"]);
    }
}


//댓글 업데이트. POST형식
- (void) updateComment:(NSString *)library idx:(NSString *)idx article:(NSString *)article uuid:(NSString *)uuid { 
    NSLog(@"updateComment 메서드 실행");
    
    dataFlag = @"updateComment";
    
    //접속할 주소 설정
    NSString *url = [[NSString alloc] initWithFormat:@"http://seoullibrary.herokuapp.com/comment/update"];
    
    // HTTP Request 인스턴스 생성
    HTTPRequestPost *httpRequestPost = [[HTTPRequestPost alloc] init];
    
    // POST로 전송할 데이터 설정
    NSDictionary *bodyObject = [NSDictionary dictionaryWithObjectsAndKeys:library,@"library",idx, @"idx", article, @"article", uuid, @"uuid", nil];
    
    // 통신 완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequestPost setDelegate:self selector:@selector(didReceiveFinished:)];
    
    // 페이지 호출
    [httpRequestPost requestUrl:url bodyObject:bodyObject];
}


//댓글 업데이트 후 받아온 데이터 파싱
- (void) parseUpdateComment:(NSString *)jsonString {
    
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    
    NSMutableDictionary* updateComment = [ parser objectWithString: jsonString ];    
    
    NSLog(@"요청처리시간: %@", [updateComment valueForKey:@"time"]);
    NSLog(@"댓글 업데이트 결과: %@", [updateComment valueForKey:@"result"]);    
}


//평점 가져오기. GET
- (void) getRating:(NSString *)library_class idx:(NSString *)idx { 
    NSLog(@"getRating 메서드 실행");
    
    dataFlag = @"getRating";
    
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
    NSLog(@"반경검색 결과의 수: %@", [rating valueForKey:@"total_rows"]);
    
    NSArray *rowsArray = [ rating objectForKey:@"rows"];
    
    for (int i=0; i < [rowsArray count]; i++) {
        NSLog(@"도서관 id: %@", [[rowsArray objectAtIndex:i] valueForKey:@"cartodb_id"]);
        NSLog(@"해당 도서관의 평점 평균: %@", [[rowsArray objectAtIndex:i] valueForKey:@"average"]);
    }
}


//평점 업데이트. POST
- (void) updateRating:(NSString *)library idx:(NSString *)idx rating:(NSString *)rating uuid:(NSString *)uuid {
    NSLog(@"updateRating 메서드 실행");
    
    dataFlag = @"updateRating";
    
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
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    
    NSMutableDictionary* ratingResult = [ parser objectWithString: jsonString ];    
    
    NSLog(@"요청처리시간: %@", [ratingResult valueForKey:@"time"]);
    NSLog(@"평점 업데이트 결과: %@", [ratingResult valueForKey:@"result"]);    
}




//HTTP통신 완료되었을 경우 실행되는 메서드(데이터를 받아왔을 때)
- (void)didReceiveFinished:(NSString *)result
{
    NSLog(@"didReceiveFinished 메소드 실행. dataFlag : %@", dataFlag);
    
    NSString *jsonString = result;
    
    //dataFlag 값에 따라서 각각 다른 파싱메서드를 호출해준다
    if ([dataFlag isEqualToString:@"getRadius"]) {
        [self parseRadius:jsonString];
    }
    else if ([dataFlag isEqualToString:@"getDist"]) {
        [self parseDist:jsonString];
    }
    else if ([dataFlag isEqualToString:@"getComment"]) {
        [self parseComment:jsonString];
    }
    else if ([dataFlag isEqualToString:@"updateComment"]) {
        [self parseUpdateComment:jsonString];
    }
    else if ([dataFlag isEqualToString:@"getRating"]) {
        [self parseRating:jsonString];
    }
    else if ([dataFlag isEqualToString:@"updateRating"]) {
        [self parseUpdateRating:jsonString];
    }
    else {
        
    }
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
