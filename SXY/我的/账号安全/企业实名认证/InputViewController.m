//
//  InputViewController.m
//  SXY
//
//  Created by yh f on 2018/12/28.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "InputViewController.h"
#import "AdressPickerView.h"

#import "ComTureModel.h"
@interface InputViewController ()<UITextFieldDelegate,AdressPickerDelegate>

@end

@implementation InputViewController{
    
    UITextField *_ValueTxt1;
    UITextField *_ValueTxt2;
    NSString *_adressID;
    AdressPickerView        *_areaPicker;       //地址选择器

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self initUI];
}


- (void)initUI{
    
    self.title = [_model.Title stringByReplacingOccurrencesOfString:@"*" withString:@""];
    _ValueTxt1 = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:[NSString stringWithFormat:@"请输入%@",[_model.Title stringByReplacingOccurrencesOfString:@"*" withString:@""]] textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LitterBlackColorValue) delegate:self];
    [self.view addSubview:_ValueTxt1];
    _ValueTxt1.frame = CGRectMake(20, 0, ScreenWidth-40, 56);
    
    
    _ValueTxt2 = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:[NSString stringWithFormat:@"请输入%@",_model.Title] textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LitterBlackColorValue) delegate:self];
    [self.view addSubview:_ValueTxt2];
    _ValueTxt2.hidden = YES;
    
    UIButton * setBtn = [BaseViewFactory buttonWithFrame:CGRectMake(28, ScreenHeight - NaviHeight64-62, ScreenWidth-56, 44) font:APPFONT16 title:@"确认" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:setBtn];
    setBtn.layer.cornerRadius = 22;
    [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_model.Title isEqualToString:@"*联系方式"]) {
        NSArray *titleArr = @[@"手机",@"座机"];
        for (int i = 0; i<2; i++) {
            UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(24, 56 *i,35, 56) textColor:UIColorFromRGB(0x939393) font:APPBLODFONTT(13) textAligment:NSTextAlignmentLeft andtext:titleArr[i]];
            [self.view addSubview:lab];
        }
        _ValueTxt1.frame = CGRectMake(94, 0, ScreenWidth-94, 56);
        _ValueTxt2.frame = CGRectMake(94, 56, ScreenWidth-94, 56);
        _ValueTxt1.placeholder = @"手机号码";
        _ValueTxt2.placeholder = @"座机号码";
        _ValueTxt2.hidden = NO;
    }else if ([_model.Title isEqualToString:@"*公司地址"]){
        
        _ValueTxt1.frame = CGRectMake(40, 0, ScreenWidth-60, 56);
        _ValueTxt2.frame = CGRectMake(40, 56, ScreenWidth-60, 56);
        _ValueTxt1.placeholder = @"省份、城市、区县";
        _ValueTxt2.placeholder = @"详细地址，如街道、楼牌号等";
        UIButton *adressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:adressBtn];
        adressBtn.frame = CGRectMake(0, 0, ScreenWidth, 56);
        [adressBtn addTarget:self action:@selector(adressBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _ValueTxt2.hidden = NO;

        
    }
    
    
    
}


/**
 选择地址
 */
- (void)adressBtnClick{
    
    
     [self presentAreaPicker];

}

#pragma mark ======== 地址选择



- (void)presentAreaPicker
{
    [self.view endEditing:YES];
    if (!_areaPicker) {
        _areaPicker = [[AdressPickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 168)];
        _areaPicker.delegate = self;
      //  [_areaPicker choseFujian];
    }
    
    [_areaPicker showInView:self.view];
    
}

#pragma mark--------------------------------JYAreaPickerDelegate--------------------------------
- (void)pickerDidChaneStatus:(AdressPickerView *)picker
{
    if (picker == _areaPicker) {
        NSString *areaString = [NSString stringWithFormat:@"%@  %@  %@", _areaPicker.provinceDic, _areaPicker.cityDic,_areaPicker.areaDic];
        NSLog(@"选择地址===========%@",areaString);
        
        [_ValueTxt1 setText:[NSString stringWithFormat:@"%@  %@  %@", _areaPicker.provinceDic[@"name"], _areaPicker.cityDic[@"name"],_areaPicker.areaDic[@"name"]]];
        
        _adressID = [NSString stringWithFormat:@"%@  %@  %@", _areaPicker.provinceDic[@"code"], _areaPicker.cityDic[@"code"],_areaPicker.areaDic[@"code"]];
        
    }
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [_areaPicker cancelPicker];
    
    return YES;
}




/**
 提交
 */
- (void)setBtnClick{
    
    if ([_model.Title isEqualToString:@"*联系方式"]) {
        if (_ValueTxt1.text.length<=0) {
            [HUD show:@"请输入手机号码"];
            return;
        }
//        if (_ValueTxt2.text.length<=0) {
//            [HUD show:@"请输入座机号码"];
//            return;
//        }
        _model.value1 = _ValueTxt1.text;
        _model.value2 = _ValueTxt2.text;

        
       
    }else if ([_model.Title isEqualToString:@"*公司地址"]){
        if (_ValueTxt1.text.length<=0) {
            [HUD show:@"请选择省份、城市、区县"];
            return;
        }
        if (_ValueTxt2.text.length<=0) {
            [HUD show:@"请输入详细地址"];
            return;
        }
        _model.value1 = _ValueTxt1.text;
        _model.value2 = _ValueTxt2.text;
        _model.adressId = _adressID;
        
    }else{
        if (_ValueTxt1.text.length<=0) {
            [HUD show:[NSString stringWithFormat:@"请输入%@",_model.Title]];
            return;
        }
        _model.value1 = _ValueTxt1.text;
    }
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
}



@end
