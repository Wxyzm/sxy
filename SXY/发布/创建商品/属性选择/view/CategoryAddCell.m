//
//  CategoryAddCell.m
//  SXY
//
//  Created by yh f on 2018/12/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "CategoryAddCell.h"

@implementation CategoryAddCell

{
    
  
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup{
//
//    bgView = [BaseViewFactory viewWithFrame:CGRectMake(15, 12, Width, 30) color:UIColorFromRGB(BTNColorValue)];
//    bgView.layer.cornerRadius = 15;
//    [self.contentView addSubview:bgView];
//
    
    CGFloat Width = (ScreenWidth/3- 30);

    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_addBtn];
    [_addBtn setImage:[UIImage imageNamed:@"addCate"] forState:UIControlStateNormal];
//    [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_addBtn setBackgroundColor:UIColorFromRGB(BTNColorValue)];
    [_addBtn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    _addBtn.titleLabel.font = APPFONT13;
    _addBtn.frame = CGRectMake(15, 12, Width, 30);
    _addBtn.layer.cornerRadius = 15;
   


}






@end
