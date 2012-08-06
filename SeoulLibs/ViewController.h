//
//  ViewController.h
//  SeoulLibrary_rho
//
//  Created by SeokWoo Rho on 12. 7. 29..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    UIButton *getRadiusButton;
    UIButton *getDistButton;
    UIButton *getCommentButton;
    UIButton *updateCommentButton;
    UIButton *getRatingButton;
    UIButton *updateRatingButton;
}


@property (nonatomic, retain) IBOutlet UIButton *getRadiusButton;
@property (nonatomic, retain) IBOutlet UIButton *getDistButton;
@property (nonatomic, retain) IBOutlet UIButton *getCommentButton;
@property (nonatomic, retain) IBOutlet UIButton *updateCommentButton;
@property (nonatomic, retain) IBOutlet UIButton *getRatingButton;
@property (nonatomic, retain) IBOutlet UIButton *updateRatingButton;


- (void) getRadius:(NSString *)library_class longtitude:(NSString *)longtitude latitude:(NSString *)latitude radius:(NSString *)radius; //반경 검색
- (void) getDist:(NSString *)library_class gu:(NSString *)gu dong:(NSString *)dong;
- (void) getComment; //댓글 가져오기
- (void) updateComment; //댓글 업데이트
- (void) getRating; //평점 가져오기
- (void) updateRating; //평점 업데이트

- (void) parseRadius:(NSString *)jsonString; //반경 파싱
- (void) parseDist:(NSString *)jsonString; //행정구역 파싱
- (void) parseComment:(NSString *)jsonString; //댓글 파싱
- (void) parseUpdateComment:(NSString *)jsonString; //댓글 업데이트 후 받아온 데이터 파싱
- (void) parseRating:(NSString *)jsonString; //평점 파싱
- (void) parseUpdateRating:(NSString *)jsonString; //평점 업데이트 후 받아온 데이터 파싱

- (NSString *)URLEncodedString; //한글 url 인코딩


@end
