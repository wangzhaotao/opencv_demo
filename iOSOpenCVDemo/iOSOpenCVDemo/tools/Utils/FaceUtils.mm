//
//  FaceUtils.m
//  OpenCVDemo
//
//  Created by ocean on 2018/10/30.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import <opencv2/stitching/detail/blenders.hpp>
#import <opencv2/stitching/detail/exposure_compensate.hpp>
#import "FaceUtils.h"
#import <opencv2/opencv.hpp>
#import <opencv2/calib3d.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/core/types.hpp>
#import <opencv2/imgproc/types_c.h>

using namespace std;
using namespace cv;

@implementation FaceUtils

//检测图片中的人脸
+(UIImage*)faceDetectWithImage:(UIImage*)inputImage {
    
    Mat image, image_gray;      //定义两个Mat变量，用于存储每一帧的图像
    UIImageToMat(inputImage, image);
    
    
    cvtColor(image, image_gray, CV_BGR2GRAY);//转为灰度图
    equalizeHist(image_gray, image_gray);//直方图均衡化，增加对比度方便处理
    
    CascadeClassifier eye_Classifier;  //载入分类器
    CascadeClassifier face_cascade;    //载入分类器
    
    //加载分类训练器，OpenCv官方文档提供的xml文档，可以直接调用
    //xml文档路径  opencv\sources\data\haarcascades
    NSString *eyeName = @"haarcascade_eye";
    NSString *eyePath = [[NSBundle mainBundle]pathForResource:eyeName ofType:@"xml"];
    String path1 = eyePath.UTF8String;
    if (!eye_Classifier.load(path1))  //需要将xml文档放在自己指定的路径下
    {
        cout << "Load haarcascade_eye.xml failed!" << endl;
        return 0;
    }
    
    NSString *frontFaceName = @"haarcascade_frontalface_alt";
    NSString *frontFacePath = [[NSBundle mainBundle]pathForResource:frontFaceName ofType:@"xml"];
    String path2 = frontFacePath.UTF8String;
    if (!face_cascade.load(path2))
    {
        cout << "Load haarcascade_frontalface_alt failed!" << endl;
        return 0;
    }
    
    //vector 是个类模板 需要提供明确的模板实参 vector<Rect>则是个确定的类 模板的实例化
    vector<Rect2i> eyeRect;
    vector<Rect2i> faceRect;
    
    //检测关于眼睛部位位置
    eye_Classifier.detectMultiScale(image_gray, eyeRect, 1.1, 2, 0 | CV_HAAR_SCALE_IMAGE, Size2i(30, 30));
    for (size_t eyeIdx = 0; eyeIdx < eyeRect.size(); eyeIdx++)
    {
        rectangle(image, eyeRect[eyeIdx], Scalar(0, 0, 255), 5);   //用矩形画出检测到的位置
    }
    
    //检测关于脸部位置
    face_cascade.detectMultiScale(image_gray, faceRect, 1.1, 2, 0 | CV_HAAR_SCALE_IMAGE, Size2i(30, 30));
    for (size_t i = 0; i < faceRect.size(); i++)
    {
        rectangle(image, faceRect[i], Scalar(0, 0, 255), 5);      //用矩形画出检测到的位置
    }
    
    UIImage *result = MatToUIImage(image);
    return result;
}
@end
