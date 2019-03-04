//
//  ForGetController.m
//  SXY
//
//  Created by yh f on 2019/1/7.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "ForGetController.h"

@interface ForGetController ()<UITextFieldDelegate>

@end

@implementation ForGetController{
    
    UITextField  *_phoneTxt;
    UITextField  *_pwdTxt;
    UITextField  *_codeTxt;
    UIButton *_sendBtn;
    YLButton *_loginBtn;
    NSTimer         *_myTimer;              //计时器
    NSInteger       _second;                //计时秒数

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    [self createBackScrollView];
    self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self initUI];
    
}

- (void)initUI{
    
    UIImageView *bgIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg copy"]];
    [self.backView addSubview:bgIma];
    bgIma.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self newsetBarBackBtnWithImage:nil];
    
//    UIImageView *hiIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hi"]];
//    [self.backView addSubview:hiIma];
//    hiIma.frame = CGRectMake(32, 80+STATUSBAR_HEIGHT, 56, 32);
    
    UILabel *hiLab = [BaseViewFactory labelWithFrame:CGRectMake(33, 80+STATUSBAR_HEIGHT, ScreenWidth-66, 30) textColor:UIColorFromRGB(BlackColorValue) font:APPBLODFONTT(22) textAligment:NSTextAlignmentLeft andtext:@"忘记密码"];
    [self.backView addSubview:hiLab];
    
    
    UILabel *quLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentCenter andtext:@"+86"];
    [self.backView addSubview:quLab];
    
    _phoneTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:@"手机号码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAColorValue) delegate:self];
    _phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    [self.backView addSubview:_phoneTxt];
    
    
    _pwdTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:@"新密码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAColorValue) delegate:self];
    [self.backView addSubview:_pwdTxt];
    _codeTxt.keyboardType = UIKeyboardTypeASCIICapable;
    
    _codeTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:@"验证码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAColorValue) delegate:self];
    [self.backView addSubview:_codeTxt];
    _codeTxt.keyboardType = UIKeyboardTypeNumberPad;
    
    _sendBtn = [BaseViewFactory buttonWithFrame:CGRectZero font:APPFONT14 title:@"发送验证码" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.backView addSubview:_sendBtn];
    [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _loginBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT(19) title:@"确定" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.backView addSubview:_loginBtn];
    _loginBtn.layer.cornerRadius = 27;
    [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    User *user = [[UserPL shareManager] getLoginUser];
    if (user) {
        _phoneTxt.text = user.phone;
        
    }
    
    quLab.sd_layout
    .leftSpaceToView(self.backView, 16)
    .topSpaceToView(hiLab, 32)
    .heightIs(56)
    .widthIs(48);
    
    _phoneTxt.sd_layout
    .leftSpaceToView(quLab, 16)
    .topEqualToView(quLab)
    .heightIs(56)
    .rightSpaceToView(self.backView, 16);
    
    _pwdTxt.sd_layout
    .leftSpaceToView(self.backView, 32)
    .topSpaceToView(_phoneTxt, 0)
    .heightIs(56)
    .rightSpaceToView(self.backView, 16);
    
    
    
    _sendBtn.sd_layout
    .widthIs(90)
    .topSpaceToView(_pwdTxt, 0)
    .heightIs(56)
    .rightSpaceToView(self.backView, 32);
    
    
    _codeTxt.sd_layout
    .leftSpaceToView(self.backView, 32)
    .topSpaceToView(_pwdTxt, 0)
    .heightIs(56)
    .rightSpaceToView(_sendBtn, 8);
    
    
    _loginBtn.sd_layout
    .rightSpaceToView(self.backView, 32)
    .leftSpaceToView(self.backView, 32)
    .heightIs(54)
    .bottomSpaceToView(self.backView, 100);
    
}




- (void)newsetBarBackBtnWithImage:(UIImage *)image
{
    UIImage *backImg;
    if (image == nil) {
        backImg = [UIImage imageNamed:@"back_arrow"];
    } else {
        backImg = image;
    }
    CGFloat height = 17;
    CGFloat width = height * backImg.size.width / backImg.size.height;
    
    YLButton* button = [[YLButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    //    [button setBackgroundImage:backImg forState:UIControlStateNormal];
    [button setImage:backImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondToLeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [button setImageRect:CGRectMake(0, 11, width, height)];
    button.frame = CGRectMake(20, STATUSBAR_HEIGHT, 30, 40);
    [self.view addSubview:button];;
}



- (void)sendBtnClick{
    if (_phoneTxt.text.length<=0) {
        [HUD show:@"请输入手机号码"];
        return;
    }
    NSDictionary *dic = @{@"text":_phoneTxt.text};
    [[UserPL shareManager] userUserGetBackVerificationCodeWithDic:dic WithReturnBlock:^(id returnValue) {
        _codeTxt.text = returnValue[@"result"];
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

- (void)loginBtnClick{
    if (_phoneTxt.text.length<=0) {
        [HUD show:@"请输入手机号码"];
        return;
    }
    if (_pwdTxt.text.length<=0) {
        [HUD show:@"请输入密码"];
        return;
    }
    if (_codeTxt.text.length<=0) {
        [HUD show:@"请输入验证码"];
        return;
    }
    NSDictionary *dic = @{@"phone":_phoneTxt.text,
                          @"pwdNew":_pwdTxt.text,
                          @"verificationCode":_codeTxt.text
                          };
    [[UserPL shareManager] userUserPwdBackWithWithDic:dic WithReturnBlock:^(id returnValue) {
        [HUD show:@"密码修改成功"];
        [self performSelector:@selector(respondToLeftButtonClickEvent) withObject:nil afterDelay:1.2];

    } withErrorBlock:^(NSString *msg) {
        
    }];
    
    
    
}







@end
