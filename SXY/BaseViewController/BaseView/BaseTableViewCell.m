//
//  BaseTableViewCell.m
//  SXY
//
//  Created by yh f on 2018/11/9.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.contentView.clipsToBounds = YES;
    }
    return self;
}
@end
