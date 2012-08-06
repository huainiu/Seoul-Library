//
//  BIDSecondViewController.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 7. 31..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDSecondViewController.h"
#import "BIDMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKUserLocation.h>
#import <CoreLocation/CLLocation.h>

@interface BIDSecondViewController ()

@end

@implementation BIDSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
                
        self.title = NSLocalizedString(@"지도 검색", @"지도 검색");
        self.tabBarItem.image = [UIImage imageNamed:@"Second"];
        self.navigationItem.title = @"지도 검색";
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)showUserLocation{
    
}

- (IBAction)goToInnerDepth:(id)sender{
    BIDMapViewController *mapview = [BIDMapViewController new];
    [self.navigationController pushViewController:mapview animated:YES];
}


@end
