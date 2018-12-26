//
//  WTRealTimeRectDetetionTool.m
//  iOSOpenCVDemo
//
//  Created by ocean on 2018/12/17.
//  Copyright © 2018年 wztMac. All rights reserved.
//

#import <opencv2/stitching/detail/blenders.hpp>
#import <opencv2/stitching/detail/exposure_compensate.hpp>

#import "WTRealTimeRectDetetionTool.h"
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

@implementation WTRealTimeRectDetetionTool

#pragma mark public
+(UIImage*)bridge_getRectDetectImage:(UIImage*)resImg {
    
    Mat res_mat, dst_mat;
    UIImageToMat(resImg, res_mat);
    
    Mat rec_mat = rectDetectWithCorners(res_mat);
    
    UIImage *dstImg = MatToUIImage(rec_mat);
    return dstImg;
}

+(UIImage*)bridge_realTimeRectDetection:(UIImage*)resImg {
    
    Mat res_mat;
    UIImageToMat(resImg, res_mat);
    
    processImage(res_mat);
    
    UIImage *dstImg = MatToUIImage(res_mat);
    return dstImg;
}

#pragma mark private
Mat rectDetectWithCorners(Mat &res_mat) {

    vector<cv::Point> corners;
    corners = processImage(res_mat);

    //根据四边形的四个顶点，提取目标图像
    //对顶点顺时针排序
    vector<cv::Point2f> corners_tmp;
    for (int i = 0; i < corners.size(); i++)
    {
        cv::Point p = corners[i];
        cv::Point2f p_tmp = Point2f(p.x, p.y);
        corners_tmp.push_back(p_tmp);
    }
    //排序
    sortCorners(corners_tmp);
    //
    corners.clear();
    for (int i = 0; i < corners_tmp.size(); i++)
    {
        cv::Point2f p = corners_tmp[i];
        cv::Point p_tmp = cv::Point(p.x, p.y);
        corners.push_back(p_tmp);
    }

    //计算目标图像的尺寸
    cv::Point2f p0 = corners[0];
    cv::Point2f p1 = corners[1];
    cv::Point2f p2 = corners[2];
    cv::Point2f p3 = corners[3];
    float space0 = getSpacePointToPoint(p0, p1);
    float space1 = getSpacePointToPoint(p1, p2);
    float space2 = getSpacePointToPoint(p2, p3);
    float space3 = getSpacePointToPoint(p3, p0);

    float width = space1 > space3 ? space1 : space3;
    float height = space0 > space2 ? space0 : space2;

    cv::Mat quad = cv::Mat::zeros(height * 3, width * 3, CV_8UC3);
    std::vector<cv::Point2f> quad_pts;
    quad_pts.push_back(cv::Point2f(0, quad.rows));
    quad_pts.push_back(cv::Point2f(0, 0));
    quad_pts.push_back(cv::Point2f(quad.cols, 0));
    quad_pts.push_back(cv::Point2f(quad.cols, quad.rows));

    //提取图像
    cv::Mat transmtx = cv::getPerspectiveTransform(corners_tmp , quad_pts);
    cv::warpPerspective(res_mat, quad, transmtx, quad.size());

    //拉普拉斯算子增强对比度
    Mat imageMat;
    Mat kernel = (Mat_<float>(3,3) << 0, -1, 0,  -1, 5, -1, 0, -1, 0);
    filter2D(quad, imageMat, quad.depth(), kernel);
    //Mat --> UIImage
    //UIImage *dstImage = MatToUIImage(imageMat);
    return imageMat;
}

