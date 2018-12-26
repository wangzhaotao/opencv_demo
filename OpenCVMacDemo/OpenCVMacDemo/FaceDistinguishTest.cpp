//
//  FaceDistinguishTest.cpp
//  OpenCVMacDemo
//
//  Created by wztMac on 2018/11/1.
//  Copyright © 2018年 wztMac. All rights reserved.
//

#include "FaceDistinguishTest.hpp"
#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/face/facerec.hpp>
#include <opencv2/face.hpp>
//矩阵帮助类
#include <opencv2/highgui.hpp>
#include <opencv2//core//types_c.h>
#include <opencv2/core/core.hpp>

using namespace cv;
using namespace std;

void faceDistinguish(ImageDic* imagesArray, ImageDic person) {
    
    std::vector<int> labels;
    Mat *src = new Mat[4];
    for (int i=0; i<4; i++) {
        ImageDic img = imagesArray[i];
        Mat img_mat = imread(img.path, CV_LOAD_IMAGE_GRAYSCALE);
        
        //图像大小归一化
        cv::resize(img_mat,img_mat,Size2i(128,128));
        
        src[i]=img_mat;
        labels.push_back(i);
    }
    
    //预测样本
    Mat src_dst = imread(person.path, CV_LOAD_IMAGE_GRAYSCALE);
    //图像大小归一化
    cv::resize(src_dst,src_dst,Size2i(128,128));
    
    
    std::vector<Mat> images;
    //加入图像
    for (int i=0; i<4; i++) {
        Mat mat = src[i];
        images.push_back(mat);
    }
    
    Ptr<cv::face::FaceRecognizer> faceClass = cv::face::EigenFaceRecognizer::create();
    Ptr<cv::face::FisherFaceRecognizer> fisherClass = cv::face::FisherFaceRecognizer::create();
    Ptr<cv::face::LBPHFaceRecognizer> lpbhClass = cv::face::LBPHFaceRecognizer::create();
    //训练
    faceClass->train(images,labels);
    fisherClass->train(images,labels);
    lpbhClass->train(images,labels);
    //保存训练的分类器
    faceClass->save("faceClass.xml");
    fisherClass->save("fisherClass.xml");
    lpbhClass->save("lpbhClass.xml");
    
    //使用训练好的分类器进行预测。
    int faceResult = faceClass->predict(src_dst);
    ImageDic resultImg = imagesArray[faceResult];
    
    cout<<"待识别人为:"<<resultImg.name<<endl;
}

//人脸识别
void faceDistinguish() {
    
    /*******************************************************
     *假定 标签1代表张三 标签2代表李四 标签3代表 王五
     ******************************************************/
    //定义保存图片和标签的向量容器
    std::vector<Mat> images;
    std::vector<int> labels;
    //读取样本
    Mat src_1 = imread("/Users/wztMac/Desktop/faces/face0.png",CV_LOAD_IMAGE_GRAYSCALE);
    Mat src_2 = imread("/Users/wztMac/Desktop/faces/face1.png",CV_LOAD_IMAGE_GRAYSCALE);
    Mat src_3 = imread("/Users/wztMac/Desktop/faces/face5.png",CV_LOAD_IMAGE_GRAYSCALE);
    Mat src_4 = imread("/Users/wztMac/Desktop/faces/face2_me.png",CV_LOAD_IMAGE_GRAYSCALE);
    //预测样本
    Mat src_5 = imread("/Users/wztMac/Desktop/faces/face1_me.png",CV_LOAD_IMAGE_GRAYSCALE);
    //图像大小归一化
    cv::resize(src_1,src_1,Size2i(128,128));
    cv::resize(src_2,src_2,Size2i(128,128));
    cv::resize(src_3,src_3,Size2i(128,128));
    cv::resize(src_4,src_4,Size2i(128,128));
    cv::resize(src_5,src_5,Size2i(128,128));
    //加入图像
    images.push_back(src_1);
    images.push_back(src_2);
    images.push_back(src_3);
    images.push_back(src_4);
    //加入标签
    labels.push_back(1);
    labels.push_back(2);
    labels.push_back(3);
    labels.push_back(4);
    
    Ptr<cv::face::FaceRecognizer> faceClass = cv::face::EigenFaceRecognizer::create();
    Ptr<cv::face::FisherFaceRecognizer> fisherClass = cv::face::FisherFaceRecognizer::create();
    Ptr<cv::face::LBPHFaceRecognizer> lpbhClass = cv::face::LBPHFaceRecognizer::create();
    //训练
    faceClass->train(images,labels);
    fisherClass->train(images,labels);
    lpbhClass->train(images,labels);
    //保存训练的分类器
    faceClass->save("faceClass.xml");
    fisherClass->save("fisherClass.xml");
    lpbhClass->save("lpbhClass.xml");
    //加载分类器
    //faceClass->load("faceClass.xml");
    //fisherClass->load("fisherClass.xml");
    //lpbhClass->load("lpbhClass.xml");
    //使用训练好的分类器进行预测。
    int faceResult = faceClass->predict(src_5);
    switch (faceResult)
    {
        case 1:
            //张三
            break;
        case 2:
            //李四
            break;
        case 3:
            //王五
            break;
        default:
            //未知
            break;
    }
    //预测样本并获取标签和置信度
    int fisherResult = -1;
    double fisherConfidence = 0.0;
    fisherClass->predict(src_5,fisherResult,fisherConfidence);
    std::cout<<String("标签类别：")<<fisherResult<<String("置信度：")<<fisherConfidence<<std::endl;
    int lpbhResult = lpbhClass->predict(src_5);
    std::cout<<String("标签类别：")<<lpbhResult;
    return;
}
