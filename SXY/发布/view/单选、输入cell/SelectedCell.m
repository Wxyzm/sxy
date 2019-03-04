//
//  SelectedCell.m
//  SXY
//
//  Created by yh f on 2018/12/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "SelectedCell.h"
#import "ShowModel.h"

@implementation SelectedCell{
    
    UILabel *_titleLab;
    UILabel *_selectedLab;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUP];
    }
    
    return self;
}


- (void)setUP{

    _titleLab = [BaseViewFactory labelWithFrame:CGRectMake(18, 0, 100, 62) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_titleLab];
    UIImageView *rightIma = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self.contentView addSubview:rightIma];
    rightIma.frame = CGRectMake(ScreenWidth-45, 13, 24, 36);
    
    _selectedLab = [BaseViewFactory labelWithFrame:CGRectMake(118, 0, ScreenWidth-118-45, 62) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_selectedLab];
    

}

-(void)setModel:(ShowModel *)model{
    
    _model = model;
    _titleLab.text = model.title;
    if (model.actueValue.length>0) {
        _selectedLab.text = model.actueValue;

    }else{
        _selectedLab.text = @"请选择";

    }
    
    
}



@end
