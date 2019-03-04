//
//  GoodsShowView.m
//  SXY
//
//  Created by yh f on 2019/1/1.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "GoodsShowView.h"
#import "SpecListModel.h"
@implementation GoodsShowView{
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_kindLab;
    UILabel *_priceLab;
    
    
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
    
    UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(18, 0, 200, 52) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@"选择商品"];
    [self addSubview:lab];
    
    
    BaseScrollView *backView = [[BaseScrollView alloc] initWithFrame:CGRectMake(18, 52, ScreenWidth-36, 110)];
    backView.backgroundColor = UIColorFromRGB(LineColorValue);
    backView.bounces = YES;
    [self addSubview: backView];
    backView.contentSize = CGSizeMake(ScreenWidth +76, 10);
    backView.pagingEnabled = YES;
    backView.showsHorizontalScrollIndicator = NO;
    backView.showsVerticalScrollIndicator = NO;

    
    _faceIma = [[UIImageView alloc] init];
    _faceIma.backgroundColor = [UIColor lightGrayColor];
    _faceIma.contentMode = UIViewContentModeScaleToFill;
    [backView addSubview:_faceIma];
    _faceIma.clipsToBounds = YES;
    _faceIma.layer.cornerRadius = 4;
    _faceIma.frame = CGRectMake(13, 14, 82, 82);
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(123, 24, ScreenWidth-36-133, 22) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@""];
    [backView addSubview:_nameLab];
    
    _kindLab = [BaseViewFactory labelWithFrame:CGRectMake(120, 59, ScreenWidth-36-130, 22) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [backView addSubview:_kindLab];
    
    _priceLab = [BaseViewFactory labelWithFrame:CGRectMake(120, 79, ScreenWidth-36-130, 22) textColor:UIColorFromRGB(0xe74922) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [backView addSubview:_priceLab];
    
    UIButton *editBtn = [BaseViewFactory buttonWithFrame:CGRectMake(ScreenWidth-36, 0, 56, 110) font:APPFONT12 title:@"编辑" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(0xFC8F30)];
    [backView addSubview:editBtn];
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteBtn = [BaseViewFactory buttonWithFrame:CGRectMake(ScreenWidth+20, 0, 56, 110) font:APPFONT12 title:@"删除" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(0xE74922)];
    [backView addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
}

-(void)setModel:(GoodsModel *)model{
    
    _model = model;

    SpecListModel *specDTOList;
    if (model.specDTOList.count>0) {
        specDTOList = model.specDTOList[0];
    }
    NSString *patten = @"";
    if (model.specDTOList.count>0) {
        patten  = specDTOList.pattern;
    }
    _nameLab.text = [GlobalMethod GoodsnameWithName:model.goodsName andPattern:patten];
    _priceLab.text = [GlobalMethod GoodsPriceWithPrice:model.minPrice andUnit:specDTOList.goodsUnit];

    
    _kindLab.text = _model.goodsCategory;
    if (model.pictureName.length>0) {
        NSArray *arr = [model.pictureName componentsSeparatedByString:@","];
        [_faceIma sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:arr[0] andisThumb:YES] placeholderImage:[UIImage imageNamed:@"proempty"]];
    }else{
        _faceIma.image = [UIImage imageNamed:@"proempty"];
    }
}


- (void)editBtnClick{
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, 0);
    }
    
}

- (void)deleteBtnClick{
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, 1);
    }
    
    
}


@end
