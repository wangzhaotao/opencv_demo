//
//  WTFaceRectDetectionVC.m
//  OpenCVFaceDetectDemo
//
//  Created by ocean on 2018/11/23.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import "WTFaceRectDetectionVC.h"
#import "FaceUtils.h"
#import "Masonry.h"
#import "TJRectDectectController.h"

@interface WTFaceRectDetectionVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)faceDetectBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *faceDetectBtn;


- (IBAction)rectDetectBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;

@end

@implementation WTFaceRectDetectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    UIImage *image = [UIImage imageNamed:@"face.png"];
    _imgView.image = image;
    
    _imgView1.image = [UIImage imageNamed:@"rect1.png"];
    
}

static BOOL detected = NO;
- (IBAction)faceDetectBtnAction:(UIButton *)sender {
    
    UIImage *image = [UIImage imageNamed:@"face.png"];
    if (!detected) {
        UIImage *result = [FaceUtils faceDetectWithImage:image];
        _imgView.image = result;
    }else {
        _imgView.image = image;
    }
}


- (IBAction)rectDetectBtnAction:(UIButton *)sender {
    
    TJRectDectectController *vc = [TJRectDectectController new];
    vc.originalImage = [UIImage imageNamed:@"rect1"];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
