//
//  HoughLinesTool.m
//  OpenCVFaceDetectDemo
//
//  Created by ocean on 2018/11/23.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import <opencv2/stitching/detail/blenders.hpp>
#import <opencv2/stitching/detail/exposure_compensate.hpp>

#import "HoughLinesTool.h"
#import <stdlib.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgproc.hpp>

using namespace cv;
using namespace std;

@implementation HoughLinesTool

//图片马赛克处理
-(void)houghProcessImage:(UIImage*)image completion:(void(^)(UIImage *cannyColorImage, UIImage *houghImage))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //UIImage 转 Mat矩阵
        Mat srcImage;
        UIImageToMat(image, srcImage);
        
        Mat midImage, dstImage;
        //边缘检测
        Canny(srcImage, midImage, 50, 200, 3);
        //灰度化
        cvtColor(midImage, dstImage, CV_GRAY2BGR);
        // 定义矢量结构存放检测出来的直线
        vector<Vec2f> lines;
        //通过这个函数，我们就可以得到检测出来的直线集合了
        HoughLines(midImage, lines, 1, CV_PI / 180, 150, 0, 0);
        //这里注意第五个参数，表示阈值，阈值越大，表明检测的越精准，速度越快，得到的直线越少（得到的直线都是很有把握的直线）
        //这里得到的lines是包含rho和theta的，而不包括直线上的点，所以下面需要根据得到的rho和theta来建立一条直线
        
        //依次画出每条线段
        for (size_t i = 0; i < lines.size(); i++)
        {
            float rho = lines[i][0]; //就是圆的半径r
            float theta = lines[i][1]; //就是直线的角度
            cv::Point pt1, pt2;
            double a = cos(theta), b = sin(theta);
            double x0 = a*rho, y0 = b*rho;
            pt1.x = cvRound(x0 + 1000 * (-b));
            pt1.y = cvRound(y0 + 1000*(a));
            pt2.x = cvRound(x0 - 1000*(-b));
            pt2.y = cvRound(y0 - 1000 * (a));
            
            line(dstImage, pt1, pt2, Scalar(55, 100, 195), 1, LINE_AA); //Scalar函数用于调节线段颜色，就是你想检测到的线段显示的是什么颜色
            
            //imshow("边缘检测后的图", midImage);
            //imshow("最终效果图", dstImage);
        }
        
        UIImage *midImg = MatToUIImage(midImage);
        UIImage *resultImg = MatToUIImage(dstImage);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(midImg, resultImg);
            }
        });
    });
}

@end
