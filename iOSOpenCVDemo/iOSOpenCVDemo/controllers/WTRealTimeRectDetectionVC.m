//
//  WTRealTimeRectDetectionVC.m
//  iOSOpenCVDemo
//
//  Created by ocean on 2018/12/17.
//  Copyright © 2018年 wztMac. All rights reserved.
//

#import "WTRealTimeRectDetectionVC.h"
#import "WTRealTimeRectDetetionTool.h"

@interface WTRealTimeRectDetectionVC ()
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *originImage2;

@property (weak, nonatomic) IBOutlet UIImageView *originImgView;
@property (weak, nonatomic) IBOutlet UIImageView *realDetectImgView;
@property (weak, nonatomic) IBOutlet UIImageView *resImgView;

@property (weak, nonatomic) IBOutlet UIImageView *originImgView2;
@property (weak, nonatomic) IBOutlet UIImageView *realDetectImgView2;
@property (weak, nonatomic) IBOutlet UIImageView *resImgView2;


- (IBAction)realDetecBtnAction:(UIButton *)sender;
- (IBAction)rectDetectionBtnAction:(UIButton *)sender;

@end

@implementation WTRealTimeRectDetectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    _originImage = [UIImage imageNamed:@"sfz1"];
    _originImgView.image = _originImage;
    _originImage2 = [UIImage imageNamed:@"sfz2"];
    _originImgView2.image = _originImage2;
}



- (IBAction)realDetecBtnAction:(UIButton *)sender {
    
    _realDetectImgView.image = [WTRealTimeRectDetetionTool bridge_realTimeRectDetection:_originImage];
    
    _realDetectImgView2.image = [WTRealTimeRectDetetionTool bridge_realTimeRectDetection:_originImage2];
}

- (IBAction)rectDetectionBtnAction:(UIButton *)sender {
    
    _resImgView.image = [WTRealTimeRectDetetionTool bridge_getRectDetectImage:_originImage];
    
    _resImgView2.image = [WTRealTimeRectDetetionTool bridge_getRectDetectImage:_originImage2];
    
    //_resImgView.image = [WTRealTimeRectDetetionTool zhizhen_drawRectInImage:_originImage];
}


@end
