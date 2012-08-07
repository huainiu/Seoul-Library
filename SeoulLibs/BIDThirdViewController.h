//
//  BIDThirdViewController.h
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 7. 31..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BID2ndDepthViewController.h"
#import "ViewController.h"


@class secondDepthViewController;

@interface BIDThirdViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIActivityIndicatorView *activityIndicator; //가운데 로딩 돌아가는거
}

@property (strong, nonatomic) NSArray *listData;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator; //가운데 로딩 돌아가는거


@end
