//
//  CircleComCell.m
//  SXY
//
//  Created by yh f on 2019/1/15.
//  Copyright © 2019 XX. All rights reserved.
//

#import "CircleComCell.h"


@implementation CircleComCell{
    
    UILabel *_nameLab;
    UILabel *_timeLab;
    UILabel *_subTLab;
    UILabel *_detailLab;
    UIButton *_zanBtn;
    UIButton *_shareBtn;
    UIView *_line;
    UIImageView *_labIma;
    UILabel *_labLab;
    NSMutableArray *_commitLabArr;
    UIButton *_morecomBtn;
    UIView *_commitView;
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
    
    
    _line = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xf4f4f4)];
    [self.contentView addSubview:_line];
    
    _labIma = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 14)];
    [self.contentView addSubview:_labIma];
    _labLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 40, 14) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(9) textAligment:NSTextAlignmentCenter andtext:@""];
    [self.contentView addSubview:_labLab];
    
    
    
    _commitView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xf7f7f7)];
    [self.contentView addSubview:_commitView];
    _commitView.hidden = YES;
    _commitLabArr = [NSMutableArray arrayWithCapacity:0];
    for (int i =0; i<2; i++) {
        UILabel *comLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x9f9da1) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
        [_commitView addSubview:comLab];
        [_commitLabArr addObject:comLab];
        comLab.numberOfLines = 2;
    }
    
    _morecomBtn = [BaseViewFactory buttonWithFrame:CGRectZero font:APPFONT12 title:@"查看更多回复" titleColor:UIColorFromRGB(BTNColorValue) backColor:UIColorFromRGB(0xf7f7f7)];
    [_commitView addSubview:_morecomBtn];
    [_morecomBtn addTarget:self action:@selector(morecomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _morecomBtn.hidden = YES;
    
}

-(void)setModel:(WantBuyModel *)model{
    _model = model;
    [_faceIma sd_setImageWithURL:[GlobalMethod returnUrlStrWithImageName:model.userPhoto andisThumb:YES] placeholderImage:[UIImage imageNamed:@"faceempty"]];
    _nameLab.text = model.userName;
    _timeLab.text = model.expirationtime;
    _subTLab.text = model.title;
    _detailLab.text = model.content;
    
    if (model.izan) {
        [_zanBtn setImage:[UIImage imageNamed:@"praise_select"] forState:UIControlStateNormal];
        
    }else{
        [_zanBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
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
    .topSpaceToView(_detailLab, a>0?_ImaH+20:20);

    _shareBtn.sd_layout
    .rightSpaceToView(_replyBtn, 16)
    .heightIs(24)
    .widthIs(24)
    .topSpaceToView(_detailLab, a>0?_ImaH+20:20);

    _zanBtn.sd_layout
    .rightSpaceToView(_shareBtn, 16)
    .heightIs(24)
    .widthIs(24)
    .topSpaceToView(_detailLab, a>0?_ImaH+20:20);

    
    
    _line
    .sd_layout
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1)
    .leftSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0);
    
    [self setCommitView];
    
}

#pragma mark ====== 评论回复显示板

- (void)setCommitView{
    for (UILabel *lab  in _commitLabArr) {
        lab.hidden = YES;
    }
    
    NSMutableArray *commitArr = [NSMutableArray arrayWithCapacity:0];
    for (CommentModel *comModel in _model.commentDTOList) {
        [commitArr addObject:[NSString stringWithFormat:@"%@：%@",comModel.name,comModel.content]];
    }
    
    
        CGFloat totlheight = 6;
        NSInteger count = commitArr.count>2?2:commitArr.count;
        for (int i = 0; i<count; i++) {
            CommentModel *comModel = _model.commentDTOList[i];
            NSRange rang =NSMakeRange(0, comModel.name.length);
            UILabel *comlab = _commitLabArr[i];
            comlab.hidden = NO;

            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:commitArr[i]];
            [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(BTNColorValue) range:rang];
            comlab.attributedText = str;
            CGFloat height = [GlobalMethod heightForString:commitArr[i] andWidth:ScreenWidth-103 andFont:APPFONT12];
            comlab.frame = CGRectMake(10, totlheight, ScreenWidth-103, height);
            totlheight += height +6;
            if (i==1) {
                _morecomBtn.hidden = NO;
                _morecomBtn.sd_layout
                .leftSpaceToView(_commitView, 10)
                .topSpaceToView(comlab, 6)
                .heightIs(17);
                [_morecomBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:17];
                
                totlheight +=23;

            }else{
                  _morecomBtn.hidden = YES;
            }
            
        }
    _commitView.sd_layout
    .topSpaceToView(_replyBtn, 8)
    .leftSpaceToView(self.contentView, 68)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(totlheight);
    if (_model.commentDTOList.count<=0) {
        _commitView.hidden = YES;
    }else{
        _commitView.hidden = NO;
    }
    
    
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

//点赞
- (void)zanBtnClick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, 0,self);
    }
    
}

//分享
- (void)shareBtnClick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, 1,self);
    }
}

//回复
- (void)replyBtnClick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, 2,self);
    }
}

//点击头像
- (void)clickImage{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, 3,self);
    }
    
    
}

- (void)morecomBtnClick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model, 4,self);
    }
    
}


#pragma mark ====== 返回高度
+(CGFloat)cellHeightWithModel:(WantBuyModel *)model{
    
    if (model.cellHeight>0) {
        return model.cellHeight;
    }
    
    CGFloat contH = [GlobalMethod heightForString:model.content andWidth:ScreenWidth -93 andFont:APPFONT14];
    CGFloat _ImaW = (ScreenWidth - 93 -10)/3;
    CGFloat _ImaH = _ImaW*3/4;
    
    CGFloat topheight;
    
    if (model.pictureName.length<=0) {
        topheight = 81+61 +contH+8;
    }else{
        topheight = 81+61 +_ImaH+contH+8;
    }
    
    
    NSMutableArray *commitArr = [NSMutableArray arrayWithCapacity:0];
    for (CommentModel *comModel in model.commentDTOList) {
        [commitArr addObject:[NSString stringWithFormat:@"%@：%@",comModel.name,comModel.content]];
    }
    
    CGFloat totlheight = 6;
    NSInteger count = commitArr.count>2?2:commitArr.count;
    for (int i = 0; i<count; i++) {
        CGFloat height = [GlobalMethod heightForString:commitArr[i] andWidth:ScreenWidth-103 andFont:APPFONT12];
        totlheight += height +6;
        if (i==1) {
            totlheight +=23;
        }
        
    }
    model.cellHeight = topheight + totlheight +16;
    return topheight + totlheight +16;
    
}



@end
