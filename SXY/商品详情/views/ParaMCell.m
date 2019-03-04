//
//  ParaMCell.m
//  SXY
//
//  Created by yh f on 2018/11/21.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ParaMCell.h"

@implementation ParaMCell{
    

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUP];
    }
    
    return self;
}


- (void)setUP{
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(25, 0, ScreenWidth-50, 1) color:UIColorFromRGB(0xCCCCCC)];
    [self.contentView addSubview:line];

    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@"："];
    [self.contentView addSubview:_nameLab];
    
    
    _valueLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x9F9DA1) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_valueLab];
    
    _nameLab.sd_layout
    .leftSpaceToView(self.contentView, 25)
    .topEqualToView(self.contentView)
    .heightIs(48);
    [_nameLab setSingleLineAutoResizeWithMaxWidth:100];
    
    _valueLab.sd_layout
    .leftSpaceToView(_nameLab, 10)
    .topSpaceToView(self.contentView, 17)
    .rightSpaceToView(self.contentView, 25)
    .autoHeightRatio(0);
    
    
    
}




+(CGFloat)cellHeightWithtitleStr:(NSString *)nameStr andmemoStr:(NSString *)memoStr{

    CGFloat weight = [GlobalMethod widthForString:nameStr andFont:APPFONT(14)] +35;
    CGFloat height = [GlobalMethod heightForString:memoStr andWidth:ScreenWidth- weight-25 andFont:APPFONT(14)];
    return height+ 34;
    
}



@end
