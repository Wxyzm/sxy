//
//  TypeDetailController.m
//  SXY
//
//  Created by yh f on 2018/12/29.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "TypeDetailController.h"
#import "ComTureNameController.h"
#import "TypeModel.h"

@interface TypeDetailController ()<UITextViewDelegate>

@end

@implementation TypeDetailController{
    
    
    UITextView *_memoTxt;
    UIView *_boomView;
    UIView *_biaoView;
    CGFloat _originY;
    TypeModel *_Selectedmodeol;
    NSMutableArray *_btnArr;
    NSMutableArray *_dataArr;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.title = @"选择角色";
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _btnArr = [NSMutableArray arrayWithCapacity:0];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    if (_userType ==2) {
        [self loadKindList];

    }else{
        
       [self initUI];
    }
}

- (void)initUI{
    [self createBackScrollView];
    self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviHeight64-70);
    self.backView.backgroundColor = UIColorFromRGB(WhiteColorValue);

    UIImageView *selectIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"default__selected"]];
    [self.backView addSubview:selectIma];
    selectIma.frame = CGRectMake(28, 37, 16, 16);
    
    
    NSString *title;
    if (_userType == 0) {
        title = @"贸易商";
    }else if (_userType == 1){
        title = @"服装企业";
    }else{
         title = @"供应链";
    }
    UILabel *showLab = [BaseViewFactory labelWithFrame:CGRectMake(54, 0, 200, 90) textColor:UIColorFromRGB(0xC0B451) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:title];
    [self.backView addSubview:showLab];
    _originY += 90;
    
    
    if (_userType == 2){
        [self.view addSubview:_biaoView];
    }
    
    
    
    _boomView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:_boomView];

    UILabel *memoLab = [BaseViewFactory labelWithFrame:CGRectMake(28, 0, 200, 56) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:@"备注信息"];
    [_boomView addSubview:memoLab];
    
    _memoTxt= [[UITextView alloc]initWithFrame:CGRectMake(18, 56,ScreenWidth-36 , 120)];
    _memoTxt.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _memoTxt.text = @"请填写您的备注信息，或者细分领域";
    _memoTxt.font =APPFONT(14);
    _memoTxt.textColor = UIColorFromRGB(LitterBlackColorValue);
    _memoTxt.delegate = self;
    [_boomView addSubview:_memoTxt];
    
    _boomView.frame = CGRectMake(0, _originY, ScreenWidth, 176);
    self.backView.contentSize = CGSizeMake(ScreenWidth, _originY+190);
    
    
    UIButton * setBtn = [BaseViewFactory buttonWithFrame:CGRectMake(28, ScreenHeight - NaviHeight64-62, ScreenWidth-56, 44) font:APPFONT16 title:@"确认" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:setBtn];
    [setBtn addTarget:self action:@selector(setAllInfo) forControlEvents:UIControlEventTouchUpInside];
    setBtn.layer.cornerRadius = 22;
  
    
   
    
    
}



- (void)loadKindList{
    
    [CategoryPL Category_CategoryGetUserKindListWithDic:nil WithReturnBlock:^(id returnValue) {
        _dataArr = [TypeModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self initBiaoViewWithArr];
        [self initUI];
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
    
    
}

- (void)initBiaoViewWithArr{
    
    _biaoView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(WhiteColorValue)];
    
    UILabel *nameLab =  [BaseViewFactory labelWithFrame:CGRectMake(28, 0, 200, 40) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@"选择类目"];
    [_biaoView addSubview:nameLab];
    
    CGFloat Magin = 32;
    CGFloat twoBtnMagin = 8;
    CGFloat originX = 24;
    CGFloat originY = 41;
    CGFloat MaxWidth = ScreenWidth-48;

    for (int i = 0; i<_dataArr.count; i++) {
        TypeModel *modeol = _dataArr[i];
        CGFloat Width = [GlobalMethod widthForString:modeol.name andFont:APPFONT14];
        UIButton *btn = [BaseViewFactory buttonWithFrame:CGRectZero font:APPFONT14 title:modeol.name titleColor:UIColorFromRGB(BlackColorValue) backColor:UIColorFromRGB(BackColorValue)];
        btn.layer.cornerRadius = 14;
        [_biaoView addSubview:btn];
        btn.tag = 1000 +i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (originX +Width+twoBtnMagin >MaxWidth) {
            originX = 24;
            originY += 40;
        }
        btn.frame = CGRectMake(originX, originY, Width+Magin, 28);
        originX += Width+Magin +twoBtnMagin;
        [_btnArr addObject:btn];

        
    }
    _biaoView.frame = CGRectMake(0, 90, ScreenWidth, originY +40+40);
    _originY += originY +40+56;
    
}



- (void)btnClick:(UIButton *)selectBtn{
    
    for (UIButton *btn in _btnArr) {
        btn.backgroundColor = UIColorFromRGB(BackColorValue);
        [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    }
    [selectBtn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    selectBtn.backgroundColor = UIColorFromRGB(BTNColorValue);
    _Selectedmodeol = _dataArr[selectBtn.tag -1000];
    
    
}

- (void)setAllInfo{
    
    
    if (_userType == 2)
    {
        if (!_Selectedmodeol) {
            [HUD show:@"请选择类目"];
            return;
        }
    }
    
    NSString *memo= @"";;
    if ([_memoTxt.text isEqualToString:@"请填写您的备注信息，或者细分领域"]) {
        memo = @"";
    }else{
        memo = _memoTxt.text;
    }
    
    NSString *userType= @"";;
    if (_userType == 0) {
        userType = @"贸易商";
    }else if (_userType == 1){
        userType = @"服装企业";
    }else{
        userType = @"供应链";
    }
    
    if (_isFirstLogin) {
        NSDictionary *dic = @{@"userType":userType,
                              @"userKind":_Selectedmodeol.name?_Selectedmodeol.name:@"",
                              @"signature":memo,
                              };
        [[UserPL shareManager] userUserSaveUserInfoWithDic:dic WithReturnBlock:^(id returnValue) {
            
            [[UserPL shareManager] gotoTabbarCOntroller];
            
        } withErrorBlock:^(NSString *msg) {
            
        }];
        
        
        
        return;
    }
    
    
    
    
   
   
    
    
    NSDictionary *dic;
    if (_userType == 2){
        dic= @{@"userKind":_Selectedmodeol.name,
               @"userType":userType,
               @"memo":memo
               };
        
    }else{
        dic= @{@"userKind":@"",
               @"userType":userType,
               @"memo":memo
               };
    }
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserTypeHaveChosed" object:dic];
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[ComTureNameController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
   

    
    
}

/*
 if (_userType == 0) {
 title = @"贸易商";
 }else if (_userType == 1){
 title = @"服装企业";
 }else{
 title = @"供应链";
 }
 */

#pragma mark - text view delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([_memoTxt.text isEqualToString: @"请填写您的备注信息，或者细分领域"]) {
        _memoTxt.text = @"";
        _memoTxt.textColor = UIColorFromRGB(BlackColorValue);
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (_memoTxt.text.length<=0) {
        _memoTxt.text =@"请填写您的备注信息，或者细分领域";
        _memoTxt.textColor = UIColorFromRGB(0x939393);
        
    }
    
    return YES;
}

@end
