//
//  InputWebsiteViewController.m
//  password_package
//
//  Created by Johnson on 2020/4/8.
//  Copyright © 2020 Jon Snow. All rights reserved.
//

#import "InputWebsiteViewController.h"
#import "PPWebsiteModel.h"
#import "PPDataManager.h"
#import "CreatePasswordViewController.h"
#import "CreatePasswordViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>

@interface InputWebsiteViewController ()<TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *websiteTF;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (nonatomic,strong) PPWebsiteModel *insertModel;

@end

@implementation InputWebsiteViewController

- (void)viewDidLoad {
    
    // 100.54 400630999
    //
    [super viewDidLoad];
    self.insertModel = [[PPWebsiteModel alloc] init];
    
    TTLog(@"webSite = %@",self.webSiteName);
    if ([self.webSiteName containsString:@"."] == NO) {
        self.websiteTF.text = [NSString stringWithFormat:@"https://www.%@.com",[self.webSiteName lowercaseString]];
    } else {
        self.websiteTF.text = [NSString stringWithFormat:@"https://www.%@",[self.webSiteName lowercaseString]];
    }
    NSString *namePath = [NSString stringWithFormat:@"/website/%@@2x.png",self.webSiteName];
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:namePath];
    self.iconImageView.image = [UIImage imageWithContentsOfFile:filePath];
    self.iconLabel.text = self.webSiteName;
    self.insertModel.title = self.iconLabel.text;
    self.insertModel.iconImg = UIImagePNGRepresentation(self.iconImageView.image);
}


- (IBAction)pressedChangeIconButton:(id)sender {
    [self pushTZImagePickerController];
}


- (IBAction)pressedCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)pressedFinishButton:(id)sender {
    
    if (self.accountTF.text.length == 0 || self.accountTF.text == nil) {
        
        return;
    }
    if (self.passwordTF.text.length == 0 || self.passwordTF.text == nil) {
        
        return;
    }
    
    self.insertModel.account = self.accountTF.text;
    self.insertModel.password = self.passwordTF.text;
    self.insertModel.link = self.websiteTF.text;
    self.insertModel.describe = self.describeTextView.text;
    
//    NSLog(@"self.insertModel = %@",self.insertModel);
    
    BOOL isSuccess = [[PPDataManager sharedInstance] insertWebsiteWithModel:self.insertModel];
    if (isSuccess) {
        TTLog(@"插入成功 需要返回");
    } else {
        TTLog(@"插入失败");
    }
}

- (IBAction)pressedCreatePasswrodButton:(id)sender {
    CreatePasswordViewController *cViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CreatePasswordViewController class])];
    cViewController.buttonText = @"确定";
    cViewController.completion = ^(NSString *pwd,UIViewController *viewController) {
        self.passwordTF.text = pwd;
        [viewController dismissViewControllerAnimated:YES completion:nil];
    };
    
    cViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:cViewController animated:YES completion:nil];
}


- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    // imagePickerVc.barItemTextColor = [UIColor blackColor];
    // [imagePickerVc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    // imagePickerVc.navigationBar.tintColor = [UIColor blackColor];
    // imagePickerVc.naviBgColor = [UIColor whiteColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    /// 允许选择原图
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    // imagePickerVc.photoWidth = 1600;
    // imagePickerVc.photoPreviewMaxWidth = 1600;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    /*
    [imagePickerVc setAssetCellDidSetModelBlock:^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
        cell.contentView.clipsToBounds = YES;
        cell.contentView.layer.cornerRadius = cell.contentView.tz_width * 0.5;
    }];
     */
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
//    // 设置竖屏下的裁剪尺寸
//    NSInteger left = 30;
//    NSInteger widthHeight = self.view.tz_width - 2 * left;
//    NSInteger top = (self.view.tz_height - widthHeight) / 2;
//    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.scaleAspectFillCrop = YES;
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
    [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
        [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
    }];
    imagePickerVc.delegate = self;
    */
    
    // imagePickerVc.isStatusBarDefault = NO;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = NO;
    imagePickerVc.allowCameraLocation = NO;
    imagePickerVc.preferredLanguage = @"zh-Hans";
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            self.iconImageView.image = photos.firstObject;
            TTLog(@"先把图片保存到相册!!!");
            self.insertModel.iconImg = UIImagePNGRepresentation(self.iconImageView.image);
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
@end
