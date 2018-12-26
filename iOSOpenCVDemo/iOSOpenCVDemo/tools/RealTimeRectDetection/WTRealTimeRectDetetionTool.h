//
//  WTRealTimeRectDetetionTool.h
//  iOSOpenCVDemo
//
//  Created by ocean on 2018/12/17.
//  Copyright © 2018年 wztMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTRealTimeRectDetetionTool : NSObject

+(UIImage*)drawRectInImage:(UIImage*)resImg;
+(UIImage*)zhizhen_drawRectInImage:(UIImage*)resImg;

+(UIImage*)bridge_realTimeRectDetection:(UIImage*)resImg;
+(UIImage*)bridge_getRectDetectImage:(UIImage*)resImg;

@end

NS_ASSUME_NONNULL_END
