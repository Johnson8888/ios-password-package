//
//  SelectIconViewController.m
//  password_package
//
//  Created by Johnson on 2020/5/14.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SelectIconViewController.h"
#import "SelectIconCell.h"
#import "AppConfig.h"
#import "Utils.h"

@interface SelectIconViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 选中的Icon文件名字
@property (nonatomic,strong) NSString *selectIconFileName;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) SelectIconCell *lastSelectedCell;
@property (nonatomic,strong) NSString *lastIconFileName;
@end

@implementation SelectIconViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 64.0f;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.lastIconFileName = [AppConfig config].iconFileName;
    if (self.lastIconFileName == nil || self.lastIconFileName.length == 0) {
        self.lastIconFileName = @"7Icon-App-60x60";
    }
    self.dataArray = [NSMutableArray array];
    for (int i = 1; i < 8; ++i) {
        NSString *fileName = [NSString stringWithFormat:@"%dIcon-App-60x60",i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"fileName"] = fileName;
        if ([fileName isEqualToString:self.lastIconFileName]) {
            dict[@"isSelect"] = @YES;
        }else {
            dict[@"isSelect"] = @NO;
        }
        [self.dataArray addObject:dict];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectIconCell class]) bundle:nil] forCellReuseIdentifier:@"com.setting.view.controller.select.icon.cell.identifier"];
    [self.tableView reloadData];
    NSLog(@"self.dataArray = %@",self.dataArray);
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.setting.view.controller.select.icon.cell.identifier"];
    NSDictionary *dict = self.dataArray[indexPath.row];
    if ([dict[@"isSelect"] boolValue]) {
        self.lastSelectedCell = cell;
    }
    cell.dataDictionary = self.dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *lastValue = self.lastSelectedCell.dataDictionary[@"fileName"];
    self.lastSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *newValue = self.lastSelectedCell.dataDictionary[@"fileName"];
    NSLog(@"lastValue = %@",lastValue);
    [self.dataArray enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:obj];
        NSString *value = tempDict[@"fileName"];
        if ([value isEqualToString:lastValue]) {
            tempDict[@"isSelect"] = @NO;
        }
        if ([value isEqualToString:newValue]) {
            tempDict[@"isSelect"] = @YES;
        }
        [self.dataArray replaceObjectAtIndex:idx withObject:tempDict];
    }];
    TTLog(@"lasetDataDict = %@",self.lastSelectedCell.dataDictionary);
    self.lastIconFileName = newValue;
    [self.tableView reloadData];
}


- (IBAction)pressedCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)pressedCompletButton:(id)sender {
    
    AppConfig *config = [AppConfig config];
    config.iconFileName = self.lastSelectedCell.dataDictionary[@"fileName"];
    [AppConfig saveConfig:config];
    [[UIApplication sharedApplication] setAlternateIconName:config.iconFileName
                                          completionHandler:^(NSError * _Nullable error) {
        if (error) {
            [Utils showPopWithText:@"设置失败,请重试!"];
        } else {
            [Utils showPopWithText:@"保存成功!"];
        }
        [self dismissViewControllerAnimated:YES completion:^{}];
        if (self.saveCallBack) {
            self.saveCallBack();
        }
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
