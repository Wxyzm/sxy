//
//  MineInfoController.m
//  SXY
//
//  Created by yh f on 2018/12/26.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MineInfoController.h"
#import "NameChangeController.h"
#import "ChangeAdressController.h"

@interface MineInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;


@end

@implementation MineInfoController{
    
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_locaLab;
    UILabel *_comLab;
    NSDictionary *_infoDic;
    
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self initUI];
    [self loadUserInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImageView *tmp=[self findNavBarBottomLine:navigationBar];
    tmp.hidden=YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImageView *tmp=[self findNavBarBottomLine:navigationBar];
    tmp.hidden=NO;
}

- (void)initUI{
    
    
    
    _faceIma = [[UIImageView alloc]init];
    _faceIma.frame = CGRectMake(ScreenWidth-98, 8, 40, 40);
    [self.view addSubview:_faceIma];
    _faceIma.layer.cornerRadius = 20;
    _faceIma.clipsToBounds = YES;
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    
    _nameLab =[BaseViewFactory labelWithFrame:CGRectMake(100, 56, ScreenWidth-100-58, 56) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentRight andtext:@""];
    [self.view addSubview:_nameLab];
    
    _locaLab=[BaseViewFactory labelWithFrame:CGRectMake(100, 112, ScreenWidth-100-35, 56) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentRight andtext:@"未认证"];
    [self.view addSubview:_locaLab];
    
    _comLab=[BaseViewFactory labelWithFrame:CGRectMake(100, 168, ScreenWidth-100-35, 56) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentRight andtext:@"未认证"];
    [self.view addSubview:_comLab];
    NSArray *titleArr = @[@"头像",@"昵称",@"地区",@"企业"];
    for (int i = 0; i<4; i++)
    {
        UILabel *leLab = [BaseViewFactory labelWithFrame:CGRectMake(24, 56 *i, 200, 56) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:titleArr[i]];
        [self.view addSubview:leLab];
        if (i<2) {
            UIImageView *right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right"]];
            [self.view addSubview:right];
            right.frame = CGRectMake(ScreenWidth-48, 10+56*i, 24, 36);
            
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000 +i;
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 56*i, ScreenWidth, 56);
    }
    
    UIButton *logoutBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT(16) title:@"退出登录" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:logoutBtn];
    logoutBtn.layer.cornerRadius = 22;
    [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    logoutBtn.frame = CGRectMake(32, 280, ScreenWidth-64, 44);
}

- (void)refreshUIWithDic:(NSDictionary *)infoDic{
    
    [_faceIma sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:[infoDic objectForKey:@"photo"] andisThumb:YES] placeholderImage:[UIImage imageNamed:@"faceempty"]];
    _nameLab.text = [infoDic objectForKey:@"name"];
        NSString *loca = [infoDic objectForKey:@"cityName"]?[infoDic objectForKey:@"cityName"]:@"";
    NSString *com = [infoDic objectForKey:@"company"]?[infoDic objectForKey:@"company"]:@"";
    if (loca.length<=0) {
        _locaLab.textColor = UIColorFromRGB(LitterBlackColorValue);
    }else{
        _locaLab.textColor = UIColorFromRGB(BlackColorValue);

    }
    if (com.length<=0) {
        _comLab.textColor = UIColorFromRGB(LitterBlackColorValue);
    }else{
        _comLab.textColor = UIColorFromRGB(BlackColorValue);
        
    }
    
    
    _locaLab.text = loca.length>0?loca:@"未认证";
    _comLab.text = com.length>0?com:@"未认证";

    
}


- (void)logoutBtnClick{
    [[UserPL shareManager] logout];
    
}

#pragma mark ======= 加载数据

- (void)loadUserInfo{
    User *user = [[UserPL shareManager] getLoginUser];
    NSDictionary *dic = @{@"id":user.userId};
    [[UserPL shareManager] userUserfindUserByIdWithDic:dic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _infoDic = returnValue[@"result"];
        [self refreshUIWithDic:returnValue[@"result"]];
        
    } andErrorBlock:^(NSString *msg) {
        
    }];
  
}

#pragma mark ======= 按钮点击

- (void)btnCLick:(UIButton *)btn{
    
    switch (btn.tag-1000) {
        case 0:{
            //头像
             [self shangchuan];
            break;
        }
        case 1:{
            //昵称
            NameChangeController *changeVc = [[NameChangeController alloc]init];
            changeVc.returnBlock = ^(NSString *nameStr) {
                _nameLab.text = nameStr;
            };
            changeVc.infoDic = _infoDic;
            [self.navigationController pushViewController:changeVc animated:YES];
            break;
        }
        case 2:{
            //
            ChangeAdressController*changeVc = [[ChangeAdressController alloc]init];
            changeVc.returnBlock = ^(NSString * _Nonnull cityStr) {
                _locaLab.text = cityStr;
            };
            changeVc.infoDic = _infoDic;
            [self.navigationController pushViewController:changeVc animated:YES];
            break;
        }
        case 3:{
            //公司认证
            break;
        }
        default:
            break;
    }
    
    
    
}

#pragma mark ======= 上传头像

- (void)upfaceImaWithIma:(UIImage *)faceImage{
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
        [self loadUserInfo];
    
    } withErrorBlock:^(NSString *msg) {
          [HUD cancel];
    }];
 
    
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
    [self upfaceImaWithIma:image];
}











- (UIImageView *)findNavBarBottomLine:(UIView *)view{
    if ([view isKindOfClass:[UIImageView class]]&&view.bounds.size.height<1) {
        return (UIImageView *)view;
    }
    for (UIView *subView in view.subviews) {
        UIImageView *imageView=[self findNavBarBottomLine:subView];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}







#pragma mark ======= get

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
