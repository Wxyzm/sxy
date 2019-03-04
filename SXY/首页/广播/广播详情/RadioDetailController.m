//
//  RadioDetailController.m
//  SXY
//
//  Created by souxiuyun on 2019/1/22.
//  Copyright © 2019 XX. All rights reserved.
//

#import "RadioDetailController.h"
#import "WantBuyModel.h"
#import "HUPhotoBrowser.h"
#import <UShareUI/UShareUI.h>

@interface RadioDetailController ()

@end

@implementation RadioDetailController{
    
    WantBuyModel *_model;
    NSMutableArray *_imaArr;
    
    UIImageView *_faceIma; //头像
    UILabel *_timeLab;     //剩余时间
    UILabel *_nameLab;     //昵称
    UILabel *_titleLab;    //标题
    UILabel *_detailLab;   //详情
    YLButton *_collectBtn; //c收藏
    UIButton *_connectBtn; //联系
    UIImageView *_labIma;  //仅支持现货
    YLButton* _shareBtn;     //分享
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _imaArr = [NSMutableArray arrayWithCapacity:0];
    [self createRightNavigationItemWithImage:@"share"];
    [self initUI];
    [self loadDetail];
    [self judgeIscollect];
}


#pragma mark ======= 加载详情
- (void)loadDetail
{
    NSDictionary *dic = @{@"id":_radioId};
    [CirclePL Circle_CircleFindCircleByIdDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _model = [WantBuyModel mj_objectWithKeyValues:returnValue];
        [self initUIWithWantBuyModel:_model];
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
}


/**
 initUI
 */
- (void)initUI{
    [self createBackScrollView];
    self.backView.frame = CGRectZero;
    self.backView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    
    _faceIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"faceempty"]];
    [self.backView addSubview:_faceIma];
    _faceIma.layer.cornerRadius = 24;
    _faceIma.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [_faceIma addGestureRecognizer:tapGesture];
    _faceIma.userInteractionEnabled = YES;
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.backView addSubview:_nameLab];
    
    _timeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentRight andtext:@""];
    [self.backView addSubview:_timeLab];
    
    _labIma =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lable_xianhuo"]];
    [self.backView addSubview:_labIma];
    _labIma.frame = CGRectZero;
    UILabel *lab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(9) textAligment:NSTextAlignmentCenter andtext:@"仅支持现货"];
    [_labIma addSubview:lab];
    lab.frame = CGRectMake(0, 0, 60, 14);
    _labIma.hidden = YES;
    _labIma.frame = CGRectMake(84, 87, 60, 14);
    
    _titleLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.backView addSubview:_titleLab];
   
    _detailLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x9f9da1) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.backView addSubview:_detailLab];
    
    for (int i = 0; i<9; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"faceempty"];
        imageView.clipsToBounds = YES;
        [self.view addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectZero;
        [_imaArr addObject:imageView];
    }
    _collectBtn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(LitterBlackColorValue) cornerRadius:0 andtarget:self action:@selector(collectBtnClick) titleFont:APPFONT16 title:@"收藏"];
    [_collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [_collectBtn setImageRect:CGRectMake(0, 25, 18, 18)];
    [_collectBtn setTitleRect:CGRectMake(28, 0, 52, 68)];
    _collectBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _collectBtn.frame = CGRectMake(34, ScreenHeight-NaviHeight64-69, 80, 68);
    [self.view addSubview:_collectBtn];

    YLButton *conBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT(19) title:@"立即联系" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:conBtn];
    conBtn.frame = CGRectMake(130, ScreenHeight-NaviHeight64-57, ScreenWidth-130-34, 44);
    conBtn.layer.cornerRadius = 22;
    [conBtn addTarget:self action:@selector(conBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight-NaviHeight64-70, ScreenWidth, 1) color:UIColorFromRGB(BackColorValue)];
    [self.view addSubview:lineView];
    
    
}

#pragma mark ========== 刷新UI

