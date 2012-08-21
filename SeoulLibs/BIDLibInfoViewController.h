//
//  BIDLibInfoViewController.h
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 8. 4..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDLibInfoViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UILabel *ratingLabel;
    UITextField *ratingText;
    UITextField *commentField;//댓글 입력창
    UITableView *commentTable; //댓글 표시되는 테이블
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITextField *commentField; //댓글 입력창
@property (nonatomic, retain) IBOutlet UILabel *ratingLabel;
@property (nonatomic, retain) IBOutlet UITextField *ratingText;
@property (nonatomic, retain) IBOutlet UITableView *commentTable;

- (IBAction)textFieldDoneEdit; // 배경을 탭하면 키보드 사라지는 액션
- (IBAction)goToMap; // 지도보기 누르면 지도 뷰 컨트롤러로 이동
- (IBAction)goToFindWay; // 길찾기 누르면 지도 뷰 컨트롤러로 이동

- (void) getRating:(NSString *)library_class idx:(NSString *)idx; //평점 가져오기
- (void) parseRating:(NSString *)jsonString; //평점 파싱
- (void) getComment:(NSString *)library_class idx:(NSString *)idx; //댓글 가져오기
- (void) updateComment:(NSString *)library idx:(NSString *)idx article:(NSString *)article uuid:(NSString *)uuid; //댓글 등록하기
- (void) getRating:(NSString *)library_class idx:(NSString *)idx; //평점 가져오기
- (void) updateRating:(NSString *)library idx:(NSString *)idx rating:(NSString *)rating uuid:(NSString *)uuid ; //평점 업데이트

- (void) parseComment:(NSString *)jsonString; //댓글 파싱
- (void) parseUpdateComment:(NSString *)jsonString; //댓글 업데이트 후 받아온 데이터 파싱
- (void) parseRating:(NSString *)jsonString; //평점 파싱
- (void) parseUpdateRating:(NSString *)jsonString; //평점 업데이트 후 받아온 데이터 파싱

- (IBAction)rate:(id)sender; //평점 매기기

- (IBAction)registerComment:(id)sender; //댓글 등록



@end
