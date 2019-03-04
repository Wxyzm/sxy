//
//  ProDetailController.m
//  SXY
//
//  Created by yh f on 2018/11/20.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ProDetailController.h"
#import "ProBannerView.h"
#import "ProParaMView.h"
#import "GoodsModel.h"
#import "SpecListModel.h"
@interface ProDetailController ()


@property (nonatomic,strong)ProBannerView *proView;

@property (nonatomic,strong)ProParaMView *proParaView;

@end

@implementation ProDetailController{
    
    CGFloat _originY;
    NSMutableArray *_imaArr;
    YLButton* _backbutton;   //返回
    YLButton* _collectBtn;   //收藏
    YLButton* _shareBtn;     //分享
    GoodsModel *_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self createBackScrollView];
    self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-70);
    self.backView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.backView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadGoodsDetail)];
    _imaArr = [NSMutableArray arrayWithCapacity:0];
    [self loadGoodsDetail];
    [self setBarBackBtnWithImage:nil];
   
}

- (void)initUIWithModel:(GoodsModel *)model{
    [self.backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    
    self.proView.model = model;
    [self.backView addSubview:self.proView];
    
    self.proParaView.model = model;
    [self.backView addSubview:self.proParaView];
    WeakSelf(self);
    _proParaView.returnBlock = ^(GoodsModel *model, NSInteger tag) {
        [weakself gotoDetailVc];
    };
    if (model.specDTOList.count<=0) {
        return;
    }
    SpecListModel *speModel = model.specDTOList[0];
    CGFloat weight = [GlobalMethod widthForString:@"备注：" andFont:APPFONT(14)] +35;
    CGFloat height = [GlobalMethod heightForString:speModel.remarks andWidth:ScreenWidth- weight-60 andFont:APPFONT(14)] +20;
    if (height<48) {
        height =48;
    }
    _proParaView.frame = CGRectMake(0, ScreenWidth +165, ScreenWidth, 114 +height +48 *7);
    
    
    _originY = ScreenWidth +165 + 114 +height +48 *7 +17;
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, _originY, ScreenWidth, 6) color:UIColorFromRGB(BackColorValue)];
    [self.backView addSubview:line];
    _originY +=6;
    
    UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(0, _originY, ScreenWidth, 74) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentCenter andtext:@"///   商品详情   ///"];
    [self.backView addSubview:lab];
    NSRange rang = [@"///   商品详情   ///" rangeOfString:@"商品详情"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"///   商品详情   ///"];
    [attStr addAttribute:NSFontAttributeName value:APPFONT(18) range:rang];
    [lab setAttributedText:attStr];
    _originY +=74;
    [_imaArr removeAllObjects];
    CGFloat imaY = _originY;
    NSArray *arr = [model.particularsPicture componentsSeparatedByString:@","];
    for (int i = 0; i<arr.count; i++) {
        UIImageView *ima = [[UIImageView alloc]init];
        ima.image = [UIImage imageNamed:@"proempty"];
        ima.frame = CGRectMake(0, imaY, ScreenWidth, ScreenWidth);
        imaY += ScreenWidth;
        [self.backView addSubview:ima];
        [_imaArr addObject:ima];
    }
    self.backView.contentSize = CGSizeMake(10, imaY +20);
    
    UIView *lineview = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight-70, ScreenWidth, 1) color:UIColorFromRGB(BackColorValue)];
    [self.view addSubview:lineview];
    
    _collectBtn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(LitterBlackColorValue) cornerRadius:0 andtarget:self action:@selector(collectBtnClick) titleFont:APPFONT16 title:@"收藏"];
    [_collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [_collectBtn setImageRect:CGRectMake(0, 25, 18, 18)];
    [_collectBtn setTitleRect:CGRectMake(28, 0, 52, 68)];
    _collectBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _collectBtn.frame = CGRectMake(34, ScreenHeight-69, 80, 68);
    [self.view addSubview:_collectBtn];
    [self judgeIscollect];
    YLButton *conBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT(19) title:@"立即联系" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:conBtn];
    conBtn.frame = CGRectMake(130, ScreenHeight-57, ScreenWidth-130-34, 44);
    conBtn.layer.cornerRadius = 22;
    [conBtn addTarget:self action:@selector(conBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self loadImageWithArr:arr];
   
}
#pragma mark ====== 跳转个人主页
- (void)gotoDetailVc{
    SpecListModel *smodel;
    if (_model.specDTOList.count<=0) {
        return;
    }
    smodel = _model.specDTOList[0];
    UserHomeController *homeVc = [[UserHomeController alloc]init];
    homeVc.userId = smodel.addUser;
    [self.navigationController pushViewController:homeVc animated:YES];
}



