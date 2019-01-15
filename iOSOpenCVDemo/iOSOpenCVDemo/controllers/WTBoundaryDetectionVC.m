//
//  WTBoundaryDetectionVC.m
//  iOSOpenCVDemo
//
//  Created by ocean on 2019/1/10.
//  Copyright © 2019年 wztMac. All rights reserved.
//

#import "WTBoundaryDetectionVC.h"
#import "Masonry.h"
#import "WTBoundaryDetectionTool.h"

@interface WTBoundaryDetectionVC ()
@property (nonatomic, strong) UIImage *originImage;

@property (strong, nonatomic) UIImageView *originImgView;
@property (strong, nonatomic) UIImageView *processedImgView;
- (IBAction)filteBtnAction:(UIButton *)sender;

@end

@implementation WTBoundaryDetectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self initUI];
    _originImage = [UIImage imageNamed:@"beautiful2"];
    [self resetImageView:_originImgView image:_originImage];
}

- (void)filteBtnAction:(UIButton *)sender {
    
    UIImage *dstImage = [[[WTBoundaryDetectionTool alloc]init]boundaryDetectionWithImage:_originImage];
    [self resetImageView:_processedImgView image:dstImage];
}

-(void)resetImageView:(UIImageView *)imageView image:(UIImage*)image {

    imageView.image = image;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize size = image.size;
    
    CGFloat maxWidth = screenSize.width-50;
    CGFloat maxHeight = screenSize.width-150;
    
    CGFloat newWidth = maxWidth;
    CGFloat newHeight = newWidth * size.height/size.width;
    if (newHeight>maxHeight) {
        newHeight = maxHeight;
        newWidth = newHeight * size.width/size.height;
    }
    
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(newWidth));
        make.height.equalTo(@(newHeight));
        //make.center.equalTo(@0);
    }];
}

-(void)initUI {
    
    UIImageView *originImgView = [[UIImageView alloc]init];
    [self.view addSubview:originImgView];
    _originImgView = originImgView;
    
    UIImageView *dstImgView = [[UIImageView alloc]init];
    [self.view addSubview:dstImgView];
    _processedImgView = dstImgView;
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"双边滤波" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(filteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //
    [_originImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@80);
        make.centerX.equalTo(@0);
    }];
    [_processedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(originImgView.mas_bottom).offset(10);
        make.centerX.equalTo(@0);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-10));
        make.centerX.equalTo(@0);
    }];
}



@end
