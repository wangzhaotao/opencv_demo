//
//  WTDrawRectController.m
//  OpenCVFaceDetectDemo
//
//  Created by ocean on 2018/11/14.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import "WTDrawRectController.h"
#import "TJPointCircleView.h"
#import "Masonry.h"

@interface WTDrawRectController ()<TJPointCircleViewDelegate>

//四个点视图
@property (nonatomic, strong) TJPointCircleView *pointView;
@property (weak, nonatomic) IBOutlet UIButton *addRectBtn;
- (IBAction)addRectBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cornerLineChangeBtn;
- (IBAction)cornerLineChangeBtnAction:(UIButton *)sender;

@end

@implementation WTDrawRectController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    
    //画点视图
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.top.equalTo(@64);
        make.bottom.equalTo(@(-80));
    }];
    
    
    
}


- (IBAction)addRectBtnAction:(UIButton *)sender {
    
    //[self.pointView addARect];
    
    CGFloat imgW = 200, imgH = 150;
    CGFloat origin_x = (self.pointView.bounds.size.width-imgW)/2,
    origin_y = (self.pointView.bounds.size.height-imgH)/2;
    NSArray *points = @[
                        @[[NSNumber numberWithFloat:origin_x],[NSNumber numberWithFloat:origin_y]],
                        @[[NSNumber numberWithFloat:origin_x+imgW],[NSNumber numberWithFloat:origin_y]],
                        @[[NSNumber numberWithFloat:origin_x],[NSNumber numberWithFloat:origin_y+imgH]],
                        @[[NSNumber numberWithFloat:origin_x+imgW],[NSNumber numberWithFloat:origin_y+imgH]]
                        ];
    [self.pointView addARectWithPoints:points];
}

- (IBAction)cornerLineChangeBtnAction:(UIButton *)sender {
    
    self.pointView.isOnlyMoveLine = !self.pointView.isOnlyMoveLine;
}


-(TJPointCircleView*)pointView
{
    if (!_pointView) {
        _pointView = [TJPointCircleView new];
        _pointView.delegate = self;
        [self.view addSubview:_pointView];
    }
    return _pointView;
}

#pragma mark TJPointCircleViewDelegate
-(void)changeDetectRect {
    NSLog(@"TJPointCircleView changeDetectRect");
}

@end