#pragma mark ====== 获取图片

- (void)loadImageWithArr:(NSArray *)arr{
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray  *imageArr = [NSMutableArray arrayWithCapacity:0];
    [imageArr addObjectsFromArray:arr];

    for (int i = 0; i<arr.count; i++) {
        __block UIImage *image1 = nil;  //要加一个 __block因为 block代码默认不能改外面的东西（记住语法即可）
        dispatch_group_async(group, queue, ^{
            NSString *url = arr[i];
            NSURL *url1 = [GlobalMethod returnUrlStrWithImageName:url andisThumb:YES];
            NSData *data1 = [NSData dataWithContentsOfURL:url1];
            image1 = [UIImage imageWithData:data1];
            if (!image1) {
                image1 = [UIImage imageNamed:@"proempty"];
            }
            [imageArr replaceObjectAtIndex:i withObject:image1];
        });
    }
    dispatch_group_notify(group, queue, ^{
        // 5.回到主线程显示图片
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGFloat imaY = _originY;

            for (int i = 0; i<arr.count; i++) {
                UIImageView *ima = _imaArr[i];
                UIImage *showImage = imageArr[i];
                ima.image = showImage;
                CGFloat Height = showImage.size.height *ScreenWidth/ showImage.size.width;
                ima.frame = CGRectMake(0, imaY, ScreenWidth, Height);
                imaY+=Height;
            }
            _originY = imaY;
            self.backView.contentSize = CGSizeMake(10, _originY +20);

        });
    });
   

    
}




#pragma mark ====== 获取详情

- (void)loadGoodsDetail{
    
    
    NSDictionary *dic = @{@"id":_goodsId};
    [GEditPL Goods_GoodsFindGoodsByIdWithDic:dic WithReturnBlock:^(id returnValue) {
        [self.backView.mj_header endRefreshing];

        GoodsModel *model = [GoodsModel mj_objectWithKeyValues:returnValue];
        if (model.specDTOList.count>0) {
            SpecListModel *speModel = model.specDTOList[0];
            if (speModel.remarks.length<=0) {
                speModel.remarks = model.goodsRemark;

            }
        }
        _model = model;
        [self initUIWithModel:model];
    } withErrorBlock:^(NSString *msg) {
        [self.backView.mj_header endRefreshing];

    }];

}
#pragma mark ====== 判断商品是否被收藏
- (void)judgeIscollect{
    
    NSDictionary *dic = @{@"id":_goodsId};
    [CollectPL Collect_CollectFindGoodsCollectWithDic:dic WithReturnBlock:^(id returnValue) {
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
#pragma mark ====== 立即联系

- (void)conBtnBtnClick{
    
    [self gotochatVcWithconversationType:ConversationType_PRIVATE andTitle:_model.storeName targetId:_model.storeId];
    
}



#pragma mark ====== 收藏

- (void)collectBtnClick{
    
    NSDictionary *dic = @{@"id":_goodsId};
    [CollectPL Collect_CollectSaveGoodsCollectWithDic:dic WithReturnBlock:^(id returnValue) {
        [self judgeIscollect];
        
    } withErrorBlock:^(NSString *msg) {
        
    }];
}


#pragma mark ====== get

-(ProBannerView *)proView{
    
    if (!_proView) {
        _proView = [[ProBannerView alloc]init];
        [self.backView addSubview:_proView];
        _proView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth +165);
    }
    
    return _proView;
}

-(ProParaMView *)proParaView{
    
    if (!_proParaView) {
        _proParaView = [[ProParaMView alloc]init];
        [self.backView addSubview:_proParaView];
        _proParaView.frame = CGRectMake(0,  ScreenWidth +165, ScreenWidth, 114 +60*8);
    }
    
    return _proParaView;
}
- (void)setBarBackBtnWithImage:(UIImage *)image
{
    UIImage *backImg;
    if (image == nil) {
        backImg = [UIImage imageNamed:@"nav_icon_back_btn"];
    } else {
        backImg = image;
    }
    CGFloat height = 18;
    CGFloat width = height * backImg.size.width / backImg.size.height;
    
   _backbutton = [[YLButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    [_backbutton setImage:backImg forState:UIControlStateNormal];
    [_backbutton addTarget:self action:@selector(respondToLeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [_backbutton setImageRect:CGRectMake(0, 11, width, height)];
    [self.view addSubview:_backbutton];
    _backbutton.frame = CGRectMake(17, STATUSBAR_HEIGHT +14, 30, 40);
  
    
}

@end
