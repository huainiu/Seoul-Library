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



int getSearchResultFlag = 0;
int searchFlag = 0;
NSMutableArray *searchDataArray = nil; 
NSMutableArray *searchSumArray = nil; 
NSMutableArray *searchResultArray = nil;

@implementation BIDThirdViewController

@synthesize SearchBar;
@synthesize activityIndicator;
@synthesize listData;
@synthesize guTable;


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
    NSLog(@"ThridViewController - viewDidLoad 메서드 실행");
    
    [super viewDidLoad];
    self.title = @"구 목록";
    // Do any additional setup after loading the view from its nib.
    NSArray *guArray = [[NSArray alloc] initWithObjects:@"강남구", @"강동구", @"강북구", @"강서구", @"관악구", @"광진구", @"구로구", @"금천구", @"노원구", @"도봉구", @"동대문구", @"동작구", @"마포구", @"서대문구", @"서초구", @"성동구", @"성북구", @"송파구", @"양천구", @"영등포구", @"용산구", @"은평구", @"종로구", @"중구", @"중랑구", nil] ;
    self.listData = guArray;
    
}


- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"ThirdViewController - viewDidAppear 메서드 실행");
    
    searchFlag = 0;
    
    for (int i=0; i < 24; i++) {
        [guTable beginUpdates];
        
        NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:i inSection:0];
        
        NSArray *indexPathArray = [NSArray arrayWithObjects:indexPath0, nil];
        
        [guTable reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        
        [guTable endUpdates];
    }
}


