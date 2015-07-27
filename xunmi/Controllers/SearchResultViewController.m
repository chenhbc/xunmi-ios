//
//  SearchResultViewController.m
//  xunmi
//
//  Created by LarryChen on 15/6/5.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "SearchResultViewController.h"

#import "SCNavTabBarController.h"
#import "CommonMacro.h"
#import "SearchUtil.h"
#import "ListViewController.h"

@interface SearchResultViewController () {
    
    ListViewController *baiduYunViewController;
    
    ListViewController *weipanViewController;
    
    ListViewController *huaweiWangpanViewController;
}

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ - 搜索结果", _searchText];
    
    [self initNavTabBar];
}

- (void)initNavTabBar {
    SearchUtil *searchUtil = [[SearchUtil alloc] init];
    
    baiduYunViewController = [[ListViewController alloc] initWithBlock:^NSArray *(int page) {
        return [searchUtil searchOnBaiduYun:_searchText :page];
    }];
    baiduYunViewController.title = @"百度云";
    
    weipanViewController = [[ListViewController alloc] initWithBlock:^NSArray *(int page) {
        return [searchUtil searchOnWeipan:_searchText :page];
    }];
    weipanViewController.title = @"微盘";
    
    huaweiWangpanViewController = [[ListViewController alloc] initWithBlock:^NSArray *(int page) {
        return [searchUtil searchOnHuaweiWangpan:_searchText :page];
    }];
    huaweiWangpanViewController.title = @"华为网盘";
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[baiduYunViewController, weipanViewController, huaweiWangpanViewController];
    navTabBarController.showArrowButton = NO;
    [navTabBarController addParentController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
