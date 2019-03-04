//
//  CommentCell.m
//  SXY
//
//  Created by yh f on 2019/1/4.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"

@implementation CommentCell{
    
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_timeLab;
    UILabel *_detailLab;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    _faceIma.frame = CGRectMake(16, 10, 48, 48);
    _faceIma.layer.cornerRadius = 24;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [_faceIma addGestureRecognizer:tapGesture];
    _faceIma.userInteractionEnabled = YES;
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(71, 14, 150, 17) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
    _timeLab= [BaseViewFactory labelWithFrame:CGRectMake(71, 36, 221, 17) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_timeLab];
    
    _detailLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_detailLab];
    
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    [self.contentView addSubview:_agreeBtn];
    _agreeBtn.frame = CGRectMake(ScreenWidth-60, 13, 42, 42);
    
    
}


-(void)setModel:(CommentModel *)model{
    
    _model = model;
    [_faceIma sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:model.photo andisThumb:YES] placeholderImage:[UIImage imageNamed:@"faceempty"]];
    _nameLab.text = model.name;
    _timeLab.text = [GlobalMethod returndetailTimeStrWith:model.updateTime];
    if (model.izan) {
        [_agreeBtn setImage:[UIImage imageNamed:@"praise_select"] forState:UIControlStateNormal];

    }else{
        [_agreeBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    }
    _detailLab.text = model.content;
    _detailLab.sd_layout
    .leftSpaceToView(self.contentView, 71)
    .rightSpaceToView(self.contentView, 35)
    .topSpaceToView(_timeLab, 15)
    .autoHeightRatio(0);
    
}


- (void)clickImage{
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model);
    }
    
    
}


+(CGFloat )cellHeightWithModel:(CommentModel *)model{
    if (model.cellHeight>0) {
        return model.cellHeight;
    }
    CGFloat height = [GlobalMethod heightForString:model.content andWidth:ScreenWidth -106 andFont:APPFONT12];
    model.cellHeight = height +93;
    return height +93;
}







@end