- (void)initUIWithWantBuyModel:(WantBuyModel *)model{
    
    self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-70-NaviHeight64);

    _faceIma.frame = CGRectMake(18, 20, 48, 48);
    NSURL *urlStr = [GlobalMethod returnUrlStrWithImageName:model.userPhoto andisThumb:YES];
    [_faceIma sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"faceempty"]];
    _nameLab.text = model.userName;
    _nameLab.frame = CGRectMake(84, 23, ScreenWidth-84-40, 17);
    _timeLab.text = model.expirationtime;
    _timeLab.frame = CGRectMake(120, 23, ScreenWidth-136, 17);
    _titleLab.text = model.title;
    _titleLab.frame = CGRectMake(84 , 58, ScreenWidth-64, 23);
    if (model.label.length>0) {
        _labIma.hidden = NO;
    }else{
        _labIma.hidden = YES;
    }
    
    
    CGFloat  _originY = 120;
    _detailLab.text = model.content;
    CGFloat height = [GlobalMethod heightForString:model.content andWidth:ScreenWidth-64 andFont:APPFONT12];
    _detailLab.frame = CGRectMake(32, 120, ScreenWidth-64, height);
    _originY += height +30;
   
    for (UIImageView *imageView in _imaArr) {
        imageView.hidden = YES;
    }
    
    
    NSArray *arr = [model.pictureName componentsSeparatedByString:@","];
    if (model.pictureName.length<=0) {
        arr = nil;
    }
    CGFloat _ImaW = (ScreenWidth - 64  -20)/3;
    CGFloat _ImaH = _ImaW;
    
    for (int i = 0; i<arr.count; i++)
    {
        UIImageView *imageView = _imaArr[i];
        imageView.hidden = NO;
        int a = i/3;
        int b = i%3;
        imageView.sd_layout
        .leftSpaceToView(self.view, 32+(_ImaW +10)*b)
        .topSpaceToView(_detailLab, 28+(_ImaH +10)*a)
        .widthIs(_ImaW)
        .heightIs(_ImaH);
        
        NSURL *urlStr = [GlobalMethod returnUrlStrWithImageName:arr[i] andisThumb:YES];
        [imageView sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"proempty"]];
                UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageView addSubview:touchBtn];
        [touchBtn addTarget:self action:@selector(touchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        touchBtn.tag = 2000 + i;
        touchBtn.frame = CGRectMake(0, 0, _ImaW, _ImaH);
    }
    
    NSInteger a = arr.count/3;
    self.backView.contentSize = CGSizeMake(ScreenWidth, _originY +(a +1)*((_ImaH +10)));
}

#pragma mark ====== 判断广播是否被收藏
- (void)judgeIscollect{
    
    NSDictionary *dic = @{@"id":_radioId};
    [CollectPL Collect_CollectFindCircleCollectWithDic:dic WithReturnBlock:^(id returnValue) {
        if ([returnValue boolValue]) {
            //已收藏
            [_collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
            [_collectBtn setImage:[UIImage imageNamed:@"collection_select"] forState:UIControlStateNormal];
        }else{
            //未收藏
            [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
            [_collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        }
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
}

#pragma mark ====== 按钮点击

- (void)collectBtnClick{
    
    NSDictionary *dic = @{@"id":_radioId};
    [CollectPL Collect_CollectSaveCircleCollectWithDic:dic WithReturnBlock:^(id returnValue) {
        [self judgeIscollect];
        
    } withErrorBlock:^(NSString *msg) {
        
    }];
}
/**
 跳转用户详情
 */
- (void)clickImage{
    UserHomeController *homeVc = [[UserHomeController alloc]init];
    homeVc.userId = _model.userId;
    [self.navigationController pushViewController:homeVc animated:YES];
    
}


#pragma mark ====== 立即联系

- (void)conBtnBtnClick{
    
    [self gotochatVcWithconversationType:ConversationType_PRIVATE andTitle:_model.userName targetId:_model.userId];
    
}

#pragma mark ====== 分享


-(void)respondToRigheButtonClickEvent{
    [self shareBtnCLickWithModel:_model];
}


/**
 分享
 */
- (void)shareBtnCLickWithModel:(WantBuyModel *)model{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
        
    }];
    
}



- (void)touchBtnClick:(UIButton *)btn{
    
    NSArray *arr = [_model.pictureName componentsSeparatedByString:@","];
    NSMutableArray *imageUrlArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<arr.count; i++) {
        NSString *urlStr =[NSString stringWithFormat:@"%@", [GlobalMethod returnUrlStrWithImageName:arr[i] andisThumb:YES]];
        [imageUrlArr addObject:urlStr];
    }
    UIImageView *imageview = _imaArr[btn.tag - 2000];
    [HUPhotoBrowser showFromImageView:imageview withURLStrings:imageUrlArr placeholderImage:imageview.image atIndex:btn.tag - 2000 dismiss:^(UIImage *image, NSInteger index) {
    }];
    
}



#pragma mark ====== 分享详情


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = @"http://cdn.fyh88.com/upload_development/1-fb36c92d90b87da62e20db9ba1457264.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"搜绣云.绣花供应链服务平台" descr:@"了解绣花上下游行业相关的时尚资讯，为企业“去库存，找工厂，找订单，找辅料，找设备，找花型 ”，提升行业竞争力" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"www.baidu.com";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        // [self alertWithError:error];
    }];
}


@end
