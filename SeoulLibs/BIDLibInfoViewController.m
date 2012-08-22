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
NSString *libInfoDataFlag2 = nil; //어떤 데이터를 받아온건지 구분해주는 flag

NSString *averageRating = nil; //평균평점

int commentCount = 0; //댓글 개수
NSMutableArray *commentId; //댓글 id
NSMutableArray *commentLibid; //댓글 달린 도서관 id
NSMutableArray *commentArticle; //댓글 본문
NSMutableArray *commentUuid; //댓글 단 기기의 uuid 
NSMutableArray *commentDate; //댓글 작성일자


@implementation BIDLibInfoViewController

@synthesize scrollView = _scrollView;
@synthesize commentField;
@synthesize ratingLabel;
@synthesize ratingText;
@synthesize commentTable;

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
    
    averageRating = [[NSString alloc] init];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollview 드래깅");
    
    //스크롤뷰 움직이면 키보드 사라지도록
    [commentField resignFirstResponder];
}



- (void)viewDidAppear:(BOOL)animated {

    NSLog(@"LibInfoViewController - viewDidAppear 메서드 실행");
    
//    ratingLabel.text = averageRating;
    
    [self getRating:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLibInfo_class"] idx:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLibInfo_id"]];
    
    [self getComment:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLibInfo_class"] idx:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLibInfo_id"]];
}


//댓글 등록
- (IBAction)registerComment:(id)sender {
    
    [self updateComment:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLibInfo_class"] idx:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLibInfo_id"] article:commentField.text uuid:[[NSUserDefaults standardUserDefaults] stringForKey:@"uuid"]];
    
    //updateComment:(NSString *)library idx:(NSString *)idx article:(NSString *)article uuid:(NSString *)uuid
}




//평점 가져오기. GET
- (void) getRating:(NSString *)library_class idx:(NSString *)idx { 
    NSLog(@"getRating 메서드 실행");
    
    libInfoDataFlag2 = @"getRating";
    
    //접속할 주소 설정
    //예시 : http://seoullibrary.herokuapp.com/rating/small/1
    NSString *url = [[NSString alloc] initWithFormat:@"http://seoullibrary.herokuapp.com/rating/%@/%@", library_class, idx];
    
    // HTTP Request 인스턴스 생성
    HTTPRequest *httpRequest = [[HTTPRequest alloc] init];
    
    // POST로 전송할 데이터 설정
    NSDictionary *bodyObject = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    
    // 통신 완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequest setDelegate:self selector:@selector(didReceiveFinished2:)];
    
    // 페이지 호출
    [httpRequest requestUrl:url bodyObject:bodyObject];  
}


//평점 파싱
- (void) parseRating:(NSString *)jsonString {    
    NSLog(@"BIDLibInfoViewController - parseRating 메서드 실행");

    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    
    NSMutableDictionary* rating = [ parser objectWithString: jsonString ];    
    
    NSLog(@"요청처리시간: %@", [rating valueForKey:@"time"]);
    NSLog(@"결과의 수: %@", [rating valueForKey:@"total_rows"]);
    
    NSArray *rowsArray = [ rating objectForKey:@"rows"];
    
    for (int i=0; i < [rowsArray count]; i++) {
        NSLog(@"도서관 id: %@", [[rowsArray objectAtIndex:i] valueForKey:@"cartodb_id"]);
        NSLog(@"해당 도서관의 평점 평균: %@", [[rowsArray objectAtIndex:i] valueForKey:@"average"]);
        
//        [[NSUserDefaults standardUserDefaults] setValue:[[rowsArray objectAtIndex:i] valueForKey:@"average"] forKey:@"averageRating"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        averageRating = [[rowsArray objectAtIndex:i] valueForKey:@"average"];
        
    }
    
    if (averageRating != nil) {
        ratingLabel.text = averageRating;
    } else {
        ratingLabel.text = @"0";
    }
}


