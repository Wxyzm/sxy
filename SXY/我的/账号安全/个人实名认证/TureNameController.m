//
//  TureNameController.m
//  SXY
//
//  Created by yh f on 2018/11/22.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "TureNameController.h"
#import "TureImageView.h"
@interface TureNameController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) TureImageView *upImageView;    //正反面
@property (nonatomic,strong) TureImageView *downImageView;    //正反面
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@end

@implementation TureNameController{
    UITextField *_nameTxt;
    UITextField *_idCardTxt;
    UIButton *_setBtn;
    BOOL  _isUpIdcard;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.title = @"实名认证";
    [self setBarBackBtnWithImage:nil];
    [self initUI];
}


- (void)initUI{
    
    UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectMake(24, 0, 60, 56) textColor:UIColorFromRGB(0x939393) font:APPBLODFONTT(14) textAligment:NSTextAlignmentLeft andtext:@"真实姓名"];
    [self.view addSubview:nameLab];
    
    UILabel *idcardLab = [BaseViewFactory labelWithFrame:CGRectMake(24, 56, 60, 56) textColor:UIColorFromRGB(0x939393) font:APPBLODFONTT(14) textAligment:NSTextAlignmentLeft andtext:@"身份证号"];
    [self.view addSubview:idcardLab];
    
    _nameTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(100, 0, ScreenWidth-124, 56) font:APPFONT14 placeholder:@"请输入姓名" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0x939393) delegate:self];
    [self.view addSubview:_nameTxt];

    _idCardTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(100, 56, ScreenWidth-124, 56) font:APPFONT14 placeholder:@"请输入身份证号码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0x939393) delegate:self];
    [self.view addSubview:_idCardTxt];
    
    CGFloat Width = (ScreenWidth -48)/2;
    _upImageView = [[TureImageView alloc]initWithFrame:CGRectMake(24, 134, Width, 110)];
    _upImageView.Lab.text = @"添加正面";
    [self.view addSubview:_upImageView];
    
    

    _downImageView  = [[TureImageView alloc]initWithFrame:CGRectMake(Width+24+5, 134, Width, 110)];
    _downImageView.Lab.text = @"添加反面";
    [self.view addSubview:_downImageView];
    
   

   

    UILabel *memolab =[BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x939393) font:APPBLODFONTT(12) textAligment:NSTextAlignmentLeft andtext:@"·完成实名认证，更好保护您的账号安全\n·每个身份证只能绑定一个账号\n·实名信息一经验证无法修改"];
    [self.view addSubview:memolab];
   
    memolab.sd_layout
    .leftSpaceToView(self.view, 24)
    .topSpaceToView(self.view, 260)
    .rightSpaceToView(self.view, 24)
    .autoHeightRatio(0);
    
    
    _setBtn = [BaseViewFactory buttonWithFrame:CGRectMake(28, ScreenHeight - NaviHeight64-62, ScreenWidth-56, 44) font:APPFONT16 title:@"提交认证" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:_setBtn];
    _setBtn.layer.cornerRadius = 22;
    [_setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //选择图片
    WeakSelf(self);
    _upImageView.reurnBlock = ^(NSInteger tag) {
        _isUpIdcard = YES;
        if (tag == 0) {
             [weakself chosePhoto];
        }else{
            weakself.upImageView.upImageView.image = nil;
            [weakself.upImageView.btn setImage:nil forState:UIControlStateNormal];
        }
    };
    _downImageView.reurnBlock = ^(NSInteger tag) {
        _isUpIdcard = NO;
        if (tag == 0) {
             [weakself chosePhoto];
        }else{
            weakself.downImageView.upImageView.image = nil;
            [weakself.downImageView.btn setImage:nil forState:UIControlStateNormal];
        }
    };
    
}

#pragma mark= ====== 提交认证

- (void)setBtnClick{
    
    if (_nameTxt.text.length<=0) {
        [HUD show:@"请输入姓名"];
        return;
    }
    
    if (_idCardTxt.text.length<=0) {
        [HUD show:@"请输入身份证号码"];
        return;
    }
    if (!_upImageView.upImageView.image) {
        [HUD show:@"请选择身份证正面照片"];
        return;
    }
    if (!_downImageView.upImageView.image) {
        [HUD show:@"请选择身份证反面照片"];
        return;
    }
    NSArray *imageArr = @[_upImageView.upImageView.image,_downImageView.upImageView.image];
    [HUD showLoading:nil];
    [UpImagePL updateToByGoodsImgArr:imageArr WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [self upAllInfoWithImaStr:returnValue[@"result"]];
        
        
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    } andImageType:@"2"];
    
    
    

}

- (void)upAllInfoWithImaStr:(NSString *)imaStr{
    
    NSArray *arr = [imaStr componentsSeparatedByString:@","];
    if (arr.count<=1) {
        [HUD cancel];
        [HUD show:@"照片上传失败"];
        return;
    }
    NSDictionary *dic = @{@"idCard":_idCardTxt.text,
                          @"realName":_nameTxt.text,
                          @"idCardFont":arr[0],
                          @"idCardBack":arr[1]
                          };
    [[UserPL shareManager] userUserSubmitRealNameAuthWithDic:dic WithReturnBlock:^(id returnValue) {
        [HUD cancel];
        NSLog(@"%@",dic);
        [HUD show:@"您的身份认证已提交，请等待审核"];
        [[NSNotificationCenter defaultCenter] postNotificationName:MineVcShouldRefresh object:nil];

        [self.navigationController popViewControllerAnimated:YES];
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    }];
    
}




#pragma mark ======= 选取照片

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


#pragma mark ======= 拍照

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
    if (_isUpIdcard) {
        //正面
        _upImageView.upImageView.image = image;
    }else{
        //反面
        _downImageView.upImageView.image = image;

    }
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
