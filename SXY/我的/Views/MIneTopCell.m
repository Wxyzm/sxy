//
//  MIneTopCell.m
//  SXY
//
//  Created by yh f on 2018/11/15.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MIneTopCell.h"
#import "MineInfoModel.h"

@implementation MIneTopCell{
    
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_infoLab;
    UILabel *_comLab;
    UIButton *_tureNameBtn;
    UIButton *_tureComBtn;
    UIButton *_changeNameBtn;
    
    
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
    _faceIma.frame = CGRectMake(30, 64 +STATUSBAR_HEIGHT, 50, 50);
    _faceIma.layer.cornerRadius = 25;
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:changeBtn];
    changeBtn.frame = CGRectMake(30, 64 +STATUSBAR_HEIGHT, 50, 50);
    [changeBtn addTarget:self action:@selector(changeFaceBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [self.contentView addSubview:setBtn];
    setBtn.frame = CGRectMake(ScreenWidth - 54, 19 +STATUSBAR_HEIGHT, 24, 24);
    [setBtn addTarget:self action:@selector(menueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    setBtn.tag = 1004;
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(100, 82, ScreenWidth-100 -45, 22) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
     _changeNameBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_changeNameBtn];
    [_changeNameBtn addTarget:self action:@selector(changeNameBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _changeNameBtn.frame = CGRectMake(100, 82, ScreenWidth-100 -45, 22);
    
    _infoLab  = [BaseViewFactory labelWithFrame:CGRectMake(100, 110, ScreenWidth-100 -45, 22) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_infoLab];
    
    _tureComBtn = [BaseViewFactory buttonWithFrame:CGRectMake(ScreenWidth-96, 110 +STATUSBAR_HEIGHT, 80, 20) font:APPFONT(8) title:@"" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(0x4BAEC4)];
    _tureComBtn.layer.cornerRadius = 10;
    [self.contentView addSubview:_tureComBtn];

    _tureNameBtn = [BaseViewFactory buttonWithFrame:CGRectMake(ScreenWidth-186, 110 +STATUSBAR_HEIGHT, 80, 20) font:APPFONT(8) title:@"" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    _tureNameBtn.layer.cornerRadius = 10;
    [self.contentView addSubview:_tureNameBtn];
    
    _comLab  = [BaseViewFactory labelWithFrame:CGRectMake(100, 143+STATUSBAR_HEIGHT, ScreenWidth-100 -21, 17) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_comLab];
    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, 176+STATUSBAR_HEIGHT, ScreenWidth, 6) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:lineView];
    
    CGFloat BtnW = (ScreenWidth - 24)/4;
    NSArray *titleArr = @[@"我的求购",@"我的收藏",@"我的广播",@"我的话题"];
    NSArray *imageArr = @[@"mine_qiugou",@"mine_collection",@"mine_guangbo",@"mine_topic"];
    
    for (int i = 0; i<4; i++) {
        YLButton *btn = [BaseViewFactory ylButtonWithFrame:CGRectMake(12 +BtnW *i, 182+STATUSBAR_HEIGHT, BtnW, 103) font:APPFONT12 title:titleArr[i] titleColor:UIColorFromRGB(BlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setImageRect:CGRectMake((BtnW -44)/2, 18, 44, 44)];
        [btn setTitleRect:CGRectMake(0, 66, BtnW, 17)];
        [self.contentView addSubview:btn];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(menueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 +i;
    }
    UIView *lineView1= [BaseViewFactory viewWithFrame:CGRectMake(0, 182+STATUSBAR_HEIGHT +103, ScreenWidth, 6) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:lineView1];
}


- (void)menueBtnClick:(YLButton *)btn{
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(btn.tag - 1000);
    }
}

- (void)changeFaceBtnCLick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(5);
    }
}

- (void)changeNameBtnClick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(6);
    }
}

-(void)setInfoModel:(MineInfoModel *)infoModel{
    _infoModel = infoModel;
    _nameLab.text = infoModel.name;
    _infoLab.text = [NSString stringWithFormat:@"%@ | %@",infoModel.cityName,infoModel.userType];
    _comLab.text = infoModel.company;
    
    NSURL *urlStr = [GlobalMethod returnUrlStrWithImageName:infoModel.photo andisThumb:YES];
    [_faceIma sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"faceempty"]];
    
    //个人
    if ([infoModel.realNameAuth intValue]==0) {
        //未认证
        [_tureNameBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureNameBtn setTitle:@"个人未认证" forState:UIControlStateNormal];
    }else if ([infoModel.realNameAuth intValue]==2){
        //审核中
        [_tureNameBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureNameBtn setTitle:@"个人认证审核中" forState:UIControlStateNormal];
    }else if ([infoModel.realNameAuth intValue]==3){
        //已认证
        [_tureNameBtn setBackgroundColor:UIColorFromRGB(BTNColorValue)];
        [_tureNameBtn setTitle:@"个人认证已通过" forState:UIControlStateNormal];
    }
    //企业
    if ([infoModel.companyAuth intValue]==0) {
        //未认证
        [_tureComBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureComBtn setTitle:@"企业未认证" forState:UIControlStateNormal];
    }else if ([infoModel.companyAuth intValue]==2){
        //审核中
        [_tureComBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureComBtn setTitle:@"企业认证审核中" forState:UIControlStateNormal];
    }else if ([infoModel.companyAuth intValue]==3){
        //已认证
        [_tureComBtn setBackgroundColor:UIColorFromRGB(0x4BAEC4)];
        [_tureComBtn setTitle:@"企业认证已通过" forState:UIControlStateNormal];
    }
    
}


@end
