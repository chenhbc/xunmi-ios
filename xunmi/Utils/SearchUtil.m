//
//  SearchUtil.m
//  xunmi
//
//  Created by LarryChen on 15/6/7.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchUtil.h"

@interface SearchUtil()

@end

NSString * const kUrl = @"www.jwss.cc";

int PAGE_NUMBER = 10;

@implementation SearchUtil

- (NSString *)getKeywordsUrl:(NSString *) keyword {
    NSString *queryStr = @"";
    if (keyword.length > 0) {
        NSArray *keywordArr = [keyword componentsSeparatedByString:@" "];
        for (NSString *k in keywordArr) {
            queryStr = [queryStr stringByAppendingString:[NSString stringWithFormat:@"+%@", k]];
        }
    }
    
    return queryStr;
}

- (NSString *)search:(NSString *) urlString {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, (CFStringRef)@"!*'();:@$,%#[]", kCFStringEncodingUTF8 ));
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@", encodedString]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setValue:@"Mozilla/5.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"_GFTOKEN=8f1a268d038ac2125bc84471" forHTTPHeaderField:@"Cookie"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *returnData = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
//    NSString *retStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    return returnData;
}

- (NSString *)searchBaiduYun:(NSString *) keyword:(int) page {
    NSString *urlString = [NSString stringWithFormat:@"%@/?q=%@+site:yun.baidu.com+OR+site:pan.baidu.com&pn=%d", kUrl, [self getKeywordsUrl:keyword], page * PAGE_NUMBER];
    
    return [self search:urlString];
}

- (NSString *)searchWeipan:(NSString *) keyword:(int) page {
    NSString *urlString = [NSString stringWithFormat:@"vdisk.weibo.com/search/?type=&sortby=default&keyword=%@&filetype=&page=%d", [self getKeywordsUrl:keyword], page];
    
    return [self search:urlString];
}

- (NSString *)searchHuaweiWangpan:(NSString *) keyword:(int) page {
    NSString *urlString = [NSString stringWithFormat:@"%@/?q=%@+site:dl.dbank.com+OR+site:dl.vmall.com&pn=%d", kUrl, [self getKeywordsUrl:keyword], page * PAGE_NUMBER];
    
    return [self search:urlString];
}

@end