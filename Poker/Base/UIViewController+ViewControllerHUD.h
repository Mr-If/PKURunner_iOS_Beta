//
//  UIViewController+ViewControllerHUD.h
//  PKU
//
//  Created by ironfive on 16/8/9.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ViewControllerHUD)

-(void)addTabbar:(NSString *)nomelName withSelectName:(NSString *)selectName withTitle:(NSString *)title;


-(void)showHUD:(NSString *)message;
-(void)showSuccessHUD:(NSString *)message;
-(void)showErrorHUD:(NSString *)message;
-(void)dissmissHUD;
-(void)showToast:(NSString *)message;


@end
