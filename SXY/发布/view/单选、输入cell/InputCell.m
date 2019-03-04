//
//  InputCell.m
//  SXY
//
//  Created by yh f on 2018/12/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "InputCell.h"
#import "ShowModel.h"

@interface InputCell()<UITextFieldDelegate>

@end


@implementation InputCell{
    
    UILabel *_titleLab;
    UITextField *_inputTxt;
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
    
    _inputTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(118, 0, ScreenWidth-118-16, 62) font:APPFONT14 placeholder:@"请输入" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:nil delegate:self];
    _inputTxt.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_inputTxt];


}

-(void)setModel:(ShowModel *)model{
    
    _model = model;
    _titleLab.text = model.title;
    _inputTxt.text = model.actueValue;
    if (model.KeyboardType) {
        _inputTxt.keyboardType = model.KeyboardType;
    }else{
        _inputTxt.keyboardType = UIKeyboardTypeDefault;

    }
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    _model.actueValue = textField.text;
    return YES;
}


@end
