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

@end
