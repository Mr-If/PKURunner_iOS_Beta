//
//  ZCTradeView.m
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

// 自定义Log
#ifdef DEBUG // 调试状态, 打开LOG功能
#define ZCLog(...) NSLog(__VA_ARGS__)
#define ZCFunc ZCLog(@"%s", __func__);
#else // 发布状态, 关闭LOG功能
#define ZCLog(...)
#define ZCFunc
#endif

// 设备判断
/**
 iOS设备宽高比
 4\4s {320, 480}  5s\5c {320, 568}  6 {375, 667}  6+ {414, 736}
 0.66             0.56              0.56          0.56
 */
#define ios7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define ios8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define ios6 ([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 7.0)
#define ios5 ([[UIDevice currentDevice].systemVersion doubleValue] < 6.0)
#define iphone5  ([UIScreen mainScreen].bounds.size.height == 568)
#define iphone6  ([UIScreen mainScreen].bounds.size.height == 667)
#define iphone6Plus  ([UIScreen mainScreen].bounds.size.height == 736)
#define iphone4  ([UIScreen mainScreen].bounds.size.height == 480)
#define ipadMini2  ([UIScreen mainScreen].bounds.size.height == 1024)

#import "ZCTradeView.h"
#import "ZCTradeInputView.h"
#import "UIAlertView+Quick.h"

@interface ZCTradeView () <UIAlertViewDelegate,ZCTradeInputViewDelegate,UITextFieldDelegate>

/** 输入框 */
@property (nonatomic, strong) ZCTradeInputView *inputView;
/** 蒙板 */
@property (nonatomic, strong) UIButton *cover;


/** 返回密码 */
@property (nonatomic, copy) NSString *passWord;

@end

@implementation ZCTradeView

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:ZCScreenBounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        /** 蒙板 */
        [self setupCover];
        /** 输入框 */
        [self setupInputView];
        /** 响应者 */
        [self setupResponsder];
    }
    return self;
}

/** 蒙板 */
- (void)setupCover
{
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cover];
    self.cover = cover;
    [self.cover setBackgroundColor:[UIColor blackColor]];
    self.cover.alpha = 0.4;
}

/** 输入框 */
- (void)setupInputView
{
    ZCTradeInputView *inputView = [[ZCTradeInputView alloc] init];
    inputView.delegate = self;
    [self addSubview:inputView];
    self.inputView = inputView;
    
    /** 注册取消按钮点击的通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancle) name:ZCTradeInputViewCancleButtonClick object:nil];
}

-(void)tradeInputView:(ZCTradeInputView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtn
{
    if ([_delegate respondsToSelector:@selector(tradeView:cancleBtnClick:)]) {
        [_delegate tradeView:self cancleBtnClick:cancleBtn];
    }
}

/** 响应者 */
- (void)setupResponsder
{
    UITextField *responsder = [[UITextField alloc] init];
    responsder.delegate = self;
    responsder.keyboardType = UIKeyboardTypeNumberPad;
    
    [self addSubview:responsder];
    self.responsder = responsder;
}

/**
 *  处理字符串 和 删除键
 */
static NSString *tempStr;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (!tempStr) {
        tempStr = string;
    }else{
        tempStr = [NSString stringWithFormat:@"%@%@",tempStr,string];
    }
    
    if ([string isEqualToString:@""]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeKeyboardDeleteButtonClick object:self];
 
        if (tempStr.length > 0) {   //  删除最后一个字符串
            NSString *cccc = [tempStr substringToIndex:[tempStr length] - 1];
            tempStr = cccc;
        }

//         NSLog(@" 点击了删除键 ---%@",tempStr);
    }else{
     
        if (tempStr.length == 6) {
//         移除自己
            [self hidenKeyboard:^(BOOL finished) {
                [self removeFromSuperview];
                [self hidenKeyboard:nil];
            }];

            // 通知代理\传递密码
            if ([self.delegate respondsToSelector:@selector(finish:)]) {
                [self.delegate finish:tempStr];
            }
//            // 回调block\传递密码
            if (self.finish) {
                self.finish(tempStr);
            }
            
            tempStr = nil;
        }
//        NSLog(@"tempStr %@",tempStr);

        NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
        userInfoDict[ZCTradeKeyboardNumberKey] = string;
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeKeyboardNumberButtonClick object:self userInfo:userInfoDict];
    }
    return YES;
}

/** 输入框的取消按钮点击 */
- (void)cancle
{
    [self hidenKeyboard:^(BOOL finished) {
        self.inputView.hidden = YES;
//        [self.countArray removeAllObjects];
        [self removeFromSuperview];
        [self hidenKeyboard:nil];
        [self.inputView setNeedsDisplay];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    ZCLog(@"dealloc---");
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /** 蒙板 */
    self.cover.frame = self.bounds;
}

/** 键盘弹出 */
- (void)showKeyboard
{
    CGFloat marginTop;
    if (iphone4) {
        marginTop = 42;
    } else if (iphone5) {
        marginTop = 100;
    } else if (iphone6) {
        marginTop = 120;
    } else {
        marginTop = 140;
    }
    
    [self.responsder becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputView.transform = CGAffineTransformMakeTranslation(0, marginTop - self.inputView.y);
    } completion:^(BOOL finished) {
    }];
}

/** 键盘退下 */
- (void)hidenKeyboard:(void (^)(BOOL finished))completion
{
    [self.responsder endEditing:NO];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputView.transform = CGAffineTransformIdentity;
    } completion:completion];
}

/** 快速创建 */
+ (instancetype)tradeView
{
    return [[self alloc] init];
}

// 关闭键盘
- (void)hidenKeyboard
{
    [self removeFromSuperview];
    [self hidenKeyboard:nil];
}

- (void)showInView:(UIView *)view
{
    // 浮现
    [view addSubview:self];

    /** 输入框起始frame */
    self.inputView.height = 180;
    self.inputView.y = (self.height - self.inputView.height) * 0.5;
    self.inputView.width = ZCScreenWidth * 0.94375;
    self.inputView.x = (ZCScreenWidth - self.inputView.width) * 0.5;
    
    /** 弹出键盘 */
    [self showKeyboard];
}

@end
