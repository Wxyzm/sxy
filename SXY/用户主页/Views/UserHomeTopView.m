//
//  UserHomeTopView.m
//  SXY
//
//  Created by yh f on 2019/1/8.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "UserHomeTopView.h"
#import "MineInfoModel.h"
@implementation UserHomeTopView{
    
    UIImageView *_faceIma;
    UILabel *_nameLab;
    UILabel *_kindLab;
    UILabel *_comLab;
    UIButton *_tureNameBtn;
    UIButton *_tureComBtn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        [self setup];
    }
    return self;
}


- (void)setup{
    _faceIma = [[UIImageView alloc]init];
    _faceIma.contentMode = UIViewContentModeScaleAspectFill;
    _faceIma.backgroundColor = UIColorFromRGB(BackColorValue);
    _faceIma.clipsToBounds = YES;
    [self addSubview:_faceIma];
    _faceIma.frame = CGRectMake(30, 18, 50, 50);
    _faceIma.layer.cornerRadius = 25;
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(100, 18, ScreenWidth-100 -45, 22) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:@""];
    [self addSubview:_nameLab];
    
    
    _kindLab  = [BaseViewFactory labelWithFrame:CGRectMake(100, 64, ScreenWidth-100 -45, 20) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self addSubview:_kindLab];
    
    _tureComBtn = [BaseViewFactory buttonWithFrame:CGRectMake(ScreenWidth-96, 64, 80, 20) font:APPFONT(8) title:@"" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(0x4BAEC4)];
    _tureComBtn.layer.cornerRadius = 10;
    [self addSubview:_tureComBtn];
    
    _tureNameBtn = [BaseViewFactory buttonWithFrame:CGRectMake(ScreenWidth-186, 64, 80, 20) font:APPFONT(8) title:@"" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    _tureNameBtn.layer.cornerRadius = 10;
    [self addSubview:_tureNameBtn];
    
    _comLab  = [BaseViewFactory labelWithFrame:CGRectMake(100, 96, ScreenWidth-100 -21, 17) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self addSubview:_comLab];
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 130, ScreenWidth, 1) color:UIColorFromRGB(BackColorValue)];
    [self addSubview:line];
    
    _chatBtn = [BaseViewFactory buttonWithFrame:CGRectMake(ScreenWidth-160, 143, 60, 30) font:APPFONT12 title:@"私信" titleColor:UIColorFromRGB(BTNColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    _chatBtn.layer.cornerRadius = 4;
    _chatBtn.layer.borderColor = UIColorFromRGB(BTNColorValue).CGColor;
    _chatBtn.layer.borderWidth = 1;
    [self addSubview:_chatBtn];

    _focBtn = [BaseViewFactory buttonWithFrame:CGRectMake(ScreenWidth-90, 143, 60, 30) font:APPFONT12 title:@"关注" titleColor:UIColorFromRGB(BTNColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    _focBtn.layer.cornerRadius = 4;
    _focBtn.layer.borderColor = UIColorFromRGB(BTNColorValue).CGColor;
    _focBtn.layer.borderWidth = 1;
    [self addSubview:_focBtn];

    UIView *lineview = [BaseViewFactory viewWithFrame:CGRectMake(0, 191, ScreenWidth, 6) color:UIColorFromRGB(BackColorValue)];
    [self addSubview:lineview];
}

-(void)setModel:(MineInfoModel *)model{
    _model = model;
    _nameLab.text = model.name;
    _kindLab.text = [NSString stringWithFormat:@"%@ | %@",model.cityName,model.userType];
    _comLab.text = model.company.length>0?model.company:@"无数据";
    
    NSURL *urlStr = [GlobalMethod returnUrlStrWithImageName:model.photo andisThumb:YES];
    [_faceIma sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"faceempty"]];
    
    //个人
    if ([model.realNameAuth intValue]==0) {
        //未认证
        [_tureNameBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureNameBtn setTitle:@"个人未认证" forState:UIControlStateNormal];
    }else if ([model.realNameAuth intValue]==2){
        //审核中
        [_tureNameBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureNameBtn setTitle:@"个人认证审核中" forState:UIControlStateNormal];
    }else if ([model.realNameAuth intValue]==3){
        //已认证
        [_tureNameBtn setBackgroundColor:UIColorFromRGB(BTNColorValue)];
        [_tureNameBtn setTitle:@"个人认证已通过" forState:UIControlStateNormal];
    }
    //企业
    if ([model.companyAuth intValue]==0) {
        //未认证
        [_tureComBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureComBtn setTitle:@"企业未认证" forState:UIControlStateNormal];
    }else if ([model.companyAuth intValue]==2){
        //审核中
        [_tureComBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureComBtn setTitle:@"企业认证审核中" forState:UIControlStateNormal];
    }else if ([model.realNameAuth intValue]==3){
        //已认证
        [_tureComBtn setBackgroundColor:UIColorFromRGB(0x4BAEC4)];
        [_tureComBtn setTitle:@"企业认证已通过" forState:UIControlStateNormal];
    }
    
}



@end
