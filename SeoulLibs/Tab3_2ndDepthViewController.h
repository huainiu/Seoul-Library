//
//  Tab3_2ndDepthViewController.h
//  SeoulLibs
//
//  Created by SeokWoo Rho on 12. 8. 15..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface Tab3_2ndDepthViewController : UITableViewController 
{
    UITableView *dongListTable;
    NSArray *dongListData;
    UIActivityIndicatorView *activityIndicator; //가운데 로딩 돌아가는거

}

@property (nonatomic, retain) IBOutlet UITableView *dongListTable;
@property (strong, nonatomic) NSArray *dongListData;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator; //가운데 로딩 돌아가는거

@end
