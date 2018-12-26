//
//  WTMosaicImageVC.m
//  OpenCVFaceDetectDemo
//
//  Created by ocean on 2018/11/23.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import "WTMosaicImageVC.h"
#import <Masonry/Masonry.h>
#import "ImageProcessUtils.h"

@interface WTMosaicImageVC ()
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation WTMosaicImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _originImage = [UIImage imageNamed:@"face1.png"];
    
    //
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    UIImageView *imgView = [[UIImageView alloc]init];
    [self.view addSubview:imgView];
    _imgView = imgView;
    _imgView.image = _originImage;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(80));
        make.leading.equalTo(@(10));
        make.width.lessThanOrEqualTo(@(width-20));
        make.height.lessThanOrEqualTo(@(height-150));
    }];
    
    UIButton *mosaicBtn = [[UIButton alloc]init];
    [mosaicBtn setTitle:@"马赛克处理" forState:UIControlStateNormal];
    [mosaicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mosaicBtn addTarget:self action:@selector(mosaicBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mosaicBtn];
    [mosaicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(10);
        make.centerX.equalTo(@0);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
}

static BOOL processed = YES;
-(void)mosaicBtnAction:(UIButton*)sender {
    
    UIImage *image = processed?[ImageProcessUtils mosaicProcessImage:_originImage level:10]:_originImage;
    _imgView.image = image;
    
    processed = !processed;
}

@end
