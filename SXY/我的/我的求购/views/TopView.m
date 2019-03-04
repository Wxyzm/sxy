//
//  TopView.m
//  ZhongFangTong
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "TopView.h"
#import "TopModel.h"

#define Btn_TAG   1000

@implementation TopView{
    
    NSMutableArray *_dataArr;
    NSMutableArray *_btnArr;
    BaseScrollView *_ScrollView;
    UIView *_lineView;
    CGFloat _OriginX;
    CGFloat _magin;
}

-(instancetype)initWithArr:(NSMutableArray *)dataArr{
    self = [super init];
    if (self) {
        _dataArr = dataArr;
        _btnArr = [NSMutableArray arrayWithCapacity:0];
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
      
        [self setUp];
    }
    return self;
}


- (void)setUp{
    
    if (_dataArr.count<=0) {
        return;
    }
    _ScrollView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
    _ScrollView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_ScrollView];
    
    _magin = 25;
    CGRect frame =CGRectZero;
    
    while (_OriginX<ScreenWidth) {
        _OriginX = 0;

        for (int i = 0; i<_dataArr.count; i++) {
            TopModel *model = _dataArr[i];
            CGFloat width = [GlobalMethod widthForString:model.title andFont:APPFONT14];
            width +=_magin;
            _OriginX += width;
        }
        NSNumber *num = [NSNumber numberWithInteger:_dataArr.count];

        _magin += 1.00/[num floatValue];
    }
    
    _OriginX = 0;
    for (int i = 0; i<_dataArr.count; i++) {
        TopModel *model = _dataArr[i];
        CGFloat width = [GlobalMethod widthForString:model.title andFont:APPFONT14];
        width +=_magin;
        YLButton * btn = [BaseViewFactory ylButtonWithFrame:CGRectMake(_OriginX, 0, width, 36) font:APPFONT14 title:model.title titleColor:UIColorFromRGB(LitterBlackColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
        [_ScrollView addSubview:btn];
        btn.tag = Btn_TAG+i;
        if (i == 0) {
            [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
            btn.on = YES;
            frame = CGRectMake(btn.left+width/2-10,42, 20, 2);
        }
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArr addObject:btn];
        _OriginX += width;
    }
    _ScrollView.contentSize = CGSizeMake(_OriginX, 36);
    
    _lineView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(BlackColorValue)];
    [_ScrollView addSubview:_lineView];
    _lineView.frame = frame;
    if (_dataArr.count<=0) {
        _lineView.hidden = YES;
        
    }else{
        _lineView.hidden = NO;
        
    }
}



- (void)topBtnClick:(YLButton *)selectbtn{
    
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(selectbtn.tag-1000);
    }
    
    TopModel *model = _dataArr[selectbtn.tag-1000];
    CGFloat width = [GlobalMethod widthForString:model.title andFont:APPFONT14];
    width +=_magin;
    for (YLButton *btn in _btnArr) {
        [btn setTitleColor:UIColorFromRGB(LitterBlackColorValue) forState:UIControlStateNormal];
    }
    [selectbtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];

    [UIView animateWithDuration:0.2 animations:^{
        self->_lineView.frame = CGRectMake(selectbtn.left+width/2-15,36, 30, 2);
    }];
    
}




- (void)setSelectedIndex:(NSInteger)index{
    if (_dataArr.count<=index) {
        return;
    }
    TopModel *model = _dataArr[index];
    CGFloat width = [GlobalMethod widthForString:model.title andFont:APPFONT14];
    width +=_magin;
    
    for (YLButton *btn in _btnArr) {
        [btn setTitleColor:UIColorFromRGB(LitterBlackColorValue) forState:UIControlStateNormal];
    }
    YLButton *selectbtn = _btnArr[index];
    [selectbtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _lineView.frame = CGRectMake(selectbtn.left+width/2-15,36, 30, 2);
    [_ScrollView setContentOffset:CGPointMake(selectbtn.left, 0) animated:NO];
    
    
}





@end
