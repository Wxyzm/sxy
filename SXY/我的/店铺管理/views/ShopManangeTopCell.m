//
//  ShopManangeTopCell.m
//  SXY
//
//  Created by yh f on 2018/11/20.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ShopManangeTopCell.h"
#import "MineInfoModel.h"
@implementation ShopManangeTopCell{
    
    UILabel *_nameLab;
    UIButton *_tureNameBtn;
    UIButton *_tureComBtn;
    UILabel *_infoLab;

    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUP];
    }
    
    return self;
}


- (void)setUP{
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(20, 20, ScreenWidth-40, 22) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
   
    
    _tureComBtn = [BaseViewFactory buttonWithFrame:CGRectMake(110, 59, 80, 20) font:APPFONT(8) title:@"" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    _tureComBtn.layer.cornerRadius = 10;
    [self.contentView addSubview:_tureComBtn];
    
    _tureNameBtn = [BaseViewFactory buttonWithFrame:CGRectMake(20, 59, 80, 20) font:APPFONT(8) title:@"" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    _tureNameBtn.layer.cornerRadius = 10;
    [self.contentView addSubview:_tureNameBtn];
    
    
    _infoLab  = [BaseViewFactory labelWithFrame:CGRectMake(20, 84, ScreenWidth-40, 22) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_infoLab];
    
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 120, ScreenWidth, 6) color:UIColorFromRGB(0xf4f4f4)];
    [self.contentView addSubview:line];
    
  
}

-(void)setModel:(MineInfoModel *)model{
    
    _model = model;
    if (!model) {
        return;
    }
    _nameLab.text =model.company;
    _infoLab.text = [NSString stringWithFormat:@"%@  |  %@",model.cityName,model.userType];
    
    //个人
    if ([_model.realNameAuth intValue]==0) {
        //未认证
        [_tureNameBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureNameBtn setTitle:@"个人未认证" forState:UIControlStateNormal];
    }else if ([_model.realNameAuth intValue]==2){
        //审核中
        [_tureNameBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureNameBtn setTitle:@"个人认证审核中" forState:UIControlStateNormal];
    }else if ([_model.realNameAuth intValue]==3){
        //已认证
        [_tureNameBtn setBackgroundColor:UIColorFromRGB(BTNColorValue)];
        [_tureNameBtn setTitle:@"个人认证已通过" forState:UIControlStateNormal];
    }
    //企业
    if ([_model.companyAuth intValue]==0) {
        //未认证
        [_tureComBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureComBtn setTitle:@"企业未认证" forState:UIControlStateNormal];
    }else if ([_model.companyAuth intValue]==2){
        //审核中
        [_tureComBtn setBackgroundColor:UIColorFromRGB(RedColorValue)];
        [_tureComBtn setTitle:@"企业认证审核中" forState:UIControlStateNormal];
    }else if ([_model.realNameAuth intValue]==3){
        //已认证
        [_tureComBtn setBackgroundColor:UIColorFromRGB(0x4BAEC4)];
        [_tureComBtn setTitle:@"企业认证已通过" forState:UIControlStateNormal];
    }
    
    
}



@end
