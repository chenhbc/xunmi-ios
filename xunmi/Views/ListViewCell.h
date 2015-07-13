//
//  ListViewCell.h
//  xunmi
//
//  Created by LarryChen on 15/6/9.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *typeImageView;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *linkLabel;

@end
