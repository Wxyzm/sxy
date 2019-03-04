//
//  PhoneBindController.m
//  SXY
//
//  Created by yh f on 2018/11/22.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "PhoneBindController.h"

@interface PhoneBindController ()<UITextFieldDelegate>

@end

@implementation PhoneBindController{
    UITextField  *_phoneTxt;
    UITextField  *_codeTxt;
    UIButton *_sendBtn;
    YLButton *_loginBtn;
    NSTimer         *_myTimer;              //计时器
    NSInteger       _second;                //计时秒数
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机绑定";
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self setBarBackBtnWithImage:nil];
    [self initUI];
}


- (void)initUI{
    UILabel *quLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentCenter andtext:@"+86"];
    [self.view addSubview:quLab];
    
    _phoneTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:@"手机号码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAColorValue) delegate:self];
    _phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneTxt];
    
    
    _codeTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:@"验证码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAColorValue) delegate:self];
    [self.view addSubview:_codeTxt];
    _codeTxt.keyboardType = UIKeyboardTypeNumberPad;
    
    _sendBtn = [BaseViewFactory buttonWithFrame:CGRectZero font:APPFONT14 title:@"发送验证码" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:_sendBtn];
    [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    YLButton *noCodeBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT12 title:@"收不到验证码?" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:noCodeBtn];
    
    
    _loginBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT(16) title:@"确认绑定" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(0xDFDFDF)];
    [self.view addSubview:_loginBtn];
    _loginBtn.layer.cornerRadius = 22;
    [_loginBtn addTarget:self action:@selector(sureBindPhone) forControlEvents:UIControlEventTouchUpInside];
    
    
    quLab.sd_layout
    .leftSpaceToView(self.view, 16)
    .topSpaceToView(self.view, 0)
    .heightIs(56)
    .widthIs(48);
    
    _phoneTxt.sd_layout
    .leftSpaceToView(quLab, 16)
    .topEqualToView(quLab)
    .heightIs(56)
    .rightSpaceToView(self.view, 16);
    
    
    _sendBtn.sd_layout
    .widthIs(80)
    .topSpaceToView(_phoneTxt, 0)
    .heightIs(56)
    .rightSpaceToView(self.view, 32);
    
    
    _codeTxt.sd_layout
    .leftSpaceToView(self.view, 32)
    .topSpaceToView(_phoneTxt, 0)
    .heightIs(56)
    .rightSpaceToView(_sendBtn, 8);
    
    noCodeBtn.sd_layout
    .rightSpaceToView(self.view, 32)
    .topSpaceToView(_codeTxt, 22)
    .heightIs(16)
    .widthIs(80);
    
    _loginBtn.sd_layout
    .rightSpaceToView(self.view, 28)
    .leftSpaceToView(self.view, 28)
    .heightIs(44)
    .bottomSpaceToView(self.view, 18);
    
}



- (void)sureBindPhone{
    if (_phoneTxt.text.length<=0) {
        [HUD show:@"请输入手机号"];
        return;
    }
    if (_codeTxt.text.length<=0) {
        [HUD show:@"请输入验证码"];
        return;
    }
    NSDictionary *dic = @{@"phone":_phoneTxt.text,
                          @"verificationCode":_codeTxt.text
                          };
    [HUD showLoading:nil];
    [[UserPL shareManager] userUserBindPhoneWithDic:dic WithReturnBlock:^(id returnValue) {
        [HUD cancel];
        [HUD show:@"绑定成功"];
        [self performSelector:@selector(back) withObject:nil afterDelay:1.2];
    } withErrorBlock:^(NSString *msg) {
         [HUD cancel];
    }];

}

- (void)back{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark ====== 验证码
- (void)sendBtnClick{
    if (_phoneTxt.text.length<=0) {
        [HUD show:@"请输入手机号"];
        return;
    }
    NSDictionary *dic = @{@"text":_phoneTxt.text};
    [[UserPL shareManager] userUserGetBindVerificationCodeWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [self timerStart];
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
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












-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField == _phoneTxt) {
        if (_phoneTxt.text.length>0) {
            [_sendBtn setTitleColor:UIColorFromRGB(BTNColorValue) forState:UIControlStateNormal];
        }else{
            [_sendBtn setTitleColor:UIColorFromRGB(LitterBlackColorValue) forState:UIControlStateNormal];
        }
    }
    if (_phoneTxt.text.length>0&&_codeTxt.text.length>0) {
        [_loginBtn setBackgroundColor:UIColorFromRGB(BTNColorValue)];

    }else{
        [_loginBtn setBackgroundColor:UIColorFromRGB(0xDFDFDF)];

    }
    
    
    return YES;
}

@end
