//
//  SafeImputCell.m
//  SXY
//
//  Created by souxiuyun on 2019/1/21.
//  Copyright © 2019 XX. All rights reserved.
//

#import "SafeImputCell.h"
#import "ComTureModel.h"

@interface SafeImputCell()<UITextFieldDelegate>



@end

@implementation SafeImputCell

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
    
    _inputTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(120, 0, ScreenWidth-140, 56) font:APPFONT14 placeholder:@"" textColor:UIColorFromRGB(LitterBlackColorValue) placeholderColor:UIColorFromRGB(LitterBlackColorValue) delegate:self];
    [self.contentView addSubview:_inputTxt];
    _inputTxt.textAlignment = NSTextAlignmentRight;

    
}

-(void)setModel:(ComTureModel *)model{
    _model = model;

    if (model.value1.length<=0) {
        _inputTxt.placeholder = model.plaName;
        _inputTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:model.plaName attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(LitterBlackColorValue)}];
    }
    _inputTxt.text = model.value1;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:model.Title];
    NSRange range = [model.Title rangeOfString:@"*"];
    if (range.length>0) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe74922) range:range];
    }
    _nameLab.attributedText = attrStr;

    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    _model.value1  = textField.text;
    
    return YES;
}


@end
