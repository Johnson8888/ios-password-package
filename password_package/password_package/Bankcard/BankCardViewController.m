//
//  BankCardViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/10.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "BankCardViewController.h"
#import "InputCartViewController.h"
#import "PresentBankCardViewController.h"
#import "PresentWebsiteViewController.h"
#import "ShowBankCardViewController.h"
#import "PPDataManager.h"
#import "PPBankCardModel.h"
#import "BankCardViewCell.h"
#import <JHUD/JHUD.h>


@interface BankCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation BankCardViewController


-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    [self refreshData];
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:PP_RETRIEVE_DATA_SUCCESS_NOTIFICATION
                                               object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BankCardViewCell class]) bundle:nil] forCellReuseIdentifier:@"com.password.package.backcard.view.controller.bank.card.cell.identifer"];
    
//    [self refreshData];
    
}



/// 刷新数据源
- (void)refreshData {
    if (self.dataArray) {
        [self.dataArray removeAllObjects];
    }
    NSMutableArray *array = [[PPDataManager sharedInstance] getAllBackCard];
    self.dataArray = array.mutableCopy;
    [self.tableView reloadData];
    if (self.dataArray.count == 0) {
        [self showEmptyMessageView];
    } else {
        [self hiddenEmptyMessageView];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BankCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.password.package.backcard.view.controller.bank.card.cell.identifer"];
    cell.dataModel = self.dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PresentBankCardViewController *presentBackCardViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([PresentBankCardViewController class])];
    presentBackCardViewController.bankCardModel = self.dataArray[indexPath.row];
    
    presentBackCardViewController.deleteCallBack = ^{
        [self refreshData];
    };
    
    presentBackCardViewController.editBankCardCallBack = ^(PPBankCardModel *cardModel) {
        [self presentEditViewControllerWithModel:cardModel];
    };
    
    presentBackCardViewController.viewBankCardCallBack = ^(PPBankCardModel *cardModel) {
        [self presentViewBankCardViewControllerWithModel:cardModel];
    };
    presentBackCardViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.tabBarController presentViewController:presentBackCardViewController animated:YES completion:^{}];
    
}


- (IBAction)pressedAddButton:(id)sender {
    InputCartViewController *inputViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([InputCartViewController class])];
    inputViewController.finishCallBack = ^{
        [self refreshData];
    };
    [self presentViewController:inputViewController animated:YES completion:nil];
}



- (void)presentEditViewControllerWithModel:(PPBankCardModel *)model {
    InputCartViewController *inputViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([InputCartViewController class])];
    inputViewController.editModel = model;
    inputViewController.finishCallBack = ^{
        [self refreshData];
    };
    [self presentViewController:inputViewController animated:YES completion:nil];
}



- (void)presentViewBankCardViewControllerWithModel:(PPBankCardModel *)model {
    ShowBankCardViewController *showViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ShowBankCardViewController class])];
    showViewController.bankCardModel = model;
    [self.navigationController pushViewController:showViewController animated:YES];
}



- (void)showEmptyMessageView {
    UIView *hudView = [self.view viewWithTag:999];
    if (hudView == nil) {
        JHUD *hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
        hudView.tag = 999;
        hudView.indicatorViewSize = CGSizeMake(138, 110);
        hudView.messageLabel.text = @"";
        hudView.customImage = [UIImage imageNamed:@"ic_empty_box"];
        [hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
        hudView.refreshButton.hidden = YES;
    }
}


- (void)hiddenEmptyMessageView {
    UIView *hudView = [self.view viewWithTag:999];
    if (hudView) {
        [hudView removeFromSuperview];
    }
}




@end
