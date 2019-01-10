//
//  WTRectDetectionDetailCell.m
//  iOSOpenCVDemo
//
//  Created by ocean on 2019/1/3.
//  Copyright © 2019年 wztMac. All rights reserved.
//

#import "WTRectDetectionDetailCell.h"

@interface WTRectDetectionDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation WTRectDetectionDetailCell

+(instancetype)createCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)idxPath {
    
    WTRectDetectionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kRectDetectionDetailCellId forIndexPath:idxPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)setInfoDic:(NSDictionary *)infoDic {
    
    _infoDic = infoDic;
    if ([infoDic isKindOfClass:[NSDictionary class]]) {
        UIImage *img = [[infoDic allValues]firstObject];
        NSString *name = [[infoDic allKeys]firstObject];
        
        _nameLabel.text = name;
        _imgView.image = img;
    }else{
        NSAssert(1, @"出错了");
    }
    
}

@end
