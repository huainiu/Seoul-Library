//
//  BIDRadiusSelectViewController.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 8. 13..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDRadiusSelectViewController.h"

@interface BIDRadiusSelectViewController ()

@end

@implementation BIDRadiusSelectViewController
@synthesize selectedRadius;

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
    // Do any additional setup after loading the view from its nib.
    radiusArray = [[NSArray alloc] initWithObjects:@"100m", @"300m", @"500m", @"1km", nil];
    //반경 선택에 주어지는 반경 값
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeSetting {
    //모달뷰 닫기 버튼 액션
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectRadius {
    //반경 선택 액션
    UIPickerView *radiusPickerView = [[UIPickerView alloc] init];
    [radiusPickerView setDelegate:self];
    [radiusPickerView setDataSource:self];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    // 피커뷰의 컴포넌트 개수 정의 (세로로 구분되는 항목) - 우리 앱은 1개라서 리턴값 1.

    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // 컴포넌트 별 항목 수 정의 , 컴포넌트가 여러개일 경우 switch문을 이용해서 분기.
    // 우리 어플은 컴포넌트가 1개이므로 걍 어레이의 데이터 행 개수와 동일
    return  [radiusArray count];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //각 행에 출력하는 이름 - 반경 어레이에서 가져옴
    return [radiusArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //피커뷰의 행을 선택하면 실행되는 메서드.
    [selectedRadius setText:[radiusArray objectAtIndex:row]]; // 레이블의 값을 피커뷰에서 선택한 값으로 변환    
}


@end
