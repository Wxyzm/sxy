//
//  TureImageView.m
//  SXY
//
//  Created by souxiuyun on 2019/1/21.
//  Copyright © 2019 XX. All rights reserved.
//

#import "TureImageView.h"

@implementation TureImageView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    
    return self;
}


- (void)initUI{
    
    _Lab = [BaseViewFactory labelWithFrame:CGRectMake(0, 10, self.bounds.size.width-10, 100) textColor:UIColorFromRGB(0x939393) font:APPBLODFONTT(14) textAligment:NSTextAlignmentCenter andtext:@""];
    _Lab.backgroundColor = UIColorFromRGB(BackColorValue);
    [self addSubview:_Lab];
    
    _upImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, self.bounds.size.width-10, 100)];
    [self addSubview:_upImageView];

    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 10, self.bounds.size.width-10, 100);
    _btn.clipsToBounds = YES;
    [self addSubview:_btn];
    [_btn addTarget:self action:@selector(upImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deletebtn.frame = CGRectMake(self.bounds.size.width-20, 0, 20, 20);
    _deletebtn.clipsToBounds = YES;
    [_deletebtn setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [self addSubview:_deletebtn];
    [_deletebtn addTarget:self action:@selector(deleteImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)upImageBtnClick{
    WeakSelf(self);
    if (weakself.reurnBlock) {
        weakself.reurnBlock(0);
    }
    
}

- (void)deleteImageBtnClick{
    WeakSelf(self);
    if (weakself.reurnBlock) {
        weakself.reurnBlock(1);
    }
}

@end
