//
//  WantBuyViewCell.m
//  SXY
//
//  Created by yh f on 2018/11/14.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "WantBuyViewCell.h"

@implementation WantBuyViewCell{
    
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_timeLab;
    UILabel *_subTLab;
    UILabel *_detailLab;
    UIButton *_collectBtn;
    UIButton *_callBtn;
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _ImaArr= [NSMutableArray arrayWithCapacity:0];
        [self setUP];
    }
    
    return self;
}


- (void)setUP{

    
    UILabel *newLab = [BaseViewFactory labelWithFrame:CGRectMake(MaginX, 0, 200, 40) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(16) textAligment:NSTextAlignmentLeft andtext:@"最新求购"];
    [self.contentView addSubview:newLab];
    
    YLButton *rightBtn = [BaseViewFactory ylButtonWithFrame:CGRectMake(ScreenWidth-57, 0, 37, 40) font:APPFONT17 title:@"更多" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = APPFONT12;
    [self.contentView addSubview:rightBtn];
    [rightBtn setTitleRect:CGRectMake(0, 0, 26, 40)];
    [rightBtn setImageRect:CGRectMake(31, 15, 6, 10)];
    [rightBtn addTarget:self action:@selector(moreBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _faceIma = [[UIImageView alloc]init];
    _faceIma.contentMode = UIViewContentModeScaleAspectFill;
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    _faceIma.clipsToBounds = YES;
    [self.contentView addSubview:_faceIma];
    _faceIma.frame = CGRectMake(16, 60, 48, 48);
    _faceIma.layer.cornerRadius = 24;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [_faceIma addGestureRecognizer:tapGesture];
    _faceIma.userInteractionEnabled = YES;
    
  
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(71, 63, 150, 13) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];

    _timeLab= [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth-241, 66, 221, 12) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_timeLab];
    
    _subTLab= [BaseViewFactory labelWithFrame:CGRectMake(71, 97, ScreenWidth-91, 20) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@""];
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
    
    
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [self.contentView addSubview:_collectBtn];
    [_collectBtn addTarget:self action:@selector(collectBtnCLick) forControlEvents:UIControlEventTouchUpInside];

    
    _callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_callBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [self.contentView addSubview:_callBtn];
    [_callBtn addTarget:self action:@selector(callBtnCLick) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xf4f4f4)];
    [self.contentView addSubview:line];
    
   
    line.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(6)
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
        weakself.returnBlock(_buyModel, tag,self);
    }
}

- (void)moreBtnCLick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_buyModel, 0,self);
    }
    
}


- (void)collectBtnCLick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_buyModel, 1,self);
    }
    
}

- (void)callBtnCLick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_buyModel, 2,self);
    }
    
}


//头像
- (void)clickImage{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_buyModel, 3,self);
    }
    
}



-(void)setBuyModel:(WantBuyModel *)buyModel{
    
    _buyModel = buyModel;
    [_faceIma sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:buyModel.userPhoto andisThumb:YES] placeholderImage:[UIImage imageNamed:@"faceempty"]];
    _nameLab.text = buyModel.userName;
    _timeLab.text = [NSString stringWithFormat:@"%@结束",buyModel.expirationtime];
    _subTLab.text = buyModel.title;
    _detailLab.text = buyModel.content;
    
    _detailLab.sd_layout
    .leftSpaceToView(self.contentView, 71)
    .rightSpaceToView(self.contentView, 20)
    .topSpaceToView(_subTLab, 4)
    .autoHeightRatio(0);
    [_detailLab setMaxNumberOfLinesToShow:2];
    
    if (buyModel.collected) {
        [_collectBtn setImage:[UIImage imageNamed:@"collection_select"] forState:UIControlStateNormal];
        
    }else{
        [_collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        
    }
    CGFloat _ImaW = (ScreenWidth - 70 -20 -10)/3;
    CGFloat _ImaH = _ImaW*3/4;
    
    
    NSArray *arr = [buyModel.pictureName componentsSeparatedByString:@","];
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
        .topSpaceToView(_subTLab, 45)
        .widthIs(_ImaW)
        .heightIs(_ImaH);
    }
    _callBtn.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .heightIs(24)
    .widthIs(24)
    .bottomSpaceToView(self.contentView, 15);
    
    _collectBtn.sd_layout
    .rightSpaceToView(_callBtn, 16)
    .heightIs(24)
    .widthIs(24)
    .bottomSpaceToView(self.contentView, 15);
    
}












+(CGFloat)cellHeight{
    CGFloat _ImaW = (ScreenWidth - 70 -20 -10)/3;
    CGFloat _ImaH = _ImaW*3/4;
    return  230 +_ImaH;
    
}

@end
