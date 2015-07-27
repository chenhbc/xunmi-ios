//
//  SearchUtil.h
//  xunmi
//
//  Created by LarryChen on 15/6/7.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

@interface SearchUtil : NSObject

// keyword split by space
- (NSString *)getKeywordsUrl:(NSString *) keyword;

// get result string by search url
- (NSString *)search:(NSString *) urlString;

- (NSString *)searchBaiduYun:(NSString *) keyword:(int) page;

- (NSString *)searchWeipan:(NSString *) keyword:(int) page;

- (NSString *)searchHuaweiWangpan:(NSString *) keyword:(int) page;

- (NSArray *) searchOnBaiduYun:(NSString *) searchText:(int) page;

- (NSArray *)searchOnWeipan:(NSString *) searchText:(int) page;

- (NSArray *) searchOnHuaweiWangpan:(NSString *) searchText: (int) page;

@end
