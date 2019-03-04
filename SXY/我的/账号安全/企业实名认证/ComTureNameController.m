//
//  ComTureNameController.m
//  SXY
//
//  Created by yh f on 2018/11/22.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ComTureNameController.h"
#import "InputViewController.h"
#import "SetUpInfoController.h"
#import "ChoseTypeController.h" //选择身份

#import "ComSafeCell.h"
#import "SafeImputCell.h"

#import "ComTureModel.h"


@interface ComTureNameController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) BaseTableView *ListTab;

@end

@implementation ComTureNameController{
    UIImageView *_faceIma;

    NSMutableArray *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.title = @"企业信息";
    [self setBarBackBtnWithImage:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserTypeHaveChosed:) name:@"UserTypeHaveChosed" object:nil];
    [self initUI];
    [self initDatas];
}




- (void)initUI{
    
    _faceIma = [[UIImageView alloc]init];
    _faceIma.clipsToBounds = YES;
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    
    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 40) color:UIColorFromRGB(0xf2f2f2)];
    [self.view addSubview:topView];
    UILabel *toplab= [BaseViewFactory labelWithFrame:CGRectMake(24, 0, ScreenWidth-48, 40) textColor:UIColorFromRGB(0x939393) font:APPBLODFONTT(13) textAligment:NSTextAlignmentLeft andtext:@"完成企业认证，您将获得更多权益并提升信任度"];
    [topView addSubview:toplab];
    
   [self.view addSubview:self.ListTab];
    UIButton * setBtn = [BaseViewFactory buttonWithFrame:CGRectMake(28, ScreenHeight - NaviHeight64-62, ScreenWidth-56, 44) font:APPFONT16 title:@"下一步" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:setBtn];
    [setBtn addTarget:self action:@selector(setAllInfo) forControlEvents:UIControlEventTouchUpInside];
    setBtn.layer.cornerRadius = 22;
}


- (void)initDatas{
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    NSArray *titleArr = @[@"公司LOGO",@"*公司名称",@"*公司地址",@"*联系方式",@"*主营产品",@"*企业类别",@"公司简介"];
    NSArray *plaArr = @[@"点击上传",@"请输入公司名称",@"请输入公司地址",@"请输入联系方式",@"请输入主营产品",@"请选择",@"请输入公司简介"];
    NSArray *upstr2 = @[@"logo",@"storeName",@"",@"goodsWeight",@"inv",@"goodsUnit",@"component"];
 //   NSArray *cellTYpe2 = @[@"1",@"2",@"2",@"2",@"2",@"1",@"2"];

    for (int i = 0; i<titleArr.count; i++) {
        ComTureModel *model = [[ComTureModel alloc]init];
        model.Title = titleArr[i];
        model.plaName = plaArr[i];
        model.upstr = upstr2[i];
        [_dataArr addObject:model];
    }
    [self.ListTab reloadData];
    
    
}



- (void)setAllInfo{
    
//    if (!_faceIma.image) {
//        [HUD show:@"请上传公司logo"];
//        return;
//    }
    for (int i = 1; i<_dataArr.count; i++) {
        ComTureModel *model  = _dataArr[i];
        if (model.value1.length<=0&&![model.Title isEqualToString:@"公司简介"]) {
            [HUD show:[NSString stringWithFormat:@"请上传%@",[model.Title stringByReplacingOccurrencesOfString:@"*" withString:@""]]];
            return;
        }
    }
    NSMutableDictionary *setDic = [[NSMutableDictionary alloc]init];
    for (int i = 1; i<_dataArr.count; i++) {
        ComTureModel *model  = _dataArr[i];
        if (i ==2) {
            NSArray *arr = [model.adressId componentsSeparatedByString:@"  "];
            NSArray *arr1 = [model.value1 componentsSeparatedByString:@"  "];

            if (arr.count<3||arr1.count<3) {
                [HUD show:@"地址选择出错，请重新选择"];
                return;
            }
            //地址
            [setDic setObject:arr1[0] forKey:@"provinceName"];
            [setDic setObject:arr[0] forKey:@"provinceIndex"];
            [setDic setObject:arr1[1] forKey:@"cityName"];
            [setDic setObject:arr[1] forKey:@"cityIndex"];
            [setDic setObject:arr1[2] forKey:@"areaName"];
            [setDic setObject:arr[2] forKey:@"areaIndex"];
            [setDic setObject:model.value2 forKey:@"detailAddress"];

        }else if (i ==3){
             //联系方式
             [setDic setObject:model.value1 forKey:@"linkPhone"];
            
             [setDic setObject:model.value2 forKey:@"linkMobile"];

        }else if (i ==5){
             //企业类别
            [setDic setObject:model.value1 forKey:@"companyType"];
            [setDic setObject:model.value2 forKey:@"userKind"];
            [setDic setObject:model.value3 forKey:@"signature"];


        }else{
            [setDic setObject:model.value1 forKey:model.upstr];
            
        }
    }
    
    SetUpInfoController *sevc = [[SetUpInfoController alloc]init];
    sevc.setDic = setDic;
    sevc.logoIma = _faceIma.image;
    [self.navigationController pushViewController:sevc animated:YES];
}



