//
//  UITableView+Tab.h
//  测试MJ刷新
//
//  Created by 123 on 15/12/30.
//  Copyright (c) 2015年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"

@interface UIScrollView (Tab)

-(void)addHeaderWithCallback:(void(^)())callback;

-(void)headerBeginRefreshing;

-(void)headerEndRefreshing;

- (void)footerBeginRefreshing;

-(void)footerEndRefreshing;

- (void)setFooterHidden:(BOOL)hidden;

- (void)addFooterWithCallback:(void (^)())callback;

@end
