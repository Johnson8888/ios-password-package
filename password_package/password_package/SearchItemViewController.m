//
//  SearchItemViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/3.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SearchItemViewController.h"

/*!  京东   印象笔记   豆瓣 12306 支付宝
 *
 * 常用的网站地址 微信 QQ 京东 淘宝 豆瓣 知乎 百度 微博 支付宝 网易邮箱 QQ邮箱 12306 印象笔记 百度网盘 Github
 *  中国工商银行
 *  中国建设银
 *  中国银行
 *  中国农业银行
 *  中国光大银行
 *  中国邮政储蓄银行
 *  交通银行
 *  招商银行
 *  中信银行
 *  浦发银行
 *  兴业银行
 *  民生银行
 *  平安银行
 *  华夏银行
 *  广发银行
 */


@interface SearchItemViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation SearchItemViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    NSArray *inCommonUseArray = @[@"wechat",@"qq",@"taobao",@"zhihu",@"baidu",
                                  @"weibo",@"163",@"github",@"jingdong",@"yinxiangbiji"
                                @"douban",@"12306",@"zhifubao"];
    
    
    NSString *folderPath = [[NSBundle mainBundle] pathForResource:@"website" ofType:nil];
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:folderPath];
    
    NSMutableArray *nameArray = [NSMutableArray array];
    //列举目录内容，可以遍历子目录
    for (NSString *path in myDirectoryEnumerator.allObjects) {
        if ([path hasSuffix:@"@2x.png"]) {
            NSString *webSiteName = [path stringByReplacingOccurrencesOfString:@"@2x.png" withString:@".com"];
            TTLog(@"webSiteName = %@",webSiteName);
            [nameArray addObject:webSiteName];
        }
    }
    
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.sectionIndexBackgroundColor =[UIColor blackColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"password.package.search.item.cell.identifier"];
    self.dataArray = @[inCommonUseArray,nameArray];
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *itemArray = self.dataArray[section];
    return itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"password.package.search.item.cell.identifier"];
    NSString *name = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//}
//- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//}
@end
