//
//  ChoseTypeController.m
//  SXY
//
//  Created by yh f on 2018/12/29.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ChoseTypeController.h"
#import "TypeDetailController.h"
@interface ChoseTypeController ()

@end

@implementation ChoseTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择角色";
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self initUI];
}

- (void)initUI{
    
    NSArray *arr = @[@"贸易商",@"服装企业",@"供应链"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [BaseViewFactory buttonWithFrame:CGRectMake(113, 120 +80*i, ScreenWidth-226, 40) font:APPFONT14 title:arr[i] titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
        [self.view addSubview:btn];
        btn.layer.cornerRadius = 20;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = UIColorFromRGB(LitterBlackColorValue).CGColor;
        btn.tag = 1000 +i;
        [btn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}


- (void)btnCLick:(UIButton *)btn{
    
    TypeDetailController *devc = [[TypeDetailController alloc]init];
    devc.userType = btn.tag - 1000;
    devc.isFirstLogin = _isFirstLogin;
    [self.navigationController pushViewController:devc animated:YES];
}

@end
