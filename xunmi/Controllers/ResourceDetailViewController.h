//
//  ResourceDetailViewController.h
//  xunmi
//
//  Created by LarryChen on 15/7/16.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourceDetailViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (retain, nonatomic) NSString *url;

@property (retain, nonatomic) NSString *name;

@end
