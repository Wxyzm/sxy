//
//  SafeCell.m
//  SXY
//
//  Created by yh f on 2018/11/22.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "SafeCell.h"

@implementation SafeCell{
      
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUP];
    }
    
    return self;
}


- (void)setUP{
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(24, 0, 150, 56) textColor:UIColorFromRGB(BlackColorValue) font:APPBLODFONTT(16) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
    UIImageView *rightIma = [[UIImageView alloc]init];
    rightIma.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:rightIma];
    rightIma.frame = CGRectMake(ScreenWidth-48,10, 24, 36);
    rightIma.image = [UIImage imageNamed:@"cell_arrow"];
    
    _statusLab= [BaseViewFactory labelWithFrame:CGRectMake(180, 0, ScreenWidth-180-48, 56) textColor:UIColorFromRGB(0x939393) font:APPFONT14 textAligment:NSTextAlignmentRight andtext:@"未绑定"];
    [self.contentView addSubview:_statusLab];
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 55, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:line];

}

@end
