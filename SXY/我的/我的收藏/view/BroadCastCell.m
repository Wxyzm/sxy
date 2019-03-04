//
//  BroadCastCell.m
//  SXY
//
//  Created by yh f on 2018/11/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BroadCastCell.h"
#import "GoodsModel.h"
#import "CollectCirModel.h"

@implementation BroadCastCell{
    
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_timeLab;
    UILabel *_subTLab;
    UILabel *_detailLab;
    UIButton *_collectBtn;
    UIButton *_callBtn;
    NSMutableArray *_ImaArr;
    UIView *_line;

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
    
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(71, 23, 150, 13) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
    _timeLab= [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth-241, 26, 221, 12) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_timeLab];
    
    _subTLab= [BaseViewFactory labelWithFrame:CGRectMake(71, 57, ScreenWidth-91, 20) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_subTLab];
    
    _detailLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_detailLab];
    _detailLab.numberOfLines = 2;
    
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = UIColorFromRGB(BackColorValue);
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        imageView.hidden = YES;
        [_ImaArr addObject:imageView];
    }
    
//    _detailLab.sd_layout
//    .leftSpaceToView(self.contentView, 71)
//    .rightSpaceToView(self.contentView, 20)
//    .topSpaceToView(_subTLab, 4)
//    .autoHeightRatio(0);
//    [_detailLab setMaxNumberOfLinesToShow:2];
    
    
    CGFloat _ImaW = (ScreenWidth - 70 -20 -10)/3;
    CGFloat _ImaH = _ImaW*3/4;
    
    for (int i = 0; i<_ImaArr.count; i++) {
        UIImageView *imageView = _ImaArr[i];
        imageView.hidden = NO;
        imageView.sd_layout
        .leftSpaceToView(self.contentView, 70+(_ImaW +5)*i)
        .topSpaceToView(_subTLab, 45)
        .widthIs(_ImaW)
        .heightIs(_ImaH);
    }
    
    
    
    
    _line = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xf4f4f4)];
    [self.contentView addSubview:_line];
    
   
}


-(void)setModel:(CollectCirModel*)model{
    
    _model = model;
    [_faceIma sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:model.userPhoto andisThumb:YES] placeholderImage:[UIImage imageNamed:@"faceempty"]];
    _nameLab.text = model.userName.length>0?model.userName:@"木有昵称";
    _timeLab.text = model.expirationtime;
    _subTLab.text = model.title;
    _detailLab.text = model.content;
    
    _detailLab.sd_layout
    .leftSpaceToView(self.contentView, 68)
    .rightSpaceToView(self.contentView, 25)
    .topSpaceToView(_subTLab, 4)
    .heightIs(35);

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
        .topSpaceToView(_subTLab, 43)
        .widthIs(_ImaW)
        .heightIs(_ImaH);
    }
    
    _line
    .sd_layout
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1)
    .leftSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0);
}


- (void)clickImage{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model);
    }
    
}



+(CGFloat)cellHeightWithModel:(CollectCirModel *)model{
    CGFloat contH = [GlobalMethod heightForString:model.content andWidth:ScreenWidth -93 andFont:APPFONT14];
    CGFloat _ImaW = (ScreenWidth - 93 -10)/3;
    CGFloat _ImaH = _ImaW*3/4;
    contH = 35;
    
    if (model.pictureName.length<=0) {
        return 81+61;
    }
    return  81+61 +_ImaH;
    
}




@end
