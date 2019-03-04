//
//  ChoseStockCell.m
//  SXY
//
//  Created by yh f on 2019/1/1.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "ChoseStockCell.h"
#import "SpecListModel.h"
@implementation ChoseStockCell{
    
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_kindLab;
    UILabel *_priceLab;
    YLButton *_selectBtn;
    
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    _faceIma.frame = CGRectMake(28, 24, 82, 82);
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(138, 24, ScreenWidth-138-28, 22) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
    _kindLab = [BaseViewFactory labelWithFrame:CGRectMake(138, 69, ScreenWidth-138-28, 22) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_kindLab];
  
    _priceLab = [BaseViewFactory labelWithFrame:CGRectMake(138, 89, ScreenWidth-138-28, 22) textColor:UIColorFromRGB(0xe74922) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_priceLab];
    
    
    _selectBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setImageRect:CGRectMake(6, 6, 24, 24)];
    [_selectBtn setImage:[UIImage imageNamed:@"selected_u"] forState:UIControlStateNormal];
    [self.contentView addSubview:_selectBtn];
    _selectBtn.frame = CGRectMake(ScreenWidth-57, 50, 30, 30);
    [_selectBtn addTarget:self action:@selector(selectedBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setModel:(GoodsModel *)model{
    _model = model;
    if (model.isSelected) {
        [_selectBtn setImage:[UIImage imageNamed:@"selected_s"] forState:UIControlStateNormal];

    }else{
        [_selectBtn setImage:[UIImage imageNamed:@"selected_u"] forState:UIControlStateNormal];

    }
    SpecListModel *specDTOList;
    if (model.specDTOList.count>0) {
        specDTOList = model.specDTOList[0];
    }
    NSString *patten = @"";
    if (model.specDTOList.count>0) {
        SpecListModel *tmodel = model.specDTOList[0];
        patten  = tmodel.pattern;
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



- (void)selectedBtnClick{
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model);
    }
    
    
}



@end
