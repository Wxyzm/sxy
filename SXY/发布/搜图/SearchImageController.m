//
//  SearchImageController.m
//  SXY
//
//  Created by yh f on 2019/1/9.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "SearchImageController.h"
#import "SearchImaResultController.h"
@interface SearchImageController ()

@end

@implementation SearchImageController{
    NSMutableArray *_btnArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.title = @"搜图";
    if (!_searIma) {
        return;
    }
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImageView *tmp=[self findNavBarBottomLine:navigationBar];
    tmp.hidden=YES;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImageView *tmp=[self findNavBarBottomLine:navigationBar];
    tmp.hidden=NO;
}

- (void)initUI{
    _btnArr = [NSMutableArray arrayWithCapacity:0];
    UIImageView *ima = [[UIImageView alloc]initWithImage:_searIma];
    CGFloat Width = _searIma.size.width *175/ _searIma.size.height;
    ima.frame = CGRectMake((ScreenWidth -Width)/2, 20, Width, 175);
    [self.view addSubview:ima];
    
    UIImageView *remindIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remind"]];
    [self.view addSubview:remindIma];
    remindIma.frame = CGRectMake(18, 235, 14, 14);
    UILabel *remindLab = [BaseViewFactory labelWithFrame:CGRectMake(43, 233, ScreenWidth-60, 17) textColor:UIColorFromRGB(0x9F9DA1) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@"为了提高搜索准确度，图片请尽量做好花位选择"];
    [self.view addSubview:remindLab];

    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 270, ScreenWidth, 6) color:UIColorFromRGB(BackColorValue)];
    [self.view addSubview:line];
    
    UILabel *kindLab = [BaseViewFactory labelWithFrame:CGRectMake(18, 290, ScreenWidth-36, 20) textColor:UIColorFromRGB(0x9F9DA1) font:APPFONT12 textAligment:NSTextAlignmentLeft andtext:@"请选择搜索类型 （多选）"];
    [self.view addSubview:kindLab];
    
    NSArray *titleArr = @[@"花边／花朵",@"满幅",@"3D重手工"];
    for (int i = 0; i<3; i++) {
        YLButton *btn = [YLButton buttonWithbackgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(0x5F5E5F) cornerRadius:4 andtarget:self action:@selector(KindBtnClick:) titleFont:APPFONT14 title:titleArr[i]];
        btn.tag = 1000 + i;
        btn.frame = CGRectMake(26+100*i, 340, 90, 30);
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = UIColorFromRGB(BackColorValue).CGColor;
        [self.view addSubview:btn];
        [_btnArr addObject:btn];
    }
    
    
    YLButton *SearchBtn = [BaseViewFactory ylButtonWithFrame:CGRectMake(28, ScreenHeight-64-NaviHeight64, ScreenWidth-56, 44) font:APPFONT(16) title:@"立即搜索" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    [self.view addSubview:SearchBtn];
    [SearchBtn addTarget:self action:@selector(SearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    SearchBtn.layer.cornerRadius = 22;
}



- (void)KindBtnClick:(YLButton *)btn{
    btn.on = !btn.on;
    if (btn.on) {
        btn.layer.borderColor = UIColorFromRGB(BTNColorValue).CGColor;
        btn.backgroundColor = UIColorFromRGB_Alpha(BTNColorValue, 0.2);
        [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    }else{
        btn.layer.borderColor = UIColorFromRGB(BackColorValue).CGColor;
        btn.backgroundColor = UIColorFromRGB_Alpha(WhiteColorValue, 1);
        [btn setTitleColor:UIColorFromRGB(0x5F5E5F) forState:UIControlStateNormal];
    }
    
}



- (void)SearchBtnClick{
    
    if (!_searIma) {
        return;
    }
    
    NSString *tagStr = @"";
    for (YLButton *btn in _btnArr) {
        if (btn.on) {
            tagStr = [NSString stringWithFormat:@"%@,%@",tagStr,btn.titleLabel.text];
        }
    }
    [HUD showLoading:nil];
    
    [UpImagePL SearchImg:_searIma andTag:tagStr WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [HUD cancel];
        NSMutableArray *goodsArr = [GoodsModel mj_objectArrayWithKeyValuesArray:returnValue[@"result"]];
        SearchImaResultController *seVc = [[SearchImaResultController alloc]init];
        seVc.dataArr = goodsArr;
        seVc.searchIma = _searIma;
        [self.navigationController pushViewController:seVc animated:YES];
        
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    }];
    
    
    
    
}


@end
