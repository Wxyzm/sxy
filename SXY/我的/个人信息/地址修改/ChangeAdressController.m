//
//  ChangeAdressController.m
//  SXY
//
//  Created by souxiuyun on 2019/1/22.
//  Copyright © 2019 XX. All rights reserved.
//

#import "ChangeAdressController.h"
#import "AdressPickerView.h"

@interface ChangeAdressController ()<UITextFieldDelegate,AdressPickerDelegate>

@end

@implementation ChangeAdressController{
    
    UITextField *_ValueTxt1;
    UITextField *_ValueTxt2;
    NSString *_adressID;
    AdressPickerView        *_areaPicker;       //地址选择器
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改地址";
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self initUI];
}

- (void)initUI{
    
    
    _ValueTxt1 = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:@"请选择地址" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LitterBlackColorValue) delegate:self];
    [self.view addSubview:_ValueTxt1];
    _ValueTxt1.frame = CGRectMake(20, 0, ScreenWidth-40, 56);
    
    
    _ValueTxt2 = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT14 placeholder:@"请输入详细地址" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LitterBlackColorValue) delegate:self];
    [self.view addSubview:_ValueTxt2];
    _ValueTxt2.hidden = YES;
    
    UIButton * setBtn = [BaseViewFactory buttonWithFrame:CGRectMake(28, ScreenHeight - NaviHeight64-62, ScreenWidth-56, 44) font:APPFONT16 title:@"确认" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:setBtn];
    setBtn.layer.cornerRadius = 22;
    [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    if (_ValueTxt1.text.length<=0) {
        [HUD show:@"请选择地址"];
        return;
    }
    if (_ValueTxt2.text.length<=0) {
        [HUD show:@"请输入详细地址"];
        return;
    }
    
    NSMutableDictionary *dic = [_infoDic mutableCopy];

    if (!_areaPicker.provinceDic) {
        
    }else{
        [dic setObject:_areaPicker.provinceDic[@"name"]  forKey:@"provinceName"];
        [dic setObject:_areaPicker.provinceDic[@"code"]  forKey:@"provinceIndex"];
        [dic setObject:_areaPicker.cityDic[@"name"]  forKey:@"cityName"];
        [dic setObject:_areaPicker.cityDic[@"code"]  forKey:@"cityIndex"];
        [dic setObject:_areaPicker.areaDic[@"name"]  forKey:@"areaName"];
        [dic setObject:_areaPicker.areaDic[@"code"]  forKey:@"areaIndex"];
    }
    [dic setObject:_ValueTxt2.text  forKey:@"detailAddress"];
    [[UserPL shareManager] userUserSaveUserInfoWithDic:dic WithReturnBlock:^(id returnValue) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MineVcShouldRefresh object:nil];
        [HUD cancel];
        [HUD show:@"保存成功"];
        WeakSelf(self);
        if (weakself.returnBlock) {
            weakself.returnBlock(_areaPicker.cityDic[@"name"]);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    }];

}

@end
