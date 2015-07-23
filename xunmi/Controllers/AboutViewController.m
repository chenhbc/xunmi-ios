//
//  AboutViewController.m
//  xunmi
//
//  Created by LarryChen on 15/7/23.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置自动行数与字符换行
//    [_lblAbout setNumberOfLines:0];
//    _lblAbout.lineBreakMode = UILineBreakModeWordWrap;
//    //自动折行设置
//    _lblAbout.lineBreakMode = UILineBreakModeWordWrap;
//    
//    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
//    //设置一个行高上限
//    CGSize size = CGSizeMake(320,2000);
//    //计算实际frame大小，并将label的frame变成实际大小
//    CGSize labelsize = [[_lblAbout text] sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    
//    [_lblAbout setFrame:CGRectMake(0, 0, labelsize.width, labelsize.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
