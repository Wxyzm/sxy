//
//  ProListCell.m
//  SXY
//
//  Created by yh f on 2018/11/14.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ProListCell.h"
#import "SpecListModel.h"
@implementation ProListCell{
    
    UIImageView *_faceIma;  //图片
    UILabel *_nameLab;      //名称
    UILabel *_priceLab;     //价格
    UILabel *_techLab;      //工艺
    UILabel *_tabLab;       //标签
    UIImageView *_tabIma;

}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        [self setUP];
    }
    
    return self;
}


- (void)setUP{
    
    CGFloat _width = (ScreenWidth - 50)/2;
    CGFloat _height = _width;

    _faceIma = [[UIImageView alloc] init];
    _faceIma.backgroundColor = [UIColor lightGrayColor];
    _faceIma.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_faceIma];
    _faceIma.clipsToBounds = YES;
    _faceIma.layer.cornerRadius = 4;
    _faceIma.frame = CGRectMake(0, 0, _width, _height);
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    

    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_priceLab];
    
    _techLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_techLab];
    
    _tabIma = [[UIImageView alloc]init];
    _tabIma.backgroundColor = [UIColor lightGrayColor];
    _tabIma.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_tabIma];
    _tabIma.clipsToBounds = YES;
    _tabIma.backgroundColor = UIColorFromRGB(BackColorValue);
    _tabIma.image = [UIImage imageNamed:@"lable_xianhuo"];
    
    _tabLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 36, 16) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(10) textAligment:NSTextAlignmentCenter andtext:@""];
    [_tabIma addSubview:_tabLab];
    
    
    _nameLab.sd_layout
    .leftEqualToView(_faceIma)
    .topSpaceToView(_faceIma, 5)
    .widthIs(_width)
    .heightIs(20);
   
    _techLab.sd_layout
    .leftEqualToView(_faceIma)
    .topSpaceToView(_nameLab, 4)
    .rightEqualToView(_faceIma)
    .heightIs(20);

    
    _priceLab.sd_layout
    .leftEqualToView(_faceIma)
    .rightEqualToView(_faceIma)
    .topSpaceToView(_techLab, 1)
    .heightIs(17);
    
    _tabIma.sd_layout
    .rightSpaceToView(self.contentView, 0)
    .centerYEqualToView(_techLab)
    .widthIs(36)
    .heightIs(16);
 
}


-(void)setGmodel:(GoodsModel *)Gmodel{
    
    _Gmodel = Gmodel;
    NSString *patten = @"";
    if (Gmodel.specDTOList.count>0) {
        SpecListModel *model = Gmodel.specDTOList[0];
        patten  = model.pattern;
    }
    _nameLab.text = [GlobalMethod GoodsnameWithName:Gmodel.goodsName andPattern:patten];

    NSArray *catearr = [Gmodel.goodsCategoryNamePath componentsSeparatedByString:@">"];
    if (catearr.count>0) {
        _techLab.text = catearr[0];
    }else{
        _techLab.text = Gmodel.goodsCategoryNamePath;
    }
    SpecListModel *specDTOList;
    if (Gmodel.specDTOList.count>0) {
        specDTOList = Gmodel.specDTOList[0];
    }
     _priceLab.text = [GlobalMethod GoodsPriceWithPrice:Gmodel.minPrice andUnit:specDTOList.goodsUnit];
    
    NSArray *arr = [Gmodel.pictureName componentsSeparatedByString:@","];
    NSString *url = @"";
    if (arr>0) {
        url = arr[0];
    }
    NSURL *urlStr = [GlobalMethod returnUrlStrWithImageName:url andisThumb:YES];
    [_faceIma sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"proempty"]];
    
    if ([Gmodel.goodsModule intValue]==0) {
        //求购
        _tabLab.text = @"求购";
        _tabIma.image = [UIImage imageNamed:@"lable_xianhuo copy"];
        
    }else if ([Gmodel.goodsModule intValue]==1){
        //现货
        _tabLab.text = @"现货";
        _tabIma.image = [UIImage imageNamed:@"lable_xianhuo"];
        
    }else if ([Gmodel.goodsModule intValue]==2){
        //供应
        _tabLab.text = @"供应";
        _tabIma.image = [UIImage imageNamed:@"lable_gongying"];
        
        
    }else{
        _tabIma.hidden = YES;
    }
}



+(CGFloat)cellHeight{
    CGFloat _width = (ScreenWidth - 50)/2;
    CGFloat _height = _width;
    return _height + 67+14;
}

@end
