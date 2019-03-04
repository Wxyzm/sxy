//
//  SetUpInfoController.m
//  SXY
//
//  Created by yh f on 2018/12/29.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "SetUpInfoController.h"
#import "TureImageView.h"
#import "PicModel.h"

@interface SetUpInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)TureImageView *bussPhotoView;
@property (nonatomic,strong)TureImageView *upCardView;
@property (nonatomic,strong)TureImageView *downCardView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;


@end

@implementation SetUpInfoController
{
    NSInteger _chosetype;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传认证资料";
    [self setBarBackBtnWithImage:nil];
     [self initUI];
    
}

- (void)initUI{
    
    [self createBackScrollView];
    self.backView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 40) color:UIColorFromRGB(0xf2f2f2)];
    [self.view addSubview:topView];
    UILabel *toplab= [BaseViewFactory labelWithFrame:CGRectMake(24, 0, ScreenWidth-48, 40) textColor:UIColorFromRGB(0x939393) font:APPBLODFONTT(13) textAligment:NSTextAlignmentLeft andtext:@"完成企业认证，您将获得更多权益并提升信任度"];
    [topView addSubview:toplab];
    

    UILabel * bussLab = [BaseViewFactory labelWithFrame:CGRectMake(12, 40, 150, 56) textColor:UIColorFromRGB(BlackColorValue) font:APPBLODFONTT(14) textAligment:NSTextAlignmentLeft andtext:@"*营业执照"];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"*营业执照"];
    NSRange range = [@"*营业执照" rangeOfString:@"*"];
    if (range.length>0) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe74922) range:range];
        bussLab.attributedText = attrStr;
    }
    [self.backView addSubview:bussLab];

    CGFloat Width = (ScreenWidth -48)/2;
    _bussPhotoView = [[TureImageView alloc]initWithFrame:CGRectMake(24, 96, Width, 110)];
    _bussPhotoView.Lab.text = @"添加营业执照";

    [self.backView addSubview:_bussPhotoView];

    
    UILabel * idcardLab = [BaseViewFactory labelWithFrame:CGRectMake(12, 216, 150, 56) textColor:UIColorFromRGB(BlackColorValue) font:APPBLODFONTT(14) textAligment:NSTextAlignmentLeft andtext:@"*法人身份证"];
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:@"*法人身份证"];
    NSRange range1 = [@"*法人身份证" rangeOfString:@"*"];
    if (range1.length>0) {
        [attrStr1 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe74922) range:range1];
        idcardLab.attributedText = attrStr1;
    }
    [self.backView addSubview:idcardLab];
    
     UILabel * showLab = [BaseViewFactory labelWithFrame:CGRectMake(110, 216, 150, 56) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPBLODFONTT(11) textAligment:NSTextAlignmentLeft andtext:@"请上传清晰的正反面"];
    [self.backView addSubview:showLab];

    
    _upCardView = [[TureImageView alloc]initWithFrame:CGRectMake(24, 272, Width, 110)];
    _upCardView.Lab.text = @"添加正面";
    [self.backView addSubview:_upCardView];
    
    _downCardView = [[TureImageView alloc]initWithFrame:CGRectMake(Width+24+5, 272, Width, 110)];
    _downCardView.Lab.text = @"添加反面";
    [self.backView addSubview:_downCardView];
    
    
    
    UILabel * memoLab = [BaseViewFactory labelWithFrame:CGRectMake(20, 400, ScreenWidth-40, 70) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPBLODFONTT(14) textAligment:NSTextAlignmentLeft andtext:@"·每个账号只能对应一个企业\n·企业认证一经验证无法修改\n·请填写真实信息，避免封号"];
    [self.backView addSubview:memoLab];
    memoLab.numberOfLines = 0;
    
    
    

    UIButton * setBtn = [BaseViewFactory buttonWithFrame:CGRectMake(28, ScreenHeight - NaviHeight64-62, ScreenWidth-56, 44) font:APPFONT16 title:@"下一步" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:setBtn];
    setBtn.layer.cornerRadius = 22;
    [setBtn addTarget:self action:@selector(setAllInfo) forControlEvents:UIControlEventTouchUpInside];
    
    //选择图片
    WeakSelf(self);
    _bussPhotoView.reurnBlock = ^(NSInteger tag) {
        _chosetype = 0;
        if (tag == 0) {
            [weakself chosePhoto];
        }else{
            _chosetype = 0;
            weakself.bussPhotoView.upImageView.image = nil;
            [weakself.bussPhotoView.btn setImage:nil forState:UIControlStateNormal];
        }
    };
    _upCardView.reurnBlock = ^(NSInteger tag) {
        _chosetype = 1;
        if (tag == 0) {
            [weakself chosePhoto];
        }else{
            
            weakself.upCardView.upImageView.image = nil;
            [weakself.upCardView.btn setImage:nil forState:UIControlStateNormal];
        }
    };
    _downCardView.reurnBlock = ^(NSInteger tag) {
        _chosetype = 2;
        if (tag == 0) {
            [weakself chosePhoto];
        }else{
            weakself.downCardView.upImageView.image = nil;
            [weakself.downCardView.btn setImage:nil forState:UIControlStateNormal];
        }
    };
    
}




- (void)setAllInfo{
    
    if (!_bussPhotoView.upImageView.image) {
        [HUD show:@"请上传营业执照"];
        return;
    }
    if (!_upCardView.upImageView.image) {
        [HUD show:@"请上身份证正面"];
        return;
    }
    if (!_downCardView.upImageView.image) {
        [HUD show:@"请上身份证反面"];
        return;
    }
    NSArray *imaArr;
    if (_logoIma) {
        imaArr = @[_bussPhotoView.upImageView.image,_upCardView.upImageView.image,_downCardView.upImageView.image,_logoIma];
    }else{
        imaArr = @[_bussPhotoView.upImageView.image,_upCardView.upImageView.image,_downCardView.upImageView.image];
    }
    

    [HUD showLoading:nil];
    [UpImagePL updateToByGoodsImgArr:imaArr WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [self upAllInfoWithImaStr:returnValue[@"result"]];

        
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    } andImageType:@"2"];
    
    
    
    
}
- (void)upAllInfoWithImaStr:(NSString *)imaStr{
    
    NSArray *arr = [imaStr componentsSeparatedByString:@","];
    [_setDic setObject:arr[0] forKey:@"businessLicense"];
    [_setDic setObject:arr[1] forKey:@"cardfont"];
    [_setDic setObject:arr[2] forKey:@"cardback"];
    if (arr.count==4) {
        //logo
        [_setDic setObject:arr[3] forKey:@"logo"];
    }
    [_setDic setObject:@"2" forKey:@"imageType"];
    [[UserPL shareManager] userUserSubmitCompanyAuthWithDic:_setDic WithReturnBlock:^(id returnValue) {
        [HUD cancel];
        [[NSNotificationCenter defaultCenter] postNotificationName:MineVcShouldRefresh object:nil];
        [HUD show:@"您的身份认证已提交，请等待审核"];
        [self performSelector:@selector(back) withObject:nil afterDelay:1.2];
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
    if (_chosetype == 0)
    {
        //正面
        _bussPhotoView.upImageView.image = image;
    }
    else if (_chosetype == 1)
    {
        _upCardView.upImageView.image = image;
    }
    else
    {
        //反面
        _downCardView.upImageView.image = image;
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



- (void)back{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}




@end
