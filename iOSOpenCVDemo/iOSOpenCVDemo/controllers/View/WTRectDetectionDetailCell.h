//
//  WTRectDetectionDetailCell.h
//  iOSOpenCVDemo
//
//  Created by ocean on 2019/1/3.
//  Copyright © 2019年 wztMac. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kRectDetectionDetailCellId = @"kRectDetectionDetailCellId";

@interface WTRectDetectionDetailCell : UITableViewCell

+(instancetype)createCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)idxPath;

@property (nonatomic, strong) NSDictionary *infoDic;

@end

