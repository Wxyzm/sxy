//
//  ReleaseWantBuyController.m
//  SXY
//
//  Created by yh f on 2018/12/4.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ReleaseWantBuyController.h"
#import "ReleaseSuccessController.h"
#import "PhotoShowView.h"
#import "PeopleNeedsView.h"
#import "UpImagePL.h"
#import "PicModel.h"
#import "WantBuyModel.h"

@interface ReleaseWantBuyController ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) PeopleNeedsView *ListView;
@property (nonatomic, strong) YLButton *dateBtn;

@end

@implementation ReleaseWantBuyController{
    
    UITextField *_titleTxt;
    UITextView *_needsTxtView;
    UILabel *_titleNumLab;
    UILabel *_needsNumLab;
    PhotoShowView *_photoShowView;
    YLButton *_sameBtn;
    NSString *_timeStr;
    NSMutableArray *_timeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布求购";
    [self setBarBackBtnWithImage:nil];
    _timeStr = @"";
    _timeArr = [NSMutableArray arrayWithCapacity:0];
    [self initUI];

}

- (void)initUI{
    [self createBackScrollView];
    self.backView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _titleTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(18, 0, ScreenWidth - 78, 52) font:APPFONT14 placeholder:@"求购标题" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0x939393) delegate:self];
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
    
    _photoShowView = [[PhotoShowView alloc]initWithFrame:CGRectMake(0, 240, ScreenWidth, 136)];
    [self.backView addSubview:_photoShowView];
    if (_searchIma) {
        PicModel *model = [[PicModel alloc]init];
        model.Image = _searchIma;
        [_photoShowView.urlPhotos addObject:model];
    }
    
    
    UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 376, ScreenWidth, 6) color:UIColorFromRGB(LineColorValue)];
    [self.backView addSubview:line1];
    
    UILabel *showLab = [BaseViewFactory labelWithFrame:CGRectMake(18, 382, 200, 62) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@"仅接受现货"];
    [self.backView addSubview:showLab];
    UILabel *showLab1 = [BaseViewFactory labelWithFrame:CGRectMake(18, 444, 200, 62) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@"有效期"];
    [self.backView addSubview:showLab1];
    
 
    _sameBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _sameBtn.frame = CGRectMake(ScreenWidth-64, 382, 64, 62);
    [self.backView addSubview:_sameBtn];
    [_sameBtn setImage:[UIImage imageNamed:@"default__selected_u"] forState:UIControlStateNormal];
    [_sameBtn setImageRect:CGRectMake(24, 23, 16, 16)];
    _sameBtn.on = NO;
    [_sameBtn addTarget:self action:@selector(sameBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    
    _dateBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _dateBtn.frame = CGRectMake(ScreenWidth-164, 444, 164, 62);
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



#pragma mark - 选项按钮点击

//仅支持现货
- (void)sameBtnCLick{
    _sameBtn.on = !_sameBtn.on;
    if (_sameBtn.on) {
        [_sameBtn setImage:[UIImage imageNamed:@"default__selected"] forState:UIControlStateNormal];
    }else{
        [_sameBtn setImage:[UIImage imageNamed:@"default__selected_u"] forState:UIControlStateNormal];

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
    if (_photoShowView.urlPhotos.count<=0) {
        [HUD show:@"至少上传一张图片"];
        return;
    }
    
    UpImagePL *upPl = [[UpImagePL alloc]init];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
   
    for (PicModel *model in _photoShowView.urlPhotos) {
        [arr addObject:model.Image];
    }
    [HUD showLoading:nil];
    [upPl updateToByGoodsImgArr:arr WithReturnBlock:^(id returnValue) {
        [self upAllInfoWithImaStr:returnValue[@"result"]];

    } withErrorBlock:^(NSString *msg) {
        [HUD cancel];
    } andImageType:@"3"];

    
}

- (void)upAllInfoWithImaStr:(NSString *)imaStr{
    
    
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[NSString stringWithFormat:@"%ld",_releaseType] forKey:@"goodsModule"];   //大模块
    [dic setValue:_titleTxt.text forKey:@"title"];                  //标题
    [dic setValue:_needsTxtView.text forKey:@"content"];        //详细需求
    [dic setValue:imaStr forKey:@"pictureName"];                    //图片
    [dic setValue:_timeStr forKey:@"vailddays"];                    //有效期限
    if ( _sameBtn.on) {
        [dic setValue:@"现货" forKey:@"label"];                    //有效期限
    }
    
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


#pragma mark - textField delegate


- (void)textFieldDidChange:(UITextField *)textField {
    
    if ([textField.text length] > 300) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 50)];
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

@end
