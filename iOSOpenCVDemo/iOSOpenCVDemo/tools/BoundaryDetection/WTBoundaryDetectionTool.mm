//
//  WTBoundaryDetectionTool.m
//  iOSOpenCVDemo
//
//  Created by ocean on 2019/1/10.
//  Copyright © 2019年 wztMac. All rights reserved.
//

#import <opencv2/stitching/detail/blenders.hpp>
#import <opencv2/stitching/detail/exposure_compensate.hpp>

#import "WTBoundaryDetectionTool.h"
#import <stdlib.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgproc.hpp>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <cstdlib>
#include <opencv2/imgproc/imgproc.hpp>//图像处理

using namespace cv;
using namespace std;

@interface WTBoundaryDetectionTool ()
@property (nonatomic, strong) NSMutableArray <NSDictionary*>*dataArray;

@end

@implementation WTBoundaryDetectionTool


-(UIImage*)boundaryDetectionWithImage:(UIImage*)image {
    
    Mat src_mat, dst_mat;
    UIImageToMat(image, src_mat);
    
    //获取灰度图像
//    Mat src_gray;
//    cvtColor(src_mat, src_gray, COLOR_BGR2GRAY);
//    UIImage *grayImg = MatToUIImage(src_gray);
//    [self.dataArray addObject:@{@"二值灰度图":grayImg}];
    
    //RGBA to RGB
    Mat mat_img_rgb;
    cvtColor(src_mat, mat_img_rgb, CV_RGBA2RGB, 3);
    
    Mat mat_img_clone=mat_img_rgb.clone();
    
    
    
    // 滤波 N越大越平越模糊(2*N+1) sigmas空间越大越模糊; sigmar相似因子
    myBialteralFilter(&mat_img_clone, &dst_mat, 25, 12.5, 50);
    //
    
    
    UIImage *result = MatToUIImage(dst_mat);
    return result;
}

/**
 * 双边滤波函数
 * 双边滤波主函数，注意，现在的权值并没有进行归一化，归一化需要在计算时，根据第一大点中讲解的公式进行计算。
 */
void myBialteralFilter(cv::Mat *src, cv::Mat *dst, int N, double sigmas, double sigmar)
{
    // [1] 初始化
    *dst = (*src).clone();
    int _size = 2 * N + 1;
    // [2] 分别计算空间权值和相似度权值
    int channels = (*dst).channels();
    double *_colorArray = NULL;
    double **_spaceArray = NULL;
    _colorArray = get_color_Array( _size, channels, sigmar);
    _spaceArray = get_space_Array(_size, channels, sigmas);
    // [3] 滤波
    doBialteral(dst, N, _colorArray, _spaceArray);
    
    return;
}

/**
 * 计算空间权值
 * 高斯函数带入坐标(空间临近)
 */
double **get_space_Array( int _size, int channels, double sigmas)
{
    // [1] 空间权值
    int i, j;
    // [1-1] 初始化数组
    double **_spaceArray = new double*[_size+1];   //多一行，最后一行的第一个数据放总值
    for (i = 0; i < _size+1; i++) {
        _spaceArray[i] = new double[_size+1];
    }
    // [1-2] 高斯分布计算
    int center_i, center_j;
    center_i = center_j = _size / 2;
    _spaceArray[_size][0] = 0.0f;
    // [1-3] 高斯函数
    for (i = 0; i < _size; i++) {
        for (j = 0; j < _size; j++) {
            _spaceArray[i][j] =
            exp(-(1.0f)* (((i - center_i)*(i - center_i) + (j - center_j)*(j - center_j)) /
                          (2.0f*sigmas*sigmas)));
            _spaceArray[_size][0] += _spaceArray[i][j];
        }
    }
    
    printf("空间权值: \n");
    for (i=0; i<_size; i++) {
        for (j=0; j<_size; j++) {
           printf("%f ", _spaceArray[i][j]);
        }
        printf("\n");
    }
    printf("结束了\n");
    printf("_spaceArray[_size][0]=%f \n", _spaceArray[_size][0]);
    
    return _spaceArray;
}

/**
 * 计算相似度权值
 * 高斯函数代入坐标值(颜色空间)
 */
