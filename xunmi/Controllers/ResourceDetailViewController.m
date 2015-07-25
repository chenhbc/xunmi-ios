//
//  ResourceDetailViewController.m
//  xunmi
//
//  Created by LarryChen on 15/7/16.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "ResourceDetailViewController.h"
#import "GSIndeterminateProgressView.h"

@interface ResourceDetailViewController () {
    GSIndeterminateProgressView * progressView;
}

@end

@implementation ResourceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.name;
    
    [self.webView setDelegate:self];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self initProgress];
    
    [progressView startAnimating];
    
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"IconShare.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareTo)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 去掉网页底部的黑色背景
    [self.webView setOpaque:NO];
    [self.webView setBackgroundColor:[UIColor clearColor]];

    [self.webView loadRequest:request];
}

- (void)shareTo {
    NSString *textToShare = self.name;
    NSURL *urlToShare = [NSURL URLWithString:self.url];
    NSArray *activityItems = @[textToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 利用webview中的scrollview的zoom特性，这个方法会让网页内容变小
    CGSize contentSize = self.webView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    self.webView.scrollView.minimumZoomScale = rw;
    self.webView.scrollView.maximumZoomScale = rw;
    self.webView.scrollView.zoomScale = rw;
    
    [progressView stopAnimating];
}

- (void)initProgress {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    progressView = [[GSIndeterminateProgressView alloc] initWithFrame:CGRectMake(0, navigationBar.frame.size.height, navigationBar.frame.size.width, 2)];
    progressView.progressTintColor = navigationBar.barTintColor;
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [navigationBar addSubview:progressView];
}

@end
