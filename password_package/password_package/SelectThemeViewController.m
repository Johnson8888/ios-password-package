//
//  SelectThemeViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/26.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SelectThemeViewController.h"
#import "SelectCell.h"
#import "AppConfig.h"
#import "Utils.h"

@interface SelectThemeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,weak) SelectCell *lastSelectedCell;
@property (nonatomic,assign) PPTheme lastTheme;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@end

@implementation SelectThemeViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    
    self.navigationItem.title = @"选择时长";
    
    [self.confirmButton setImage:[[UIImage imageNamed:@"ic_accept"]
                                  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                        forState:UIControlStateNormal];
    self.confirmButton.tintColor = SYSTEM_COLOR;
    
    [self.closeButton setImage:[[UIImage imageNamed:@"ic_close"]
                                  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                        forState:UIControlStateNormal];
    self.closeButton.tintColor = SYSTEM_COLOR;
    
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    NSDictionary *dic0 = @{@"title":@"白色",@"selected":@NO,@"value":[NSNumber numberWithInteger:PP_THEME_WHITE]};
    NSDictionary *dic1 = @{@"title":@"红色",@"selected":@NO,@"value":[NSNumber numberWithInteger:PP_THEME_RED]};
    NSDictionary *dic2 = @{@"title":@"蓝色",@"selected":@NO,@"value":[NSNumber numberWithInteger:PP_THEME_BLUE]};
    NSDictionary *dic3 = @{@"title":@"绿色",@"selected":@NO,@"value":[NSNumber numberWithInteger:PP_THEME_GREEN]};
    NSDictionary *dic4 = @{@"title":@"紫色",@"selected":@NO,@"value":[NSNumber numberWithInteger:PP_THEME_PURPLE]};
    NSDictionary *dic5 = @{@"title":@"暗黑",@"selected":@NO,@"value":[NSNumber numberWithInteger:PP_THEME_BLACK]};
    
    AppConfig *config = [AppConfig config];
    self.lastTheme = config.mainTheme;
    
    self.dataArray = [NSMutableArray arrayWithArray:@[dic0,dic1,dic2,dic3,dic4,dic5]];
    [self.dataArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PPTheme theme = [obj[@"value"] integerValue];
        if (theme == config.mainTheme) {
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:obj];
            tempDic[@"selected"] = @YES;
            [self.dataArray replaceObjectAtIndex:idx withObject:tempDic];
        }
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectCell class]) bundle:nil] forCellReuseIdentifier:@"com.select.theme.view.controller.identifier"];
    
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.select.theme.view.controller.identifier"];
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
    self.lastTheme = newValue;
    [self.tableView reloadData];
}

- (IBAction)pressedCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedConfirmButton:(id)sender {
    if ([AppConfig config].isSharkFeedBack) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    }

    AppConfig *config = [AppConfig config];
    config.mainTheme = self.lastTheme;
    [AppConfig saveConfig:config];
    [self dismissViewControllerAnimated:YES completion:^{}];
    [Utils showPopWithText:@"保存成功!"];
    if (self.selectThemeCallBack) {
        self.selectThemeCallBack();
    }
}

@end
