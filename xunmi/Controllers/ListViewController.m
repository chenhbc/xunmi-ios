//
//  ListViewController.m
//  xunmi
//
//  Created by LarryChen on 15/6/10.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "ListViewController.h"
#import "ListViewCell.h"
#import "MJRefresh.h"
#import "ResourceDetailViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

int CURRENT_PAGE = 0;

@synthesize imageArray;
@synthesize tableViewImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id) initWithBlock:(NSArray * (^) (int page)) refreshingBlock {
    self = [super init];
    if(self) {
        // 必须先做这一步，才有刷新操作
        [self addTableView];
        
//        [self.navigationController = [[UINavigationController alloc] initWithRootViewController:<#(UIViewController *)#>];
        
        // 下拉刷新，设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.tableViewImage.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.imageArray = [refreshingBlock(0) mutableCopy];
            
            [self reloadTableViewDataSource];
        }];
        
        // 上拉加载更多,设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.tableViewImage.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 每次加载更多之前页数+1
            CURRENT_PAGE ++;
            
            [self.imageArray addObjectsFromArray:refreshingBlock(CURRENT_PAGE)];
            
            [self reloadTableViewDataSource];
        }];
    }
    
    // 马上进入刷新状态
    [self.tableViewImage.header beginRefreshing];
    
    [self setExtraCellLineHidden:self.tableViewImage];
    
    return self;
}

- (void)addTableView {
    // 高度要加上导航栏的高度和Tabbar的高度，在SCNavTabBar中定义
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(-10, 0, self.view.frame.size.width, self.view.frame.size.height + 49 + 44) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableViewImage = tableView;
    
    [self.view addSubview:tableViewImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"listViewCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ListViewCell" bundle:nil] forCellReuseIdentifier:@"listViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"listViewCell"];
    }
    
//    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
//        cell.contentView.frame = cell.bounds;
//        cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
//    }
//    
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
//    [cell setNeedsLayout];
//    [cell layoutIfNeeded];
    
    // add data
    
    NSDictionary *detail = [self.imageArray objectAtIndex:indexPath.row];
    NSString *title = [self flattenHTML:[detail objectForKey:@"title"]];
    cell.titleLabel.text = title;
    cell.linkLabel.text = [detail objectForKey:@"url"];
    
    cell.imageView.image = [UIImage imageNamed:[self getImage:title]];
    
    return cell;
}

- (NSString *) getImage:(NSString *) title {
    // NSString *suffix = [title pathExtension];
    if ([self hasSuffix:title :@"xls"] || [self hasSuffix:title :@"xlsx"]) {
        return @"excel.png";
    } else if ([self hasSuffix:title :@"doc"] || [self hasSuffix:title :@"docx"]) {
        return @"word.png";
    } else if ([self hasSuffix:title :@"ppt"] || [self hasSuffix:title :@"pptx"]) {
        return @"ppt.png";
    } else if ([self hasSuffix:title :@"jpg"] || [self hasSuffix:title :@"jpeg"]
                || [self hasSuffix:title :@"gif"] || [self hasSuffix:title :@"png"]
                || [self hasSuffix:title :@"bmp"] || [self hasSuffix:title :@"ico"]) {
        return @"picture.png";
    } else if ([self hasSuffix:title :@"avi"] || [self hasSuffix:title :@"mp4"]
                || [self hasSuffix:title :@"rmvb"] || [self hasSuffix:title :@"wmv"]
                || [self hasSuffix:title :@"rm"] || [self hasSuffix:title :@"mkv"]) {
        return @"video.png";
    } else if ([self hasSuffix:title :@"mp3"] || [self hasSuffix:title :@"wma"]
                || [self hasSuffix:title :@"wav"] || [self hasSuffix:title :@"flac"]
                || [self hasSuffix:title :@"m4a"] || [self hasSuffix:title :@"ape"]) {
        return @"music.png";
    } else if ([self hasSuffix:title :@"pdf"]) {
        return @"pdf.png";
    } else if ([self hasSuffix:title :@"txt"] || [self hasSuffix:title :@"epub"]
                || [self hasSuffix:title :@"mobi"]) {
        return @"text.png";
    }
    return @"unknown.png";
}

- (BOOL) hasSuffix:(NSString *) str :(NSString *) suffix{
    return [str rangeOfString:suffix options:NSCaseInsensitiveSearch].location != NSNotFound;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ListViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// 允许长按菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    // 只显示复制按钮
    if (action == @selector(copy:)) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        NSDictionary *detail = [self.imageArray objectAtIndex:indexPath.row];
        NSString *url = [detail objectForKey:@"url"];
        
        [UIPasteboard generalPasteboard].string = [url stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *detail = [self.imageArray objectAtIndex:indexPath.row];
    
    // 由于当前ViewController和ResourceDetailController不在同一个storyboard中，所以不能用以下方式获取
    // 也不能用alloc init的方式
//    ResourceDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"resourceDetailViewController"];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    ResourceDetailViewController *resultController = [storyboard instantiateViewControllerWithIdentifier:@"resourceDetailViewController"];
    resultController.name = [self flattenHTML:[detail objectForKey:@"title"]];
    resultController.url = [detail objectForKey:@"url"];
    
    [self.navigationController pushViewController:resultController animated:YES];
    
    [self.tableViewImage deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -refresh-
- (void) reloadTableViewDataSource {
    // 刷新表格
    [self.tableViewImage reloadData];
    
    // 拿到当前的下拉刷新控件，结束刷新状态
    [self.tableViewImage.header endRefreshing];
    [self.tableViewImage.footer endRefreshing];
    
}

- (void) reloadTableViewDataSourceWithArray:(NSArray *) array  {
    self.imageArray = [array mutableCopy];

    [self.tableViewImage reloadData];
}

//隐藏多余的分割线
-(void)setExtraCellLineHidden:(UITableView*)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

// 去掉html元素
- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    return html;
}

@end
