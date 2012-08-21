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
    UILabel *ratingLabel;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (nonatomic, retain) IBOutlet UILabel *ratingLabel;

- (IBAction)textFieldDoneEdit; // 배경을 탭하면 키보드 사라지는 액션
- (IBAction)goToMap; // 지도보기 누르면 지도 뷰 컨트롤러로 이동
- (IBAction)goToFindWay; // 길찾기 누르면 지도 뷰 컨트롤러로 이동

- (void) getRating:(NSString *)library_class idx:(NSString *)idx; //평점 가져오기
- (void) parseRating:(NSString *)jsonString; //평점 파싱


@end
