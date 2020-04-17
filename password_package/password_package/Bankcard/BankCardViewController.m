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
#import "ShowBankCardViewController.h"
#import "PPDataManager.h"
#import "PPBankCardModel.h"
#import "BankCardViewCell.h"

@interface BankCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation BankCardViewController


-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BankCardViewCell class]) bundle:nil] forCellReuseIdentifier:@"com.password.package.backcard.view.controller.bank.card.cell.identifer"];
    
    [self refreshData];
    
}


- (void)refreshData {
    if (self.dataArray) {
        [self.dataArray removeAllObjects];
    }
    NSMutableArray *array = [[PPDataManager sharedInstance] getAllBackCard];
    self.dataArray = array.mutableCopy;
    [self.tableView reloadData];
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
    
    presentBackCardViewController.deleteCallBack = ^{
        [self refreshData];
    };
    
    presentBackCardViewController.editBankCardCallBack = ^(PPBankCardModel *cardModel) {
        [self presentEditViewControllerWithModel:cardModel];
    };
    
    presentBackCardViewController.viewBankCardCallBack = ^(PPBankCardModel *cardModel) {
        [self presentViewBankCardViewControllerWithModel:cardModel];
    };
    
    [self.navigationController presentViewController:presentBackCardViewController animated:YES completion:^{}];
}


- (IBAction)pressedAddButton:(id)sender {
    InputCartViewController *inputViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([InputCartViewController class])];
    [self presentViewController:inputViewController animated:YES completion:nil];
}



- (void)presentEditViewControllerWithModel:(PPBankCardModel *)model {
    InputCartViewController *inputViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([InputCartViewController class])];
    inputViewController.editModel = model;
    [self presentViewController:inputViewController animated:YES completion:nil];

}


- (void)presentViewBankCardViewControllerWithModel:(PPBankCardModel *)model {
    ShowBankCardViewController *showViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ShowBankCardViewController class])];
    showViewController.bankCardModel = model;
    self.tabBarController.tabBar.hidden = YES;
    TTLog(@"tab = %@",self.tabBarController);
    [self.navigationController pushViewController:showViewController animated:YES];
}


@end
