//
//  ProCollectionCell.m
//  SXY
//
//  Created by yh f on 2018/11/10.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ProCollectionCell.h"

#define  ProCollWidth  210*TimeScaleX
#define  ProCollHeight  120*TimeScaleX

@implementation ProCollectionCell{
    
    UIImageView *_faceIma;  //图片
    UILabel *_nameLab;      //名称
    UILabel *_tabLab;       //标签
    UILabel *_priceLab;     //价格
    UILabel *_techLab;      //工艺

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
    
    _faceIma = [[UIImageView alloc] init];
    _faceIma.backgroundColor = [UIColor lightGrayColor];
    _faceIma.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_faceIma];
    _faceIma.clipsToBounds = YES;
    _faceIma.layer.cornerRadius = 4;
    _faceIma.frame = CGRectMake(0, 0, ProCollWidth, ProCollHeight);
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
    _tabLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(10) textAligment:NSTextAlignmentCenter andtext:@""];
    _tabLab.backgroundColor = UIColorFromRGB(BTNColorValue);
    [self.contentView addSubview:_tabLab];
    _tabLab.hidden = YES;
    
    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(12) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_priceLab];
    
    _techLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_techLab];
    
    
    
    
    _nameLab.sd_layout
    .leftEqualToView(_faceIma)
    .topSpaceToView(_faceIma, 9)
    .heightIs(20);
    [_nameLab setSingleLineAutoResizeWithMaxWidth:180*TimeScaleX];
    
    _tabLab.sd_layout
    .leftSpaceToView(_nameLab, 4)
    .centerYEqualToView(_nameLab)
    .widthIs(26)
    .heightIs(12);
    
    _priceLab.sd_layout
    .leftSpaceToView(_tabLab, 4)
    .rightEqualToView(_faceIma)
    .centerYEqualToView(_nameLab)
    .heightIs(17);
   
    
    _techLab.sd_layout
    .leftEqualToView(_faceIma)
    .topSpaceToView(_nameLab, 4)
    .rightEqualToView(_faceIma)
    .heightIs(19);
    
    
}

-(void)setProModel:(GoodsModel *)proModel{
    _proModel = proModel;
    NSString *patten = @"";
    SpecListModel *model;
    if (proModel.specDTOList.count>0) {
        model= proModel.specDTOList[0];
        patten  = model.pattern;
    }
    _nameLab.text = [GlobalMethod GoodsnameWithName:proModel.goodsName andPattern:patten];
    
    _priceLab.text = [NSString stringWithFormat:@"￥%@",proModel.minPrice];
    _priceLab.text = [GlobalMethod GoodsPriceWithPrice:proModel.minPrice andUnit:model.goodsUnit];

    
    NSArray *arr = [proModel.pictureName componentsSeparatedByString:@","];
    NSString *url = @"";
    if (arr>0) {
        url = arr[0];
    }
    NSURL *urlStr = [GlobalMethod returnUrlStrWithImageName:url andisThumb:YES];
    [_faceIma sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"proempty"]];
    
    NSArray *catearr = [proModel.goodsCategoryNamePath componentsSeparatedByString:@">"];
    if (catearr.count>0) {
        _techLab.text = catearr[0];
    }else{
        _techLab.text = proModel.goodsCategoryNamePath;
    }
    
}


@end
