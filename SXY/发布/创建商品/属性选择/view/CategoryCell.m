//
//  CategoryCell.m
//  SXY
//
//  Created by yh f on 2018/12/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "CategoryCell.h"
#import "CategoryModel.h"
@implementation CategoryCell{
    
    UIView *bgView;
    UILabel *_nameLab;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup{
    
    CGFloat Width = ScreenWidth/3- 30;
    bgView = [BaseViewFactory viewWithFrame:CGRectMake(15, 12, Width, 30) color:UIColorFromRGB(BTNColorValue)];
    bgView.layer.cornerRadius = 15;
    [self.contentView addSubview:bgView];
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, Width, 30) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(13) textAligment:NSTextAlignmentCenter andtext:@""];
    [bgView addSubview:_nameLab];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"deleteCate"] forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteBtn];
    _deleteBtn.frame = CGRectMake(ScreenWidth/3-18, 17, 18, 18);
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void)deleteBtnClick{
    WeakSelf(self);
    if (weakself.returnBlock) {
        weakself.returnBlock(_model);
    }
    
    
}





-(void)setModel:(CategoryModel *)model{
    _model = model;
    _nameLab.text = model.name;
    if (model.isSelected) {
        _deleteBtn.hidden = YES;
        bgView.backgroundColor = UIColorFromRGB(BTNColorValue);
        _nameLab.textColor = UIColorFromRGB(WhiteColorValue);
    }else{
        _deleteBtn.hidden = NO;
        bgView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _nameLab.textColor = UIColorFromRGB(0x939393);
        
    }
    
}





@end
