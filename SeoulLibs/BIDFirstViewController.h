//
//  BIDFirstViewController.h
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 7. 31..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIDLibInfoViewController.h"

@interface BIDFirstViewController : UIViewController
    <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *listData;

@end