double *get_color_Array(int _size, int channels, double sigmar)
{
    // [2] 相似度权值
    int n;
    double *_colorArray = new double[255 * channels + 2];   //最后一位放总值
    double wr = 0.0f;
    _colorArray[255 * channels + 1] = 0.0f;
    for (n = 0; n < 255 * channels + 1; n++) {
        _colorArray[n] = exp((-1.0f*(n*n)) / (2.0f*sigmar*sigmar));
        _colorArray[255 * channels + 1] += _colorArray[n];
    }
    printf("颜色相似度权值: ");
    for (n=0; n< 255 * channels + 1; n++) {
        printf("%f ", _colorArray[n]);
    }
    printf("\n");
    return _colorArray;
}

/**
 * 滤波
 * 双边 扫描计算
 */
void doBialteral(cv::Mat *_src, int N, double *_colorArray, double **_spaceArray) {
    
    int _size = (2 * N + 1);
    cv::Mat temp = (*_src).clone();
    // [1] 扫描
    for (int i = 0; i < (*_src).rows; i++) {
        printf("i=%d\n", i);
        for (int j = 0; j < (*_src).cols; j++) {
            // [2] 忽略边缘
            if (i > (_size / 2) - 1 && j > (_size / 2) - 1 &&
                i < (*_src).rows - (_size / 2) && j < (*_src).cols - (_size / 2)) {
                
                // [3] 找到图像输入点，以输入点为中心与核中心对齐
                //     核心为中心参考点 卷积算子=>高斯矩阵180度转向计算
                //     x y 代表卷积核的权值坐标   i j 代表图像输入点坐标
                //     卷积算子     (f*g)(i,j) = f(i-k,j-l)g(k,l)          f代表图像输入 g代表核
                //     带入核参考点 (f*g)(i,j) = f(i-(k-ai), j-(l-aj))g(k,l)   ai,aj 核参考点
                //     加权求和  注意：核的坐标以左上0,0起点
                double sum[3] = { 0.0,0.0,0.0 };
                int x, y, values;
                double space_color_sum = 0.0f;
                // 注意: 公式后面的点都在核大小的范围里
                // 双边公式 g(ij) =  (f1*m1 + f2*m2 + ... + fn*mn) / (m1 + m2 + ... + mn)
                // space_color_sum = (m1 + m12 + ... + mn)
                for (int k = 0; k < _size; k++) {
                    for (int l = 0; l < _size; l++) {
                        x = i - k + (_size / 2);   // 原图x  (x,y)是输入点
                        y = j - l + (_size / 2);   // 原图y  (i,j)是当前输出点
                        values = abs((*_src).at<cv::Vec3b>(i, j)[0] + (*_src).at<cv::Vec3b>(i, j)[1] + (*_src).at<cv::Vec3b>(i, j)[2]
                                     - (*_src).at<cv::Vec3b>(x, y)[0] - (*_src).at<cv::Vec3b>(x, y)[1] - (*_src).at<cv::Vec3b>(x, y)[2]);
                        space_color_sum += (_colorArray[values] * _spaceArray[k][l]);
                    }
                }
                // 计算过程
                for (int k = 0; k < _size; k++) {
                    for (int l = 0; l < _size; l++) {
                        x = i - k + (_size / 2);   // 原图x  (x,y)是输入点
                        y = j - l + (_size / 2);   // 原图y  (i,j)是当前输出点
                        values = abs((*_src).at<cv::Vec3b>(i, j)[0] + (*_src).at<cv::Vec3b>(i, j)[1] + (*_src).at<cv::Vec3b>(i, j)[2]
                                     - (*_src).at<cv::Vec3b>(x, y)[0] - (*_src).at<cv::Vec3b>(x, y)[1] - (*_src).at<cv::Vec3b>(x, y)[2]);
                        for (int c = 0; c < 3; c++) {
                            sum[c] += ((*_src).at<cv::Vec3b>(x, y)[c]
                                       * _colorArray[values]
                                       * _spaceArray[k][l])
                            / space_color_sum;
                        }
                    }
                }
                for (int c = 0; c < 3; c++) {
                    temp.at<cv::Vec3b>(i, j)[c] = sum[c];
                }
            }
        }
    }
    // 放入原图
    (*_src) = temp.clone();
    
    return ;
}








#pragma mark set/get
-(NSMutableArray*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
