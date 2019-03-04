//
//  ProBannerView.m
//  SXY
//
//  Created by yh f on 2018/11/20.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ProBannerView.h"
#import "SDCycleScrollView.h"
#import "GoodsModel.h"
#import "SpecListModel.h"
@interface ProBannerView ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)SDCycleScrollView *bannerView;


@end
@implementation ProBannerView{
    UILabel *_nameLab;      //名称
    UILabel *_tabLab;       //标签
    UILabel *_priceLab;     //价格
    UILabel *_techLab;      //工艺
    UIImageView *_tabIma;
    
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        [self setUP];
    }
    
    return self;
}

- (void)setUP{
    
    [self addSubview:self.bannerView];
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentLeft andtext:@""];
    [self addSubview:_nameLab];
    
    _tabIma = [[UIImageView alloc]init];
    _tabIma.backgroundColor = [UIColor lightGrayColor];
    _tabIma.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_tabIma];
    _tabIma.clipsToBounds = YES;
    _tabIma.backgroundColor = UIColorFromRGB(BackColorValue);
    _tabIma.image = [UIImage imageNamed:@"lable_xianhuo"];
    
    _tabLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 36, 16) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(10) textAligment:NSTextAlignmentCenter andtext:@""];
    [_tabIma addSubview:_tabLab];
    
    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(28) textAligment:NSTextAlignmentLeft andtext:@""];
    [self addSubview:_priceLab];
    
    _techLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@""];
    [self addSubview:_techLab];
    
    _tabIma.sd_layout
    .rightSpaceToView(self, 24)
    .topSpaceToView(self.bannerView, 28)
    .widthIs(36)
    .heightIs(16);
    
    _nameLab.sd_layout
    .leftSpaceToView(self, 24)
    .topSpaceToView(self.bannerView, 28)
    .rightSpaceToView(_tabIma, 4)
    .autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    
    
    _techLab.sd_layout
    .rightSpaceToView(self, 24)
    .topSpaceToView(_nameLab, 16)
    .leftSpaceToView(self, 24)
    .heightIs(16);
    
    
    
    _priceLab.sd_layout
    .leftSpaceToView(self, 24)
    .bottomSpaceToView(self, 20)
    .rightSpaceToView(self, 24)
    .heightIs(36);
    
    
}



- (void)setModel:(GoodsModel *)model{
    _model = model;
    NSString *patten = @"";
    if (model.specDTOList.count>0) {
        SpecListModel *tmodel = model.specDTOList[0];
        patten  = tmodel.pattern;
    }
    _nameLab.text = [GlobalMethod GoodsnameWithName:model.goodsName andPattern:patten];

    SpecListModel *specDTOList;
    if (model.specDTOList.count>0) {
        specDTOList = model.specDTOList[0];
    }
    _priceLab.text = [GlobalMethod GoodsPriceWithPrice:model.minPrice andUnit:specDTOList.goodsUnit];
    _techLab.text = model.goodsCategory;
    if ([model.goodsModule intValue]==0) {
        //求购
        _tabLab.text = @"求购";
        _tabIma.image = [UIImage imageNamed:@"lable_xianhuo copy"];

    }else if ([model.goodsModule intValue]==1){
        //现货
         _tabLab.text = @"现货";
        _tabIma.image = [UIImage imageNamed:@"lable_xianhuo"];

    }else if ([model.goodsModule intValue]==2){
        //供应
        _tabLab.text = @"供应";
        _tabIma.image = [UIImage imageNamed:@"lable_gongying"];

        
    }else{
        _tabIma.hidden = YES;
    }
    
    
    NSMutableArray *urlArr = [NSMutableArray arrayWithCapacity:0];
    if (model.pictureName.length>0) {
        NSArray *arr = [model.pictureName componentsSeparatedByString:@","];
        for (NSString *urlStr in arr) {
            NSURL *url = [GlobalMethod returnUrlStrWithImageName:urlStr andisThumb:YES];
            [urlArr addObject:[NSString stringWithFormat:@"%@",url]];
        }
    }
    self.bannerView.imageURLStringsGroup = urlArr;

    
}




#pragma mark ===== get
-(SDCycleScrollView *)bannerView{
    
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth) imageURLStringsGroup:nil]; // 模拟网络延时情景
        _bannerView.pageDotColor = UIColorFromRGB(BackColorValue);
        _bannerView.currentPageDotColor = UIColorFromRGB(NAVColorValue);
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.delegate = self;
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _bannerView;
    
    
}




@end
