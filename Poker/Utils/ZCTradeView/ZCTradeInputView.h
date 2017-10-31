//
//  ZCTradeInputView.h
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//  交易输入视图

#import <Foundation/Foundation.h>

static NSString *ZCTradeInputViewCancleButtonClick = @"ZCTradeInputViewCancleButtonClick";
static NSString *ZCTradeInputViewOkButtonClick = @"ZCTradeInputViewOkButtonClick";
static NSString *ZCTradeInputViewPwdKey = @"ZCTradeInputViewPwdKey";

static NSString *ZCTradeKeyboardDeleteButtonClick = @"ZCTradeKeyboardDeleteButtonClick";
static NSString *ZCTradeKeyboardOkButtonClick = @"ZCTradeKeyboardOkButtonClick";
static NSString *ZCTradeKeyboardNumberButtonClick = @"ZCTradeKeyboardNumberButtonClick";
static NSString *ZCTradeKeyboardNumberKey = @"ZCTradeKeyboardNumberKey";

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@class ZCTradeInputView;
@protocol ZCTradeInputViewDelegate <NSObject>

@optional
/** 确定按钮点击 */
- (void)tradeInputView:(ZCTradeInputView *)tradeInputView okBtnClick:(UIButton *)okBtn;
/** 取消按钮点击 */
- (void)tradeInputView:(ZCTradeInputView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtn;
@end

@interface ZCTradeInputView : UIView
@property (nonatomic, weak) id<ZCTradeInputViewDelegate> delegate;
@end
