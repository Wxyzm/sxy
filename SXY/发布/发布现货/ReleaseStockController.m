//
//  ReleaseStockController.m
//  SXY
//
//  Created by yh f on 2018/12/17.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ReleaseStockController.h"
#import "ReleaseSuccessController.h"
#import "CreateGoodsController.h"
#import "ChoseStockController.h"
#import "GoodsEditController.h"

#import "PeopleNeedsView.h"
#import "GoodsSelectedView.h"
#import "GoodsShowView.h"

@interface ReleaseStockController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong)GoodsSelectedView *selectedView;

@property (nonatomic,strong)GoodsShowView *goodsShowView;


@property (nonatomic, strong) PeopleNeedsView *ListView;

@property (nonatomic, strong) YLButton *dateBtn;

@end

@implementation ReleaseStockController{
    
    UITextField *_titleTxt;
    UITextView *_needsTxtView;
    UILabel *_titleNumLab;
    UILabel *_needsNumLab;
    NSString *_timeStr;
    NSString *_goodsId;
    BOOL _selectedGood;
    NSMutableArray *_timeArr;
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_releaseType == ReleaseType_GoodsInStock) {
        //现货
        self.title = @"发布现货";
    }else{
        //供应
        self.title = @"发布供应";
    }
    [self setBarBackBtnWithImage:nil];
    _timeArr = [NSMutableArray arrayWithCapacity:0];

    _timeStr = @"";
    [self initUI];

}

- (void)initUI
{

    [self createBackScrollView];
    self.backView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _titleTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(18, 0, ScreenWidth - 78, 52) font:APPFONT14 placeholder:@"标题" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0x939393) delegate:self];
    [self.backView addSubview:_titleTxt];
    [_titleTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _titleNumLab = [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth -60, 0, 40, 52) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(12) textAligment:NSTextAlignmentRight andtext:@"0/30"];
    [self.backView addSubview:_titleNumLab];
    
    _needsTxtView = [[UITextView alloc]initWithFrame:CGRectMake(18, 74,ScreenWidth-38 , 120)];
    _needsTxtView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _needsTxtView.text = @"请输入您的详细需求";
    _needsTxtView.font =APPFONT(15);
    _needsTxtView.textColor = UIColorFromRGB(0x939393);
    _needsTxtView.delegate = self;
    [self.backView addSubview:_needsTxtView];
    
    _needsNumLab = [BaseViewFactory labelWithFrame:CGRectMake(100, 194, ScreenWidth-120, 34) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(12) textAligment:NSTextAlignmentRight andtext:@"0/300"];
    [self.backView addSubview:_needsNumLab];
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 234, ScreenWidth, 6) color:UIColorFromRGB(LineColorValue)];
    [self.backView addSubview:line];

    _selectedView = [[GoodsSelectedView alloc]initWithFrame:CGRectMake(0, 240, ScreenWidth, 182)];
    [self.backView addSubview:_selectedView];
    
    [self.backView addSubview:self.goodsShowView];
    self.goodsShowView.frame = CGRectMake(0, 240, ScreenWidth, 182);
    self.goodsShowView.hidden = YES;
    WeakSelf(self);

    self.goodsShowView.returnBlock = ^(GoodsModel *model, NSInteger type) {
        if (type == 0) {
            //edit
            [weakself editGoods:model];
        }else{
            //delete
            _selectedGood = NO;
            [weakself refreshGoodWithModel:model];
            
        }
        
        
    };
    
    [_selectedView setReturnBlock:^(NSInteger btnTag) {
        if (btnTag ==0) {
            //库存选择
            ChoseStockController *choseVC= [[ChoseStockController alloc]init];
            choseVC.releaseType = weakself.releaseType;
            choseVC.returnBlock = ^(GoodsModel *selectModel) {
                _selectedGood = YES;
                [weakself refreshGoodWithModel:selectModel];
            };
            [weakself.navigationController pushViewController:choseVC animated:YES];
            
        }else if (btnTag ==1){
            //直接创建
            CreateGoodsController *crVc = [[CreateGoodsController alloc]init];
            crVc.releaseType = weakself.releaseType;
            crVc.returnBlock = ^(GoodsModel *model) {
                 _selectedGood = YES;
                [weakself refreshGoodWithModel:model];

            };
            [weakself.navigationController pushViewController:crVc animated:YES];
        }
       
    }];
    
    

    UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 422, ScreenWidth, 6) color:UIColorFromRGB(LineColorValue)];
    [self.backView addSubview:line1];
    
    UILabel *showLab1 = [BaseViewFactory labelWithFrame:CGRectMake(18, 428, 200, 62) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@"有效期"];
    [self.backView addSubview:showLab1];
    
    
    _dateBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _dateBtn.frame = CGRectMake(ScreenWidth-164, 428, 164, 62);
    [self.backView addSubview:_dateBtn];
    [_dateBtn setImage:[UIImage imageNamed:@"right_arrow_middle"] forState:UIControlStateNormal];
    [_dateBtn setImageRect:CGRectMake(129, 26, 5, 10)];
    [_dateBtn addTarget:self action:@selector(dateBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [_dateBtn setTitleRect:CGRectMake(0, 0, 119, 62)];
    _dateBtn.titleLabel.font = APPFONT14;
    _dateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_dateBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];

    UIButton  *setBtn = [BaseViewFactory buttonWithFrame:CGRectMake(28, 540, ScreenWidth-56, 44) font:APPFONT16 title:@"立即发布" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    setBtn.layer.cornerRadius = 22;
    [self.backView addSubview:setBtn];
    [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.backView.contentSize = CGSizeMake(30, 604);
    
    
    
}


- (void)editGoods:(GoodsModel *)model{
    GoodsEditController *edvc = [[GoodsEditController alloc]init];
    edvc.nowModel = model;
    WeakSelf(self);
    edvc.returnBlock = ^(GoodsModel * _Nonnull model) {
        _selectedGood = YES;
        [weakself refreshGoodWithModel:model];
    };
    [self.navigationController pushViewController:edvc animated:YES];
}


- (void)refreshGoodWithModel:(GoodsModel *)model{
    
    self.goodsShowView.model = model;
    _goodsId = model.theID;

    if (_selectedGood) {
        self.goodsShowView.hidden = NO;
        _selectedView.hidden = YES;
        
    }else{
        
        self.goodsShowView.hidden = YES;
        _selectedView.hidden = NO;
        
    }
}


//有效期
- (void)dateBtnCLick{
    
    if (_timeArr.count<=0) {
        [self loadDateAr];
        return;
    }
    [self showDateListView];
    
    
}
- (void)showDateListView{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSString * timeStr in _timeArr) {
        [arr addObject:[NSString stringWithFormat:@"%@天",timeStr]];
    }
    self.ListView.dataArr = arr;
    [self.ListView showinView:[UIApplication sharedApplication].keyWindow];
    WeakSelf(self);
    self.ListView.returnBlock = ^(NSString *selectedStr) {
        _timeStr = [selectedStr stringByReplacingOccurrencesOfString:@"天" withString:@""];
        [weakself.dateBtn setTitle:selectedStr forState:UIControlStateNormal];
    };
    
}

#pragma mark - 获取有效期
-(void)loadDateAr{
    NSDictionary *dic = @{@"":@""};
    [HUD showLoading:nil];
    [CategoryPL Category_CategoryGetVailddaysListWithDic:dic WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [HUD cancel];
        for (NSDictionary *dic in returnValue) {
            [_timeArr addObject:dic[@"name"]];
        }
        [self showDateListView];
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    }];
    
}


