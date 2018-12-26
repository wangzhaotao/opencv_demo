//
//  HoughLinesTool.h
//  OpenCVFaceDetectDemo
//
//  Created by ocean on 2018/11/23.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HoughLinesTool : NSObject

//图片马赛克处理
-(void)houghProcessImage:(UIImage*)image completion:(void(^)(UIImage *cannyColorImage, UIImage *houghImage))completion;

@end

