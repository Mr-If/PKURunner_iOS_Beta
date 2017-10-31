//
//  ZCTradeInputView.m
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

#define ZCTradeInputViewNumCount 6

// 快速生成颜色
#define ZCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

typedef enum {
    ZCTradeInputViewButtonTypeWithCancle = 10000,
    ZCTradeInputViewButtonTypeWithOk = 20000,
}ZCTradeInputViewButtonType;

#import "ZCTradeInputView.h"
#import "NSString+Extension.h"

@interface ZCTradeInputView ()
/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *nums;
/** 确定按钮 */
@property (nonatomic, weak) UIButton *okBtn;
/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancleBtn;
@end

@implementation ZCTradeInputView

#pragma mark - LazyLoad

- (NSMutableArray *)nums
{
    if (_nums == nil) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        /** 注册keyboard通知 */
        [self setupKeyboardNote];
        /** 添加子控件 */
        [self setupSubViews];
    }
    return self;
}

/** 添加子控件 */
- (void)setupSubViews
{
    /** 取消按钮 */
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancleBtn];
//    [cancleBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/zhifu-close"] forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.cancleBtn = cancleBtn;
    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn.tag = ZCTradeInputViewButtonTypeWithCancle;
}

/** 注册keyboard通知 */
- (void)setupKeyboardNote
{
    // 删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete) name:ZCTradeKeyboardDeleteButtonClick object:nil];
    
    // 数字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:ZCTradeKeyboardNumberButtonClick object:nil];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.cancleBtn.width = 15;
    self.cancleBtn.height = 15;
    self.cancleBtn.x = 10;
    self.cancleBtn.y = 10;
}

#pragma mark - Private

// 删除
- (void)delete
{
    [self.nums removeLastObject];
    
//    NSLog(@"delete nums %@ ",self.nums);

    [self setNeedsDisplay];
}

// 数字
- (void)number:(NSNotification *)note
{;
    NSDictionary *userInfo = note.userInfo;
    NSString *numObj = userInfo[ZCTradeKeyboardNumberKey];
    if (numObj.length >= ZCTradeInputViewNumCount) return;
    [self.nums addObject:numObj];
//    NSLog(@"数字 nums %@ ",self.nums);
    [self setNeedsDisplay];

}

// 按钮点击
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == ZCTradeInputViewButtonTypeWithCancle) {  // 取消按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:cancleBtnClick:)]) {
            [self.delegate tradeInputView:self cancleBtnClick:btn];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeInputViewCancleButtonClick object:self];
    }
}

- (void)drawRect:(CGRect)rect
{
    // 画图
    UIImage *bg = [UIImage imageNamed:@"trade.bundle/pssword_bg"];
    UIImage *field = [UIImage imageNamed:@"trade.bundle/password_in"];
    
    [bg drawInRect:rect];
    
    CGFloat x = ZCScreenWidth * 0.096875 * 0.5;
    CGFloat y = ZCScreenWidth * 0.40625 * 0.5;
    CGFloat w = ZCScreenWidth * 0.846875;
    CGFloat h = ZCScreenWidth * 0.121875;
    [field drawInRect:CGRectMake(x, y, w, h)];
    
    // 画字
    NSString *title = @"请输入校园网关密码";
    
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:ZCScreenWidth * 0.053125] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat titleW = size.width;
    CGFloat titleH = size.height;
    CGFloat titleX = (self.width - titleW) * 0.5;
    CGFloat titleY = ZCScreenWidth * 0.03125;
    CGRect titleRect = CGRectMake(titleX, titleY, titleW, titleH);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:ZCScreenWidth * 0.053125];
    attr[NSForegroundColorAttributeName] = ZCColor(102, 102, 102);
    
    [title drawInRect:titleRect withAttributes:attr];
    
    // 画点
    UIImage *pointImage = [UIImage imageNamed:@"trade.bundle/yuan"];
    CGFloat pointW = ZCScreenWidth * 0.05;
    CGFloat pointH = pointW;
    CGFloat pointY = ZCScreenWidth * 0.24;
    CGFloat pointX;
    CGFloat margin = ZCScreenWidth * 0.0484375;
    CGFloat padding = ZCScreenWidth * 0.045578125;
    for (int i = 0; i < self.nums.count; i++) {
        pointX = margin + padding + i * (pointW + 2 * padding);
//        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
        NSString *num=[self.nums objectAtIndex:i];
        
        CGRect numrect=[num boundingRectWithSize:CGSizeMake(w/6, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]} context:nil];
        
        
        float numx=x+(w/6-numrect.size.width)/2.0+w/6*i;
        
        [num drawInRect:CGRectMake(numx, y+(h-numrect.size.height)/2.0, numrect.size.width, numrect.size.height) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
        
    }
    
    // ok按钮状态
    BOOL statue = NO;
    if (self.nums.count == ZCTradeInputViewNumCount) {
        statue = YES;
    } else {
        statue = NO;
    }
    self.okBtn.enabled = statue;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
