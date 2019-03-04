//
//  ComSafeCell.m
//  SXY
//
//  Created by yh f on 2018/12/28.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ComSafeCell.h"
#import "ComTureModel.h"

@implementation ComSafeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUP];
    }
    
    return self;
}


- (void)setUP{
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(24, 0, 150, 56) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPBLODFONTT(14) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
    _rightIma = [[UIImageView alloc]init];
    _rightIma.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_rightIma];
    _rightIma.frame = CGRectMake(ScreenWidth-48,10, 24, 36);
    _rightIma.image = [UIImage imageNamed:@"cell_arrow"];
    _rightIma.hidden = YES;
    
    _showLab= [BaseViewFactory labelWithFrame:CGRectMake(100, 0, ScreenWidth-120, 56) textColor:UIColorFromRGB(LitterBlackColorValue) font:APPFONT14 textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_showLab];
    
}

-(void)setModel:(ComTureModel *)model{
    _model = model;
    _nameLab.text = model.Title;
    if ([model.Title isEqualToString:@"*联系方式"]) {
        if (model.value1.length<=0&&model.value2.length<=0) {
            _showLab.text = model.plaName;

        }else{
            _showLab.text =[NSString stringWithFormat:@"手机：%@ 座机：%@",model.value1.length>0?model.value1:@"无数据",model.value2.length>0?model.value2:@"无数据"];
        }
       
    }else{
        _showLab.text = model.value1;
        if (model.value1.length<=0) {
            _showLab.text = model.plaName;
        }
    }
   
    
    
    if ([model.Title isEqualToString:@"*企业类别"]) {
        _rightIma.hidden = NO;
        _showLab.frame = CGRectMake(100, 0, ScreenWidth-145, 56);

    }else{
         _rightIma.hidden = YES;
        _showLab.frame = CGRectMake(100, 0, ScreenWidth-120, 56);
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:model.Title];
    NSRange range = [model.Title rangeOfString:@"*"];
    if (range.length>0) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe74922) range:range];
        _nameLab.attributedText = attrStr;
    }
    
    
}


@end
