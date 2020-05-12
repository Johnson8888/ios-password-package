//
//  ClearPasteboardViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/20.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "ClearPasteboardViewController.h"
#import "SelectCell.h"
#import "AppConfig.h"
#import "Utils.h"

@interface ClearPasteboardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,weak) SelectCell *lastSelectedCell;
@property (nonatomic,assign) NSInteger clearPasteboardValue;
@end

@implementation ClearPasteboardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.clearPasteboardValue = [AppConfig config].clearPasteboardDuration;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    NSDictionary *dic0 = @{@"title":@"10秒",@"selected":@NO,@"value":@10};
    NSDictionary *dic1 = @{@"title":@"30秒",@"selected":@NO,@"value":@30};
    NSDictionary *dic2 = @{@"title":@"1分钟",@"selected":@NO,@"value":@60};
    NSDictionary *dic3 = @{@"title":@"2分钟",@"selected":@NO,@"value":@120};
    NSDictionary *dic4 = @{@"title":@"5分钟",@"selected":@NO,@"value":@300};
    NSDictionary *dic5 = @{@"title":@"从不",@"selected":@NO,@"value":[NSNumber numberWithInt:PP_NEVER_TO_DO_TAG]};
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:@[dic0,dic1,dic2,dic3,dic4,dic5]];
    
    NSInteger idx = -1;
    NSMutableDictionary *targetDict = nil;
    
    for (int i = 0; i < tempArray.count; ++i) {
        NSDictionary *dic = tempArray[i];
        NSInteger value = [dic[@"value"] intValue];
        if (value == self.clearPasteboardValue) {
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectCell class]) bundle:nil] forCellReuseIdentifier:@"com.clear.paste.board.tableview.identifier"];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.clear.paste.board.tableview.identifier"];
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
    self.clearPasteboardValue = newValue;
    [self.tableView reloadData];
}

- (IBAction)pressedConfirmButton:(id)sender {
    AppConfig *config = [AppConfig config];
    config.clearPasteboardDuration = self.clearPasteboardValue;
    [AppConfig saveConfig:config];
    [self dismissViewControllerAnimated:YES completion:^{}];
    [Utils showPopWithText:@"保存成功!"];
    if (self.clearCallBack) {
        self.clearCallBack();
    }
}

- (IBAction)pressedCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