//发布
- (void)setBtnClick{
    
    if (_titleTxt.text.length<=0) {
        [HUD show:@"请输入标题"];
        return;
    }
    if (_needsTxtView.text.length<=0||[_needsTxtView.text isEqualToString:@"请输入您的详细需求"]) {
        [HUD show:@"请输入您的详细需求"];
        return;
    }
    if (_dateBtn.titleLabel.text.length<=0) {
        [HUD show:@"请输入有效时间"];
        return;
    }
    if (!_selectedGood) {
        [HUD show:@"请选择火添加商品"];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    // "goodsModule s": "0：求购 1：现货  2：供应链   3：话题",
    if (_releaseType == ReleaseType_GoodsInStock) {
        //现货
        [dic setValue:@"1" forKey:@"goodsModule"];   //大模块
    }else{
        //供应
        [dic setValue:@"2" forKey:@"goodsModule"];   //大模块
    }
    
    [dic setValue:_titleTxt.text forKey:@"title"];                  //标题
    [dic setValue:_needsTxtView.text forKey:@"goodsRemark"];        //详细需求
//    [dic setValue:imaStr forKey:@"pictureName"];                    //图片
    [dic setValue:_timeStr forKey:@"vailddays"];                    //图片
    [dic setValue:_goodsId forKey:@"goodsId"];                  //标题
    [HUD showLoading:nil];
    [CirclePL Circle_CircleSaveCircleCircleWithDic:dic WithReturnBlock:^(id returnValue) {
        [HUD cancel];
        [HUD show:@"发布成功"];
        [self performSelector:@selector(goToSuccessVc) withObject:nil afterDelay:1];
    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
        [HUD show:msg];
        
    }];
    
}


- (void)goToSuccessVc{
    
    ReleaseSuccessController *successVc = [[ReleaseSuccessController alloc]init];
    successVc.releaseType = _releaseType;
    successVc.title = @"发布求购";
    [self.navigationController pushViewController:successVc animated:YES];
    
}


#pragma mark - textField delegate


- (void)textFieldDidChange:(UITextField *)textField {
    
    if ([textField.text length] > 30) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 30)];
        [textField.undoManager removeAllActions];
        [textField becomeFirstResponder];
        
    }
    _titleNumLab.text = [NSString stringWithFormat:@"%ld/30",_titleTxt.text.length];
    
    
    
}
#pragma mark - text view delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([_needsTxtView.text isEqualToString: @"请输入您的详细需求"]) {
        _needsTxtView.text = @"";
        _needsTxtView.textColor = UIColorFromRGB(BlackColorValue);
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (_needsTxtView.text.length<=0) {
        _needsTxtView.text =@"请输入您的详细需求";
        _needsTxtView.textColor = UIColorFromRGB(0x939393);
        
    }
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    if ([textView.text length] > 300) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 50)];
        [textView.undoManager removeAllActions];
        [textView becomeFirstResponder];
    }
    _needsNumLab.text = [NSString stringWithFormat:@"%ld/300",_needsTxtView.text.length];
}

#pragma mark - get

-(PeopleNeedsView *)ListView{
    
    if (!_ListView) {
        _ListView = [[PeopleNeedsView alloc]init];
    }
    
    return _ListView;
    
}

-(GoodsShowView *)goodsShowView{
    
    if (!_goodsShowView) {
        _goodsShowView = [[GoodsShowView alloc]init];
    }
    
    return _goodsShowView;
    
}




@end
