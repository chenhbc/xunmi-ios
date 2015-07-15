//
//  ListViewController.h
//  xunmi
//
//  Created by LarryChen on 15/6/10.
//  Copyright (c) 2015年 xunmi. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class ListViewController;
//@protocol CustomTableViewDelegate <NSObject>
//@required;
//-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(ListViewController *)aView;
//-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(ListViewController *)aView;
//-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(ListViewController *)aView;
//-(void)refreshData:(void(^)())complete FromView:(ListViewController *)aView;
//@optional
////- (void)tableViewWillBeginDragging:(UIScrollView *)scrollView;
////- (void)tableViewDidScroll:(UIScrollView *)scrollView;
//////- (void)tableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
////- (BOOL)tableViewEgoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view FromView:(CustomTableView *)aView;
//@end
//
//@protocol CustomTableViewDataSource <NSObject>
//@required;
//-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(ListViewController *)aView;
//-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(ListViewController *)aView;
//
//@end

@interface ListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) NSMutableArray *imageArray;
@property (retain, nonatomic) UITableView *tableViewImage;

- (void)reloadTableViewDataSourceWithArray:(NSArray *) array;

- (id) initWithBlock:(NSArray * (^) (int page)) refreshingBlock;

@end
