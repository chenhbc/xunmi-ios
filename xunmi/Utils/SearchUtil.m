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

// 搜索引擎
NSString * const kUrl = @"www.bing.com";

// 匹配标题和URL正则
NSString * const kRegex = @"<li.*?class=\"b_algo\".*?>.*?<h2>.*?<a.*?href=\"(.*?)\".*?>(.*?)</a>.*?</h2>.*?<div.*?class=\"b_caption\">.*?</div>.*?</li>";

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
    
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.89 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"MUID=06967142A0EA6413382876B2A16065DC; SRCHUID=V=2&GUID=537664C6A2AE43C095A2B01D4473E623; MUIDB=06967142A0EA6413382876B2A16065DC; SRCHD=AF=QBRE; SRCHUSR=AUTOREDIR=0&GEOVAR=&DOB=20150726; _FP=BDCE=130823885395050309&BDCEH=F9228750531A508EB41F30CA9F1D3059; SRCHHPGUSR=CW=1264&CH=396&DPR=2" forHTTPHeaderField:@"Cookie"];

    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *returnData = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
//    NSString *retStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    return returnData;
}

- (NSString *)searchBaiduYun:(NSString *) keyword:(int) page {
    // %@/search?q=%@+site:yun.baidu.com+OR+site:pan.baidu.com&first=%d
    // 暂不知道必应的或者搜索用法
    NSString *urlString = [NSString stringWithFormat:@"%@/search?q=%@+site:pan.baidu.com&first=%d&mkt=zh-CN", kUrl, [self getKeywordsUrl:keyword], page * PAGE_NUMBER];
    
    return [self search:urlString];
}

- (NSString *)searchWeipan:(NSString *) keyword:(int) page {
    NSString *urlString = [NSString stringWithFormat:@"vdisk.weibo.com/search/?type=&sortby=default&keyword=%@&filetype=&page=%d", [self getKeywordsUrl:keyword], page];
    
    return [self search:urlString];
}

- (NSString *)searchHuaweiWangpan:(NSString *) keyword:(int) page {
    NSString *urlString = [NSString stringWithFormat:@"%@/search?q=%@+site:dl.dbank.com&first=%d&mkt=zh-CN", kUrl, [self getKeywordsUrl:keyword], page * PAGE_NUMBER];
    
    return [self search:urlString];
}

- (NSArray *) searchOnBaiduYun:(NSString *) searchText:(int) page {
    NSArray *jsonObj;
    
    NSString *resultStr = [self searchBaiduYun:searchText : page];
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kRegex
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:resultStr options:0 range:NSMakeRange(0, [resultStr length])];
    
    NSString *jsonStr = @"[";
    
    for (NSTextCheckingResult *match in arrayOfAllMatches) {NSLog(@"match:%@", match);
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
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingAllowFragments error:&error];
    
    //    [baiduYunViewController reloadTableViewDataSourceWithArray:jsonObj];
    return jsonObj;
}

- (NSArray *)searchOnWeipan:(NSString *) searchText:(int) page {
    NSArray *jsonObj;
    NSString *resultStr = [[[SearchUtil alloc] init] searchWeipan:searchText : page];
    
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
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingAllowFragments error:&error];
    
    return jsonObj;
}

- (NSArray *) searchOnHuaweiWangpan:(NSString *) searchText: (int) page {
    NSArray *jsonObj;
    NSString *resultStr = [[[SearchUtil alloc] init] searchHuaweiWangpan:searchText : page];
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kRegex
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
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingAllowFragments error:&error];
    
    return jsonObj;
}

@end