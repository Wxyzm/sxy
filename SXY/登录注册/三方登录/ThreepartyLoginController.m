//
//  ThreepartyLoginController.m
//  SXY
//
//  Created by yh f on 2019/1/18.
//  Copyright © 2019 XX. All rights reserved.
//

#import "ThreepartyLoginController.h"
#import "BindPhotoController.h"
#import "ChoseTypeController.h"
#import <UMCommon/UMCommon.h>


@interface ThreepartyLoginController ()

@end

@implementation ThreepartyLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self initUI];
}

- (void)initUI{
    
    UIImageView *faceIma = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-60, 80, 120, 120)];
    [self.view addSubview:faceIma];
    [faceIma sd_setImageWithURL:[NSURL URLWithString:_resp.iconurl] placeholderImage:nil];
    faceIma.layer.cornerRadius = 60;
    
    UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 220, ScreenWidth, 18) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT15 textAligment:NSTextAlignmentCenter andtext:_resp.name];
    [self.view addSubview:nameLab];
    
    YLButton *loginBtn = [BaseViewFactory ylButtonWithFrame:CGRectMake(20, 260, ScreenWidth - 40, 44) font:APPFONT(19) title:@"登录" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    loginBtn.layer.cornerRadius = 22;
    [self.view  addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)loginBtnClick{
    
    if (_isWx) {
        //微信
        [self wxLogin];
        
    }else{
        //QQ
        [self QQLogin];

    }
}

- (void)wxLogin{
    NSDictionary *dic = @{@"openid":_resp.openid};
    [[UserPL shareManager] userUserLoginByWxWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        if ([returnValue[@"result"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = returnValue[@"result"];
            if ([[dic objectForKey:@"userType"] isEqualToString:@""]||![dic objectForKey:@"userType"]) {
                //未选取身份
                ChoseTypeController *typeVC = [[ChoseTypeController alloc]init];
                typeVC.isFirstLogin = YES;
                [self.navigationController pushViewController:typeVC animated:YES];
                
            }else{
                
                [[UserPL shareManager] gotoTabbarCOntroller];
            }
        }else{
            //未绑定
            BindPhotoController *binVC = [[BindPhotoController alloc]init];
            binVC.resp = _resp;
            [self.navigationController pushViewController:binVC animated:YES];
        }
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
}

- (void)QQLogin{
    NSDictionary *dic = @{@"openid":_resp.openid};
    [[UserPL shareManager] userUserLoginByQQWithDic:dic WithReturnBlock:^(id returnValue) {
          NSLog(@"%@",returnValue);
        if ([returnValue[@"result"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = returnValue[@"result"];
            if ([[dic objectForKey:@"userType"] isEqualToString:@""]||![dic objectForKey:@"userType"]) {
                //未选取身份
                ChoseTypeController *typeVC = [[ChoseTypeController alloc]init];
                typeVC.isFirstLogin = YES;
                [self.navigationController pushViewController:typeVC animated:YES];
                
            }else{
                
                [[UserPL shareManager] gotoTabbarCOntroller];
            }
        }else{
            //未绑定
            BindPhotoController *binVC = [[BindPhotoController alloc]init];
            binVC.resp = _resp;
            [self.navigationController pushViewController:binVC animated:YES];
        }
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
}




- (void)showAlertView
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"亲爱的用户，您的第三方账户未绑定，请登录后前往 我的 - 设置 页面进行绑定。" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