vector<cv::Point> processImage(Mat &res_mat) //, vector<cv::Point> &cornors1
{
    Mat src_gray, filtered, edges, dilated_edges;
    vector<cv::Point> cornors1;
    
    //获取灰度图像
    cvtColor(res_mat, src_gray, COLOR_BGR2GRAY);
    //线性滤波，模糊处理，消除某些背景干扰信息
    blur(src_gray, filtered, cv::Size(3, 3));
    //高斯滤波
    //GaussianBlur(src_gray, filtered, cv::Size(3, 3), 0);
    //中值滤波
    //cv::medianBlur(src_gray, filtered, 3);
    
    //是否开启 膨胀 腐蚀操作
    int flag = 0;
    if (flag==0) {
        //腐蚀操作，消除某些背景干扰信息
        erode(filtered, filtered, Mat(),cv::Point(-1, -1), 3, 1, 1);
    }
    
    int thresh = 35;
    //边缘检测
    Canny(filtered, edges, thresh, thresh*3, 3);
    if (flag==0) {
        //膨胀操作，尽量使边缘闭合
        dilate(edges, dilated_edges, Mat(), cv::Point(-1, -1), 3, 1, 1);
    }else{
       edges.copyTo(dilated_edges);
    }
    
    vector<vector<cv::Point> > contours, squares, hulls;
    //寻找边框
    findContours(dilated_edges, contours, RETR_LIST, CHAIN_APPROX_SIMPLE);
    
    vector<cv::Point> hull, approx;
    for (size_t i = 0; i < contours.size(); i++)
    {
        //边框的凸包
        convexHull(contours[i], hull);
        //多边形拟合凸包边框(此时的拟合的精度较低)
        approxPolyDP(Mat(hull), approx, arcLength(Mat(hull), true)*0.02, true); //approx
        //筛选出面积大于某一阈值的，且四边形的各个角度都接近直角的凸四边形
        if (approx.size() == 4 && fabs(contourArea(Mat(approx))) > 40000 &&
            isContourConvex(Mat(approx)))
        {
            double maxCosine = 0;
            for (int j = 2; j < 5; j++)
            {
                double cosine = fabs(getAngle(approx[j%4], approx[j-2], approx[j-1]));
                maxCosine = MAX(maxCosine, cosine);
            }
            //角度大概72度
            if (maxCosine < 0.3) {
                squares.push_back(approx);
                hulls.push_back(hull);
            }
        }
    }
    
    vector<cv::Point> largest_square;
    //找出外接矩形最大的四边形
    int idex = findLargestSquare(squares, largest_square);
    if (largest_square.size() == 0 || idex == -1) return cornors1;
    
    //找到这个最大的四边形对应的凸边框，再次进行多边形拟合，此次精度较高，拟合的结果可能是大于4条边的多边形
    //接下来的操作，主要是为了解决，证件有圆角时检测到的四个顶点的连线会有切边的问题
    hull = hulls[idex];
    approxPolyDP(Mat(hull), approx, 3, true);
    vector<cv::Point> newApprox;
    double maxL = arcLength(Mat(approx), true)*0.02;
    //找到高精度拟合时得到的顶点中 距离小于 低精度拟合得到的四个顶点 maxL的顶点，排除部分顶点的干扰
    for (cv::Point p : approx)
    {
        if (!(getSpacePointToPoint(p, largest_square[0]) > maxL &&
              getSpacePointToPoint(p, largest_square[1]) > maxL &&
              getSpacePointToPoint(p, largest_square[2]) > maxL &&
              getSpacePointToPoint(p, largest_square[3]) > maxL))
        {
            newApprox.push_back(p);
        }
    }
    //找到剩余顶点连线中，边长大于 2 * maxL的四条边作为四边形物体的四条边
    vector<Vec4i> lines;
    for (int i = 0; i < newApprox.size(); i++)
    {
        cv::Point p1 = newApprox[i];
        cv::Point p2 = newApprox[(i+1)%newApprox.size()];
        if (getSpacePointToPoint(p1, p2) > 2 * maxL)
        {
            lines.push_back(Vec4i(p1.x, p1.y, p2.x,p2.y));
        }
    }
    
    //计算出这四条边中 相邻两条边的交点，即物体的四个顶点
    //vector<cv::Point> cornors1;
    for (int i = 0; i < lines.size(); i++)
    {
        cv::Point cornor = computeIntersect(lines[i],lines[(i+1)%lines.size()]);
        cornors1.push_back(cornor);
    }
    //绘制出四条边
    for (int i = 0; i < cornors1.size(); i++)
    {
        line(res_mat, cornors1[i], cornors1[(i+1)%cornors1.size()], CV_RGB(255, 0, 0), 15, CV_AA); //Scalar(0,0,255)
    }
    return cornors1;
}

//相关自定义函数：
#pragma mark =========== 寻找最大边框 ===========
int findLargestSquare(const vector<vector<cv::Point> >& squares, vector<cv::Point>& biggest_square)
{
    if (!squares.size()) return -1;
    
    int max_width = 0;
    int max_height = 0;
    int max_square_idx = 0;
    for (int i = 0; i < squares.size(); i++)
    {
        cv::Rect rectangle = boundingRect(Mat(squares[i]));
        if ((rectangle.width >= max_width) && (rectangle.height >= max_height))
        {
            max_width = rectangle.width;
            max_height = rectangle.height;
            max_square_idx = i;
        }
    }
    biggest_square = squares[max_square_idx];
    return max_square_idx;
}

