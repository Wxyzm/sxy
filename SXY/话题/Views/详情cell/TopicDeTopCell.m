//
//  TopicDeTopCell.m
//  SXY
//
//  Created by yh f on 2019/1/16.
//  Copyright © 2019 XX. All rights reserved.
//

#import "TopicDeTopCell.h"

@implementation TopicDeTopCell{
    
    UILabel *_timeLab;
    UILabel *_detailLab;
    UIButton *_zanBtn;
    UIButton *_shareBtn;
    UIButton *_replyBtn;
    
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
    
    _detailLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@""];
    _detailLab.numberOfLines = 0;
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
    
    _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zanBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    [self.contentView addSubview:_zanBtn];
    [_zanBtn addTarget:self action:@selector(zanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [self.contentView addSubview:_shareBtn];
    [_shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_replyBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [self.contentView addSubview:_replyBtn];
    [_replyBtn addTarget:self action:@selector(replyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _timeLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xb1b1b1) font:APPFONT(10) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_timeLab];
}


-(void)setDetailModel:(WantBuyModel *)detailModel{
    _detailModel = detailModel;
    _detailLab.text = detailModel.content;
    _timeLab.text = [GlobalMethod returndetailTimeStrWith:detailModel.addTime];

    if (detailModel.izan) {
        [_zanBtn setImage:[UIImage imageNamed:@"praise_select"] forState:UIControlStateNormal];
        
    }else{
        [_zanBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    }
    
    
    _detailLab.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 20)
    .topSpaceToView(self.contentView, 16)
    .autoHeightRatio(0);
    
    CGFloat _ImaW = (ScreenWidth - 52)/3;
    CGFloat _ImaH = _ImaW*3/4;
    NSArray *arr;
    if (detailModel.pictureName.length>0) {
        arr = [detailModel.pictureName componentsSeparatedByString:@","];
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
        .leftSpaceToView(self.contentView, 20+(_ImaW +6)*i)
        .topSpaceToView(_detailLab, 10)
        .widthIs(_ImaW)
        .heightIs(_ImaH);
    }
    _replyBtn.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .heightIs(24)
    .widthIs(24)
    .bottomSpaceToView(self.contentView, 10);
    
    _shareBtn.sd_layout
    .rightSpaceToView(_replyBtn, 16)
    .heightIs(24)
    .widthIs(24)
    .bottomSpaceToView(self.contentView, 10);
    
    _zanBtn.sd_layout
    .rightSpaceToView(_shareBtn, 16)
    .heightIs(24)
    .widthIs(24)
    .bottomSpaceToView(self.contentView, 10);
    
    _timeLab.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .centerYEqualToView(_zanBtn)
    .heightIs(14);
    [_timeLab setSingleLineAutoResizeWithMaxWidth:200];
    
    
}


- (void)zanBtnClick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_detailModel, 0,self);
    }
    
}

- (void)shareBtnClick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_detailModel, 1,self);
    }
}

- (void)replyBtnClick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_detailModel, 2,self);
    }
}

//图片点击
- (void)singleTapAction:(UITapGestureRecognizer *)gest{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)gest;
    UIImageView *views = (UIImageView*) tap.view;
    NSUInteger tag = views.tag;
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_detailModel, tag,self);
    }
}


+(CGFloat)cellHeightWithModel:(WantBuyModel *)model{
    if (model.cellHeight>0) {
        return model.cellHeight;
    }
    CGFloat height = [GlobalMethod heightForString:model.content andWidth:ScreenWidth -40 andFont:APPFONT14];
     CGFloat _ImaW = (ScreenWidth - 52)/3;
    CGFloat _ImaH = _ImaW*3/4;

    model.cellHeight = height +16+ _ImaH +26+14+10;
    return height +93;
    
    
    
}

@end
