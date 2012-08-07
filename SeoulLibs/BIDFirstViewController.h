//
//  BIDFirstViewController.h
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 7. 31..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIDLibInfoViewController.h"

@interface BIDFirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
    UITableView *resultTable;
}

- (void) getRadius:(NSString *)library_class longtitude:(NSString *)longtitude latitude:(NSString *)latitude radius:(NSString *)radius; //반경 검색
- (void) parseRadius:(NSString *)jsonString; //반경 파싱

@property (strong, nonatomic) NSArray *listData;
@property (nonatomic, retain) IBOutlet UITableView *resultTable;


@end
