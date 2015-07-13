//
//  MainViewController.m
//  xunmi
//
//  Created by LarryChen on 15/5/31.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "MainViewController.h"
#import "SearchResultViewController.h"

@interface MainViewController ()

@property UITextField *txtSearch;

@property UIImageView *btnSearch;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float frameHeight = self.view.frame.size.height;
    float frameWidth = self.view.frame.size.width;
    
    // search logo[1100 * 550]
    
    // logo view size
    float logoWidth = 200;
    float logoHeight = 100;
    
    // logo point
    float logoTop = frameHeight / 4;
    float logoLeft = (frameWidth - logoWidth) / 2;
    
    UIImage *pic = [ UIImage imageNamed:@"searchlogo.png"];
    
    UIImageView *imageView   = [[UIImageView alloc] initWithFrame:CGRectMake(logoLeft, logoTop, logoWidth, logoHeight)];
    [imageView setImage:pic];
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds  = YES;

    // search text
    
    // search text view size
    float searchTextWidth = frameWidth - 30;
    float searchTextHeight = 40;
    
    // search text point
    float searchTextTop = logoTop + logoHeight;
    float searchTextLeft = (frameWidth - searchTextWidth) / 2;

    _txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(searchTextLeft, searchTextTop, searchTextWidth, searchTextHeight)];
    _txtSearch.borderStyle = UITextBorderStyleRoundedRect;
    _txtSearch.backgroundColor = [UIColor whiteColor];
    _txtSearch.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //再次编辑就清空
    _txtSearch.clearsOnBeginEditing = YES;
    _txtSearch.placeholder = @"搜索网盘资源";
    _txtSearch.returnKeyType = UIReturnKeySearch;
    
    // image search button
    _btnSearch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_b.png"]];
    _btnSearch.contentMode =  UIViewContentModeRight;
    [_btnSearch setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    CGSize size = CGSizeMake(30, 30);
    
    _btnSearch.image = [self rescaleImageToSize:size];
    
    // 一定要先将userInteractionEnabled置为YES，这样才能响应单击事件
    _btnSearch.userInteractionEnabled = YES; // 设置图片可以交互
    
    // ImageView click event
    UITapGestureRecognizer *searchGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSearch)];
    [_btnSearch addGestureRecognizer:searchGesture];
    searchGesture = nil;
    
    _txtSearch.rightView = _btnSearch;
    _txtSearch.rightViewMode = UITextFieldViewModeAlways;
    
    // set delegate on textfield, Can respond the keyboard events
    _txtSearch.delegate = self;
    
    [self.view addSubview:imageView];
    [self.view addSubview:_txtSearch];
    
    
    // Detachment first responder
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(geture:)];
    [self.view addGestureRecognizer:gesture];
    gesture = nil;
}

// resize image
- (UIImage *)rescaleImageToSize:(CGSize)size {
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    [_btnSearch.image drawInRect:rect];  // scales image to rect
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// text change event
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}

// Press return key
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _txtSearch) {
        [textField resignFirstResponder];
    }
    
    [self toSearch];
    
    return NO;
}

// to search result page
-(void)toSearch {
    SearchResultViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultViewController"];
    
    controller.searchText = [_txtSearch text];
    
    [self.navigationController pushViewController:controller animated:YES];
}

// Detachment first responder method
-(void)geture:(UITapGestureRecognizer *)sender{
    for (id object in self.view.subviews) {
        if ([object isKindOfClass:[UITextField class]]) {
            [object resignFirstResponder];
        }
    }
}

@end
