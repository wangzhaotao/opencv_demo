//
//  WTHoughLinesVC.m
//  OpenCVFaceDetectDemo
//
//  Created by ocean on 2018/11/23.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import "WTHoughLinesVC.h"
#import "HoughLinesTool.h"

@interface WTHoughLinesVC ()
@property (nonatomic, strong) UIImage *originImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
- (IBAction)houghBtnAction:(UIButton *)sender;

@end

@implementation WTHoughLinesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    _originImage = [UIImage imageNamed:@"lineimg.png"];
    _imgView.image = _originImage;
}


- (IBAction)houghBtnAction:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    [[HoughLinesTool new] houghProcessImage:_originImage completion:^(UIImage *cannyColorImage, UIImage *houghImage) {
        
        weakSelf.imgView2.image = cannyColorImage; //边缘检测Canny 灰度化
        weakSelf.imgView3.image = houghImage;
    }];
}


@end
