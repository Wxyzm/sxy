//
//  MineWantCell.m
//  SXY
//
//  Created by yh f on 2018/11/17.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MineWantCell.h"
#import "WantBuyModel.h"


@implementation MineWantCell{
    
    UIView *_bgView;
    UILabel *_titleLab;
    UILabel *_timeLab;
    UIImageView *_markIma;
    UILabel *_detailLab;
    NSMutableArray *_ImaArr;
    
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
    
    
    _bgView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(WhiteColorValue)];
    [self.contentView addSubview:_bgView];
    _bgView.layer.borderColor = UIColorFromRGB(BackColorValue).CGColor;
    _bgView.layer.borderWidth = 1;
    
    
    _titleLab= [BaseViewFactory labelWithFrame:CGRectMake(16, 14, ScreenWidth- 32, 23) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:@""];
    [_bgView addSubview:_titleLab];
    
    _timeLab= [BaseViewFactory labelWithFrame:CGRectMake(90, 41, ScreenWidth- 32-106, 14) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentRight andtext:@""];
    [_bgView addSubview:_timeLab];
    
    
    _markIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lable_jinzhichixianhuo"]];
    [_bgView addSubview:_markIma];
    _markIma.frame = CGRectMake(16, 41, 60, 14);
    
    _detailLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [_bgView addSubview:_detailLab];
    
    
    
    
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = UIColorFromRGB(BackColorValue);
        imageView.clipsToBounds = YES;
        [_bgView addSubview:imageView];
        imageView.hidden = YES;
        [_ImaArr addObject:imageView];
    }
    
   
    
    
}



-(void)setModel:(WantBuyModel *)model{
    _model = model;
    for (UIImageView *imageView in _ImaArr) {
        imageView.hidden = YES;
    }
    
    _titleLab.text = model.title;
    _timeLab.text = model.expirationtime;
    _detailLab.text = model.content;
    if (model.label.length>0) {
        _markIma.hidden = NO;
    }else{
        _markIma.hidden = YES;
    }
    
    
    NSArray *arr = [model.pictureName componentsSeparatedByString:@","];
    NSInteger a = arr.count>3?3:arr.count;
    for (int i = 0; i<a; i++) {
        UIImageView *imageView = _ImaArr[i];
        imageView.image = nil;
        imageView.hidden = NO;
        NSURL *urlStr = [GlobalMethod returnUrlStrWithImageName:arr[i] andisThumb:YES];
        [imageView sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"empty"]];
    }
    
    _bgView.sd_layout
    .leftSpaceToView(self.contentView, 16)
    .rightSpaceToView(self.contentView, 16)
    .topSpaceToView(self.contentView, 8)
    .bottomSpaceToView(self.contentView, 0);
    
    
    _detailLab.sd_layout
    .leftSpaceToView(_bgView, 16)
    .rightSpaceToView(_bgView, 20)
    .topSpaceToView(_timeLab, 4)
    .autoHeightRatio(0);
    [_detailLab setMaxNumberOfLinesToShow:2];
    
    
    CGFloat _ImaW = (ScreenWidth - 64  -10)/3;
    CGFloat _ImaH = _ImaW*3/4;
    
    for (int i = 0; i<_ImaArr.count; i++) {
        UIImageView *imageView = _ImaArr[i];
        imageView.sd_layout
        .leftSpaceToView(_bgView, 16+(_ImaW +5)*i)
        .topSpaceToView(_timeLab, 45)
        .widthIs(_ImaW)
        .heightIs(_ImaH);
    }
    
    
}






+(CGFloat )cellheightWithModel:(WantBuyModel *)model{
    NSArray *arr = [model.pictureName componentsSeparatedByString:@","];
    if (arr.count>0) {
        CGFloat _ImaW = (ScreenWidth - 64  -10)/3;
        CGFloat _ImaH = _ImaW*3/4;
        return 128 + _ImaH;
    }
    
    return 120;
    
}

@end
