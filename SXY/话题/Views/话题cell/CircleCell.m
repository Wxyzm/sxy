//
//  CircleCell.m
//  SXY
//
//  Created by yh f on 2018/12/21.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "CircleCell.h"

@implementation CircleCell{
    
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_timeLab;
    UILabel *_subTLab;
    UILabel *_detailLab;
    UIButton *_collecBtn;
    UIButton *_replyBtn;
    UIView *_line;
    UIImageView *_labIma;
    UILabel *_labLab;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _ImaArr= [NSMutableArray arrayWithCapacity:0];
        [self setUP];
    }
    return self;
}



- (void)setUP{
    _faceIma = [[UIImageView alloc]init];
    _faceIma.contentMode = UIViewContentModeScaleAspectFill;
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    _faceIma.clipsToBounds = YES;
    [self.contentView addSubview:_faceIma];
    _faceIma.frame = CGRectMake(16, 20, 48, 48);
    _faceIma.layer.cornerRadius = 24;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [_faceIma addGestureRecognizer:tapGesture];
    _faceIma.userInteractionEnabled = YES;
    
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(68, 23, 150, 13) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
    _timeLab= [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth-241, 23, 221, 12) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_timeLab];
    
    _subTLab= [BaseViewFactory labelWithFrame:CGRectMake(68, 57, ScreenWidth-106, 20) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_subTLab];
    
    _detailLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_detailLab];
    
    
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = UIColorFromRGB(BackColorValue);
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        imageView.hidden = YES;
        [_ImaArr addObject:imageView];
        imageView.userInteractionEnabled = YES;//打开用户交互
        imageView.tag = 1000+i;
        //初始化一个手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [imageView addGestureRecognizer:tapGesture];
    }
    
    _collecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collecBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [self.contentView addSubview:_collecBtn];
    [_collecBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_replyBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [self.contentView addSubview:_replyBtn];
    [_replyBtn addTarget:self action:@selector(replyBtClick) forControlEvents:UIControlEventTouchUpInside];

    
    _line = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xf4f4f4)];
    [self.contentView addSubview:_line];
    
    _labIma = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 14)];
    [self.contentView addSubview:_labIma];
    _labLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 40, 14) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(9) textAligment:NSTextAlignmentCenter andtext:@""];
    [self.contentView addSubview:_labLab];

 
}

-(void)setModel:(WantBuyModel *)model{
    _model = model;
    [_faceIma sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:model.userPhoto andisThumb:YES] placeholderImage:[UIImage imageNamed:@"faceempty"]];
    _nameLab.text = model.userName;
    _timeLab.text = model.expirationtime;
    _subTLab.text = model.title;
    _detailLab.text = model.content;
    
    if (model.collected) {
        [_collecBtn setImage:[UIImage imageNamed:@"collection_select"] forState:UIControlStateNormal];

    }else{
        [_collecBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];

    }
    if ([model.goodsModule isEqualToString:@"0"]) {
        _labIma.image = [UIImage imageNamed:@"lable_xianhuo copy"];
        _labLab.text = @"求购";
        
    }else if ([model.goodsModule isEqualToString:@"1"]){
        _labIma.image = [UIImage imageNamed:@"lable_xianhuo"];
        _labLab.text = @"现货";
        
    }else if ([model.goodsModule isEqualToString:@"2"]){
        _labIma.image = [UIImage imageNamed:@"lable_gongying"];
        _labLab.text = @"供应";
        
    }else{
        //话题
        _labIma.image = nil;
        _labLab.text = @"";
        if (model.izan) {
            [_collecBtn setImage:[UIImage imageNamed:@"praise_select"] forState:UIControlStateNormal];
            
        }else{
            [_collecBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
            
        }
    }
    
    
    
    _detailLab.sd_layout
    .leftSpaceToView(self.contentView, 68)
    .rightSpaceToView(self.contentView, 25)
    .topSpaceToView(_subTLab, 4)
    .autoHeightRatio(0);
    
    for (UIImageView *imageView in _ImaArr) {
        imageView.hidden = YES;
    }
    
    CGFloat _ImaW = (ScreenWidth - 93 -10)/3;
    CGFloat _ImaH = _ImaW*3/4;
    NSArray *arr;
    if (model.pictureName.length>0) {
        arr = [model.pictureName componentsSeparatedByString:@","];
    }
    NSInteger a = arr.count;
    if (arr.count>3) {
        a = 3;
    }
    for (int i = 0; i<a; i++) {
        UIImageView *imageView = _ImaArr[i];
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:arr[i] andisThumb:YES] placeholderImage:[UIImage imageNamed:@"proempty"]];
        
        imageView.sd_layout
        .leftSpaceToView(self.contentView, 70+(_ImaW +5)*i)
        .topSpaceToView(_detailLab, 4)
        .widthIs(_ImaW)
        .heightIs(_ImaH);
    }
    
    _replyBtn.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .heightIs(24)
    .widthIs(24)
    .bottomSpaceToView(self.contentView, 15);
    
    _collecBtn.sd_layout
    .rightSpaceToView(_replyBtn, 16)
    .heightIs(24)
    .widthIs(24)
    .bottomSpaceToView(self.contentView, 15);
    
    _line
    .sd_layout
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1)
    .leftSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0);
}

#pragma mark ====== 按钮点击

//图片点击
- (void)singleTapAction:(UITapGestureRecognizer *)gest{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)gest;
    UIImageView *views = (UIImageView*) tap.view;
    NSUInteger tag = views.tag;
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, tag,self);
    }
}
- (void)agreeBtnClick{
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, 0,self);
    }
    
    
}


- (void)replyBtClick{
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, 1,self);
    }
    
}

- (void)clickImage{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, 2,self);
    }
    
    
}


+(CGFloat)cellHeightWithModel:(WantBuyModel *)model{
    
    CGFloat contH = [GlobalMethod heightForString:model.content andWidth:ScreenWidth -93 andFont:APPFONT14];
    CGFloat _ImaW = (ScreenWidth - 93 -10)/3;
    CGFloat _ImaH = _ImaW*3/4;
    if (model.pictureName.length<=0) {
        return 81+61 +contH+8;
    }
    return  81+61 +_ImaH+contH+8;
    
}













@end
