//
//  NameChangeController.m
//  SXY
//
//  Created by yh f on 2018/12/26.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "NameChangeController.h"

@interface NameChangeController ()<UITextFieldDelegate>

@end

@implementation NameChangeController{
    
    UITextField *_nameTxt;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"昵称修改";
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);     
    [self setBarBackBtnWithImage:nil];
    [self initUI];

}

- (void)initUI{
    
    
    
    _nameTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(27, 0, ScreenWidth-54, 56) font:APPFONT14 placeholder:@"请输入昵称" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LitterBlackColorValue) delegate:self];
    [self.view addSubview:_nameTxt];
    _nameTxt.text = _infoDic[@"name"];
    
    
    UIButton *setBtn = [BaseViewFactory buttonWithFrame:CGRectMake(28, ScreenHeight-NaviHeight64-62, ScreenWidth-56, 44) font:APPFONT14 title:@"完成" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:setBtn];
    [setBtn addTarget:self action:@selector(setBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    setBtn.layer.cornerRadius = 22;
}

- (void)setBtnCLick{
    
//    [self collectMan];
//    return;
    
    if (_nameTxt.text.length<=0) {
        [HUD show:@"请输入昵称"];
        return;
    }
    NSMutableDictionary *dic = [_infoDic mutableCopy];
    [dic setObject:_nameTxt.text  forKey:@"name"];

    [[UserPL shareManager] userUserSaveUserInfoWithDic:dic WithReturnBlock:^(id returnValue) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MineVcShouldRefresh object:nil];
        [HUD cancel];
        [HUD show:@"保存成功"];
        WeakSelf(self);
        if (weakself.returnBlock) {
            weakself.returnBlock(_nameTxt.text);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    }];
  
}

- (void)collectGoods{
    NSDictionary *dic = @{@"id":_nameTxt.text};
    [CollectPL Collect_CollectSaveGoodsCollectWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
    
}

- (void)collectCirtle{
    NSDictionary *dic = @{@"id":_nameTxt.text};
    [CollectPL Collect_CollectSaveCircleCollectWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
    } withErrorBlock:^(NSString *msg) {
        
    }];
}

- (void)collectMan{
    NSDictionary *dic = @{@"id":_nameTxt.text};
    [CollectPL Collect_CollectSaveUserCollectWithDic:dic WithReturnBlock:^(id returnValue) {
         NSLog(@"%@",returnValue);
    } withErrorBlock:^(NSString *msg) {
        
    }];
}



@end
