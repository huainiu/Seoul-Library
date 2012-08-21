//
//  Tab3_3ndDepthViewController.m
//  SeoulLibs
//
//  Created by SeokWoo Rho on 12. 8. 15..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "Tab3_3ndDepthViewController.h"
#import "Tab3_2ndDepthViewController.h"
#import "BIDThirdViewController.h"
#import "BIDLibInfoViewController.h"

@interface Tab3_3ndDepthViewController ()

@end


NSMutableDictionary *distResult = Nil;

@implementation Tab3_3ndDepthViewController

@synthesize libListTable;
@synthesize noLibLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initializatcion
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@ %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedGu"], [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedDong"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"3ndDepthViewController - viewDidAppear 메서드 실행");
    [libListTable reloadData];    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"] == 0) {
        noLibLabel.hidden = FALSE;
        libListTable.hidden = TRUE;
    } else {
        noLibLabel.hidden = TRUE;
        libListTable.hidden = FALSE;
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"resultCount"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    cell.textLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_name", indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // Configure the cell...
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [libListTable deselectRowAtIndexPath:indexPath animated:YES];

    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_class", indexPath.row]] forKey:@"currentLibInfo_class"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_id", indexPath.row]] forKey:@"currentLibInfo_id"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_distance", indexPath.row]] forKey:@"currentLibInfo_distance"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_longtitude", indexPath.row]] forKey:@"currentLibInfo_longtitude"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_latitude", indexPath.row]] forKey:@"currentLibInfo_latitude"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_name", indexPath.row]] forKey:@"currentLibInfo_name"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_category", indexPath.row]] forKey:@"currentLibInfo_category"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_guname", indexPath.row]] forKey:@"currentLibInfo_guname"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_dongname", indexPath.row]] forKey:@"currentLibInfo_dongname"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_slaveno", indexPath.row]] forKey:@"currentLibInfo_slaveno"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_organization", indexPath.row]] forKey:@"currentLibInfo_organization"];
    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"3_lib%i_opendate", indexPath.row]] forKey:@"currentLibInfo_guname"];

    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"tabFlag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    BIDLibInfoViewController *libInfoViewController = [BIDLibInfoViewController alloc];
    [self.navigationController pushViewController:libInfoViewController animated:YES];
    
}

@end
