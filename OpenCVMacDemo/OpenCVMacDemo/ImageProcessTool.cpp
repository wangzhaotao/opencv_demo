//
//  ImageProcessTool.cpp
//  OpenCVMacDemo
//
//  Created by ocean on 2018/11/22.
//  Copyright © 2018年 wztMac. All rights reserved.
//

#include "ImageProcessTool.hpp"
#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

/*
 
 膨胀就是对图像高亮部分进行“领域扩张”，效果图拥有比原图更大的高亮区域；腐蚀是原图中的高亮区域被蚕食，效果图拥有比原图更小的高亮区域。
 
 1.膨胀
 膨胀就是求局部最大值的操作，从图像直观看来，就是将图像光亮部分放大，黑暗部分缩小。
 
 2.腐蚀
 可以看到，图像原来黑暗的部分被放大了，明亮的部分被缩小了。
 
 3.开运算：先腐蚀再膨胀，用来消除小物体
 
 4.闭运算：先膨胀再腐蚀，用于排除小型黑洞
 
 5.形态学梯度：就是膨胀图与俯视图之差，用于保留物体的边缘轮廓。
 
 6.顶帽：原图像与开运算图之差，用于分离比邻近点亮一些的斑块。
 
 7.黑帽：闭运算与原图像之差，用于分离比邻近点暗一些的斑块。
 
 */


//膨胀
void dilateProcess() {
    
    Mat img = imread("/Users/ocean/Documents/iOS_Demo/OpenCVMacDemo_S/OpenCVMacDemo/faces/face1.png");
    namedWindow("原始图", WINDOW_NORMAL);
    imshow("原始图", img);
    Mat out;
    //获取自定义核
    Mat element = getStructuringElement(MORPH_RECT, Size(15, 15)); //第一个参数MORPH_RECT表示矩形的卷积核，当然还可以选择椭圆形的、交叉型的
    //膨胀操作
    dilate(img, out, element);
    namedWindow("膨胀操作", WINDOW_NORMAL);
    imshow("膨胀操作", out);
    waitKey(0);
}

//腐蚀
void erodeProcess() {
    
    Mat img = imread("/Users/ocean/Documents/iOS_Demo/OpenCVMacDemo_S/OpenCVMacDemo/faces/face1.png");
    namedWindow("原始图", WINDOW_NORMAL);
    imshow("原始图", img);
    Mat out;
    //获取自定义核
    Mat element = getStructuringElement(MORPH_RECT, Size(15, 15)); //第一个参数MORPH_RECT表示矩形的卷积核，当然还可以选择椭圆形的、交叉型的
    //腐蚀操作
    erode(img, out, element);
    namedWindow("腐蚀操作", WINDOW_NORMAL);
    imshow("腐蚀操作", out);
    waitKey(0);
}

//开运算: 先膨胀，再腐蚀
void morphOpenProcess() {
    
    Mat img = imread("/Users/ocean/Documents/iOS_Demo/OpenCVMacDemo_S/OpenCVMacDemo/faces/face1.png");
    namedWindow("原始图", WINDOW_NORMAL);
    imshow("原始图", img);
    Mat out1, out;
    //获取自定义核
    Mat element = getStructuringElement(MORPH_RECT, Size(15, 15)); //第一个参数MORPH_RECT表示矩形的卷积核，当然还可以选择椭圆形的、交叉型的
    //先膨胀
    dilate(img, out1, element);
    //再腐蚀
    erode(out1, out, element);
    namedWindow("开运算操作", WINDOW_NORMAL);
    imshow("开运算操作", out);
    waitKey(0);
}

//闭运算: 先腐蚀，再膨胀
void morphCloseProcess() {
    
    Mat img = imread("/Users/ocean/Documents/iOS_Demo/OpenCVMacDemo_S/OpenCVMacDemo/faces/face1.png");
    namedWindow("原始图", WINDOW_NORMAL);
    imshow("原始图", img);
    Mat out1, out;
    //获取自定义核
    Mat element = getStructuringElement(MORPH_RECT, Size(15, 15)); //第一个参数MORPH_RECT表示矩形的卷积核，当然还可以选择椭圆形的、交叉型的
    //先腐蚀
    erode(img, out1, element);
    //再膨胀
    dilate(out1, out, element);
    namedWindow("闭运算运算操作", WINDOW_NORMAL);
    imshow("闭运算操作", out);
    waitKey(0);
}

//形态学梯度
void gradientProcess() {
    
    Mat img = imread("/Users/ocean/Documents/iOS_Demo/OpenCVMacDemo_S/OpenCVMacDemo/faces/face1.png");
    namedWindow("原始图", WINDOW_NORMAL);
    imshow("原始图", img);
    Mat out;
    //第一个参数MORPH_RECT表示矩形的卷积核，当然还可以选择椭圆形的、交叉型的
    Mat element = getStructuringElement(MORPH_RECT, Size(15, 15));
    //高级形态学处理，调用这个函数就可以了，具体要选择哪种操作，就修改第三个参数就可以了。这里演示的是形态学梯度处理
    morphologyEx(img, out, MORPH_GRADIENT, element);
    namedWindow("形态学处理", WINDOW_NORMAL);
    imshow("形态学处理操作", out);
    waitKey(0);
}

//顶帽
void tophatProcess() {
    
    Mat img = imread("/Users/ocean/Documents/iOS_Demo/OpenCVMacDemo_S/OpenCVMacDemo/faces/face1.png");
    namedWindow("原始图", WINDOW_NORMAL);
    imshow("原始图", img);
    Mat out;
    //第一个参数MORPH_RECT表示矩形的卷积核，当然还可以选择椭圆形的、交叉型的
    Mat element = getStructuringElement(MORPH_RECT, Size(15, 15));
    //高级形态学处理，调用这个函数就可以了，具体要选择哪种操作，就修改第三个参数就可以了。这里演示的是形态学梯度处理
    morphologyEx(img, out, MORPH_TOPHAT, element);
    namedWindow("顶帽处理", WINDOW_NORMAL);
    imshow("顶帽处理操作", out);
    waitKey(0);
}

//黑帽
void blackhatProcess() {
    
    Mat img = imread("/Users/ocean/Documents/iOS_Demo/OpenCVMacDemo_S/OpenCVMacDemo/faces/face1.png");
    namedWindow("原始图", WINDOW_NORMAL);
    imshow("原始图", img);
    Mat out;
    //第一个参数MORPH_RECT表示矩形的卷积核，当然还可以选择椭圆形的、交叉型的
    Mat element = getStructuringElement(MORPH_RECT, Size(15, 15));
    //高级形态学处理，调用这个函数就可以了，具体要选择哪种操作，就修改第三个参数就可以了。这里演示的是形态学梯度处理
    morphologyEx(img, out, MORPH_BLACKHAT, element);
    namedWindow("顶帽处理", WINDOW_NORMAL);
    imshow("顶帽处理操作", out);
    waitKey(0);
}
