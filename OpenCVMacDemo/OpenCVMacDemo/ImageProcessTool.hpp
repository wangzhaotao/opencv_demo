//
//  ImageProcessTool.hpp
//  OpenCVMacDemo
//
//  Created by ocean on 2018/11/22.
//  Copyright © 2018年 wztMac. All rights reserved.
//

#ifndef ImageProcessTool_hpp
#define ImageProcessTool_hpp

#include <stdio.h>

//膨胀
void dilateProcess();
//腐蚀
void erodeProcess();
//开运算: 先膨胀，再腐蚀
void morphOpenProcess();
//闭运算: 先腐蚀，再膨胀
void morphCloseProcess();
//形态学梯度
void gradientProcess();
//顶帽
void tophatProcess();
//黑帽
void blackhatProcess();


#endif /* ImageProcessTool_hpp */
