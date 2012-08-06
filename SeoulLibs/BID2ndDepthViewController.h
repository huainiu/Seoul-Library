//
//  BID2ndDepthViewController.h
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 8. 3..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface BID2ndDepthViewController : UITableViewController 
{
    UITableView *libListTable;
}

@property (nonatomic, retain) IBOutlet UITableView *libListTable;

@end