#pragma mark ======= tabbleviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *SafeCellId = @"topSafeCellId";
        ComSafeCell  *cell = [tableView dequeueReusableCellWithIdentifier:SafeCellId];
        if (!cell) {
            cell = [[ComSafeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SafeCellId];
            [cell.contentView addSubview:_faceIma];
            _faceIma.frame = CGRectMake(ScreenWidth-126, 8, 40, 40);
        }
        cell.model = _dataArr[indexPath.row];
        return cell;
    }else if (indexPath.row == 1||indexPath.row == 4||indexPath.row == 6){
        static NSString *SafeCellId = @"inputcellid";
        SafeImputCell  *cell = [tableView dequeueReusableCellWithIdentifier:SafeCellId];
        if (!cell) {
            cell = [[SafeImputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SafeCellId];
        }
        cell.model = _dataArr[indexPath.row];
        return cell;
        
        
    }
    
    
    
    static NSString *SafeCellId = @"SafeCellId";
    ComSafeCell  *cell = [tableView dequeueReusableCellWithIdentifier:SafeCellId];
    if (!cell) {
        cell = [[ComSafeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SafeCellId];
    }
    cell.model = _dataArr[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
         [self chosePhoto];
        return;
    }else if (indexPath.row == 5){
        //选择身份
        ChoseTypeController *choseVC= [[ChoseTypeController alloc]init];
        [self.navigationController pushViewController:choseVC animated:YES];
         return;
    }else if (indexPath.row == 1||indexPath.row == 4||indexPath.row == 6){
        return;
    }
    
    
    InputViewController *inputVc = [[InputViewController alloc]init];
    inputVc.model = _dataArr[indexPath.row];
    inputVc.returnBlock = ^(ComTureModel *model) {
        [self.ListTab reloadData];
    };
    [self.navigationController pushViewController:inputVc animated:YES];
    
  
    
}




//选取身份
- (void)UserTypeHaveChosed:(NSNotification *)notification{
    
    NSDictionary *dic = notification.object;
    ComTureModel *model = _dataArr[5];
    model.value1 = dic[@"userType"];
    model.value2 = dic[@"userKind"];
    model.value3 = dic[@"memo"];

    [self.ListTab reloadData];
    
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark ======= 选取logo


-(void)chosePhoto
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
        _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
    
}

- (void)pushImagePickerController {
    //初始化UIImagePickerController类
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    //判断数据来源为相册
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //设置代理
    picker.delegate = self;
    //打开相册
    [self presentViewController:picker animated:YES completion:nil];
    
}

//选择完成回调函数
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (!image ) {
        return;
    }
    _faceIma.image = image;
}





#pragma mark ======= get

-(BaseTableView *)ListTab{
    
    
    if (!_ListTab) {
        _ListTab = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-NaviHeight64-120) style:UITableViewStylePlain];
        _ListTab.delegate = self;
        _ListTab.dataSource = self;
        _ListTab.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _ListTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ListTab.estimatedRowHeight = 0;
        _ListTab.sectionHeaderHeight = 0.01;
        _ListTab.sectionFooterHeight = 0.01;
        //        _ListTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadListDatas)];
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
        _imagePickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // set appearance / 改变相册选择页的导航栏外观
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9.0, *)) {
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

@end
