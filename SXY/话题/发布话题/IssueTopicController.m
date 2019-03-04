//
//  IssueTopicController.m
//  SXY
//
//  Created by yh f on 2018/12/21.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "IssueTopicController.h"
#import "PhotoShowView.h"
#import "UpImagePL.h"
#import "PicModel.h"

@interface IssueTopicController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation IssueTopicController{
    
    UITextField *_titleTxt;
    UITextView *_detailTxtView;
    PhotoShowView *_photoShowView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布话题";
    [self initUI];
}

- (void)initUI{
    
    YLButton* button = [[YLButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondToLeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = left;
    [button setTitleColor:UIColorFromRGB(0x898989) forState:UIControlStateNormal];
    button.titleLabel.font = APPFONT13;
    
    [self createBackScrollView];
    self.backView.backgroundColor = UIColorFromRGB(WhiteColorValue);

//    _titleTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(18, 0, ScreenWidth - 36, 52) font:APPFONT14 placeholder:@"请输入标题" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0x939393) delegate:self];
//    [self.backView addSubview:_titleTxt];
    
    
    _detailTxtView = [[UITextView alloc]initWithFrame:CGRectMake(18, 20,ScreenWidth-36 , 120)];
    _detailTxtView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _detailTxtView.text = @"请输入您的话题内容";
    _detailTxtView.font =APPFONT(14);
    _detailTxtView.textColor = UIColorFromRGB(0x939393);
    _detailTxtView.delegate = self;
    [self.backView addSubview:_detailTxtView];
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 234, ScreenWidth, 6) color:UIColorFromRGB(LineColorValue)];
    [self.backView addSubview:line];
    
    
    _photoShowView = [[PhotoShowView alloc]initWithFrame:CGRectMake(0, 240, ScreenWidth, 136)];
    [self.backView addSubview:_photoShowView];
    _photoShowView.maxNum = 3;
    
    UIButton  *setBtn = [BaseViewFactory buttonWithFrame:CGRectMake(28, 400, ScreenWidth-56, 44) font:APPFONT16 title:@"立即发布" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(BTNColorValue)];
    setBtn.layer.cornerRadius = 22;
    [self.backView addSubview:setBtn];
    [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.backView.contentSize = CGSizeMake(30, 500);
    
}
//发布
- (void)setBtnClick{
    
//    if (_titleTxt.text.length<=0) {
//        [HUD show:@"请输入标题"];
//        return;
//    }
    if (_detailTxtView.text.length<=0||[_detailTxtView.text isEqualToString:@"请输入您的话题内容"]) {
        [HUD show:@"请输入您的详细需求"];
        return;
    }

    if (_photoShowView.urlPhotos.count >0) {
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
    }else{
        [self upAllInfoWithImaStr:@""];

    }



}
- (void)upAllInfoWithImaStr:(NSString *)urlStr{
    NSDictionary *dic = @{@"content":_detailTxtView.text,
                          @"goodsModule":@"3",
                          @"pictureName":urlStr,
                          @"title":@""
                          };
    [CirclePL Circle_CircleSaveCircleCircleWithDic:dic WithReturnBlock:^(id returnValue) {
        [HUD show:@"话题发布成功"];
        [self performSelector:@selector(respondToLeftButtonClickEvent) withObject:nil afterDelay:1];
        
    } withErrorBlock:^(NSString *msg) {
        
    }];
    
    
    
}





#pragma mark - text view delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([_detailTxtView.text isEqualToString: @"请输入您的话题内容"]) {
        _detailTxtView.text = @"";
        _detailTxtView.textColor = UIColorFromRGB(BlackColorValue);
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (_detailTxtView.text.length<=0) {
        _detailTxtView.text =@"请输入您的话题内容";
        _detailTxtView.textColor = UIColorFromRGB(0x939393);
        
    }
    
    return YES;
}



@end
