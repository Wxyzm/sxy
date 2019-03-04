//
//  LoginController.m
//  SXY
//
//  Created by yh f on 2018/11/3.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "LoginController.h"
#import "ChoseTypeController.h"
#import "ReController.h"//注册
#import "ForGetController.h"//忘记密码
#import "ThreepartyLoginController.h"
#import "XieYiViewController.h"

@interface LoginController ()<UITextFieldDelegate>



@end

@implementation LoginController{
    
    UITextField  *_phoneTxt;
    UITextField  *_codeTxt;
    UIButton *_sendBtn;
    YLButton *_loginBtn;
    YLButton *_agreeBtn;
    UIButton *_loginTypeBtn;
    NSTimer         *_myTimer;              //计时器
    NSInteger       _second;                //计时秒数
    BOOL _isPhonetype;
    BOOL   _agreeXY;

    UILabel *_quLab;
    UIButton *_registBTn;
    YLButton *_noCodeBtn;
    UIImageView *_hiIma;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    [self createBackScrollView];
    self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self initUI];
}


- (void)initUI{
    _isPhonetype = YES;
    _agreeXY = YES;
    UIImageView *bgIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg copy"]];
    [self.backView addSubview:bgIma];
    bgIma.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    
    CGFloat _originY = 0;
    
    _originY +=  80+STATUSBAR_HEIGHT;
    _hiIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hi"]];
    [self.backView addSubview:_hiIma];
    _hiIma.frame = CGRectMake(32,_originY, 56, 32);
    
    _originY += 32+32;
    _quLab = [BaseViewFactory labelWithFrame:CGRectMake(16, _originY, 48, 56) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentCenter andtext:@"+86"];
    [self.backView addSubview:_quLab];

    _phoneTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(80, _originY, ScreenWidth-112, 56) font:APPFONT14 placeholder:@"手机号码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAColorValue) delegate:self];
    _phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    [self.backView addSubview:_phoneTxt];

    _originY += 56;
    _sendBtn = [BaseViewFactory buttonWithFrame:CGRectMake(ScreenWidth-122, _originY, 90, 56) font:APPFONT14 title:@"发送验证码" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.backView addSubview:_sendBtn];
    [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _codeTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(32, _originY, ScreenWidth-32-122, 56) font:APPFONT14 placeholder:@"验证码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAColorValue) delegate:self];
    [self.backView addSubview:_codeTxt];
    _codeTxt.keyboardType = UIKeyboardTypeNumberPad;

   
    _originY += 56+22;
    _agreeBtn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(LitterBlackColorValue) cornerRadius:0 andtarget:self action:@selector(agreeBtnClick) titleFont:APPFONT12 title:@"同意"];
    [self.backView addSubview:_agreeBtn];
    [_agreeBtn setImage:[UIImage imageNamed:@"default__selected"] forState:UIControlStateNormal];
    [_agreeBtn setImageRect:CGRectMake(0, 0, 16, 16)];
    [_agreeBtn setTitleRect:CGRectMake(24, 0, 25, 16)];
    _agreeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    _agreeBtn.frame = CGRectMake(32, _originY, 49, 16);
    
    UIButton *xieyiBtn = [BaseViewFactory buttonWithFrame:CGRectZero font:APPFONT12 title:@"" titleColor:UIColorFromRGB(PLAColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.backView addSubview:xieyiBtn];
    [xieyiBtn addTarget:self action:@selector(xieyiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    xieyiBtn.frame = CGRectMake(81, _originY, 50, 16);

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"服务协议"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(LitterBlackColorValue) range:strRange];
    [xieyiBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    
    _noCodeBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT12 title:@"收不到验证码?" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.backView addSubview:_noCodeBtn];
    [_noCodeBtn addTarget:self action:@selector(noCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _registBTn =[BaseViewFactory buttonWithFrame:CGRectZero font:APPFONT14 title:@"注册" titleColor:UIColorFromRGB(BlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.backView addSubview:_registBTn];
    [_registBTn addTarget:self action:@selector(registBTnClick) forControlEvents:UIControlEventTouchUpInside];
    
    

    _loginBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT(19) title:@"手机登录" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.backView addSubview:_loginBtn];
    _loginBtn.layer.cornerRadius = 27;
    [_loginBtn setImage:[UIImage imageNamed:@"phone_w"] forState:UIControlStateNormal];
    [_loginBtn setImageRect:CGRectMake((ScreenWidth-64)/2-58, 14.5, 25, 25)];
    [_loginBtn setTitleRect:CGRectMake((ScreenWidth-64)/2-18, 0, 80, 54)];
    [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    YLButton *qqBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT(12) title:@"QQ登录" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.backView addSubview:qqBtn];
    [qqBtn setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [qqBtn setImageRect:CGRectMake(0, 0, 16, 16)];
    [qqBtn setTitleRect:CGRectMake(24, 0, 50, 16)];
    [qqBtn addTarget:self action:@selector(qqBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _loginTypeBtn =[BaseViewFactory buttonWithFrame:CGRectZero font:APPFONT14 title:@"账号登录" titleColor:UIColorFromRGB(BTNColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.backView addSubview:_loginTypeBtn];
    [_loginTypeBtn addTarget:self action:@selector(choseLogintype) forControlEvents:UIControlEventTouchUpInside];
    
    YLButton *weixinBtn = [BaseViewFactory ylButtonWithFrame:CGRectZero font:APPFONT(12) title:@"微信登录" titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [self.backView addSubview:weixinBtn];
    [weixinBtn setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [weixinBtn setImageRect:CGRectMake(0, 0, 16, 16)];
    [weixinBtn setTitleRect:CGRectMake(24, 0, 50, 16)];
    [weixinBtn addTarget:self action:@selector(weixinBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(LitterBlackColorValue)];
    [self.backView addSubview:lineView];
  
    
    User *user = [[UserPL shareManager] getLoginUser];
    if (user) {
        _phoneTxt.text = user.phone;

    }
    
    _registBTn.hidden = YES;
    
    _noCodeBtn.sd_layout
    .rightSpaceToView(self.backView, 13)
    .topSpaceToView(_agreeBtn, 16)
    .heightIs(16)
    .widthIs(90);
    
    
   
    
    _loginTypeBtn.sd_layout
    .rightSpaceToView(self.backView, 32)
    .leftSpaceToView(self.backView, 32)
    .heightIs(54)
    .bottomSpaceToView(self.backView, 100);
    
    _loginBtn.sd_layout
    .rightSpaceToView(self.backView, 32)
    .leftSpaceToView(self.backView, 32)
    .heightIs(54)
    .bottomSpaceToView(_loginTypeBtn, 5);
    
    
    qqBtn.sd_layout
    .rightSpaceToView(self.backView, ScreenWidth/2 + 28)
    .widthIs(74)
    .heightIs(16)
    .bottomSpaceToView(self.backView, 40);
    
    weixinBtn.sd_layout
    .leftSpaceToView(self.backView, ScreenWidth/2 + 28)
    .widthIs(74)
    .heightIs(16)
    .bottomSpaceToView(self.backView, 40);
    
    lineView.sd_layout
    .centerXIs(ScreenWidth/2)
    .widthIs(2)
    .heightIs(10)
    .bottomSpaceToView(self.backView, 43);
    
    _registBTn.sd_layout
    .rightSpaceToView(self.backView, 16)
    .topSpaceToView(_codeTxt, 23)
    .heightIs(16)
    .widthIs(30);
    
}





#pragma mark ====== 验证码
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


#pragma mark ====== 切换登录类型

/**
 切换登录类型
 */
- (void)choseLogintype{
    _isPhonetype = !_isPhonetype;
    [self setUI];
}


- (void)setUI{
    
    if (_isPhonetype) {
        _quLab.hidden = NO;
        _codeTxt.secureTextEntry = NO;
        _sendBtn.hidden = NO;
        _registBTn.hidden = YES;
        _codeTxt.placeholder = @"验证码";
        _phoneTxt.placeholder = @"手机号码";
        [_noCodeBtn setTitle:@"收不到验证码？" forState:UIControlStateNormal];
        _phoneTxt.frame = CGRectMake(80,  80+STATUSBAR_HEIGHT +64, ScreenWidth-96, 56);
        [_loginBtn setTitle:@"手机登录" forState:UIControlStateNormal];
        [_loginTypeBtn setTitle:@"账号登录" forState:UIControlStateNormal];
        _codeTxt.keyboardType = UIKeyboardTypeNumberPad;

    }else{
        _quLab.hidden = YES;
        _codeTxt.secureTextEntry = YES;
        _sendBtn.hidden = YES;
        _registBTn.hidden = NO;
        _codeTxt.placeholder = @"请输入密码";
        _phoneTxt.placeholder = @"请输入账号";
        [_noCodeBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        _phoneTxt.frame = CGRectMake(32,  80+STATUSBAR_HEIGHT +64, ScreenWidth-96, 56);
        [_loginBtn setTitle:@"账号登录" forState:UIControlStateNormal];
        [_loginTypeBtn setTitle:@"手机登录" forState:UIControlStateNormal];
        _codeTxt.keyboardType = UIKeyboardTypeASCIICapable;

      
        
    }
    
    
    
    
    
}


#pragma mark ====== 登录

/**
 登录
 */
- (void)loginBtnClick{
    if (_phoneTxt.text.length<=0) {
        [HUD show:@"请输入手机号码"];
        return;
    }
    if (_codeTxt.text.length<=0) {
        [HUD show:@"请输入验证码"];
        return;
    }
    if (!_agreeXY) {
        [HUD show:@"请同意服务协议"];
        return;
    }
    
    NSDictionary *dic;
    if (_isPhonetype) {
        //手机登录
        dic = @{@"loginName":_phoneTxt.text,
                @"password":@"",
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
        
    }else{
        dic = @{@"username":_phoneTxt.text,
                @"password":_codeTxt.text
                };
        [[UserPL shareManager] userUserLoginWithDic:dic WithReturnBlock:^(id returnValue) {
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
}


#pragma mark ====== 注册
- (void)registBTnClick{
    ReController *reVC = [[ReController alloc]init];
    [self.navigationController pushViewController:reVC animated:YES];
    
    
}

#pragma mark ====== 忘记密码，收不到验证码
- (void)noCodeBtnClick{
    if (_isPhonetype) {
        //电话联系
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18457586800"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        //忘记密码
        ForGetController*reVC = [[ForGetController alloc]init];
        [self.navigationController pushViewController:reVC animated:YES];
        
        
    }
    
}

#pragma mark ====== 同意服务协议
- (void)agreeBtnClick{
    _agreeXY = !_agreeXY;
    if (_agreeXY) {
        [_agreeBtn setImage:[UIImage imageNamed:@"default__selected"] forState:UIControlStateNormal];
        
    }else{
        [_agreeBtn setImage:[UIImage imageNamed:@"default__selected_u"] forState:UIControlStateNormal];
        
        
    }
    
}

#pragma mark ====== 协议
- (void)xieyiBtnClick
{
    XieYiViewController *xieyiVc = [[XieYiViewController alloc]init];
    [self.navigationController pushViewController:xieyiVc animated:YES];
}


#pragma mark ====== 三方登录

- (void)qqBtnClick{
    [HUD show:@"暂未开放"];
    return;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [HUD show:@"未知错误，请稍后再试"];
        }else{
            UMSocialUserInfoResponse *resp = result;
            //授权信息
            NSLog(@"QQ uid:%@",resp.uid);
            NSLog(@"QQ openid:%@",resp.openid);
            NSLog(@"QQ accessToken:%@",resp.accessToken);
            NSLog(@"QQ refreshToken:%@",resp.refreshToken);
            NSLog(@"QQ expiration:%@",resp.expiration);
            //用户信息
            NSLog(@"QQ name:%@",resp.name);
            NSLog(@"QQ iconurl:%@",resp.iconurl);
            NSLog(@"QQ gender:%@",resp.gender);
            //第三方平台sdk源数据
            NSLog(@"QQ originalResponse:%@",resp.originalResponse);
            ThreepartyLoginController *thVc = [[ThreepartyLoginController alloc]init];
            thVc.resp = resp;
            thVc.title = @"QQ登录";
            thVc.isWx = NO;
            [self.navigationController pushViewController:thVc animated:YES];
        }
    }];
    
}

- (void)weixinBtnClick{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [HUD show:@"未知错误，请稍后再试"];
        }else{
            UMSocialUserInfoResponse *resp = result;
            //授权信息
            NSLog(@"Wechat uid:%@",resp.uid);
            NSLog(@"Wechat openid:%@",resp.openid);
            NSLog(@"Wechat accessToken:%@",resp.accessToken);
            NSLog(@"Wechat refreshToken:%@",resp.refreshToken);
            NSLog(@"Wechat expiration:%@",resp.expiration);
            //用户信息
            NSLog(@"Wechat name:%@",resp.name);
            NSLog(@"Wechat iconurl:%@",resp.iconurl);
            NSLog(@"Wechat gender:%@",resp.gender);
            //第三方平台sdk源数据
            NSLog(@"Wechat originalResponse:%@",resp.originalResponse);
            ThreepartyLoginController *thVc = [[ThreepartyLoginController alloc]init];
            thVc.resp = resp;
            thVc.title = @"微信登录";
            thVc.isWx = YES;
            [self.navigationController pushViewController:thVc animated:YES];
        }
    }];
}





@end
