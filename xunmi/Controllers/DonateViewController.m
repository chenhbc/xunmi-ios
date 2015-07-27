//
//  DonateViewController.m
//  xunmi
//
//  Created by LarryChen on 15/7/18.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "DonateViewController.h"

@interface DonateViewController ()

@end

@implementation DonateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self longPanGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//长按效果
- (void)longPanGesture {
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPanGestureProcess:)];
    longGesture.numberOfTapsRequired = 0;
    longGesture.numberOfTouchesRequired = 1;
    longGesture.minimumPressDuration = 1;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:longGesture];
}

- (void)longPanGestureProcess:(UILongPressGestureRecognizer *)longGesture {
    if (longGesture.state == UIGestureRecognizerStateBegan) {NSLog(@"state");
        UIImageWriteToSavedPhotosAlbum([self.imageView image], nil, nil,nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存成功"
                                                        message:@"二维码已保存于图片库中" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
