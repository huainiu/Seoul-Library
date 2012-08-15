//
//  Tab3_3ndDepthViewController.m
//  SeoulLibs
//
//  Created by SeokWoo Rho on 12. 8. 15..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "Tab3_3ndDepthViewController.h"

@interface Tab3_3ndDepthViewController ()

@end

@implementation Tab3_3ndDepthViewController

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

@end
