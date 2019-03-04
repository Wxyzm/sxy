//
//  ReController.m
//  SXY
//
//  Created by yh f on 2019/1/7.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "ReController.h"
#import "XieYiViewController.h"
#import "ChoseTypeController.h"

@interface ReController ()<UITextFieldDelegate>

@end

@implementation ReController{
    
    UITextField  *_phoneTxt;
    UITextField  *_pwdTxt;
    UITextField  *_codeTxt;
    UIButton *_sendBtn;
    YLButton *_loginBtn;
    YLButton *_agreeBtn;
    NSTimer         *_myTimer;              //计时器
    NSInteger       _second;                //计时秒数
    BOOL   _agreeXY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    [self initUI];
    
    
}

- (void)initUI{
    _agreeXY = YES;
    
    UIImageView *bgIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg copy"]];
    [self.view addSubview:bgIma];
    bgIma.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [self newsetBarBackBtnWithImage:nil];
    
    UILabel *hiLab = [BaseViewFactory labelWithFrame:CGRectMake(33, 80+STATUSBAR_HEIGHT, ScreenWidth-66, 30) textColor:UIColorFromRGB(BlackColorValue) font:APPBLODFONTT(22) textAligment:NSTextAlignmentLeft andtext:@"注册"];
    [self.view addSubview:hiLab];
    
    
    
    _phoneTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:@"请输入手机号码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAColorValue) delegate:self];
    _phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneTxt];
    
    _pwdTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:@"请输入密码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAColorValue) delegate:self];
    [self.view addSubview:_pwdTxt];
    _pwdTxt.keyboardType = UIKeyboardTypeASCIICapable;
    
    
    _codeTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:@"验证码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAColorValue) delegate:self];
    [self.view addSubview:_codeTxt];
    _codeTxt.keyboardType = UIKeyboardTypeNumberPad;
    
    _sendBtn = [BaseViewFactory buttonWithFrame:CGRectZero font:APPFONT14 title:@"发送验证码" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:_sendBtn];
    [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    
    YLButton *noCodeBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT12 title:@"收不到验证码?" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:noCodeBtn];
    
    _loginBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT(19) title:@"确认" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:_loginBtn];
    _loginBtn.layer.cornerRadius = 27;
    [_loginBtn setImage:[UIImage imageNamed:@"phone_w"] forState:UIControlStateNormal];
    [_loginBtn setImageRect:CGRectMake((ScreenWidth-64)/2-58, 14.5, 25, 25)];
    [_loginBtn setTitleRect:CGRectMake((ScreenWidth-64)/2-18, 0, 80, 54)];
    [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
  
    
    User *user = [[UserPL shareManager] getLoginUser];
    if (user) {
        _phoneTxt.text = user.phone;
        
    }
    
  
    _phoneTxt.sd_layout
    .leftSpaceToView(self.view, 32)
    .topSpaceToView(hiLab, 0)
    .heightIs(56)
    .rightSpaceToView(self.view, 16);
    
    _pwdTxt.sd_layout
    .leftSpaceToView(self.view, 32)
    .topSpaceToView(_phoneTxt, 0)
    .heightIs(56)
    .rightSpaceToView(self.view, 16);
    
    
    
    _sendBtn.sd_layout
    .widthIs(90)
    .topSpaceToView(_pwdTxt, 0)
    .heightIs(56)
    .rightSpaceToView(self.view, 32);
    
    
    _codeTxt.sd_layout
    .leftSpaceToView(self.view, 32)
    .topSpaceToView(_pwdTxt, 0)
    .heightIs(56)
    .rightSpaceToView(_sendBtn, 8);
    
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
    
    noCodeBtn.sd_layout
    .rightSpaceToView(self.view, 32)
    .topEqualToView(_agreeBtn)
    .heightIs(16)
    .widthIs(80);
    
    
    _loginBtn.sd_layout
    .rightSpaceToView(self.view, 32)
    .leftSpaceToView(self.view, 32)
    .heightIs(54)
    .bottomSpaceToView(self.view, 100);
    
   
    
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

/**
 发送验证码
 */
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


/**
 协议
 */
- (void)xieyiBtnClick{
    XieYiViewController *xieyiVc = [[XieYiViewController alloc]init];
    [self.navigationController pushViewController:xieyiVc animated:YES];
}


/**
 确定
 */
- (void)loginBtnClick{
    if (!_agreeXY) {
        [HUD show:@"请同意服务协议"];
        return;
    }
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
    NSDictionary *dic = @{@"loginName":_phoneTxt.text,
                          @"password":_pwdTxt.text,
                          @"verificationCode":_codeTxt.text
                          };
    
    [[UserPL shareManager] userUsergetLoginByPhoneDic:dic WithReturnBlock:^(id returnValue) {
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
//    [[UserPL shareManager] userUserRegisterUserByPhoneWithWithDic:dic WithReturnBlock:^(id returnValue) {
//        [HUD show:@"注册成功"];
//        [self performSelector:@selector(respondToLeftButtonClickEvent) withObject:nil afterDelay:1.2];
//    } withErrorBlock:^(NSString *msg) {
//
//    }];
    
    
}





@end
