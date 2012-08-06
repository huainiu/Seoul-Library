//
//  BIDTableViewCell.m
//  SeoulLibs
//
//  Created by 김 명훈 on 12. 8. 3..
//  Copyright (c) 2012년 서울대학교. All rights reserved.
//

#import "BIDTableViewCell.h"

#define kParkInfoValueTag 1

@implementation BIDTableViewCell

@synthesize parkInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect parkInfoLabelRect = CGRectMake(0, 5, 70, 15);
        UILabel *parkInfoLabel = [[UILabel alloc] initWithFrame:parkInfoLabelRect];
        parkInfoLabel.textAlignment = UITextAlignmentRight;
        parkInfoLabel.text = @"parkInfo:";
        parkInfoLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:parkInfoLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
