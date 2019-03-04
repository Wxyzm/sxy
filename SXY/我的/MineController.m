//
//  MineController.m
//  SXY
//
//  Created by yh f on 2018/11/8.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MineController.h"
#import "AppDelegate.h"
#import "MIneControllerHeader.h"
#import "MineInfoModel.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZPhotoPreviewController.h"
#import "NameChangeController.h"
#import "TZTestCell.h"

@interface MineController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) BaseTableView *ListTab;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@end

@implementation MineController{
    
    MineInfoModel *_model;
    NSDictionary *_infoDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    [self initUI];
    [self loadMineInfo];
}

- (void)initUI{
    
    [self.view addSubview:self.ListTab];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMineInfo) name:MineVcShouldRefresh object:nil];
}


#pragma mark ====== tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 182+STATUSBAR_HEIGHT +103 +6;
    }
    
    return 62;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *MIneTopCellId= @"MIneTopCellID";
        MIneTopCell  *cell = [tableView dequeueReusableCellWithIdentifier:MIneTopCellId];
        if (!cell) {
            cell = [[MIneTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MIneTopCellId];
        }
        cell.infoModel = _model;
        WeakSelf(self);
        cell.returnBlock = ^(NSInteger tag) {
            [weakself menueBtnCLickWithTag:tag];
        };
        return cell;
    }else {
        NSArray *nameArr = @[@"店铺管理",@"账号安全",@"客服"];
        
        static NSString *MineChoseViewCellId= @"MineChoseViewCellId";
        MineChoseViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:MineChoseViewCellId];
        if (!cell) {
            cell = [[MineChoseViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MineChoseViewCellId];
        }
        cell.nameLab.text = nameArr[indexPath.row -1];
        
        return cell;
        
        
    }
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 1:{
            //店铺管理
            if ([_model.realNameAuth intValue]==3||[_model.companyAuth intValue]==3) {
                ShopManagerController *shopVc = [[ShopManagerController alloc]init];
                [self.navigationController pushViewController:shopVc animated:YES];
                
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先进行实名认证" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            
            break;
        }
        case 2:{
            MineSafeController *safeVc = [[MineSafeController alloc]init];
            [self.navigationController pushViewController:safeVc animated:YES];
            break;
        }
        case 3:{
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18457586800"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            break;
        }
        case 4:{
            
            break;
        }
        case 5:{
            [[UserPL shareManager] logout];
            break;
        }
        default:
            break;
    }
    
    
}

#pragma mark ========= 求购 收藏等按钮点击
- (void)menueBtnCLickWithTag:(NSInteger)tag{
    
    switch (tag) {
        case 0:{
            MineWantController *wantVc = [[MineWantController  alloc]init];
            [self.navigationController pushViewController:wantVc animated:YES];
            break;
        }
        case 1:{
            MuneCollectController *collectVc = [[MuneCollectController  alloc]init];
            [self.navigationController pushViewController:collectVc animated:YES];
            break;
        }
        case 2:{
            MineBoardCastController*broadVc = [[MineBoardCastController  alloc]init];
            [self.navigationController pushViewController:broadVc animated:YES];
            break;
        }
        case 3:{
            MinetopicController*topicVc = [[MinetopicController  alloc]init];
            [self.navigationController pushViewController:topicVc animated:YES];
            break;
        }
        case 4:{
            MineInfoController*infoVc = [[MineInfoController  alloc]init];
            [self.navigationController pushViewController:infoVc animated:YES];
            break;
        }case 5:{
            //换头像
              [self shangchuan];
            break;
        }case 6:{
            //改名字
            NameChangeController *changeVc = [[NameChangeController alloc]init];
            changeVc.infoDic = _infoDic;
            [self.navigationController pushViewController:changeVc animated:YES];
            break;
        }
        default:
            break;
    }
    
    
}







#pragma mark ========= 加载个人信息

- (void)loadMineInfo{
    User *user = [[UserPL shareManager]getLoginUser];
    NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%@",user.userId]};
    [[UserPL shareManager] userUserfindUserByIdWithDic:dic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _model = [MineInfoModel mj_objectWithKeyValues:returnValue[@"result"]];
        _infoDic = returnValue[@"result"];
        [self.ListTab.mj_header endRefreshing];
        [self.ListTab reloadData];
    } andErrorBlock:^(NSString *msg) {
         [self.ListTab.mj_header endRefreshing];
    }];
    
    
    
    
}
#pragma mark ======= 上传头像

- (void)upfaceImaWithIma:(UIImage *)faceImage{
    
    if (!_infoDic) {
        return;
    }
    
    NSArray *imaArr = @[faceImage];
    [HUD showLoading:nil];
    [UpImagePL updateToByGoodsImgArr:imaArr WithReturnBlock:^(id returnValue) {
        NSMutableDictionary *setDic = [_infoDic mutableCopy];
        [setDic setObject:returnValue[@"result"]  forKey:@"photo"];
        [self upAllInfoWithDic:setDic];
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    } andImageType:@"1"];
}



- (void)upAllInfoWithDic:(NSDictionary *)dic{
    [[UserPL shareManager] userUserSaveUserInfoWithDic:dic WithReturnBlock:^(id returnValue) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MineVcShouldRefresh object:nil];
        [HUD cancel];
        [HUD show:@"保存成功"];
        
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    }];
    
    
}

#pragma mark - 选取照片


-(void)shangchuan
{
    // [self pushImagePickerController];
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
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        appdelegate.window.rootViewController.definesPresentationContext = YES;
        [appdelegate.window.rootViewController presentViewController:self.imagePickerVc  animated:YES completion:nil];
        
       
        
      //  [self presentViewController:self.imagePickerVc animated:YES completion:nil];
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
    // 2. 在这里设置imagePickerVc的外观 naviBgColor
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
    
    [self upfaceImaWithIma:image];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
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
     [self upfaceImaWithIma:photos[0]];
    
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
}


#pragma mark ========= get


-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TABBAR_HEIGHT) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.backgroundColor = UIColorFromRGB(BackColorValue);
        _ListTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ListTab.estimatedRowHeight = 0;
        _ListTab.sectionHeaderHeight = 0.01;
        _ListTab.sectionFooterHeight = 0.01;
        _ListTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMineInfo)];
        //        _ListTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadmoreData)];
        if (@available(iOS 11.0, *)) {
            _ListTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _ListTab;
    
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        
        // set appearance / 改变相册选择页的导航栏外观
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
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
