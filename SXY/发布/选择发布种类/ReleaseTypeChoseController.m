//
//  ReleaseTypeChoseController.m
//  SXY
//
//  Created by yh f on 2018/12/4.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ReleaseTypeChoseController.h"
#import "ReleaseWantBuyController.h"
#import "ReleaseStockController.h"
#import "SearchImageController.h"

#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZPhotoPreviewController.h"
#import "TZTestCell.h"
#import "PicModel.h"
#import "MineInfoModel.h"
@interface ReleaseTypeChoseController ()<TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;


@end

@implementation ReleaseTypeChoseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    [self initUI];
    
}

- (void)initUI{
    
    
    UIImageView *topIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_bg"]];
    [self.view addSubview:topIma];
    topIma.frame = CGRectMake(0, 0, ScreenWidth, 270 +STATUSBAR_HEIGHT);
    
    UILabel *souxiuLab = [BaseViewFactory labelWithFrame:CGRectMake(30, 63+STATUSBAR_HEIGHT, ScreenWidth-60, 64) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(48) textAligment:NSTextAlignmentLeft andtext:@"SOUXIU"];
    [topIma addSubview:souxiuLab];

    NSString *souxiuText = souxiuLab.text;
    NSMutableAttributedString *souxiuattributedString = [[NSMutableAttributedString alloc] initWithString:souxiuText attributes:@{NSKernAttributeName:@(5)}];
    NSMutableParagraphStyle *souxiuparagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [souxiuattributedString addAttribute:NSParagraphStyleAttributeName value:souxiuparagraphStyle range:NSMakeRange(0, [souxiuText length])];
    souxiuLab.attributedText = souxiuattributedString;
    [souxiuLab sizeToFit];
    
    UILabel *subLab = [BaseViewFactory labelWithFrame:CGRectMake(40, 114+STATUSBAR_HEIGHT, ScreenWidth-60, 64) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(11) textAligment:NSTextAlignmentLeft andtext:@"因为相信  所以简单"];
    [topIma addSubview:subLab];
    NSString *labelText = subLab.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(10)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    subLab.attributedText = attributedString;
    [subLab sizeToFit];
    
    
    UIButton *backBtn = [BaseViewFactory buttonWithWidth:30 imagePath:@"shut"];
    [self.view addSubview:backBtn];
    backBtn.frame = CGRectMake(ScreenWidth/2-15, ScreenHeight-78, 30, 30);
    [backBtn addTarget:self action:@selector(respondToLeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
  
    
    
    NSArray *imaNameArr = @[@"soutu",@"qiugou",@"xianhuo",@"gongying"];
    NSArray *nameArr = @[@"搜图",@"发布求购",@"发布现货",@"发布供应"];
    for (int i =0 ; i<4; i++) {
        int a = i/2;
        int b = i%2;
        
        UIImageView *ima = [BaseViewFactory icomWithWidth:60 imagePath:imaNameArr[i]];
        [self.view addSubview:ima];
        ima.frame = CGRectMake((ScreenWidth/2)-105+150*b, 330+STATUSBAR_HEIGHT+120*a, 60, 60);
        
        UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectMake((ScreenWidth/2)-105+150*b, 330+STATUSBAR_HEIGHT+120*a+76, 60, 20) textColor:UIColorFromRGB(0xC0B451) font:APPFONT14 textAligment:NSTextAlignmentCenter andtext:nameArr[i]];
        [self.view addSubview:nameLab];
        
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:topBtn];
        topBtn.frame = CGRectMake((ScreenWidth/2)-105+150*b, 330+STATUSBAR_HEIGHT+120*a, 60, 100);
        topBtn.tag = 1000 +i;
        [topBtn addTarget:self action:@selector(releaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        
        if (_isHiddenSoutu) {
            if (i == 0) {
                ima.hidden = YES;
                topBtn.hidden = YES;
                nameLab.hidden = YES;
            }else if (i == 1){
                topBtn.frame = CGRectMake((ScreenWidth/2)-30, 330+STATUSBAR_HEIGHT+120*a, 60, 100);
                ima.frame = CGRectMake((ScreenWidth/2)-30, 330+STATUSBAR_HEIGHT+120*a, 60, 60);
                nameLab.frame = CGRectMake((ScreenWidth/2)-30, 330+STATUSBAR_HEIGHT+120*a+76, 60, 20);
            }
        }
        
        
        
    }
    
    
    
}




- (void)releaseBtnClick:(UIButton *)Btn
{

    
    User *user = [[UserPL shareManager]getLoginUser];
    NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%@",user.userId]};
    if (Btn.tag == 1000) {
        [self gotoTrueNameWithTag:Btn.tag - 1000];
        return;

    }
    
    
    [[UserPL shareManager] userUserfindUserByIdWithDic:dic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
       MineInfoModel *model = [MineInfoModel mj_objectWithKeyValues:returnValue[@"result"]];
        if ([model.realNameAuth intValue]==3||[model.companyAuth intValue]==3) {
            [self gotoTrueNameWithTag:Btn.tag - 1000];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先进行实名认证" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    } andErrorBlock:^(NSString *msg) {
        [HUD show:msg];
    }];
    
    
    
    
    
    
    
}

- (void)gotoTrueNameWithTag:(NSInteger)tag{
    switch (tag)
    {
        case 0:{
            [self shangchuan];
            break;
        }
        case 1:{
            ReleaseWantBuyController *reVc = [[ReleaseWantBuyController alloc]init];
            reVc.releaseType = ReleaseType_WantBuy;
            [self.navigationController pushViewController:reVc animated:YES];
            break;
        }
        case 2:{
            ReleaseStockController*reVc = [[ReleaseStockController alloc]init];
            reVc.releaseType = ReleaseType_GoodsInStock;
            [self.navigationController pushViewController:reVc animated:YES];
            break;
        }
        case 3:{
            ReleaseStockController*reVc = [[ReleaseStockController alloc]init];
            reVc.releaseType = ReleaseType_Supply;
            [self.navigationController pushViewController:reVc animated:YES];
            break;
        }
        default:
            break;
    }
    
}



- (void)respondToLeftButtonClickEvent{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ======= 头像选取


-(void)shangchuan
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"照片选取" message:@"选择照片选取方式" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert  addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushImagePickerController];
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}






- (void)takePhoto {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        
        [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
    
}
#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:5 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    imagePickerVc.oKButtonTitleColorDisabled = UIColorFromRGB(RedColorValue);
    imagePickerVc.oKButtonTitleColorNormal = UIColorFromRGB(RedColorValue);
    imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        // tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        
                        
                    }];
                }];
            }
        }];
    }
}
- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
  
    [self searchImageWithImage:image];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // DLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (photos.count<=0) {
        return;
    }
    
    [self searchImageWithImage:photos[0]];

}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
}


- (void)searchImageWithImage:(UIImage *)oriImage{
    
    
    SearchImageController *seVc = [[SearchImageController alloc]init];
    seVc.searIma = oriImage;
    [self.navigationController pushViewController:seVc animated:YES];
}


#pragma mark ======= get

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        
        // set appearance / 改变相册选择页的导航栏外观
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9.0, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
@end
