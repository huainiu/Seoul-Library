//
//  BIDLibInfoViewController.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 8. 4..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDLibInfoViewController.h"
#import "BIDFirstViewController.h"

@interface BIDLibInfoViewController ()

@end

@implementation BIDLibInfoViewController

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
