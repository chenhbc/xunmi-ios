//
//  SearchResultViewController.m
//  xunmi
//
//  Created by LarryChen on 15/6/5.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "SearchResultViewController.h"

#import "GSIndeterminateProgressView.h"
#import "SCNavTabBarController.h"
#import "CommonMacro.h"
#import "SearchUtil.h"
#import "ListViewController.h"

@interface SearchResultViewController () {
    GSIndeterminateProgressView * progressView;
    
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
    
//    [self initProgress];
}

- (void)initProgress {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    progressView = [[GSIndeterminateProgressView alloc] initWithFrame:CGRectMake(0, navigationBar.frame.size.height + NAVIGATION_BAR_HEIGHT, navigationBar.frame.size.width, 2)];
    progressView.progressTintColor = navigationBar.barTintColor;
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [navigationBar addSubview:progressView];
}

- (void)initNavTabBar {
    baiduYunViewController = [[ListViewController alloc] initWithBlock:^NSArray *(int page) {
        return [self searchOnBaiduYun:page];
    }];
    baiduYunViewController.title = @"百度云";
    
    weipanViewController = [[ListViewController alloc] initWithBlock:^NSArray *(int page) {
        return [self searchOnWeipan:page];
    }];
    weipanViewController.title = @"微盘";
    
    huaweiWangpanViewController = [[ListViewController alloc] initWithBlock:^NSArray *(int page) {
        return [self searchOnHuaweiWangpan:page];
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

- (NSArray *) searchOnBaiduYun:(int) page {
    NSArray *jsonObj;
    NSString *resultStr = [[[SearchUtil alloc] init] searchBaiduYun:_searchText : page];
    
    NSError *error;
    NSString *regulaStr = @"<h3 class=\\\\\"r\\\\\"(.+?)>(.+?)<a href=\\\\\"(.+?)\\\\\" target=\\\\\"_blank\\\\\">(.+?)<\\\\/a>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:resultStr options:0 range:NSMakeRange(0, [resultStr length])];
    
    NSString *jsonStr = @"[";
    
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        // match.range
        NSString *resultUrl = [resultStr substringWithRange:[match rangeAtIndex:3]];
        NSString *resultTitle = [resultStr substringWithRange:[match rangeAtIndex:4]];
        
        if (![jsonStr isEqualToString:@"["]) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"{\"url\":\"%@\", \"title\":\"%@\"}", resultUrl, resultTitle]];
    }
    
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    if (error) {
        NSLog(@"Has error");
    }
    NSLog(@"Loading data");
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingAllowFragments error:&error];
    
//    [baiduYunViewController reloadTableViewDataSourceWithArray:jsonObj];
    return jsonObj;
}

- (NSArray *)searchOnWeipan:(int) page {
    NSArray *jsonObj;
    NSString *resultStr = [[[SearchUtil alloc] init] searchWeipan:_searchText : page];
    
    NSError *error;
    NSString *regulaStr = @"<div class=\"sort_name_detail\"><a href=\"(.+?)\" target=\"_blank\" title=\"(.+?)\">";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:resultStr options:0 range:NSMakeRange(0, [resultStr length])];
    
    NSString *jsonStr = @"[";
    
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        // match.range
        NSString *resultUrl = [resultStr substringWithRange:[match rangeAtIndex:1]];
        NSString *resultTitle = [resultStr substringWithRange:[match rangeAtIndex:2]];
        
        if (![jsonStr isEqualToString:@"["]) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"{\"url\":\"%@\", \"title\":\"%@\"}", resultUrl, resultTitle]];
    }
    
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    if (error) {
        NSLog(@"Has error");
    }
    NSLog(@"Loading data");
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingAllowFragments error:&error];
    
//    [weipanViewController reloadTableViewDataSourceWithArray:jsonObj];
    return jsonObj;
}

- (NSArray *) searchOnHuaweiWangpan: (int) page {
    NSArray *jsonObj;
    NSString *resultStr = [[[SearchUtil alloc] init] searchHuaweiWangpan:_searchText : page];
    
    NSError *error;
    NSString *regulaStr = @"<h3 class=\\\\\"r\\\\\"(.+?)>(.+?)<a href=\\\\\"(.+?)\\\\\" target=\\\\\"_blank\\\\\">(.+?)<\\\\/a>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:resultStr options:0 range:NSMakeRange(0, [resultStr length])];
    
    NSString *jsonStr = @"[";
    
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        // match.range
        NSString *resultUrl = [resultStr substringWithRange:[match rangeAtIndex:3]];
        NSString *resultTitle = [resultStr substringWithRange:[match rangeAtIndex:4]];
        
        if (![jsonStr isEqualToString:@"["]) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"{\"url\":\"%@\", \"title\":\"%@\"}", resultUrl, resultTitle]];
    }
    
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    if (error) {
        NSLog(@"Has error");
    }
    NSLog(@"Loading data");
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingAllowFragments error:&error];
    
    //    [huaweiWangpanViewController reloadTableViewDataSourceWithArray:jsonObj];
    return jsonObj;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
