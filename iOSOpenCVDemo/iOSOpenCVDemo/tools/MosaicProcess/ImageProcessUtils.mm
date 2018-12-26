//
//  ImageProcessUtils.m
//  OpenCVDemo
//
//  Created by ocean on 2018/10/29.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import <opencv2/stitching/detail/blenders.hpp>
#import <opencv2/stitching/detail/exposure_compensate.hpp>

#import "ImageProcessUtils.h"
#import <stdlib.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgproc.hpp>

using namespace cv;

@implementation ImageProcessUtils

//图片马赛克处理
+(UIImage*)mosaicProcessImage:(UIImage*)image level:(int)level {
    
    //UIImage 转 Mat矩阵
    Mat mat_img_src;
    UIImageToMat(image, mat_img_src);
    
    //RGBA to RGB
    Mat mat_img_rgb;
    cvtColor(mat_img_src, mat_img_rgb, CV_RGBA2RGB, 3);
    
    Mat mat_img_clone=mat_img_rgb.clone();
    
    int width = mat_img_rgb.cols;
    int height = mat_img_rgb.rows;
    
    for (int i=0; i<height-level; i+=level) {
        for (int j=0; j<width-level; j+=level) {
            
            Rect2i rect = Rect2i(j, i, level, level);
            Mat roi = mat_img_clone(rect);
            
            //随机偏移
            int xOffset = (rand()%(level-0))+0;
            int yOffset = (rand()%(level-0))+0;
            Scalar color = Scalar(mat_img_rgb.at<Vec3b>(i+xOffset,j+yOffset)[0],
                                  mat_img_rgb.at<Vec3b>(i+xOffset,j+yOffset)[1],
                                  mat_img_rgb.at<Vec3b>(i+xOffset,j+yOffset)[2]);
            Mat roiCopy = Mat(rect.size(), CV_8UC3, color);
            roiCopy.copyTo(roi);
        }
    }
    
    UIImage *result = MatToUIImage(mat_img_clone);
    return result;
}







@end
