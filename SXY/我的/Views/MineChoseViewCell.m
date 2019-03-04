//
//  MineChoseViewCell.m
//  SXY
//
//  Created by yh f on 2018/11/17.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MineChoseViewCell.h"

@implementation MineChoseViewCell{
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUP];
    }
    
    return self;
}


- (void)setUP{
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(29, 0, 200, 62) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT16 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
    YLButton *rightBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [self.contentView addSubview:rightBtn];
    rightBtn.frame = CGRectMake(ScreenWidth - 45, 13, 24, 36);
    [rightBtn setImageRect:CGRectMake(0, 0, 24, 36)];
    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(29, 61, ScreenWidth-48, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:lineView];
    
    
    
    
    

    
}


@end
