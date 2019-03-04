//
//  BindPhotoController.m
//  SXY
//
//  Created by souxiuyun on 2019/1/21.
//  Copyright © 2019 XX. All rights reserved.
//

#import "BindPhotoController.h"
#import <UMCommon/UMCommon.h>
#import "ChoseTypeController.h"
#import "XieYiViewController.h"

@interface BindPhotoController ()<UITextFieldDelegate>

@end

@implementation BindPhotoController{
    
    UITextField  *_phoneTxt;
    UITextField  *_codeTxt;
    UIButton *_sendBtn;
    NSTimer         *_myTimer;              //计时器
    NSInteger       _second;                //计时秒数
    YLButton *_agreeBtn;
    BOOL   _agreeXY;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);

    [self initUI];
}


- (void)initUI{
    _agreeXY = YES;

    UIImageView *faceIma = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-60, 80, 120, 120)];
    [self.view addSubview:faceIma];
    [faceIma sd_setImageWithURL:[NSURL URLWithString:_resp.iconurl] placeholderImage:nil];
    faceIma.layer.cornerRadius = 60;
    
    UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 220, ScreenWidth, 18) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT15 textAligment:NSTextAlignmentCenter andtext:_resp.name];
    [self.view addSubview:nameLab];
    
    
    _phoneTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(32, 260, ScreenWidth-112, 56) font:APPFONT14 placeholder:@"请输入手机号码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LitterBlackColorValue) delegate:self];
    _phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneTxt];
    
    _sendBtn = [BaseViewFactory buttonWithFrame:CGRectMake(ScreenWidth-122, 316, 90, 56) font:APPFONT14 title:@"发送验证码" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:_sendBtn];
    [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _codeTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(32, 316, ScreenWidth-32-122, 56) font:APPFONT14 placeholder:@"验证码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LitterBlackColorValue) delegate:self];
    [self.view addSubview:_codeTxt];
    _codeTxt.keyboardType = UIKeyboardTypeNumberPad;
    
    _agreeBtn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(LitterBlackColorValue) cornerRadius:0 andtarget:self action:@selector(agreeBtnClick) titleFont:APPFONT12 title:@"同意"];
    [self.view addSubview:_agreeBtn];
    [_agreeBtn setImage:[UIImage imageNamed:@"default__selected"] forState:UIControlStateNormal];
    [_agreeBtn setImageRect:CGRectMake(0, 0, 16, 16)];
    [_agreeBtn setTitleRect:CGRectMake(24, 0, 25, 16)];
    _agreeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    UIButton *xieyiBtn = [BaseViewFactory buttonWithFrame:CGRectZero font:APPFONT12 title:@"" titleColor:UIColorFromRGB(PLAColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:xieyiBtn];
    [xieyiBtn addTarget:self action:@selector(xieyiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"服务协议"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(LitterBlackColorValue) range:strRange];
    [xieyiBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    
    _agreeBtn.sd_layout
    .leftSpaceToView(self.view, 32)
    .topSpaceToView(_codeTxt, 22)
    .heightIs(16)
    .widthIs(49);
    
    xieyiBtn.sd_layout
    .leftSpaceToView(_agreeBtn, 0)
    .topSpaceToView(_codeTxt, 22)
    .heightIs(16)
    .widthIs(50);
    
    
    YLButton *loginBtn = [BaseViewFactory ylButtonWithFrame:CGRectMake(20, 450, ScreenWidth - 40, 44) font:APPFONT(19) title:@"确定绑定" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    loginBtn.layer.cornerRadius = 22;
    [self.view  addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}


- (void)sendBtnClick{
    if (_phoneTxt.text.length<=0) {
        [HUD show:@"请输入手机号码"];
        return;
    }
    NSDictionary *dic = @{@"text":_phoneTxt.text};
    [[UserPL shareManager] userUsergetRegVerificationCodeDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _codeTxt.text = returnValue[@"result"];
        [self timerStart];
    } withErrorBlock:^(NSString *msg) {
        
    }];
}

- (void)xieyiBtnClick
{
    XieYiViewController *xieyiVc = [[XieYiViewController alloc]init];
    [self.navigationController pushViewController:xieyiVc animated:YES];
}



- (void)loginBtnClick{
    if (!_agreeXY) {
        [HUD show:@"请同意服务协议"];
        return;
    }
    if (_phoneTxt.text.length<=0) {
        [HUD show:@"请输入手机号码"];
        return;
    }
    if (_codeTxt.text.length<=0) {
        [HUD show:@"请输入手机号码"];
        return;
    }
    NSDictionary *dic = @{@"loginName":_phoneTxt.text,
                          @"openid":_resp.openid,
                          @"verificationCode":_codeTxt.text
                          };
    [[UserPL shareManager] userUserLoginByWxWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        NSDictionary *dic = returnValue[@"result"];
        if ([[dic objectForKey:@"userType"] isEqualToString:@""]||![dic objectForKey:@"userType"]) {
            //未选取身份
            ChoseTypeController *typeVC = [[ChoseTypeController alloc]init];
            typeVC.isFirstLogin = YES;
            [self.navigationController pushViewController:typeVC animated:YES];
            
        }else{
            
            [[UserPL shareManager] gotoTabbarCOntroller];
        }
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
}

/**
 同意
 */
- (void)agreeBtnClick{
    _agreeXY = !_agreeXY;
    if (_agreeXY) {
        [_agreeBtn setImage:[UIImage imageNamed:@"default__selected"] forState:UIControlStateNormal];
        
    }else{
        [_agreeBtn setImage:[UIImage imageNamed:@"default__selected_u"] forState:UIControlStateNormal];
        
        
    }
}




//倒计时
- (void)timerStart
{
    _second = TIMEOUT;
    [self endTimer];
    [_sendBtn setTitle:[NSString stringWithFormat:@"%02ds后再获取",(int)_second] forState:UIControlStateNormal];
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
}


//计时时钟 每秒刷新
- (void)scrollTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (--_second > 0){
            NSString *message = [NSString stringWithFormat:@"%02ds后再获取",(int)_second];
            [_sendBtn setTitle:message forState:UIControlStateNormal];
            _sendBtn.userInteractionEnabled = NO;
            
        } else {
            //关闭定时器
            _sendBtn.userInteractionEnabled = YES;
            _sendBtn.titleLabel.alpha = 1;
            [_sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [_myTimer invalidate];
            _myTimer = nil;
        }
    });
}

- (void)endTimer
{
    
    [_myTimer invalidate];
    _myTimer = nil;
}

@end
