//
//  UITableView+Tab.m
//  测试MJ刷新
//
//  Created by 123 on 15/12/30.
//  Copyright (c) 2015年 123. All rights reserved.
//

#import "UIScrollView+Tab.h"

@implementation UIScrollView (Tab)

-(void)addHeaderWithCallback:(void (^)())callback
{
    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        callback();
    }];
    
//        MJRefreshGifHeader *header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
//            callback();
//        }];
//        NSMutableArray *refreshingImages = [NSMutableArray array];
//        for (NSUInteger i = 1; i<=12; i++) {
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd.png", i]];
//            [refreshingImages addObject:image];
//        }
//        [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
//    
//    [header setImages:refreshingImages forState:MJRefreshStateIdle];
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [header setImages:refreshingImages forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
//    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        callback();
    
//    }];
    
        self.header=header;
    
}
-(void)headerBeginRefreshing
{
    [self.header beginRefreshing];
}

-(void)headerEndRefreshing
{
    [self.header endRefreshing];
}

- (void)footerBeginRefreshing
{
    [self.footer beginRefreshing];
}

-(void)footerEndRefreshing
{
    [self.footer endRefreshing];
}

- (void)setFooterHidden:(BOOL)hidden
{
//    if (hidden) {
//         [self.footer endRefreshing];
//    }else{
//        [self.footer resetNoMoreData];
//    }
    [self.footer setHidden:hidden];
//    self.footer.hidden=hidden;
    
    if (hidden) {
        [self.footer removeFromSuperview];
    }
//    [self.footer removeFromSuperview];
}

-(void)addFooterWithCallback:(void (^)())callback
{
    MJRefreshAutoNormalFooter *fotter=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        callback();
    }];
    self.footer=fotter;
    [self.footer setHidden:YES];
}

@end
