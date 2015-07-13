//
//  ListViewCell.m
//  xunmi
//
//  Created by LarryChen on 15/6/9.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "ListViewCell.h"

@implementation ListViewCell

- (void)awakeFromNib {
    // Initialization code
    self.typeImageView.layer.cornerRadius = 5;
    self.typeImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
