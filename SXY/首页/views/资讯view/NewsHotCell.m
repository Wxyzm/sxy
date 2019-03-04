//
//  NewsHotCell.m
//  SXY
//
//  Created by yh f on 2019/1/2.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "NewsHotCell.h"
#import "NewsModel.h"

@implementation NewsHotCell{
    
    UIImageView *_faceIma;  //图片
    UILabel *_nameLab;      //标题名称
    
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
    _faceIma.frame = CGRectMake(0, 0, 164, 72);
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    _nameLab.numberOfLines = 2;
    
}


-(void)setModel:(NewsModel *)model{
    _model = model;
    _nameLab.text = model.title;

    NSArray *arr = [model.pictureName componentsSeparatedByString:@","];
    NSString *url = @"";
    if (arr>0) {
        url = arr[0];
    }
    NSURL *urlStr = [GlobalMethod returnUrlStrWithImageName:url andisThumb:YES];
    [_faceIma sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"proempty"]];
    _nameLab.sd_layout
    .leftEqualToView(_faceIma)
    .topSpaceToView(_faceIma, 9)
    .rightEqualToView(_faceIma)
    .autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    
}


@end
