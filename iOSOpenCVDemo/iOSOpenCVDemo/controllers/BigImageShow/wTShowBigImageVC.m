//
//  wTShowBigImageVC.m
//  iOSOpenCVDemo
//
//  Created by ocean on 2019/1/4.
//  Copyright © 2019年 wztMac. All rights reserved.
//

#import "wTShowBigImageVC.h"
#import "Masonry.h"

@interface wTShowBigImageVC ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIImage *image;
@property (strong, nonatomic) UIImageView *imgView;
- (void)closeBtnAction:(UIButton *)sender;

@end

@implementation wTShowBigImageVC

+(void)showBigImage:(UIImage*)image target:(UIViewController*)target {
    
    wTShowBigImageVC *vc = [[wTShowBigImageVC alloc]init];
    vc.image = image;
    
    vc.modalPresentationStyle=UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [target presentViewController:vc animated:YES completion:nil];
}
- (IBAction)closeBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(instancetype)init {
    if (self=[super init]) {
        [self initUI];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
}
-(void)initUI {
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.8;
    [self.view addSubview:backView];
    _backView = backView;
    
    UIImageView *imgView = [[UIImageView alloc]init];
    [self.view addSubview:imgView];
    _imgView = imgView;
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"  关  闭  " forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _closeBtn = button;
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(@0);
    }];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.bottom.equalTo(@(-20));
        make.centerX.equalTo(@0);
    }];
}

-(void)setImage:(UIImage *)image {
    _image = image;
    self.imgView.image = image;
    
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
    
    [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(newWidth));
        make.height.equalTo(@(newHeight));
        make.center.equalTo(@0);
    }];
}



@end