/**
 根据三个点计算中间那个点的夹角   pt1 pt0 pt2
 */
double getAngle(cv::Point pt1, cv::Point pt2, cv::Point pt0)
{
    double dx1 = pt1.x - pt0.x;
    double dy1 = pt1.y - pt0.y;
    double dx2 = pt2.x - pt0.x;
    double dy2 = pt2.y - pt0.y;
    return (dx1*dx2 + dy1*dy2)/sqrt((dx1*dx1 + dy1*dy1)*(dx2*dx2 + dy2*dy2) + 1e-10);
}

/**
 点到点的距离
 
 @param p1 点1
 @param p2 点2
 @return 距离
 */
double getSpacePointToPoint(cv::Point p1, cv::Point p2)
{
    int a = p1.x-p2.x;
    int b = p1.y-p2.y;
    return sqrt(a * a + b * b);
}

/**
 两直线的交点
 
 @param a 线段1
 @param b 线段2
 @return 交点
 */
cv::Point2f computeIntersect(cv::Vec4i a, cv::Vec4i b)
{
    int x1 = a[0], y1 = a[1], x2 = a[2], y2 = a[3], x3 = b[0], y3 = b[1], x4 = b[2], y4 = b[3];
    
    if (float d = ((float)(x1 - x2) * (y3 - y4)) - ((y1 - y2) * (x3 - x4)))
    {
        cv::Point2f pt;
        pt.x = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / d;
        pt.y = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / d;
        return pt;
    }
    else
        return cv::Point2f(-1, -1);
}

/**
 对多个点按顺时针排序
 
 @param corners 点的集合
 */
void sortCorners(std::vector<cv::Point2f>& corners)
{
    if (corners.size() == 0) return;
    //先延 X轴排列
    cv::Point pl = corners[0];
    int index = 0;
    for (int i = 1; i < corners.size(); i++)
    {
        cv::Point point = corners[i];
        if (pl.x > point.x)
        {
            pl = point;
            index = i;
        }
    }
    corners[index] = corners[0];
    corners[0] = pl;
    
    cv::Point lp = corners[0];
    for (int i = 1; i < corners.size(); i++)
    {
        for (int j = i+1; j<corners.size(); j++)
        {
            cv::Point point1 = corners[i];
            cv::Point point2 = corners[j];
            if ((point1.y-lp.y*1.0)/(point1.x-lp.x)>(point2.y-lp.y*1.0)/(point2.x-lp.x))
            {
                cv::Point temp = point1;
                corners[i] = corners[j];
                corners[j] = temp;
            }
        }
    }
}


#pragma mark test
+(UIImage*)drawRectInImage:(UIImage*)resImg {
    
    Mat res_mat;
    UIImageToMat(resImg, res_mat);
    
    //顶点
    vector<cv::Point> corners;
    cv::Point p0 = cv::Point(606,55);
    corners.push_back(p0);
    cv::Point p1 = cv::Point(585,387);
    corners.push_back(p1);
    cv::Point p2 = cv::Point(53,383);
    corners.push_back(p2);
    cv::Point p3 = cv::Point(47,39);
    corners.push_back(p3);
    
    //划线
    for (int i = 0; i < corners.size(); i++)
    {
        line(res_mat, corners[i], corners[(i+1)%corners.size()], Scalar(0,0,255), 5);
    }
    
    UIImage *dstImg = MatToUIImage(res_mat);
    return dstImg;
}

+(UIImage*)zhizhen_drawRectInImage:(UIImage*)resImg {
    
    Mat res_mat;
    UIImageToMat(resImg, res_mat);
    
    copyLineRecTImage(res_mat);
    
    UIImage *dstImg = MatToUIImage(res_mat);
    return dstImg;
}
void copyLineRecTImage(Mat &res_mat) {
    
    //顶点
    vector<cv::Point> corners;
    cv::Point p0 = cv::Point(606,55);
    corners.push_back(p0);
    cv::Point p1 = cv::Point(585,387);
    corners.push_back(p1);
    cv::Point p2 = cv::Point(53,383);
    corners.push_back(p2);
    cv::Point p3 = cv::Point(47,39);
    corners.push_back(p3);
    
    //划线
    for (int i = 0; i < corners.size(); i++)
    {
        line(res_mat, corners[i], corners[(i+1)%corners.size()], Scalar(0,0,255), 5);
    }
}


@end
