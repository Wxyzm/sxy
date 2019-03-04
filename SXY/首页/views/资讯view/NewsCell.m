//
//  NewsCell.m
//  SXY
//
//  Created by yh f on 2019/1/3.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "NewsCell.h"
#import "NewsModel.h"

@implementation NewsCell{
    
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_timeLab;
    
    YLButton *_seeNumBtn;
    YLButton *_shareNumBtn;
    YLButton *_replyNumBtn;

    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    _faceIma.frame = CGRectMake(ScreenWidth - 137, 20, 120, 72);
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    _nameLab.numberOfLines = 2;
    
    _timeLab = [BaseViewFactory labelWithFrame:CGRectMake(22, 110, 200, 17) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_timeLab];
    
    _seeNumBtn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(LitterBlackColorValue) cornerRadius:0 andtarget:self action:@selector(seeNumBtnCLick) titleFont:APPFONT12 title:@"0"];
    [self.contentView addSubview:_seeNumBtn];
    [_seeNumBtn setImage:[UIImage imageNamed:@"information_view"] forState:UIControlStateNormal];
    [_seeNumBtn setImageRect:CGRectMake(0, 4, 12, 12)];
    [_seeNumBtn setTitleRect:CGRectMake(22, 0, 30, 20)];
    
    
    _shareNumBtn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(LitterBlackColorValue) cornerRadius:0 andtarget:self action:@selector(shareNumBtnCLick) titleFont:APPFONT12 title:@"0"];
    [self.contentView addSubview:_shareNumBtn];
    [_shareNumBtn setImage:[UIImage imageNamed:@"information_share"] forState:UIControlStateNormal];
    [_shareNumBtn setImageRect:CGRectMake(0, 4, 12, 12)];
    [_shareNumBtn setTitleRect:CGRectMake(22, 0, 30, 20)];
    
    _replyNumBtn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(LitterBlackColorValue) cornerRadius:0 andtarget:self action:@selector(replyNumBtnCLick) titleFont:APPFONT12 title:@"0"];
    [self.contentView addSubview:_replyNumBtn];
    [_replyNumBtn setImage:[UIImage imageNamed:@"information_comments"] forState:UIControlStateNormal];
    [_replyNumBtn setImageRect:CGRectMake(0, 4, 12, 12)];
    [_replyNumBtn setTitleRect:CGRectMake(22, 0, 30, 20)];
    
    
}



- (void)seeNumBtnCLick{
    
    
}

- (void)shareNumBtnCLick{
    
    
}

- (void)replyNumBtnCLick{

    
    
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
    
    [ _replyNumBtn setTitle:model.commentCount.length>0?model.commentCount:@"0" forState:UIControlStateNormal];
    [ _shareNumBtn setTitle:model.shareCount.length>0?model.shareCount:@"0" forState:UIControlStateNormal];
    [ _seeNumBtn setTitle:model.clickCount.length>0?model.clickCount:@"0" forState:UIControlStateNormal];

    
    _nameLab.sd_layout
    .leftSpaceToView(self.contentView, 17)
    .topSpaceToView(self.contentView, 17)
    .rightSpaceToView(_faceIma, 18)
    .autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    
    _replyNumBtn.sd_layout
    .rightSpaceToView(self.contentView, 17)
    .topSpaceToView(_faceIma, 17)
    .widthIs(52)
    .heightIs(20);
    
    
    _shareNumBtn.sd_layout
    .rightSpaceToView(_replyNumBtn, 20)
    .topSpaceToView(_faceIma, 17)
    .widthIs(52)
    .heightIs(20);
    
    _seeNumBtn.sd_layout
    .rightSpaceToView(_shareNumBtn, 20)
    .topSpaceToView(_faceIma, 17)
    .widthIs(52)
    .heightIs(20);
}


@end
