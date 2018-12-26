//
//  TJPointCircleView.h
//  OpenCVRectDectectDemo
//
//  Created by WZT on 2017/3/20.
//  Copyright © 2017年 WZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJRectModel.h"

@protocol TJPointCircleViewDelegate <NSObject>

-(void)changeDetectRect;

@end

@interface TJPointCircleView : UIView

@property (nonatomic, strong) NSMutableArray <TJRectModel*>*rectsArray;
@property (nonatomic, weak) id<TJPointCircleViewDelegate>delegate;

@property (nonatomic, assign) BOOL isInQuadrilateral;     //是否是内四边形
@property (nonatomic, assign) BOOL isOnlyMoveLine;

#pragma mark public methods
-(void)addARect;
-(void)addARectWithPoints:(NSArray*)points;
//清空之前的绘制
-(void)clearBeforeCircleAndLines;

@end
