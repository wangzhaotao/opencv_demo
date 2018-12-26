//
//  FaceDistinguishTest.hpp
//  OpenCVMacDemo
//
//  Created by wztMac on 2018/11/1.
//  Copyright © 2018年 wztMac. All rights reserved.
//

#ifndef FaceDistinguishTest_hpp
#define FaceDistinguishTest_hpp

#include <stdio.h>
#include <iostream>
#include <cstring>

using namespace std;

class ImageDic {
    
public:
    string path;
    string name;
    char astring[100];
    
    ImageDic(){
//        cout << "默认ImageDic构造函数" << endl;
    }
    ImageDic(char bstring[]) {
        strcpy(astring, bstring);
    }
    ImageDic(string path1, string name1) {
        path = path1;
        name = name1;
    }
    
    ~ImageDic(){
//        cout << "进行ImageDic的析构"<<endl;
    }
};

void faceDistinguish(ImageDic* imagesArray, ImageDic person);

void faceDistinguish();

#endif /* FaceDistinguishTest_hpp */
