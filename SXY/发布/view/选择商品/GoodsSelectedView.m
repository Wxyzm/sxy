//
//  GoodsSelectedView.m
//  SXY
//
//  Created by yh f on 2018/12/17.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "GoodsSelectedView.h"

@implementation GoodsSelectedView{
    
    YLButton *_StockBtn;
    YLButton *_CreateBtn;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(18, 0, 200, 52) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@"选择商品"];
    [self addSubview:lab];
    
    
    UIScrollView *bgScrollview = [BaseViewFactory scrollViewWithFrame:CGRectMake(18, 52, ScreenWidth-36, 110) color:UIColorFromRGB(WhiteColorValue) delegate:nil];
    [self addSubview:bgScrollview];

    CGFloat BtnW = (ScreenWidth - 56)/2;
    _StockBtn = [BaseViewFactory ylButtonWithFrame:CGRectMake(0, 0, BtnW, 70) font:APPFONT12 title:@"库中选择" titleColor:UIColorFromRGB(0xC4C4C4) backColor:UIColorFromRGB(0xF5F5F5)];
    [_StockBtn setImage:[UIImage imageNamed:@"inventory_select"] forState:UIControlStateNormal];
    [bgScrollview addSubview:_StockBtn];
    [_StockBtn setTitleRect:CGRectMake((BtnW-74)/2, 0, 50, 70)];
    [_StockBtn setImageRect:CGRectMake((BtnW-74)/2+50+10, 28, 14, 14)];
    [_StockBtn addTarget:self action:@selector(stockBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _CreateBtn = [BaseViewFactory ylButtonWithFrame:CGRectMake((ScreenWidth-36)/2+10, 0, BtnW, 70) font:APPFONT12 title:@"直接创建" titleColor:UIColorFromRGB(0xC4C4C4) backColor:UIColorFromRGB(0xF5F5F5)];
    [_CreateBtn setImage:[UIImage imageNamed:@"inventory_select"] forState:UIControlStateNormal];
    [bgScrollview addSubview:_CreateBtn];
    [_CreateBtn setTitleRect:CGRectMake((BtnW-74)/2, 0, 50, 70)];
    [_CreateBtn setImageRect:CGRectMake((BtnW-74)/2+50+10, 28, 14, 14)];
    [_CreateBtn addTarget:self action:@selector(createBtnClick) forControlEvents:UIControlEventTouchUpInside];

}



/**
 库中选择
 */
- (void)stockBtnClick{
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(0);
    }
    
}

/**
 直接创建
 */
- (void)createBtnClick{
    
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(1);
    }
    
    
}













@end
