//
//  ImageProcessUtils.h
//  OpenCVDemo
//
//  Created by ocean on 2018/10/29.
//  Copyright © 2018年 ocean. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface ImageProcessUtils : NSObject

//图片马赛克处理
+(UIImage*)mosaicProcessImage:(UIImage*)image level:(int)level;

@end
