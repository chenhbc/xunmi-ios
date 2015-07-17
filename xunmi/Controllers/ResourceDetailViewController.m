//
//  ResourceDetailViewController.m
//  xunmi
//
//  Created by LarryChen on 15/7/16.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "ResourceDetailViewController.h"

@interface ResourceDetailViewController ()

@end

@implementation ResourceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.name;
    
    [self.webView setDelegate:self];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // yes:根据webview自适应，NO：根据内容自适应
//    [self.webView setScalesPageToFit:NO];
//    self.webView.scalesPageToFit = NO;
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    CGFloat webViewHeight=[webView.scrollView contentSize].height;
//    CGRect newFrame = webView.frame;
//    newFrame.size.height = webViewHeight;
//    webView.frame = newFrame;
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    //修改服务器页面的meta的值
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
//    [webView stringByEvaluatingJavaScriptFromString:meta];
    
    
    // 利用webview中的scrollview的zoom特性，这个方法会让网页内容变小
    CGSize contentSize = self.webView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    self.webView.scrollView.minimumZoomScale = rw;
    self.webView.scrollView.maximumZoomScale = rw;
    self.webView.scrollView.zoomScale = rw;
    
//    NSString *javascript = [NSString stringWithFormat:@"var viewPortTag=document.createElement('meta');  \
//                  viewPortTag.id='viewport';  \
//                  viewPortTag.name = 'viewport';  \
//                  viewPortTag.content = 'width=%d; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;';  \
//                  document.getElementsByTagName('head')[0].appendChild(viewPortTag);" , (int)self.webView.bounds.size.width];
//    
//    [self.webView stringByEvaluatingJavaScriptFromString:javascript];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
