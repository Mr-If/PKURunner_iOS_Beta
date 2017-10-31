//
//  UIImage+CanvasImage.m
//  PKU
//
//  Created by ironfive on 16/8/11.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "UIImage+CanvasImage.h"

@implementation UIImage (CanvasImage)

+(UIImage *)createColorWithImage:(UIColor *)color withRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  pressedColorImg;
}

@end
