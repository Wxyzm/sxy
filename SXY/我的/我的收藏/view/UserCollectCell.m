//
//  UserCollectCell.m
//  SXY
//
//  Created by yh f on 2018/11/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "UserCollectCell.h"
#import "MineInfoModel.h"

@implementation UserCollectCell{
    
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_identLab;
    UILabel *_comLab;

    
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
    _faceIma.frame = CGRectMake(26, 20, 50, 50);
    _faceIma.layer.cornerRadius = 25;
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(91, 17, ScreenWidth-91-107, 20) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];

    _identLab = [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth-200-23, 17, 200, 20) textColor:UIColorFromRGB(0x9F9DA1) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_identLab];

    _comLab = [BaseViewFactory labelWithFrame:CGRectMake(91, 53, ScreenWidth-91, 17) textColor:UIColorFromRGB(0x9F9DA1) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_comLab];

}


- (void)setModel:(MineInfoModel *)model{
    _model = model;
    [_faceIma sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:model.photo andisThumb:YES] placeholderImage:[UIImage imageNamed:@"faceempty"]];

    
    _nameLab.text = model.name.length>0? model.name:@"木有昵称";
    _identLab.text = [NSString stringWithFormat:@"%@  |  %@",model.cityName,model.userType];
    _comLab.text =model.company;
    
    
}

@end
