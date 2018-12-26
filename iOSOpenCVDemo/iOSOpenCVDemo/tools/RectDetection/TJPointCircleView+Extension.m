//
//  TJPointCircleView+Extension.m
//  OpenCVFaceDetectDemo
//
//  Created by ocean on 2018/11/15.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import "TJPointCircleView+Extension.h"

@implementation TJPointCircleView (Extension)

-(NSMutableArray*)cornerPoints {
    
    TJRectModel *model = self.rectsArray[0];
    NSArray *pointsArray = model.pointsArray;
    
    NSArray *temp = [pointsArray subarrayWithRange:NSMakeRange(0, 4)];
    NSLog(@"排序前顶点坐标:%@", temp);
    NSArray *sortedYArr = [model resetOrderOfCornerPointsByABCD:temp];
    NSLog(@"排序后顶点坐标:%@", sortedYArr);
    
    NSMutableArray* cornerPoints = [NSMutableArray arrayWithArray:sortedYArr];
    return cornerPoints;
}

@end