- (void)viewDidUnload
{
    [self setSearchBar:nil];
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
    
    [guTable deselectRowAtIndexPath:indexPath animated:YES];
    [[NSUserDefaults standardUserDefaults] setValue:[listData objectAtIndex:indexPath.row] forKey:@"selectedGu"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [SearchBar resignFirstResponder];
    
    //해당 구의 도서관 목록 띄워주는 페이지 호출
    Tab3_2ndDepthViewController *dongListViewController = [Tab3_2ndDepthViewController alloc];
    [self.navigationController pushViewController:dongListViewController animated:YES];
}



//searchbar에서 검색 버튼을 클릭했을 때 실행되는 메서드
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchFlag = 1;
    [self getSearchResult:@"large" name:SearchBar.text];
    [self getSearchResult:@"small" name:SearchBar.text];
    [SearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchFlag = 0;
    SearchBar.text = @"";
    [SearchBar resignFirstResponder];
    [self viewDidAppear:NO];
}


//행정구역 검색. GET
- (void) getSearchResult:(NSString *)library_class name:(NSString *)name {
    
    NSLog(@"getSearch 메서드 실행");
    
    NSString *url = nil;
    
    //접속할 주소 설정
    //예시 : http://seoullibrary.herokuapp.com/name/library_class/name
    url = [[NSString stringWithFormat: @"http://seoullibrary.herokuapp.com/name/%@/%@", library_class, name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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


//HTTP통신 완료되었을 경우 실행되는 메서드(데이터를 받아왔을 때)
- (void)didReceiveFinished:(NSString *)result
{
    NSLog(@"didReceiveFinished 메소드 실행.");
    
    NSString *jsonString = result;
    
    [self parseSearchResult:jsonString];
}


//검색결과 파싱
- (void) parseSearchResult:(NSString *)jsonString {
    
    getSearchResultFlag = getSearchResultFlag + 1; //데이터 1번 받아온거 확보되었으니 flag에 1을 더해줌
    
    NSLog(@"jsonString : %@", jsonString);
    
    //파서 객체 생성
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    //getSearchResult로 서버에서 받아온 데이터를 딕셔너리에 넣음
    NSMutableDictionary* searchResult = [ parser objectWithString: jsonString ];
    
    NSLog(@"요청처리시간: %@", [searchResult valueForKey:@"time"]);
    NSLog(@"반경검색 결과의 수: %@", [searchResult valueForKey:@"total_rows"]);
    
    if (getSearchResultFlag == 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:[[searchResult valueForKey:@"total_rows"] intValue] forKey:@"resultCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"resultCount : %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"]);
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"] +[[searchResult valueForKey:@"total_rows"] intValue] forKey:@"resultCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"resultCount : %i", [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"]);
    }
    
    searchDataArray = [searchResult objectForKey:@"rows"];    
    NSLog(@"searchDataArray count : %i", [searchDataArray count]);
    
    if (getSearchResultFlag == 1) {
        NSLog(@"getSearchResultFlag == 1");
        searchSumArray = searchDataArray;
        [searchSumArray setArray:searchDataArray]; //새로 받아온 데이터 Array중 rows 부분을 sumArray에 넣어준다
    }
    else {
        NSLog(@"getSearchResultFlag != 1");
        for (int i=0; i < [searchDataArray count]; i++) {
            [searchSumArray addObject:[searchDataArray objectAtIndex:i]];
        }
    }
    
    if(getSearchResultFlag == 2) { //데이터를 2번 받아왔다면(large, small)
        NSLog(@"getSearchResultFlag == 2");
        searchResultArray = searchSumArray;
        
        //정렬
        NSSortDescriptor *arraySorter = [[NSSortDescriptor alloc] initWithKey:@"fclty_nm" ascending:YES];
        [searchResultArray sortUsingDescriptors:[NSArray arrayWithObject:arraySorter]];
        
        //        resultArray = [resultArray sortedArrayUsingSelector:@selector(nameCompare:)];
        
        for (int i=0; i < [searchResultArray count]; i++) {
            NSLog(@"도서관 종류%i: %@", i,[[searchResultArray objectAtIndex:i] valueForKey:@"lib_class"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[searchResultArray objectAtIndex:i] valueForKey:@"lib_class"] forKey:[NSString stringWithFormat:@"3_search_lib%i_class", i]];
            NSLog(@"도서관 id%i: %@", i,[[searchResultArray objectAtIndex:i] valueForKey:@"cartodb_id"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[searchResultArray objectAtIndex:i] valueForKey:@"cartodb_id"] forKey:[NSString stringWithFormat:@"3_search_lib%i_id", i]];
            NSLog(@"도서관의 좌표%i: %@", i, [[searchResultArray objectAtIndex:i] valueForKey:@"st_astext"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[searchResultArray objectAtIndex:i] valueForKey:@"st_astext"] forKey:[NSString stringWithFormat:@"3_search_lib%i_point", i]];
            NSLog(@"도서관 이름%i: %@", i, [[searchResultArray objectAtIndex:i] valueForKey:@"fclty_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[searchResultArray objectAtIndex:i] valueForKey:@"fclty_nm"] forKey:[NSString stringWithFormat:@"3_search_lib%i_name", i]];
            NSLog(@"도서관 구분%i: %@", i, [[searchResultArray objectAtIndex:i] valueForKey:@"fly_gbn"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[searchResultArray objectAtIndex:i] valueForKey:@"fly_gbn"] forKey:[NSString stringWithFormat:@"3_search_lib%i_category", i]];
            NSLog(@"행정구 이름%i: %@", i, [[searchResultArray objectAtIndex:i] valueForKey:@"gu_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[searchResultArray objectAtIndex:i] valueForKey:@"gu_nm"] forKey:[NSString stringWithFormat:@"3_search_lib%i_guname", i]];
            NSLog(@"행정동 이름%i: %@", i, [[searchResultArray objectAtIndex:i] valueForKey:@"hnr_nm"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[searchResultArray objectAtIndex:i] valueForKey:@"hnr_nm"] forKey:[NSString stringWithFormat:@"3_search_lib%i_dongname", i]];
            NSLog(@"주 지번%i: %@", i, [[searchResultArray objectAtIndex:i] valueForKey:@"masterno"]);
            NSLog(@"보조 지번%i: %@", i, [[searchResultArray objectAtIndex:i] valueForKey:@"slaveno"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[searchResultArray objectAtIndex:i] valueForKey:@"slaveno"] forKey:[NSString stringWithFormat:@"3_search_lib%i_slaveno", i]];
            NSLog(@"운영 주최%i: %@", i, [[searchResultArray objectAtIndex:i] valueForKey:@"orn_org"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[searchResultArray objectAtIndex:i] valueForKey:@"orn_org"] forKey:[NSString stringWithFormat:@"3_search_lib%i_organization", i]];
            NSLog(@"개관일%i: %@", i, [[searchResultArray objectAtIndex:i] valueForKey:@"opnng_de"]);
            [[NSUserDefaults standardUserDefaults] setValue:[[searchResultArray objectAtIndex:i] valueForKey:@"opnng_de"] forKey:[NSString stringWithFormat:@"3_search_lib%i_opendate", i]];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //해당 구,동의 도서관 목록 띄워주는 페이지 호출
            [guTable beginUpdates];
            NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:i inSection:0];
            
            NSArray *indexPathArray = [NSArray arrayWithObjects:indexPath0, nil];
            
            [guTable reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            
            [guTable endUpdates];
            getSearchResultFlag = 0;
            
        }
        //Activity Indicator 비활성화.
        [activityIndicator stopAnimating];     
        activityIndicator.hidden= TRUE;
        
    }
}




/*
 //return 클릭시 액션 구현
 - (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
 
 //userID textfield는 return키가 next이므로 next클릭하면 userPassword로 커서 이동
 if(theTextField == userID){
 [userPassword becomeFirstResponder];
 } 
 //userPassword는 return키가 done이므로 done클릭하면 키보드 내려감
 else if(theTextField == userPassword)
 {
 [userPassword resignFirstResponder];
 }
 
 return YES;
 }
 */


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
    
    if ( searchFlag == 0 ) {
        cell.textLabel.text = [listData objectAtIndex:row];
    } else {
        cell.textLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_search_lib%i_name", indexPath.row]];
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (IBAction)backgroundTap {
    [SearchBar resignFirstResponder];
}


@end
