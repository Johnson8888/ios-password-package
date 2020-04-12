//
//  ViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/1.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "MainViewController.h"
#import "PPPasswordCreator.h"
#import "LoginViewController.h"
#import "SearchItemViewController.h"
#import "CreatePasswordViewController.h"
#import "CSYGroupButtonView.h"
#import <Masonry.h>
#import <JHUD/JHUD.h>
#import "PPDataManager.h"
#import "SearchItemViewCell.h"
#import "PresentWebsiteViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation MainViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
//    [self showEmptyMessageView];
    
    self.tableView.rowHeight = 64.0f;
    self.tableView.tableFooterView = [[UIView alloc] init];
    NSArray *arrayLeft = @[@"按钮1",@"按钮2",@"按钮3"];
    //相应数组
    CSYGroupButtonView *groupButton = [[CSYGroupButtonView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 85, self.view.bounds.size.height - 100 - 65, 65, 65) mainButtonTitle:@"添加" selectedTitle:@"添加" otherButtonsTitle:arrayLeft];
    groupButton.ButtonClickBlock = ^(UIButton *btn) {
        NSLog(@"%@ tag=%ld",btn.titleLabel.text,(long)btn.tag);
        if (btn.tag == 1) {
            [self showCreatePasswordViewController];
        }
        if (btn.tag == 2) {
            [self showSelectedItemViewController];
        }
        
    };
    [self.view addSubview:groupButton];
    TTLog(@"view did load");
    
    
    [[PPDataManager sharedInstance] getAllWebsiteWithCompletion:^(NSMutableArray<PPWebsiteModel *> * _Nonnull array, NSError * _Nullable error) {
        if (error) {
            TTLog(@"get all website error = %@",array);
        } else {
            if (self.dataArray) {
                [self.dataArray removeAllObjects];
            }
            if (array.count != 0) {
                self.dataArray = array.mutableCopy;
                [self.tableView reloadData];
            }
        }
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchItemViewCell class]) bundle:nil] forCellReuseIdentifier:@"com.main.view.controller.search.item.cell"];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchItemViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"com.main.view.controller.search.item.cell"];
    PPWebsiteModel *model = self.dataArray[indexPath.row];
    cell.dataModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PresentWebsiteViewController *sViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([PresentWebsiteViewController class])];
    sViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.tabBarController presentViewController:sViewController animated:YES completion:nil];
}



- (void)showSelectedItemViewController {
    SearchItemViewController *sViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SearchItemViewController class])];
    sViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:sViewController animated:YES completion:nil];
}


- (void)showCreatePasswordViewController {
    CreatePasswordViewController *cViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CreatePasswordViewController class])];
    cViewController.alertText = @"复制成功!";
    cViewController.buttonText = @"复制";
    cViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:cViewController animated:YES completion:nil];
}

- (IBAction)pressedAddBarButton:(UIBarButtonItem *)sender {
    [self showSelectedItemViewController];
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


@end
