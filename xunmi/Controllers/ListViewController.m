//
//  ListViewController.m
//  xunmi
//
//  Created by LarryChen on 15/6/10.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import "ListViewController.h"
#import "ListViewCell.h"

@interface ListViewController ()

@end

@implementation ListViewController

@synthesize imageArray;
@synthesize tableViewImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_refreshHeaderView == nil) {
        float height = self.tableViewImage.bounds.size.height;
//        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - height, self.tableViewImage.bounds.size.width, height)];
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    [self addTableView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self setExtraCellLineHidden:self.tableView];
}

- (id) initWithNSArray:(NSArray *) array {
    self = [super init];
    
    if(self) {
        self.imageArray = array;
        [self addTableView];
    }
    return self;
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
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
    
    // add data
    
    NSDictionary *detail = [self.imageArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [self flattenHTML:[detail objectForKey:@"title"]];
    cell.linkLabel.text = [detail objectForKey:@"url"];
    
    cell.imageView.image = [UIImage imageNamed:@"unknown.png"];
    [cell.imageView setFrame:CGRectMake(0, 0, 50, 50)];
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ListViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -refresh-
- (void) reloadTableViewDataSource {
    [self.tableViewImage reloadData];
    _reloading = YES;
    
//    if ([_delegate respondsToSelector:@selector(refreshData: FromView:)]) {
//        [_delegate refreshData:^{
//            [self doneLoadingTableViewData];
//        } FromView:self];
//    }else{
//        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
//    }
}

- (void) reloadTableViewDataSourceWithArray:(NSArray *) array  {
    self.imageArray = array;
    _reloading = YES;
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableViewImage reloadData];
//    });
    NSLog(@"%lu", (unsigned long)[self.imageArray count]);
}

- (void) doneLoadingTableViewData {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods
- (void) egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    NSLog(@"reload data....");
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL) egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    return _reloading; // should return if data source model is reloading
}

- (NSDate *) egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return YES;
}

//隐藏多余的分割线
-(void)setExtraCellLineHidden:(UITableView*)tableView
{
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
