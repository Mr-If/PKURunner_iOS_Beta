//
//  CutImageViewController.m
//  WQHPrintJob
//
//  Created by job on 16/6/14.
//  Copyright © 2016年 job. All rights reserved.
//

#import "CutImageViewController.h"
#define kScreenHight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define cutWidth kScreenWidth
#define cutEdg   (kScreenHight -64- cutWidth)/2

@interface CutImageViewController()<UIScrollViewDelegate>
@property(strong, nonatomic) UIScrollView *scroller;
@property(strong, nonatomic) UIImageView *imageView;

@end

@implementation CutImageViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.title = @"裁剪";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doSure)];
    self.view.backgroundColor = [UIColor blackColor];
    _imageView = [[UIImageView alloc]initWithImage:self.chooseImage];
    if (self.chooseImage.size.width > self.chooseImage.size.height) {
       _imageView.frame = CGRectMake(0, 0, kScreenWidth, self.chooseImage.size.height * kScreenWidth/self.chooseImage.size.width);
    }else {
        if (self.chooseImage.size.height>kScreenHight) {
            _imageView.frame = CGRectMake(0, 0, kScreenWidth, self.chooseImage.size.height * kScreenWidth/self.chooseImage.size.width);
        }
    }
    if (_imageView.bounds.size.width<kScreenWidth || _imageView.bounds.size.height < kScreenWidth) {
        CGRect frame = _imageView.frame;
        frame.size = CGSizeMake(kScreenWidth, kScreenWidth);
        _imageView.frame =frame;
         
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
    }
   
   
    
    
    _scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHight)];
    _scroller.contentSize =_imageView.bounds.size;
    _scroller.showsVerticalScrollIndicator = NO;
    _scroller.showsHorizontalScrollIndicator = NO;

//     _scroller.maximumZoomScale = 1;
//    _scroller.minimumZoomScale = 1.0;

    _scroller.layer.borderColor = [UIColor whiteColor].CGColor;
    _scroller.layer.borderWidth = 1;
    _scroller.frame = CGRectMake(1, cutEdg, kScreenWidth-2, kScreenWidth-1);
    _scroller.delegate = self;
 
    _scroller.layer.masksToBounds = NO;
//    imageView.center = CGPointMake(_scroller.width/2, _scroller.height/2);
    if (_imageView.bounds.size.width == _imageView.bounds.size.height) {
       _scroller.contentOffset = CGPointMake(0, 0);
    }else {
        _scroller.contentOffset = CGPointMake(0, (_imageView.bounds.size.height - cutWidth)/2);
    }
   
    [_scroller addSubview:_imageView];
    [self.view addSubview:_scroller];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, cutEdg)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:view];
    
    UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHight-64-cutEdg, kScreenWidth, cutEdg)];
    aview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:aview];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"x-----%f,y-----%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)tmpScrollView
//{
//    return _imageView;
//}


-(void)doSure {
    
    _scroller.autoresizesSubviews  = YES;
    UIImage *tempImage = [self shotCutViewByView: _imageView];
    NSLog(@"x----%f,y-----%f",_scroller.contentOffset.x,_scroller.contentOffset.y);
    
    UIImage *aImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(tempImage.CGImage, CGRectMake( _scroller.contentOffset.x,   _scroller.contentOffset.y, kScreenWidth, kScreenWidth))];
    if ([self.delegate respondsToSelector:@selector(commpleteChooseCutImage: andCutViewCon:)]) {
        [self.delegate commpleteChooseCutImage:aImage andCutViewCon:self];
        
    }
  
    
  
}



-(UIImage*)shotCutViewByView:(UIView *)aView {
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, YES, 1);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    //UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);
    
    UIGraphicsEndImageContext();
    return img;
}

@end
