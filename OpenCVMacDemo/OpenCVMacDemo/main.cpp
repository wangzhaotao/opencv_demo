//
//  main.cpp
//  OpenCVMacDemo
//
//  Created by wztMac on 2018/10/31.
//  Copyright © 2018年 wztMac. All rights reserved.
//

#include <iostream>
//#include <string.h>
#include <cstring>
#include "CaptureCannyTest.hpp"
#include "FaceDistinguishTest.hpp"
#include "ImageProcessTool.hpp"

using namespace std;

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
    ImageDic* imagesArray = new ImageDic[4];

    ImageDic img1 = ImageDic("/Users/wztMac/Documents/OpenCV_study/opencv/OpenCVMacDemo/OpenCVMacDemo/faces/face0.png", "美女0");
    ImageDic img2 = ImageDic("/Users/wztMac/Documents/OpenCV_study/opencv/OpenCVMacDemo/OpenCVMacDemo/faces/face1.png", "美女1");
    ImageDic img3 = ImageDic("/Users/wztMac/Documents/OpenCV_study/opencv/OpenCVMacDemo/OpenCVMacDemo/faces/face5.png", "帅哥5");
    ImageDic img4 = ImageDic("/Users/wztMac/Documents/OpenCV_study/opencv/OpenCVMacDemo/OpenCVMacDemo/faces/face2_me.png", "我自己");
    imagesArray[0] = img1;
    imagesArray[1] = img2;
    imagesArray[2] = img3;
    imagesArray[3] = img4;

    cout << "姓名:"<<img1.name<<"\n";
    cout << "姓名:"<<img2.name<<"\n";
    cout << "姓名:"<<img3.name<<"\n";
    cout << "姓名:"<<img4.name<<"\n";

    ImageDic dst = ImageDic("/Users/wztMac/Documents/OpenCV_study/opencv/OpenCVMacDemo/OpenCVMacDemo/faces/face1_me.png", "黑人");
    faceDistinguish(imagesArray, dst);
//
//    
//    captureCannyTest();
//    faceDistinguish();
//    
//    膨胀
//    dilateProcess();
//    腐蚀
//    erodeProcess();
//    开运算
//    morphOpenProcess();
//    闭运算
//    morphCloseProcess();
//    形态学处理
//    gradientProcess();
//    顶帽
//    tophatProcess();
//    黑帽
//    blackhatProcess();
    
    return 0;
}