//댓글 가져오기. GET
- (void) getComment:(NSString *)library_class idx:(NSString *)idx { 
    NSLog(@"getComment 메서드 실행");
    
    libInfoDataFlag = @"getComment";
    
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
    NSLog(@"BIDLibInfoViewController - parseComment 메서드 실행");

    commentId = [[NSMutableArray alloc] init]; //댓글 id
    commentLibid = [[NSMutableArray alloc] init]; //댓글 달린 도서관 id
    commentArticle = [[NSMutableArray alloc] init]; //댓글 본문
    commentUuid = [[NSMutableArray alloc] init]; //댓글 단 기기의 uuid 
    commentDate = [[NSMutableArray alloc] init]; //댓글 작성일자
    
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    
    NSMutableDictionary* comment = [ parser objectWithString: jsonString ];    
    
    NSLog(@"요청처리시간: %@", [comment valueForKey:@"time"]);
    NSLog(@"댓글요청 결과의 수: %@", [comment valueForKey:@"total_rows"]);
    
    commentCount = [[comment valueForKey:@"total_rows"] intValue]; //댓글요청 결과의 수 변수에 저장
    
    NSArray *rowsArray = [ comment objectForKey:@"rows"];
    
    for (int i=0; i < commentCount; i++) {
        [[NSUserDefaults standardUserDefaults] setValue:[[rowsArray objectAtIndex:i] valueForKey:@"comment_id"] forKey:[NSString stringWithFormat:@"comment%i_id", i]];
        
        [commentId addObject:[[rowsArray objectAtIndex:i] valueForKey:@"comment_id"]];
        
        [[NSUserDefaults standardUserDefaults] setValue:[[rowsArray objectAtIndex:i] valueForKey:@"cartodb_id"] forKey:[NSString stringWithFormat:@"comment%i_libid", i]];
        
        [commentLibid addObject:[[rowsArray objectAtIndex:i] valueForKey:@"cartodb_id"]];
        
        NSLog(@"해당 댓글의 본문%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"comment_article"]);
        [[NSUserDefaults standardUserDefaults] setValue:[[rowsArray objectAtIndex:i] valueForKey:@"comment_article"] forKey:[NSString stringWithFormat:@"comment%i_article", i]];
        
        [commentArticle addObject:[[rowsArray objectAtIndex:i] valueForKey:@"comment_article"]];

        
        [[NSUserDefaults standardUserDefaults] setValue:[[rowsArray objectAtIndex:i] valueForKey:@"comment_uuid"] forKey:[NSString stringWithFormat:@"comment%i_uuid", i]];

        [commentUuid addObject:[[rowsArray objectAtIndex:i] valueForKey:@"comment_uuid"]];
        
        NSLog(@"코멘트를 남긴 시각%i: %@", i, [[rowsArray objectAtIndex:i] valueForKey:@"comment_date"]);
        
        //가져온 DATE 파싱
        NSString *tempCommentDate = [[rowsArray objectAtIndex:i] valueForKey:@"comment_date"];
        NSArray *tempCommentDateArray = [tempCommentDate componentsSeparatedByString:@"T"];
        NSString *parsingCommentDate = ((NSString *)[tempCommentDateArray objectAtIndex:0]);
        
        [[NSUserDefaults standardUserDefaults] setValue:parsingCommentDate forKey:[NSString stringWithFormat:@"comment%i_date", i]];
        [commentDate addObject:parsingCommentDate];
    }
    
    [commentTable reloadData];
    
}



//댓글 업데이트. POST형식
- (void) updateComment:(NSString *)library idx:(NSString *)idx article:(NSString *)article uuid:(NSString *)uuid { 
    NSLog(@"updateComment 메서드 실행");
    
    libInfoDataFlag = @"updateComment";
    
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
    NSLog(@"BIDLibInfoViewController - parseUpdateComment 메서드 실행");
    
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    
    NSMutableDictionary* updateComment = [ parser objectWithString: jsonString ];    
    
    NSLog(@"요청처리시간: %@", [updateComment valueForKey:@"time"]);
    NSLog(@"댓글 업데이트 결과: %@", [updateComment valueForKey:@"result"]);   
    
    [self viewDidAppear:NO];
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
        [self parseComment:jsonString];
    }
    else if ([libInfoDataFlag isEqualToString:@"updateComment"]) {
        [self parseUpdateComment:jsonString];
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

//HTTP통신 완료되었을 경우 실행되는 메서드(데이터를 받아왔을 때)
- (void)didReceiveFinished2:(NSString *)result
{
    NSLog(@"didReceiveFinished2 메소드 실행. dataFlag : %@", libInfoDataFlag2);
    
    NSString *jsonString = result;
    
    //dataFlag 값에 따라서 각각 다른 파싱메서드를 호출해준다
    if ([libInfoDataFlag2 isEqualToString:@"getRadius"]) {
        //        [self parseRadius:jsonString];
    }
    else if ([libInfoDataFlag2 isEqualToString:@"getDist"]) {
        //        [self parseDist:jsonString];
    }
    else if ([libInfoDataFlag2 isEqualToString:@"getComment"]) {
        [self parseComment:jsonString];
    }
    else if ([libInfoDataFlag2 isEqualToString:@"updateComment"]) {
        [self parseUpdateComment:jsonString];
    }
    else if ([libInfoDataFlag2 isEqualToString:@"getRating"]) {
        [self parseRating:jsonString];
    }
    else if ([libInfoDataFlag2 isEqualToString:@"updateRating"]) {
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


// =====================테이블 뷰 세팅 관련 메서드 시작===========================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"BIDLibInfoViewController - numberOfRowsInSection 메서드 실행");
    return commentCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"BIDLibInfoViewController - cellForRowsAtIndexPath 메서드 실행");
    static NSString *cIdentifier = @"cell"; //셀 구분자 정의
    UITableViewCell *cell = [commentTable dequeueReusableCellWithIdentifier:cIdentifier]; //식별자와 함꼐 재사용가능한 셀 만들기
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cIdentifier];
    }
    
    cell.textLabel.text = [commentArticle objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [commentDate objectAtIndex:indexPath.row];
    
    return cell;
}


// =====================테이블 뷰 세팅 관련 메서드 끝===========================

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"BIDLibInfoViewController - viewDidDisappear 메서드 실행");
}

- (void)viewDidUnload
{
    NSLog(@"BIDLibInfoViewController - viewDidUnload 메서드 실행");
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
