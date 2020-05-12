//
//  SetAutoLockViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/21.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SetAutoLockViewController.h"
#import "SelectCell.h"
#import "AppConfig.h"
#import "Utils.h"

@interface SetAutoLockViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger autoLockValue;
@property(nonatomic,weak) SelectCell *lastSelectedCell;

@end

@implementation SetAutoLockViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // /// 多长时间自动锁屏 输入要入密码  默认是 立刻  10秒 30秒 1分钟 5分钟 10分钟
    
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectCell class]) bundle:nil] forCellReuseIdentifier:@"com.set.auto.lock.viewcontroller.identifier"];
    
    self.autoLockValue = [AppConfig config].autoLockDuration;
    
    NSDictionary *dic0 = @{@"title":@"立刻",@"selected":@NO,@"value":@0};
    NSDictionary *dic1 = @{@"title":@"10秒",@"selected":@NO,@"value":@10};
    NSDictionary *dic2 = @{@"title":@"30秒",@"selected":@NO,@"value":@30};
    NSDictionary *dic3 = @{@"title":@"1分钟",@"selected":@NO,@"value":@60};
    NSDictionary *dic4 = @{@"title":@"5分钟",@"selected":@NO,@"value":@300};
    NSDictionary *dic5 = @{@"title":@"10分钟",@"selected":@NO,@"value":@600};
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:@[dic0,dic1,dic2,dic3,dic4,dic5]];
    
    NSInteger idx = -1;
    NSMutableDictionary *targetDict = nil;
    
    for (int i = 0; i < tempArray.count; ++i) {
        NSDictionary *dic = tempArray[i];
        NSInteger value = [dic[@"value"] intValue];
        if (value == self.autoLockValue) {
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            tmpDic[@"selected"] = @YES;
            idx = i;
            targetDict = tmpDic;
            break;
        }
    }
    
    if (idx != -1 && targetDict != nil) {
        [tempArray replaceObjectAtIndex:idx withObject:targetDict];
    }
    self.dataArray = tempArray;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.set.auto.lock.viewcontroller.identifier"];
        cell.dataDictionary = self.dataArray[indexPath.row];
    if ([[cell.dataDictionary objectForKey:@"selected"] boolValue] == YES) {
        self.lastSelectedCell = cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger lastValue = [self.lastSelectedCell.dataDictionary[@"value"] intValue];
    self.lastSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger newValue = [self.lastSelectedCell.dataDictionary[@"value"] intValue];
    [self.dataArray enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:obj];
        NSInteger value = [tempDict[@"value"] intValue];
        if (value == lastValue) {
            tempDict[@"selected"] = @NO;
        }
        if (value == newValue) {
            tempDict[@"selected"] = @YES;
        }
        [self.dataArray replaceObjectAtIndex:idx withObject:tempDict];
    }];
    self.autoLockValue = newValue;
    [self.tableView reloadData];
}

- (IBAction)pressedConfirmButton:(id)sender {
    AppConfig *config = [AppConfig config];
    config.autoLockDuration = self.autoLockValue;
    [AppConfig saveConfig:config];
    [self dismissViewControllerAnimated:YES completion:^{}];
    [Utils showPopWithText:@"保存成功!"];
    if (self.saveCallBack) {
        self.saveCallBack();
    }
}

- (IBAction)pressedCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
