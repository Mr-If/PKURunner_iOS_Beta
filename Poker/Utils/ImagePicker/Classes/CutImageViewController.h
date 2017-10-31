//
//  CutImageViewController.h
//  WQHPrintJob
//
//  Created by job on 16/6/14.
//  Copyright © 2016年 job. All rights reserved.
//


#import <UIKit/UIKit.h>
@class CutImageViewController;
@protocol CutChooseHeaderDelegate <NSObject>

- (void)commpleteChooseCutImage:(UIImage *)headerImage andCutViewCon:(CutImageViewController *)cutCon;

@end


@interface CutImageViewController : UIViewController
@property (strong, nonatomic) UIImage *chooseImage;
@property (strong, nonatomic) id<CutChooseHeaderDelegate>delegate;
@end
