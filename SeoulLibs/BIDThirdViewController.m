//
//  BIDThirdViewController.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 7. 31..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDThirdViewController.h"
#import "HTTPRequestPost.h"
#import "HTTPRequest.h"
#import "SBJson.h"

@interface BIDThirdViewController ()

@end



@implementation BIDThirdViewController
@synthesize SearchBar;

@synthesize activityIndicator;
@synthesize listData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"도서관목록", @"도서관목록");
        self.tabBarItem.image = [UIImage imageNamed:@"Third"];
        self.navigationItem.title = @"도서관 목록";
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"구 목록";
    // Do any additional setup after loading the view from its nib.
    NSArray *guArray = [[NSArray alloc] initWithObjects:@"강남구", @"강동구", @"강북구", @"강서구", @"관악구", @"광진구", @"구로구", @"금천구", @"노원구", @"도봉구", @"동대문구", @"동작구", @"마포구", @"서대문구", @"서초구", @"성동구", @"성북구", @"송파구", @"양천구", @"영등포구", @"용산구", @"은평구", @"종로구", @"중구", @"중랑구", nil] ;
    self.listData = guArray;
    
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.listData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSUserDefaults standardUserDefaults] setValue:[listData objectAtIndex:indexPath.row] forKey:@"selectedGu"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //2ndview띄우기 코드 넣을곳
    //해당 구의 도서관 목록 띄워주는 페이지 호출
    Tab3_2ndDepthViewController *dongListViewController = [Tab3_2ndDepthViewController alloc];
    [self.navigationController pushViewController:dongListViewController animated:YES];
}


#pragma mark-
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [listData objectAtIndex:row];
    return cell;
}

- (IBAction)backgroundTap {
    [SearchBar resignFirstResponder];
}

@end
