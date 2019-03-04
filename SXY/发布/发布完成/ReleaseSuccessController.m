//
//  ReleaseSuccessController.m
//  SXY
//
//  Created by yh f on 2018/12/7.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ReleaseSuccessController.h"

@interface ReleaseSuccessController ()

@end

@implementation ReleaseSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布求购";
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self initUI];

}

- (void)initUI{
    
    CGFloat _originY = 123;
    UIImageView *topIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success"]];
    [self.view addSubview:topIma];
    topIma.frame = CGRectMake((ScreenWidth-83)/2, _originY, 83, 74);
    _originY +=74+12;
    
    UILabel * showLab = [BaseViewFactory labelWithFrame:CGRectMake(0, _originY, ScreenWidth, 20) textColor:UIColorFromRGB(0xc4c4c4) font:APPFONT14 textAligment:NSTextAlignmentCenter andtext:@"发布成功"];
    [self.view addSubview:showLab];
    _originY +=47;

//    UIButton *deBtn = [BaseViewFactory buttonWithFrame:CGRectMake((ScreenWidth-118)/2, _originY, 118, 28) font:APPFONT14 title:@"查看详情" titleColor:UIColorFromRGB(0xc4c4c4) backColor:UIColorFromRGB(WhiteColorValue)];
//    deBtn.layer.cornerRadius = 14;
//    deBtn.layer.borderColor = UIColorFromRGB(0xc4c4c4).CGColor;
//    deBtn.layer.borderWidth = 1;
//    [self.view addSubview:deBtn];
//    [deBtn addTarget:self action:@selector(gotoMyReleaseVc) forControlEvents:UIControlEventTouchUpInside];

    
    
    
}


-(void)respondToLeftButtonClickEvent{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}




@end
