//
//  BIDRadiusSelectViewController.h
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 8. 13..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//
//  첫번째 탭에서 반경 버튼을 눌렀을 때 나오는 모달뷰

#import <UIKit/UIKit.h>

@interface BIDRadiusSelectViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *radiusArray; //반경 목록 어레이
}

- (IBAction)closeSetting;
//모달뷰 닫기 버튼 액션

- (IBAction)selectRadius;
//반경 선택 액션

@property (strong, nonatomic) IBOutlet UILabel *selectedRadius; // 선택된 반경 값 반환

@end
