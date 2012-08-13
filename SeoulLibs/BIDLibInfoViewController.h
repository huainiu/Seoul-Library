//
//  BIDLibInfoViewController.h
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 8. 4..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDLibInfoViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *commentField;

- (IBAction)textFieldDoneEdit; // 배경을 탭하면 키보드 사라지는 액션
- (IBAction)goToMap; // 지도보기 누르면 지도 뷰 컨트롤러로 이동
- (IBAction)goToFindWay; // 길찾기 누르면 지도 뷰 컨트롤러로 이동


@end
