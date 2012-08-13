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


@interface BIDLibInfoViewController ()

@end

@implementation BIDLibInfoViewController

@synthesize scrollView = _scrollView;
@synthesize commentField;

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
    self.title = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"lib%i_name", [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedLib"]]];
    
    //스크롤뷰 생성
    _scrollView.frame = CGRectMake(0, 158, 320, 209);
    _scrollView.contentSize = CGSizeMake(320,800);

    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidAppear:(BOOL)animated {
    
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"tabFlag"]) {
        case 1:
            self.title = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"1_lib%i_name", [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedLib"]]];

            break;
            
        case 3:
            self.title = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_name", [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedLib"]]];

            break;
    }
    
    
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
