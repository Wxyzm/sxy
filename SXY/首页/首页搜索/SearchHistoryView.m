//
//  SearchHistoryView.m
//  DaMinEPC
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "SearchHistoryView.h"


#define KBtnTag            1000
#define HORIZONTAL_PADDING 7.0f
#define LABEL_MARGIN       15.0f    //按钮横向间距
#define BOTTOM_MARGIN      10.0f    //按钮纵向间距

#define BtnH        40.0f    //按钮高度

@implementation SearchHistoryView{
    
    NSUserDefaults *_userDefaults;
    BOOL _isShowInView;
    NSMutableArray *_btnArr;
    CGRect previousFrame ;
    int totalHeight ;

}

-(instancetype)init{
    
    
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _btnArr = [NSMutableArray arrayWithCapacity:0];
        self.hidden = YES;

        [self setUp];
    }
    return self;
}

- (void)setUp{
    
    UILabel *toplab = [BaseViewFactory labelWithFrame:CGRectMake(15, 0, 200, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT15 textAligment:NSTextAlignmentLeft andtext:@"搜索历史"];
    [self addSubview:toplab];
    
    UIButton *seleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:seleteBtn];
    seleteBtn.frame = CGRectMake(ScreenWidth -28, 17.5, 13, 15);
    [seleteBtn setImage:[UIImage imageNamed:@"manager_delete"] forState:UIControlStateNormal];
    [seleteBtn addTarget:self action:@selector(deleteAllHistory) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *hisArr = [_userDefaults objectForKey:[NSString stringWithFormat:@"%@%@",SearchHistory,[GlobalMethod getUserid]]];
    previousFrame.origin.y = 50;
    
    [hisArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        [_btnArr addObject:tagBtn];

        [tagBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        tagBtn.backgroundColor=UIColorFromRGB(0xf5f5f5);
        tagBtn.titleLabel.font=APPFONT15;
        [tagBtn setTitle:obj forState:UIControlStateNormal];
        tagBtn.tag=KBtnTag+idx;
        tagBtn.layer.cornerRadius = BtnH/2;
        tagBtn.clipsToBounds=YES;
        
        NSDictionary *attrs = @{NSFontAttributeName : APPFONT15};
        CGSize Size_str=[obj sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*4;
        Size_str.height = BtnH;
        
        
        CGRect newRect = CGRectZero;
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
            
            newRect.origin = CGPointMake(15, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            
        }
        
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        previousFrame=tagBtn.frame;
        [self addSubview:tagBtn];

    }];
  
}


- (void)refreshView{
    NSArray *hisArr = [_userDefaults objectForKey:[NSString stringWithFormat:@"%@%@",SearchHistory,[GlobalMethod getUserid]]];
    if (hisArr.count<=0) {
        [_btnArr enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
            [btn removeFromSuperview];
        }];
         [_btnArr removeAllObjects];
    }
    for (int i = 0; i<hisArr.count; i++) {
        if (i>=_btnArr.count) {
            NSString *title = hisArr[i];
            UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            tagBtn.frame=CGRectZero;
            [_btnArr addObject:tagBtn];
            
            [tagBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
            [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            tagBtn.backgroundColor=UIColorFromRGB(0xf5f5f5);
            tagBtn.titleLabel.font=APPFONT15;
            [tagBtn setTitle:title forState:UIControlStateNormal];
            tagBtn.tag=KBtnTag+i;
            tagBtn.layer.cornerRadius = BtnH/2;
            tagBtn.clipsToBounds=YES;
            
            NSDictionary *attrs = @{NSFontAttributeName : APPFONT15};
            CGSize Size_str=[title sizeWithAttributes:attrs];
            Size_str.width += HORIZONTAL_PADDING*4;
            Size_str.height = BtnH;
            
            
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
                
                newRect.origin = CGPointMake(15, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
                totalHeight +=Size_str.height + BOTTOM_MARGIN;
            }
            else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
                
            }
            
            newRect.size = Size_str;
            [tagBtn setFrame:newRect];
            previousFrame=tagBtn.frame;
            [self addSubview:tagBtn];
            
        }
    }
    
}


-(void)deleteAllHistory{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    [_userDefaults setObject:arr forKey:[NSString stringWithFormat:@"%@%@",SearchHistory,[GlobalMethod getUserid]]];
    [_userDefaults synchronize];
    [_btnArr enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        [btn removeFromSuperview];
    }];
    [_btnArr removeAllObjects];
    previousFrame.origin.x = 0;
    previousFrame.origin.y = 50;
    previousFrame.size.width = 0;
    previousFrame.size.height = 0;

}

- (void)tagBtnClick:(UIButton *)btn{
    
    [self cancelPicker];
    WeakSelf(self);
    if (weakself.returnValueBlock) {
        weakself.returnValueBlock(btn.titleLabel.text);
    }
    
}

//显示
- (void)showInView:(UIView *) view
{
    if (_isShowInView) return;
    _isShowInView = YES;
    self.hidden = NO;
    [self refreshView];
    self.frame = CGRectMake(0, ScreenHeight, self.frame.size.width, self.frame.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 50+STATUSBAR_HEIGHT, self.width, ScreenHeight);

    }];
}

//消失
- (void)cancelPicker
{
    if (!_isShowInView) return;
    _isShowInView = NO;

    [UIView animateWithDuration:0.3 animations:^{
                         self.frame = CGRectMake(0, ScreenHeight, self.width, ScreenHeight);

                     }
                     completion:^(BOOL finished){
                         self.hidden = YES;
                     }];
}



@end
