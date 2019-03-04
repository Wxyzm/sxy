//
//  TopicCell.m
//  SXY
//
//  Created by yh f on 2018/11/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "TopicCell.h"
#import "WantBuyModel.h"
@implementation TopicCell{
    
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_detailLab;
 
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    _faceIma.frame = CGRectMake(20, 0, 82, 82);
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(122, 0, ScreenWidth-142, 20) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];

    _detailLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x9f9da1) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_detailLab];
    
    

}


-(void)setModel:(WantBuyModel *)model{
    _model = model;
    _faceIma.image = nil;
    NSArray *arr = [model.pictureName componentsSeparatedByString:@","];
    NSString *urlStr = @"";
    if (arr.count>0) {
        urlStr = arr[0];
    }
    [_faceIma sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:urlStr andisThumb:YES] placeholderImage:[UIImage imageNamed:@"faceempty"]];
    _nameLab.text = model.title;
    _detailLab.text = model.content;
    _detailLab.sd_layout
    .topSpaceToView(_nameLab, 4)
    .leftEqualToView(_nameLab)
    .rightSpaceToView(self.contentView, 20)
    .autoHeightRatio(0);
    [_detailLab setMaxNumberOfLinesToShow:3];
    
}



@end
