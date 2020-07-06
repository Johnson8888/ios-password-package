//
//  SearchItemViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/3.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "SearchItemViewController.h"
#import "SearchItemViewCell.h"
#import "PPPasswordCreator.h"
#import <SCIndexViewConfiguration.h>
#import <UITableView+SCIndexView.h>
#import <SCIndexView.h>
#import <Masonry.h>
#import <PYSearch/PYSearch.h>
#import "InputWebsiteViewController.h"

/*!  京东   印象笔记   豆瓣 12306 支付宝
 *
 * 常用的网站地址 微信 QQ 淘宝 京东 微博 支付宝 豆瓣 12306 印象笔记  知乎 百度 百度网盘 网易邮箱 QQ邮箱  Github
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


@interface SearchItemViewController ()<
UITableViewDelegate,
UITableViewDataSource,
PYSearchViewControllerDelegate,
PYSearchViewControllerDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 当前页面显示的数据
@property (nonatomic,strong) NSMutableDictionary *dataDictionary;
/// 被 搜索数据的数组
@property (nonatomic,strong) NSMutableArray *searchDataArray;
/// 搜索结果的数组
@property (nonatomic,strong) NSMutableArray *resultDataArray;

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.resultDataArray = [NSMutableArray array];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(20, 14.5, headerView.bounds.size.width - 40, 35);
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 10.0f;
    
    if (@available(iOS 13.0, *)) {
        [searchButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    } else {
        [searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [searchButton setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self
                     action:@selector(pressedSearchButton:)
           forControlEvents:UIControlEventTouchUpInside];
    searchButton.backgroundColor = [UIColor colorWithRed:205/255.0f green:225/255.0f blue:235/255.0f alpha:1.0f];
    [headerView addSubview:searchButton];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[[UIImage imageNamed:@"btn_close_circle_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                     forState:UIControlStateNormal];
    
    closeButton.lee_theme
    .LeeAddTintColor(kThemeDefault, SYSTEM_COLOR)
    .LeeAddTintColor(kThemeRed, LEEColorHex(kColorThemeRed))
    .LeeAddTintColor(kThemeBlue, LEEColorHex(kColorThemeBlue))
    .LeeAddTintColor(kThemeGreen, LEEColorHex(kColorThemeGreen))
    .LeeAddTintColor(kThemePurple, LEEColorHex(kColorThemePurple))
    .LeeAddTintColor(kThemeYellow, LEEColorHex(kColorThemeYellow));
    

    
    [headerView addSubview:closeButton];
    [closeButton addTarget:self
                    action:@selector(pressedCloseButton:)
          forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 76, 14.5, 36, 36);
    self.tableView.tableHeaderView = headerView;
    
    
        
    self.tableView.rowHeight = 64.0f;
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configuration];
    configuration.indicatorTextColor = SYSTEM_COLOR;
    self.tableView.sc_indexViewConfiguration = configuration;
    self.tableView.sc_translucentForTableViewInNavigationBar = YES;
    
    self.dataDictionary = [NSMutableDictionary dictionary];
    
    NSArray *inCommonUseArray = @[@"Wechat",@"QQ",@"Taobao",@"Zhihu",@"Baidu",@"Weibo",@"163",@"Github",@"jingdong",@"Yinxiang",@"douban",@"12306",@"zhifubao"];

    
    self.dataDictionary[@"常用"] = inCommonUseArray;
    
    NSString *folderPath = [[NSBundle mainBundle] pathForResource:@"website" ofType:nil];
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:folderPath];
    
    self.searchDataArray = [NSMutableArray array];
    for (NSString *path in myDirectoryEnumerator.allObjects) {
        if ([path hasSuffix:@"@2x.png"] == NO) {
            continue;
        }
        NSString *webSiteName = [path stringByReplacingOccurrencesOfString:@"@2x.png" withString:@""];
        [self.searchDataArray addObject:webSiteName];
        NSString *startCharacter = [[webSiteName substringToIndex:1] uppercaseString];
        if ([self theStringIsAllNumbers:startCharacter]) {
            continue;
        }
        if ([self.dataDictionary objectForKey:startCharacter] == nil) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:webSiteName];
            self.dataDictionary[startCharacter] = array;
        } else {
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataDictionary[startCharacter]];
            [array addObject:webSiteName];
            self.dataDictionary[startCharacter] = array;
        }
    }
    
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor blackColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchItemViewCell class]) bundle:nil] forCellReuseIdentifier:@"password.package.search.item.cell.identifier"];
    
    NSMutableArray *mutableKeysArray = [NSMutableArray arrayWithArray:self.dataDictionary.allKeys];
    NSMutableArray *sortedArray = [self paixuWith:mutableKeysArray];
    [sortedArray removeObjectAtIndex:0];
    
    self.tableView.sc_indexViewDataSource = sortedArray.copy;
    self.tableView.sc_startSection = 0;
    [self.tableView reloadData];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataDictionary.allKeys.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *mutableKeysArray = [NSMutableArray arrayWithArray:self.dataDictionary.allKeys];
    NSMutableArray *sortedArray = [self paixuWith:mutableKeysArray];
    NSArray *itemArray = [self.dataDictionary objectForKey:sortedArray[section]];
    return itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"password.package.search.item.cell.identifier"];
    NSMutableArray *mutableKeysArray = [NSMutableArray arrayWithArray:self.dataDictionary.allKeys];
    NSMutableArray *sortedArray = [self paixuWith:mutableKeysArray];
    NSString *key = sortedArray[indexPath.section];
    NSArray *valueArray = self.dataDictionary[key];
    NSString *name = valueArray[indexPath.row];
    cell.websiteName = name;
//    cell.descriptionName = [SearchItemViewController descriptionWithName:name];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSMutableArray *mutableKeysArray = [NSMutableArray arrayWithArray:self.dataDictionary.allKeys];
    NSMutableArray *sortedArray = [self paixuWith:mutableKeysArray];
    return sortedArray[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InputWebsiteViewController *inputViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([InputWebsiteViewController class])];
    SearchItemViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    inputViewController.webSiteName = cell.websiteName;
    inputViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:inputViewController animated:YES completion:nil];
}


/// 点击关闭按钮
/// @param btn 关闭按钮
- (void)pressedCloseButton:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/// 点击搜索按钮
/// @param btn 搜索按钮
- (void)pressedSearchButton:(UIButton *)btn {
    NSArray *hotSeaches = @[];    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"输入关键字"];
    searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    searchViewController.delegate = self;
    searchViewController.dataSource = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:NO completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [searchViewController.searchBar becomeFirstResponder];
    });
}


#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText {
    if (searchText.length == 0) {
        return;
    }
    [self.resultDataArray removeAllObjects];
    for (NSString *item in self.searchDataArray) {
        if ([[item lowercaseString] containsString:[searchText lowercaseString]]) {
            [self.resultDataArray addObject:item];
        }
    }
    if (self.resultDataArray.count > 0) {
        [searchViewController.searchSuggestionView reloadData];
    }
}


#pragma mark - PYSearchViewControllerDataSource
- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView
                    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *searchSuggestionIdentifier = @"com.password.package.search.suggest.view.cell.identifier";
    SearchItemViewCell *cell = [searchSuggestionView dequeueReusableCellWithIdentifier:searchSuggestionIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SearchItemViewCell class]) owner:self options:nil].firstObject;
    }
    cell.websiteName = self.resultDataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}


- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath
                   searchBar:(UISearchBar *)searchBar {
    
    NSString *text = self.resultDataArray[indexPath.row];
    InputWebsiteViewController *inputViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([InputWebsiteViewController class])];
    inputViewController.webSiteName = text;
    [searchViewController.navigationController presentViewController:inputViewController animated:YES completion:^{}];
}

- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView
            numberOfRowsInSection:(NSInteger)section {
    return self.resultDataArray.count;
}
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView {
    return 1;
}
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}



//根据拼音的字母排序  ps：排序适用于所有类型
- (NSMutableArray *)paixuWith:(NSMutableArray *)array{
    [array sortUsingComparator:^NSComparisonResult(NSString *node1, NSString *node2) {
        NSString *string1 = [node1 substringToIndex:1];
        NSString *string2 = [node2 substringToIndex:1];;
        return [string1 compare:string2];
    }];
    id lastObject = array.lastObject;
    [array insertObject:lastObject atIndex:0];
    [array removeLastObject];
    return array;
}

- (BOOL)theStringIsAllNumbers:(NSString*)str {
    NSScanner *scan = [NSScanner scannerWithString: str];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}




+ (NSString *)descriptionWithName:(NSString *)name {
    NSString *resultName = name;
    if ([name isEqualToString:@"Wechat"]) {
        resultName = @"微信";
    }
    if ([name isEqualToString:@"Taobao"]) {
        resultName = @"淘宝";
    }
    if ([name isEqualToString:@"Zhihu"]) {
        resultName = @"知乎";
    }
    if ([name isEqualToString:@"Baidu"]) {
        resultName = @"百度";
    }
    if ([name isEqualToString:@"Weibo"]) {
        resultName = @"微博";
    }
    if ([name isEqualToString:@"jingdong"]) {
        resultName = @"京东";
    }
    if ([name isEqualToString:@"Yinxiang"]) {
        resultName = @"印象笔记";
    }
    if ([name isEqualToString:@"douban"]) {
        resultName = @"豆瓣";
    }
    if ([name isEqualToString:@"zhifubao"]) {
        resultName = @"支付宝";
    }
    return resultName;
}



@end
