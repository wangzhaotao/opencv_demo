//
//  GaussFilterTool.h
//  OpenCVFaceDetectDemo
//
//  Created by ocean on 2018/11/23.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GaussFilterTool : NSObject

-(void)gaussFilteImage:(UIImage*)image completion:(void(^)(UIImage *saltNoiseImg, UIImage *cusGaussFilteImg, UIImage *sysGaussFilteImg))completion;

@end

