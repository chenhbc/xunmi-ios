//
//  SettingsViewController.m
//  xunmi
//
//  Created by LarryChen on 15/6/3.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  返回按钮触发的事件
 *
 *  @param sender 返回按钮
 */
- (void)backBarButtonPressed:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

//NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//
//NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//
//_lblAppVersion.text = [NSString stringWithFormat:@"v%@", app_Version];

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}


@end
