//
//  GaussFilterTool.m
//  OpenCVFaceDetectDemo
//
//  Created by ocean on 2018/11/23.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import <opencv2/stitching/detail/blenders.hpp>
#import <opencv2/stitching/detail/exposure_compensate.hpp>

#import "GaussFilterTool.h"
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

@implementation GaussFilterTool


-(void)gaussFilteImage:(UIImage*)image completion:(void(^)(UIImage *saltNoiseImg, UIImage *cusGaussFilteImg, UIImage *sysGaussFilteImg))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        //UIImage 转 Mat矩阵
        Mat mat_img_src;
        UIImageToMat(image, mat_img_src);
        
        //椒盐噪声
        Mat salt_image;
        mat_img_src.copyTo(salt_image);
        salt_image = saltNoiseToImage(mat_img_src, 5000);
//        salt_image = addSaltNoise(mat_img_src, 5000);
        
        Mat _cusGaussian;
        Mat _sysGaussian;
        gaussianFilte(salt_image, _cusGaussian);
        GaussianBlur(salt_image, _sysGaussian, cv::Size(3, 3), 3.0);
        
        //Mat 转 UIImage
        UIImage *noiseImg = MatToUIImage(salt_image);
        UIImage *cusGusFilImg = MatToUIImage(_cusGaussian);
        UIImage *sysGusFilImg = MatToUIImage(_sysGaussian);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(noiseImg, cusGusFilImg, sysGusFilImg);
            }
        });
    });
}

//图像添加椒盐噪声
Mat addSaltNoise(Mat srcImage, int n)
{
    Mat resultImage = srcImage.clone();
    for (int k = 0; k < n; k++)
    {
        //随机取值行列
        int i = rand() % resultImage.cols;
        int j = rand() % resultImage.rows;
        //图像通道判定
        if (resultImage.channels() == 1) //if (resultImage.type() == CV_8UC1) { // gray-level image
            resultImage.at<uchar>(j, i) = 255;
        else
        {
            resultImage.at<Vec3b>(j, i)[0] = 255;
            resultImage.at<Vec3b>(j, i)[1] = 255;
            resultImage.at<Vec3b>(j, i)[2] = 255;
        }
    }
    return resultImage;
}

//椒盐噪声
Mat saltNoiseToImage(Mat image, int n)//本函数加入彩色盐噪声
{
    Mat resultImage = image.clone();
    srand( (unsigned)time( NULL ) );
    for(int k=0; k<n; k++)//将图像中n个像素随机置零
    {
        int i = rand()%resultImage.cols;
        int j = rand()%resultImage.rows;
        //将图像颜色随机改变
        resultImage.at<Vec3b>(j,i)[0] = 250;
        resultImage.at<Vec3b>(j,i)[1] = 150;
        resultImage.at<Vec3b>(j,i)[2] = 250;
    }
    return resultImage;
}


//创建高斯矩阵
double **getGuassionDataMatrix(int size, double sigma) {
    
    int i, j;
    double sum = 0.0;
    int center = size; //以第一个点的坐标为原点，求出中心点的坐标
    
    double **arr = new double *[size];//建立一个size*size大小的二维数组
    for (i = 0; i < size; ++i)
        arr[i] = new double[size];
    
    for (i = 0; i < size; ++i)
        for (j = 0; j < size; ++j) {
            arr[i][j] = exp(-((i - center)*(i - center) + (j - center)*(j - center)) / (sigma*sigma * 2));
            sum += arr[i][j];
        }
    for (i = 0; i < size; ++i)
        for (j = 0; j < size; ++j)
            arr[i][j] /= sum;
    return arr;
}

void gaussianFilte(const Mat _src, Mat &_dst) {
    
    if (!_src.data) return;
    double **arr;
    Mat tmp(_src.size(), _src.type());
    for (int i = 0; i < _src.rows; ++i)
        for (int j = 0; j < _src.cols; ++j) {
            //边缘不进行处理
            if ((i - 1) > 0 && (i + 1) < _src.rows && (j - 1) > 0 && (j + 1) < _src.cols) {
                arr = getGuassionDataMatrix(3, 1);//自定义得到的权值数组
                tmp.at<Vec3b>(i, j)[0] = 0;
                tmp.at<Vec3b>(i, j)[1] = 0;
                tmp.at<Vec3b>(i, j)[2] = 0;
                for (int x = 0; x < 3; ++x) {
                    for (int y = 0; y < 3; ++y) {
                        tmp.at<Vec3b>(i, j)[0] += arr[x][y] * _src.at<Vec3b>(i + 1 - x, j + 1 - y)[0];
                        tmp.at<Vec3b>(i, j)[1] += arr[x][y] * _src.at<Vec3b>(i + 1 - x, j + 1 - y)[1];
                        tmp.at<Vec3b>(i, j)[2] += arr[x][y] * _src.at<Vec3b>(i + 1 - x, j + 1 - y)[2];
                    }
                }
            }
        }
    tmp.copyTo(_dst);
}


//创建高斯矩阵
void createGaussDataMatrix(int rows) {
    
    double arr[rows][rows];
    double sum = 0.0;
    double sigma = 1.5;
    for (int i=0; i<rows; ++i) {
        for (int j=0; j<rows; ++j) {
            sum += arr[i][j]=exp(-((i-1)*(i-1)+(j-1)*(j-1))/(2*sigma*sigma));
        }
    }
    for (int i=0; i<rows; ++i) {
        for (int j=0; j<rows; ++j) {
            arr[i][j] /= sum;
        }
    }
    for (int i=0; i<rows; i++) {
        for (int j=0; j<rows; ++j) {
            cout<<arr[i][j]<<" ";
        }
        cout<<endl;
    }
}

@end
