//
//  WTRectDetectionDetailVC.m
//  iOSOpenCVDemo
//
//  Created by ocean on 2019/1/3.
//  Copyright © 2019年 wztMac. All rights reserved.
//

#import "WTRectDetectionDetailVC.h"
#import "WTRectDetectionDetailCell.h"
#import "WTRealTimeRectDetetionTool.h"
#import "wTShowBigImageVC.h"

@interface WTRectDetectionDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImage *originImage;
- (IBAction)imgProcessBtnAction:(UIButton *)sender;

@property (nonatomic, strong) WTRealTimeRectDetetionTool *tool;

@end

@implementation WTRectDetectionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WTRectDetectionDetailCell.class) bundle:nil] forCellReuseIdentifier:kRectDetectionDetailCellId];
    
    //
    _originImage = [UIImage imageNamed:@"rect1"];
    
    [self.dataArray addObject:@{@"原始图像":_originImage}];
    [self.tableView reloadData];
}


#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WTRectDetectionDetailCell *cell = [WTRectDetectionDetailCell createCellWithTableView:tableView indexPath:indexPath];
    cell.infoDic = self.dataArray[indexPath.row];
    
    return cell;
}


#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *infoDic = self.dataArray[indexPath.row];
    UIImage *image = [[infoDic allValues]firstObject];
    
    [wTShowBigImageVC showBigImage:image target:self];
}


#pragma mark actions
- (IBAction)imgProcessBtnAction:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    [[WTRealTimeRectDetetionTool share]processImage:_originImage completion:^(BOOL success) {
        if (success) {
            [weakSelf refreshTableView];
        }
    }];
    
}
-(void)refreshTableView {
    self.dataArray = [NSMutableArray arrayWithArray:[[WTRealTimeRectDetetionTool share] getProcessedImages]];
    [self.tableView reloadData];
}


#pragma mark set/get
-(NSMutableArray*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
